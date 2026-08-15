import 'package:flutter/material.dart';

import '../theme/app_design_constants.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final String? errorText;

  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.errorText,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label case final label?) ...[
          Text(
            label,
            style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscured,
          keyboardType: widget.keyboardType,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline,
            ),
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: colorScheme.outline,
                    ),
                    onPressed: () => setState(() => _obscured = !_obscured),
                  )
                : null,
            filled: true,
            fillColor: colorScheme.surface,
            border: _outlineBorder(colorScheme.outlineVariant),
            enabledBorder: _outlineBorder(colorScheme.outlineVariant),
            focusedBorder: _outlineBorder(colorScheme.primary, width: 2),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _outlineBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: AppDesignConstants.radiusMedium,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
