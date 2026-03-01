import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../core/utils/navigation_utils.dart';
import '../../core/api/auth_api.dart';
import '../../core/auth/auth_storage.dart';
import '../login/login_screen.dart';
import '../plan/plan_selection_section.dart';
import 'verify_email_screen.dart';

/// Экран регистрации — проверка через API бекенда
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorText;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(const Duration(milliseconds: 400));
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _doRegister();
    });
  }

  void _doRegister() {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _errorText = null;
      if (name.isEmpty) _errorText = l10n.errorEnterName;
      else if (name.length > 50) _errorText = l10n.errorNameTooLong;
      else if (surname.isEmpty) _errorText = l10n.errorEnterSurname;
      else if (surname.length > 50) _errorText = l10n.errorSurnameTooLong;
      else if (email.isEmpty) _errorText = l10n.errorEnterEmail;
      else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) _errorText = l10n.errorInvalidEmail;
      else if (password.isEmpty) _errorText = l10n.errorEnterPassword;
      else if (password.length > 128) _errorText = l10n.errorPasswordTooLong;
      if (_errorText != null) return;
      _loading = true;
    });

    if (_errorText != null) return;
    _registerApi(name, surname, email, password);
  }

  Future<void> _registerApi(String name, String surname, String email, String password) async {
    try {
      final res = await AuthApi.register(
        name: name,
        surname: surname,
        email: email,
        password: password,
      );
      if (!mounted) return;
      if (res.success && res.accessToken != null && res.refreshToken != null) {
        await AuthStorage.saveAuth(
          accessToken: res.accessToken!,
          refreshToken: res.refreshToken!,
          userEmail: res.userEmail,
          userName: res.userName ?? name,
          userSurname: res.userSurname ?? surname,
        );
        Navigator.of(context).pushReplacement(
          noAnimationRoute(const PlanSelectionSection()),
        );
      } else if (res.success && res.codeSent) {
        Navigator.of(context).pushReplacement(
          noAnimationRoute(VerifyEmailScreen(email: email)),
        );
      } else {
        final l10n = AppLocalizations.of(context)!;
        String err = res.error ?? l10n.errorRegistration;
        if (err.toLowerCase().contains('8') && (err.toLowerCase().contains('символ') || err.toLowerCase().contains('character'))) {
          err = l10n.errorServerPasswordShort(password.length);
        }
        setState(() {
          _errorText = err;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorText = AppLocalizations.of(context)!.errorConnection;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(width: double.infinity, height: double.infinity, color: Colors.white),
          Positioned.fill(
            child: Image.asset(
              'assets/images/registerfon.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.white),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/icons/harmonyicon.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.white.withOpacity(0.3),
                            child: const Icon(Icons.apps, color: Colors.white, size: 40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.registrationTitle,
                    style: GoogleFonts.inter(
                      fontSize: 20, fontWeight: FontWeight.w400,
                      color: Colors.white, decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildTextField(AppLocalizations.of(context)!.nameHint, _nameController),
                        const SizedBox(height: 16),
                        _buildTextField(AppLocalizations.of(context)!.surnameHint, _surnameController),
                        const SizedBox(height: 16),
                        _buildTextField(AppLocalizations.of(context)!.emailHint, _emailController),
                        const SizedBox(height: 16),
                        _buildTextField(AppLocalizations.of(context)!.passwordHint, _passwordController, obscure: true),
                        if (_errorText != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _errorText!,
                            style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 14),
                          ),
                        ],
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF202020),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            onPressed: _loading ? null : _onRegister,
                            child: _loading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text(
                                    AppLocalizations.of(context)!.registerButton,
                                    style: GoogleFonts.inter(
                                      fontSize: 16, fontWeight: FontWeight.w600,
                                      color: const Color(0xFF202020),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          AppLocalizations.of(context)!.alreadyHaveAccount,
                          style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w400,
                            color: Colors.white, decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushReplacement(
                            noAnimationRoute(const LoginScreen()),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.loginLink,
                                style: GoogleFonts.inter(
                                  fontSize: 14, fontWeight: FontWeight.w600,
                                  color: Colors.white, decoration: TextDecoration.none,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          AppLocalizations.of(context)!.orLoginWith,
                          style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w400,
                            color: Colors.white, decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildGoogleIcon(),
                            const SizedBox(width: 16),
                            _buildAppleIcon(),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {bool obscure = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xFF202020)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xFF757575)),
              contentPadding: const EdgeInsets.only(top: 13, bottom: 13, left: 16, right: 16),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  static const double _socialButtonSize = 56;
  static const double _socialIconSize = 28;

  Widget _buildGoogleIcon() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: _socialButtonSize,
        height: _socialButtonSize,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/google_logo.svg',
            width: _socialIconSize,
            height: _socialIconSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildAppleIcon() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: _socialButtonSize,
        height: _socialButtonSize,
        decoration: const BoxDecoration(
          color: Color(0xFF000000),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/apple_logo.svg',
            width: _socialIconSize,
            height: _socialIconSize,
            fit: BoxFit.contain,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
