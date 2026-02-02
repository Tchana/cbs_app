import 'package:center_for_biblical_studies/features/authentication/login_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/page/main_page.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/shared/text_input_field.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_regex.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/constants/constants.dart';
import 'package:center_for_biblical_studies/utils/snackbar_helpers.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _supabase = SupabaseService();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  bool _isLoading = false;
  String? _errorMessage;

  void initializeControllers() {
    nameController = TextEditingController()..addListener(controllerListener);
    emailController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
    confirmPasswordController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void controllerListener() {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    if (name.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty) return;
    fieldValidNotifier.value = AppRegex.emailRegex.hasMatch(email) &&
        AppRegex.passwordRegex.hasMatch(password) &&
        AppRegex.passwordRegex.hasMatch(confirmPassword) &&
        password == confirmPassword;
  }

  @override
  void initState() {
    initializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final result = await _supabase.signUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      name: nameController.text.trim().isNotEmpty
          ? nameController.text.trim()
          : null,
    );
    if (!mounted) return;
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    setState(() {
      _isLoading = false;
      if (result['error'] == true) {
        _errorMessage = result['message'] as String? ?? 'Registration failed';
      } else if (result['requiresEmailConfirmation'] == true) {
        SnackbarHelper.showSnackBar(l10n.checkEmailToConfirm);
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        Get.offAll(() => const LoginPage());
      } else {
        SnackbarHelper.showSnackBar(l10n.registrationComplete);
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        Get.offAll(() => const MainPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    return Scaffold(
      backgroundColor: CbsColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: CbsColors.primaryBrown,
        foregroundColor: CbsColors.white,
        elevation: 0,
        title: Text(
          l10n.register,
          style: smallStyle18.copyWith(
            color: CbsColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
            decoration: BoxDecoration(
              color: CbsColors.primaryBrown,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.createYourAccount,
                  style: largeStyle32Bold.copyWith(
                    color: CbsColors.white,
                    fontSize: 26,
                    height: 1.2,
                  ),
                ),
                gapH8,
                Text(
                  l10n.register,
                  style: smallStyle18.copyWith(
                    color: CbsColors.primaryYellow,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextInputField(
                    autofocus: true,
                    padding: 0,
                    label: l10n.name,
                    hintText: l10n.name,
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _formKey.currentState?.validate(),
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.pleaseEnterName;
                      return v.length < 4 ? l10n.invalidName : null;
                    },
                  ),
                  gapH20,
                  TextInputField(
                    padding: 0,
                    label: l10n.email,
                    hintText: l10n.email,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _formKey.currentState?.validate(),
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.pleaseEnterEmail;
                      return AppConstants.emailRegex.hasMatch(v)
                          ? null
                          : l10n.invalidEmail;
                    },
                  ),
                  gapH20,
                  ValueListenableBuilder<bool>(
                    valueListenable: passwordNotifier,
                    builder: (_, obscure, __) => TextInputField(
                      padding: 0,
                      obscure: obscure,
                      label: l10n.password,
                      hintText: l10n.password,
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (_) => _formKey.currentState?.validate(),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return l10n.pleaseEnterPassword;
                        }
                        return AppConstants.passwordRegex.hasMatch(v)
                            ? null
                            : l10n.invalidPassword;
                      },
                      suffixIcon: IconButton(
                        onPressed: () => passwordNotifier.value = !obscure,
                        icon: Icon(
                          obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 22,
                          color: CbsColors.hintColor,
                        ),
                      ),
                    ),
                  ),
                  gapH20,
                  ValueListenableBuilder(
                    valueListenable: confirmPasswordNotifier,
                    builder: (_, confirmObscure, __) => TextInputField(
                      padding: 0,
                      obscure: confirmObscure,
                      label: l10n.confirmPassword,
                      hintText: l10n.confirmPassword,
                      controller: confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (_) => _formKey.currentState?.validate(),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return l10n.pleaseReEnterPassword;
                        }
                        if (!AppConstants.passwordRegex.hasMatch(v)) {
                          return l10n.invalidPassword;
                        }
                        return passwordController.text == v
                            ? null
                            : l10n.passwordNotMatched;
                      },
                      suffixIcon: IconButton(
                        onPressed: () =>
                            confirmPasswordNotifier.value = !confirmObscure,
                        icon: Icon(
                          confirmObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 22,
                          color: CbsColors.hintColor,
                        ),
                      ),
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    gapH20,
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CbsColors.errorColor[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: CbsColors.errorColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 20,
                            color: CbsColors.errorColor,
                          ),
                          gapW8,
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: smallStyle18.copyWith(
                                color: CbsColors.errorColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  gapH28,
                  ValueListenableBuilder<bool>(
                    valueListenable: fieldValidNotifier,
                    builder: (_, isValid, __) => SizedBox(
                      height: 56,
                      child: FilledButton(
                        onPressed:
                            (isValid && !_isLoading) ? _handleSignUp : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: CbsColors.primaryBrown,
                          disabledBackgroundColor:
                              CbsColors.primaryBrown.withValues(alpha: 0.5),
                          foregroundColor: CbsColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: CbsColors.white,
                                ),
                              )
                            : Text(
                                l10n.register,
                                style: smallStyle18.copyWith(
                                  color: CbsColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.iHaveAccount,
                  style: smallStyle18.copyWith(
                    color: CbsColors.primaryDark[600],
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.to(() => const LoginPage()),
                  child: Text(
                    l10n.login,
                    style: smallStyle18.copyWith(
                      color: CbsColors.primaryBrown,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
