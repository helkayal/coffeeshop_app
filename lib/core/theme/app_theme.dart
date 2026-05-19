import 'package:flutter/material.dart';

import 'app_dark_theme.dart';
import 'app_light_theme.dart';

class AppTheme {
  static ThemeData get lightTheme => createLightTheme();
  static ThemeData get darkTheme => createDarkTheme();
}
