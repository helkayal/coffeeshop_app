import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('domain does not depend on Flutter or data layers', () {
    final violations = <String>[];
    for (final file in _dartFiles(Directory('lib/features'))) {
      if (!file.path.contains('/domain/')) continue;
      final source = file.readAsStringSync();
      if (source.contains("package:flutter/") ||
          RegExp(r'''import\s+["'][^"']*/data/''').hasMatch(source)) {
        violations.add(file.path);
      }
    }
    expect(violations, isEmpty);
  });

  test('lib uses relative imports for project files', () {
    final violations = _dartFiles(Directory('lib'))
        .where(
          (file) => file.readAsStringSync().contains('package:coffeeshop_app/'),
        )
        .map((file) => file.path)
        .toList();
    expect(violations, isEmpty);
  });

  test('presentation does not import data or access storage services', () {
    final violations = <String>[];
    for (final file in _dartFiles(Directory('lib/features'))) {
      if (!file.path.contains('/presentation/')) continue;
      final source = file.readAsStringSync();
      if (RegExp(r'''import\s+["'][^"']*/data/''').hasMatch(source) ||
          source.contains('LocalStorageService') ||
          source.contains('RemoteDataSource')) {
        violations.add(file.path);
      }
    }
    expect(violations, isEmpty);
  });

  test('English and Arabic translation keys match', () {
    final english =
        jsonDecode(File('assets/translations/en.json').readAsStringSync())
            as Map<String, dynamic>;
    final arabic =
        jsonDecode(File('assets/translations/ar.json').readAsStringSync())
            as Map<String, dynamic>;
    expect(_flatten(english), _flatten(arabic));
  });

  test('literal translation references exist in both locale files', () {
    final english = _translationKeys('assets/translations/en.json');
    final arabic = _translationKeys('assets/translations/ar.json');
    final referenced = <String>{};
    final keyPattern = RegExp(r'''["']([A-Za-z0-9_.-]+)["']\.tr\s*\(''');

    for (final file in _dartFiles(Directory('lib'))) {
      for (final match in keyPattern.allMatches(file.readAsStringSync())) {
        referenced.add(match.group(1)!);
      }
    }

    expect(
      referenced.difference(english),
      isEmpty,
      reason: 'Missing English keys',
    );
    expect(
      referenced.difference(arabic),
      isEmpty,
      reason: 'Missing Arabic keys',
    );
  });

  test('English and Arabic placeholders match for every translation', () {
    final english = _translationValues('assets/translations/en.json');
    final arabic = _translationValues('assets/translations/ar.json');
    final placeholder = RegExp(r'\{[^}]*\}');

    for (final key in english.keys) {
      final englishArgs = placeholder
          .allMatches(english[key]!)
          .map((match) => match.group(0))
          .toList();
      final arabicArgs = placeholder
          .allMatches(arabic[key]!)
          .map((match) => match.group(0))
          .toList();
      expect(arabicArgs, englishArgs, reason: 'Placeholder mismatch for $key');
    }
  });
}

Set<String> _translationKeys(String path) {
  final values =
      jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  return _flatten(values);
}

Map<String, String> _translationValues(String path) {
  final values =
      jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  return _flattenValues(values);
}

Iterable<File> _dartFiles(Directory directory) => directory
    .listSync(recursive: true)
    .whereType<File>()
    .where((file) => file.path.endsWith('.dart'));

Set<String> _flatten(Map<String, dynamic> values, [String prefix = '']) {
  final result = <String>{};
  for (final entry in values.entries) {
    final key = prefix.isEmpty ? entry.key : '$prefix.${entry.key}';
    if (entry.value is Map<String, dynamic>) {
      result.addAll(_flatten(entry.value as Map<String, dynamic>, key));
    } else {
      result.add(key);
    }
  }
  return result;
}

Map<String, String> _flattenValues(
  Map<String, dynamic> values, [
  String prefix = '',
]) {
  final result = <String, String>{};
  for (final entry in values.entries) {
    final key = prefix.isEmpty ? entry.key : '$prefix.${entry.key}';
    if (entry.value is Map<String, dynamic>) {
      result.addAll(_flattenValues(entry.value as Map<String, dynamic>, key));
    } else {
      result[key] = entry.value.toString();
    }
  }
  return result;
}
