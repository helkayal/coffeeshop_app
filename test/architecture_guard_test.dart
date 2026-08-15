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
