import 'package:flutter/material.dart';

import '../widgets/email_verification_content.dart';

/// Shown after registration or when a login attempt is blocked due to
/// an unverified email. Accepts the verification token and optionally
/// lets the user request a new one.
class EmailVerificationScreen extends StatelessWidget {
  final String email;
  final bool autoResend;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    this.autoResend = false,
  });

  @override
  Widget build(BuildContext context) {
    return EmailVerificationContent(email: email, autoResend: autoResend);
  }
}
