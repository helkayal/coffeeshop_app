import 'package:flutter/widgets.dart';

import 'app_spacing.dart';

class AppInsets {
  const AppInsets._();

  // Uniform padding
  static const EdgeInsets zero = EdgeInsets.zero;
  static const EdgeInsets a4 = EdgeInsets.all(AppSpacing.s4);
  static const EdgeInsets a6 = EdgeInsets.all(AppSpacing.s6);
  static const EdgeInsets a8 = EdgeInsets.all(AppSpacing.s8);
  static const EdgeInsets a10 = EdgeInsets.all(AppSpacing.s10);
  static const EdgeInsets a12 = EdgeInsets.all(AppSpacing.s12);
  static const EdgeInsets a16 = EdgeInsets.all(AppSpacing.s16);
  static const EdgeInsets a20 = EdgeInsets.all(AppSpacing.s20);
  static const EdgeInsets a22 = EdgeInsets.all(AppSpacing.s22);
  static const EdgeInsets a24 = EdgeInsets.all(AppSpacing.s24);
  static const EdgeInsets a32 = EdgeInsets.all(AppSpacing.s32);

  // Horizontal padding
  static const EdgeInsets h4 = EdgeInsets.symmetric(horizontal: AppSpacing.s4);
  static const EdgeInsets h8 = EdgeInsets.symmetric(horizontal: AppSpacing.s8);
  static const EdgeInsets h10 = EdgeInsets.symmetric(horizontal: AppSpacing.s10);
  static const EdgeInsets h12 = EdgeInsets.symmetric(horizontal: AppSpacing.s12);
  static const EdgeInsets h16 = EdgeInsets.symmetric(horizontal: AppSpacing.s16);
  static const EdgeInsets h20 = EdgeInsets.symmetric(horizontal: AppSpacing.s20);
  static const EdgeInsets h24 = EdgeInsets.symmetric(horizontal: AppSpacing.s24);
  static const EdgeInsets h32 = EdgeInsets.symmetric(horizontal: AppSpacing.s32);

  // Vertical padding
  static const EdgeInsets v4 = EdgeInsets.symmetric(vertical: AppSpacing.s4);
  static const EdgeInsets v6 = EdgeInsets.symmetric(vertical: AppSpacing.s6);
  static const EdgeInsets v8 = EdgeInsets.symmetric(vertical: AppSpacing.s8);
  static const EdgeInsets v12 = EdgeInsets.symmetric(vertical: AppSpacing.s12);
  static const EdgeInsets v14 = EdgeInsets.symmetric(vertical: AppSpacing.s14);
  static const EdgeInsets v16 = EdgeInsets.symmetric(vertical: AppSpacing.s16);
  static const EdgeInsets v20 = EdgeInsets.symmetric(vertical: AppSpacing.s20);

  // Single side padding
  static const EdgeInsets b4 = EdgeInsets.only(bottom: AppSpacing.s4);
  static const EdgeInsets b8 = EdgeInsets.only(bottom: AppSpacing.s8);
  static const EdgeInsets b12 = EdgeInsets.only(bottom: AppSpacing.s12);
  static const EdgeInsets b16 = EdgeInsets.only(bottom: AppSpacing.s16);
  static const EdgeInsets b24 = EdgeInsets.only(bottom: AppSpacing.s24);
  static const EdgeInsets b120 = EdgeInsets.only(bottom: AppSpacing.s120);
  static const EdgeInsets t48 = EdgeInsets.only(top: AppSpacing.s48);

