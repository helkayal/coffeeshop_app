import 'package:flutter/material.dart';

/// Breakpoints for adaptive layouts.
///
/// - phone   : width < 600
/// - tablet  : 600 <= width < 840
/// - desktop : width >= 840
class AppBreakpoints {
  AppBreakpoints._();

  static const double tablet = 600;
  static const double desktop = 840;

  /// Max width for centered body content on wide screens.
  static const double contentMaxWidth = 720;

  /// Max width for form-heavy screens (login, register).
  static const double formMaxWidth = 480;
}

extension AppBreakpointsContext on BuildContext {
  double get _width => MediaQuery.sizeOf(this).width;

  bool get isTablet => _width >= AppBreakpoints.tablet;
  bool get isDesktop => _width >= AppBreakpoints.desktop;
  bool get isPhone => _width < AppBreakpoints.tablet;
}
