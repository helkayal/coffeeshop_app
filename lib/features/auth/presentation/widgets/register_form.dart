import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_design_constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_header.dart';
import '../../../../core/widgets/gender_selection.dart';
import 'location_section.dart';
import 'login_link.dart';
import 'name_fields.dart';
import 'profile_picture_widget.dart';

class RegisterForm extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onRegisterPressed;
  final ValueNotifier<String?> genderNotifier, stateNotifier, cityNotifier;
  final TextEditingController firstNameController, lastNameController;
  final TextEditingController emailController, passwordController;

  const RegisterForm({
    super.key,
    required this.isLoading,
    required this.onRegisterPressed,
    required this.genderNotifier,
    required this.stateNotifier,
    required this.cityNotifier,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignConstants.paddingLarge),
      child: Column(
        children: [
          AuthHeader(
            title: 'auth.join_the_club'.tr(),
            subtitle: 'auth.register_subtitle'.tr(),
          ),
          const SizedBox(height: 32),
          ValueListenableBuilder<String?>(
            valueListenable: genderNotifier,
            builder: (context, gender, _) =>
                ProfilePictureWidget(gender: gender ?? 'male'),
          ),
          const SizedBox(height: 32),
          NameFields(
            firstNameController: firstNameController,
            lastNameController: lastNameController,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: emailController,
            hintText: 'auth.email_address'.tr(),
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.email_outlined, color: Theme.of(context).colorScheme.outline),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<String?>(
            valueListenable: genderNotifier,
            builder: (context, gender, _) => GenderSelection(
              selectedGender: gender ?? 'male',
              onGenderChanged: (val) => genderNotifier.value = val,
              maleLabel: 'auth.male'.tr(),
              femaleLabel: 'auth.female'.tr(),
              genderLabel: 'auth.gender'.tr(),
            ),
          ),
          const SizedBox(height: 16),
          LocationSection(
            stateNotifier: stateNotifier,
            cityNotifier: cityNotifier,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: passwordController,
            hintText: 'auth.password'.tr(),
            isPassword: true,
            prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.outline),
            suffixIcon: Icon(Icons.visibility_off_outlined, color: Theme.of(context).colorScheme.outline),
          ),
          const SizedBox(height: 32),
          AppButton(
            text: 'auth.register_now'.tr(),
            isLoading: isLoading,
            onPressed: isLoading ? () {} : onRegisterPressed,
          ),
          const SizedBox(height: 16),
          const LoginLink(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
