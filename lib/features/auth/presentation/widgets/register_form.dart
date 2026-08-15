import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
  final TextEditingController emailController, dateOfBirthController;
  final TextEditingController passwordController, confirmPasswordController;
  final VoidCallback onPickDateOfBirth;
  final VoidCallback onPickImage;
  final String? selectedImagePath;
  final String? firstNameError;
  final String? lastNameError;
  final String? emailError;
  final String? stateError;
  final String? cityError;
  final String? dateOfBirthError;
  final String? passwordError;
  final String? confirmPasswordError;

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
    required this.dateOfBirthController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onPickDateOfBirth,
    required this.onPickImage,
    this.selectedImagePath,
    this.firstNameError,
    this.lastNameError,
    this.emailError,
    this.stateError,
    this.cityError,
    this.dateOfBirthError,
    this.passwordError,
    this.confirmPasswordError,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignConstants.paddingLarge,
      ),
      child: Column(
        children: [
          AuthHeader(
            title: 'auth.join_the_club'.tr(),
            subtitle: 'auth.register_subtitle'.tr(),
          ),
          const SizedBox(height: 32),
          ValueListenableBuilder<String?>(
            valueListenable: genderNotifier,
            builder: (context, gender, _) => ProfilePictureWidget(
              gender: gender ?? 'male',
              imagePath: selectedImagePath,
              onTap: onPickImage,
            ),
          ),
          const SizedBox(height: 32),
          NameFields(
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            firstNameError: firstNameError,
            lastNameError: lastNameError,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: emailController,
            hintText: 'auth.email_address'.tr(),
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.email_outlined, color: colorScheme.outline),
            errorText: emailError,
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
            stateError: stateError,
            cityError: cityError,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onPickDateOfBirth,
            child: AbsorbPointer(
              child: AppTextField(
                controller: dateOfBirthController,
                hintText: 'auth.date_of_birth'.tr(),
                prefixIcon: Icon(
                  Icons.calendar_today_outlined,
                  color: colorScheme.outline,
                ),
                errorText: dateOfBirthError,
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: passwordController,
            hintText: 'auth.password'.tr(),
            isPassword: true,
            prefixIcon: Icon(Icons.lock_outline, color: colorScheme.outline),
            errorText: passwordError,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: confirmPasswordController,
            hintText: 'auth.confirm_password'.tr(),
            isPassword: true,
            prefixIcon: Icon(Icons.lock_outline, color: colorScheme.outline),
            errorText: confirmPasswordError,
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