  // Symmetric padding
  static const EdgeInsets h8v2 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s8,
    vertical: AppSpacing.s2,
  );
  static const EdgeInsets h8v4 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s8,
    vertical: AppSpacing.s4,
  );
  static const EdgeInsets h10v4 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s10,
    vertical: AppSpacing.s4,
  );
  static const EdgeInsets h12v4 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s12,
    vertical: AppSpacing.s4,
  );
  static const EdgeInsets h12v6 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s12,
    vertical: AppSpacing.s6,
  );
  static const EdgeInsets h16v8 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s16,
    vertical: AppSpacing.s8,
  );
  static const EdgeInsets h16v10 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s16,
    vertical: AppSpacing.s10,
  );
  static const EdgeInsets h16v12 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s16,
    vertical: AppSpacing.s12,
  );
  static const EdgeInsets h18v14 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s18,
    vertical: AppSpacing.s14,
  );
  static const EdgeInsets h20v14 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s20,
    vertical: AppSpacing.s14,
  );
  static const EdgeInsets h24v16 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s24,
    vertical: AppSpacing.s16,
  );
  static const EdgeInsets h24v20 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s24,
    vertical: AppSpacing.s20,
  );
  static const EdgeInsets v16h24 = EdgeInsets.symmetric(
    vertical: AppSpacing.s16,
    horizontal: AppSpacing.s24,
  );

  // Compound Directional / Asymmetric insets
  static const EdgeInsets b24t8 = EdgeInsets.only(
    bottom: AppSpacing.s24,
    top: AppSpacing.s8,
  );

  static const EdgeInsets b24h24 = EdgeInsets.fromLTRB(
    AppSpacing.s24,
    0,
    AppSpacing.s24,
    AppSpacing.s24,
  );

  static const EdgeInsetsDirectional b24t12h8 = EdgeInsetsDirectional.fromSTEB(
    AppSpacing.s8,
    AppSpacing.s12,
    AppSpacing.s8,
    AppSpacing.s24,
  );

  // Screen layout insets (Directional for RTL support)
  static const EdgeInsetsDirectional screen =
      EdgeInsetsDirectional.fromSTEB(
        AppSpacing.s24,
        AppSpacing.s32,
        AppSpacing.s24,
        AppSpacing.s96,
      );

  static const EdgeInsetsDirectional screenTop40 =
      EdgeInsetsDirectional.fromSTEB(
        AppSpacing.s24,
        AppSpacing.s40,
        AppSpacing.s24,
        AppSpacing.s96,
      );

  static const EdgeInsetsDirectional screenTop24 =
      EdgeInsetsDirectional.fromSTEB(
        AppSpacing.s24,
        AppSpacing.s24,
        AppSpacing.s24,
        AppSpacing.s96,
      );

  static const EdgeInsetsDirectional screenTop8 =
      EdgeInsetsDirectional.fromSTEB(
        AppSpacing.s24,
        AppSpacing.s8,
        AppSpacing.s24,
        AppSpacing.s96,
      );

  static const EdgeInsetsDirectional screenCompact =
      EdgeInsetsDirectional.fromSTEB(
        AppSpacing.s16,
        AppSpacing.s8,
        AppSpacing.s16,
        AppSpacing.s140,
      );

  static const EdgeInsetsDirectional screenMenu =
      EdgeInsetsDirectional.fromSTEB(
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s16,
        0,
      );

  static const EdgeInsetsDirectional screenTop16Bottom0 =
      EdgeInsetsDirectional.fromSTEB(
        AppSpacing.s24,
        AppSpacing.s16,
        AppSpacing.s24,
        0,
      );

  // Bottom sheets
  static const EdgeInsets bottomSheet = EdgeInsets.fromLTRB(
    AppSpacing.s24,
    AppSpacing.s24,
    AppSpacing.s24,
    AppSpacing.s24,
  );

  static const EdgeInsets bottomSheetTop16 = EdgeInsets.fromLTRB(
    AppSpacing.s24,
    AppSpacing.s16,
    AppSpacing.s24,
    AppSpacing.s24,
  );

  static EdgeInsets bottomSheetWithKeyboard(BuildContext context) =>
      EdgeInsets.fromLTRB(
        AppSpacing.s24,
        AppSpacing.s24,
        AppSpacing.s24,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.s24,
      );
}
