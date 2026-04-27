import 'package:center_for_biblical_studies/data/authentication/login_data.dart';
import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/features/authentication/signup_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/page/main_page.dart';
import 'package:center_for_biblical_studies/services/auth_service.dart';
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _passwordObscure = ValueNotifier(true);
  final ValueNotifier<bool> _fieldValid = ValueNotifier(false);

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  final SupabaseService _apiService = SupabaseService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController()..addListener(_onFieldsChanged);
    _passwordController = TextEditingController()
      ..addListener(_onFieldsChanged);
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (loggedIn && mounted) {
      Get.offAll(() => const MainPage());
    }
  }

  void _onFieldsChanged() {
    final email = _emailController.text;
    final password = _passwordController.text;
    if (email.isEmpty && password.isEmpty) return;
    _fieldValid.value = AppRegex.emailRegex.hasMatch(email) &&
        AppRegex.passwordRegex.hasMatch(password);
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiService.login(LoginData(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ));

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        if (response["error"] == true) {
          _errorMessage = response["message"] as String? ?? 'Unknown error';
          _logError(
            status: response["status"],
            message: _errorMessage!,
            responseData: response,
          );
        } else {
          _fetchData();
          final l10n = AppLocalizations.of(context) ??
              AppLocalizations(const Locale('fr'));
          SnackbarHelper.showSnackBar(l10n.loggedIn);
          _emailController.clear();
          _passwordController.clear();
          Get.offAll(() => const MainPage());
        }
      });
    } catch (e, stackTrace) {
      if (!mounted) return;
      final msg = e.toString();
      setState(() {
        _isLoading = false;
        _errorMessage = msg;
      });
      _logError(message: msg, stackTrace: stackTrace);
    }
  }

  void _logError({
    int? status,
    String? message,
    Map<String, dynamic>? responseData,
    StackTrace? stackTrace,
  }) {
    // ignore: avoid_print
    print('┌─────────────────────────────────────────────────────────────');
    // ignore: avoid_print
    print('│ LOGIN ERROR');
    // ignore: avoid_print
    print('├─────────────────────────────────────────────────────────────');
    // ignore: avoid_print
    if (status != null) print('│ Status: $status');
    // ignore: avoid_print
    if (message != null) print('│ Message: $message');
    if (responseData != null && responseData.isNotEmpty) {
      // ignore: avoid_print
      print('│ Response: $responseData');
    }
    if (stackTrace != null) {
      // ignore: avoid_print
      print('│ StackTrace: $stackTrace');
    }
    // ignore: avoid_print
    print('└─────────────────────────────────────────────────────────────');
  }

  Future<void> _fetchData() async {
    final dc = Get.find<DataController>();
    try {
      dc.setCourses(await _apiService.fetchCourses());
    } catch (_) {}
    try {
      dc.setBooks(await _apiService.fetchBooks());
    } catch (_) {}
    try {
      dc.setTeachers(await _apiService.fetchTeachers());
    } catch (_) {}
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordObscure.dispose();
    _fieldValid.dispose();
    super.dispose();
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
          l10n.login,
          style: smallStyle18.copyWith(
            color: CbsColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header block
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
                  l10n.signInToYourNAccount,
                  style: largeStyle32Bold.copyWith(
                    color: CbsColors.white,
                    fontSize: 26,
                    height: 1.2,
                  ),
                ),
                gapH8,
                Text(
                  l10n.signInToYourAccount,
                  style: smallStyle18.copyWith(
                    color: CbsColors.primaryYellow,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          // Form
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInput(
                    controller: _emailController,
                    label: l10n.email,
                    hint: l10n.email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.pleaseEnterEmail;
                      return AppConstants.emailRegex.hasMatch(v)
                          ? null
                          : l10n.invalidEmail;
                    },
                  ),
                  gapH20,
                  ValueListenableBuilder<bool>(
                    valueListenable: _passwordObscure,
                    builder: (_, obscure, __) => _buildInput(
                      controller: _passwordController,
                      label: l10n.password,
                      hint: l10n.password,
                      obscure: obscure,
                      textInputAction: TextInputAction.done,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return l10n.pleaseEnterPassword;
                        }
                        return AppConstants.passwordRegex.hasMatch(v)
                            ? null
                            : l10n.invalidPassword;
                      },
                      suffix: IconButton(
                        onPressed: () => _passwordObscure.value = !obscure,
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
                  gapH12,
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        l10n.forgotPassword,
                        style: smallStyle18.copyWith(
                          color: CbsColors.primaryBrown,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    gapH12,
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
                    valueListenable: _fieldValid,
                    builder: (_, isValid, __) => SizedBox(
                      height: 56,
                      child: FilledButton(
                        onPressed:
                            (isValid && !_isLoading) ? _handleLogin : null,
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
                                l10n.login,
                                style: smallStyle18.copyWith(
                                  color: CbsColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                  gapH24,
                  Row(
                    children: [
                      Expanded(
                          child: Divider(color: CbsColors.primaryGrey[600])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          l10n.orLoginWith,
                          style: smallStyle18.copyWith(
                            color: CbsColors.hintColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Divider(color: CbsColors.primaryGrey[600])),
                    ],
                  ),
                  gapH20,
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon:
                              const Icon(Icons.g_mobiledata_rounded, size: 24),
                          label: Text(l10n.google),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: CbsColors.primaryDark[800],
                            side:
                                BorderSide(color: CbsColors.primaryGrey[600]!),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      gapW16,
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.facebook_rounded, size: 24),
                          label: Text(l10n.facebook),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: CbsColors.primaryDark[800],
                            side:
                                BorderSide(color: CbsColors.primaryGrey[600]!),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Register link
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.doNotHaveAccount,
                  style: smallStyle18.copyWith(
                    color: CbsColors.primaryDark[600],
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.to(() => const SignupPage()),
                  child: Text(
                    l10n.register,
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

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    bool obscure = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    Widget? suffix,
  }) {
    return TextInputField(
      controller: controller,
      label: label,
      hintText: hint,
      obscure: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: (_) => _formKey.currentState?.validate(),
      suffixIcon: suffix,
      padding: 0,
    );
  }
}
