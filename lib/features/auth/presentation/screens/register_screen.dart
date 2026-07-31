import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_snack_bar.dart' show AppSnackBar, SnackBarType;
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RegisterScreenContent();
  }
}

class _RegisterScreenContent extends StatefulWidget {
  const _RegisterScreenContent();

  @override
  State<_RegisterScreenContent> createState() => _RegisterScreenContentState();
}

class _RegisterScreenContentState extends State<_RegisterScreenContent> {
  final _genderNotifier = ValueNotifier<String?>('male');
  final _stateNotifier = ValueNotifier<String?>(null);
  final _cityNotifier = ValueNotifier<String?>(null);

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _dateOfBirth;
  String? _selectedImagePath;

  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _stateError;
  String? _cityError;
  String? _dateOfBirthError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();

    _firstNameController.addListener(_clearFirstNameError);
    _lastNameController.addListener(_clearLastNameError);
    _emailController.addListener(_clearEmailError);
    _passwordController.addListener(_clearPasswordError);
    _confirmPasswordController.addListener(_clearConfirmPasswordError);

    _stateNotifier.addListener(_clearStateError);
    _cityNotifier.addListener(_clearCityError);
  }

  void _clearFirstNameError() {
    if (_firstNameError != null && _firstNameController.text.trim().isNotEmpty) {
      setState(() => _firstNameError = null);
    }
  }

  void _clearLastNameError() {
    if (_lastNameError != null && _lastNameController.text.trim().isNotEmpty) {
      setState(() => _lastNameError = null);
    }
  }

  void _clearEmailError() {
    if (_emailError != null && _emailController.text.trim().isNotEmpty) {
      setState(() => _emailError = null);
    }
  }

  void _clearPasswordError() {
    final text = _passwordController.text;
    if (text.length >= 8) {
      setState(() => _passwordError = null);
    }
    if (_confirmPasswordController.text.isNotEmpty) {
      _clearConfirmPasswordError();
    }
  }

  void _clearConfirmPasswordError() {
    final text = _confirmPasswordController.text;
    if (_confirmPasswordError == null && text.isEmpty) return;

    if (text.isEmpty) {
      setState(() => _confirmPasswordError =
          'validation.confirm_password_required'.tr());
    } else if (text.length < 8) {
      setState(
          () => _confirmPasswordError = 'validation.password_min_length'.tr());
    } else if (text != _passwordController.text) {
      setState(() => _confirmPasswordError =
          'validation.passwords_do_not_match'.tr());
    } else {
      setState(() => _confirmPasswordError = null);
    }
  }

  void _clearStateError() {
    if (_stateError != null && _stateNotifier.value != null) {
      setState(() => _stateError = null);
    }
  }

  void _clearCityError() {
    if (_cityError != null && _cityNotifier.value != null) {
      setState(() => _cityError = null);
    }
  }

  @override
  void dispose() {
    _genderNotifier.dispose();
    _stateNotifier.dispose();
    _cityNotifier.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dateOfBirthController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImagePath = picked.path);
      sl<LocalStorageService>().setPendingAvatarPath(picked.path);
    }
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'auth.date_of_birth'.tr(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
        _dateOfBirthController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        _dateOfBirthError = null;
      });
    }
  }

  bool _validate() {
    var valid = true;

    final firstName = _firstNameController.text.trim();
    if (firstName.isEmpty) {
      _firstNameError = 'validation.first_name_required'.tr();
      valid = false;
    } else {
      _firstNameError = null;
    }

    final lastName = _lastNameController.text.trim();
    if (lastName.isEmpty) {
      _lastNameError = 'validation.last_name_required'.tr();
      valid = false;
    } else {
      _lastNameError = null;
    }

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _emailError = 'validation.email_required'.tr();
      valid = false;
    } else if (!_isValidEmail(email)) {
      _emailError = 'validation.email_invalid'.tr();
      valid = false;
    } else {
      _emailError = null;
    }

    if (_stateNotifier.value == null) {
      _stateError = 'validation.state_required'.tr();
      valid = false;
    } else {
      _stateError = null;
    }

    if (_cityNotifier.value == null) {
      _cityError = 'validation.city_required'.tr();
      valid = false;
    } else {
      _cityError = null;
    }

    if (_dateOfBirth == null) {
      _dateOfBirthError = 'validation.dob_required'.tr();
      valid = false;
    } else {
      _dateOfBirthError = null;
    }

    final password = _passwordController.text;
    if (password.isEmpty) {
      _passwordError = 'validation.password_required'.tr();
      valid = false;
    } else if (password.length < 8) {
      _passwordError = 'validation.password_min_length'.tr();
      valid = false;
    } else {
      _passwordError = null;
    }

    final confirmPassword = _confirmPasswordController.text;
    if (confirmPassword.isEmpty) {
      _confirmPasswordError = 'validation.confirm_password_required'.tr();
      valid = false;
    } else if (confirmPassword != password) {
      _confirmPasswordError = 'validation.passwords_do_not_match'.tr();
      valid = false;
    } else {
      _confirmPasswordError = null;
    }

    setState(() {});
    return valid;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^\@\s]+@[^\@\s]+\.[^\@\s]+$').hasMatch(email);
  }

  void _onRegisterPressed() {
    if (!_validate()) return;

    context.read<AuthCubit>().register(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          gender: _genderNotifier.value!,
          state: _stateNotifier.value,
          city: _cityNotifier.value,
          dateOfBirth: _dateOfBirth,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              AppSnackBar.show(context, state.message, type: SnackBarType.error);
            } else if (state is AuthRegisterSuccess) {
              // Navigate to the verification screen carrying the registered email.
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.verifyEmail,
                (route) => false,
                arguments: state.email,
              );
            }
          },
          builder: (context, state) => RegisterForm(
            isLoading: state is AuthLoading,
            onRegisterPressed: _onRegisterPressed,
            genderNotifier: _genderNotifier,
            stateNotifier: _stateNotifier,
            cityNotifier: _cityNotifier,
            firstNameController: _firstNameController,
            lastNameController: _lastNameController,
            emailController: _emailController,
            dateOfBirthController: _dateOfBirthController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            onPickDateOfBirth: _pickDateOfBirth,
            onPickImage: _pickImage,
            selectedImagePath: _selectedImagePath,
            firstNameError: _firstNameError,
            lastNameError: _lastNameError,
            emailError: _emailError,
            stateError: _stateError,
            cityError: _cityError,
            dateOfBirthError: _dateOfBirthError,
            passwordError: _passwordError,
            confirmPasswordError: _confirmPasswordError,
          ),
        ),
      ),
    );
  }
}
