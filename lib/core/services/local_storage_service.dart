import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static const String _boxName = 'app_preferences';
  static const String _isFirstRunKey = 'is_first_run';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  bool isFirstRun() {
    final box = Hive.box(_boxName);
    return box.get(_isFirstRunKey, defaultValue: true) as bool;
  }

  Future<void> setFirstRunCompleted() async {
    final box = Hive.box(_boxName);
    await box.put(_isFirstRunKey, false);
  }
}
