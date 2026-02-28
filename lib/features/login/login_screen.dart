import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import '../../main.dart';
import '../../core/utils/navigation_utils.dart';
import '../../core/api/auth_api.dart';
import '../../core/auth/auth_storage.dart';
import '../registration/registration_screen.dart';
import '../plan/plan_selection_section.dart';

/// Экран входа — проверка через API бекенда
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorText;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _errorText = null;
      if (email.isEmpty) _errorText = 'Введите почту';
      else if (!email.contains('@')) _errorText = 'Введите корректный email';
      else if (password.length < 8) _errorText = 'Пароль не короче 8 символов';
      if (_errorText != null) return;
      _loading = true;
    });

    try {
      final res = await AuthApi.login(email: email, password: password);
      if (!mounted) return;
      if (res.success && res.accessToken != null && res.refreshToken != null) {
        await AuthStorage.saveAuth(
          accessToken: res.accessToken!,
          refreshToken: res.refreshToken!,
          userEmail: res.userEmail,
          userName: res.userName,
        );
        Navigator.of(context).pushReplacement(
          noAnimationRoute(const PlanSelectionSection()),
        );
      } else {
        setState(() {
          _errorText = res.error ?? 'Неверная почта или пароль';
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorText = 'Не удалось подключиться. Проверьте интернет.';
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
                    'ВХОД',
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
                        _buildTextField('Телефон или почта', _emailController),
                        const SizedBox(height: 16),
                        _buildTextField('Пароль', _passwordController, obscure: true),
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
                            onPressed: _loading ? null : _onLogin,
                            child: _loading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text(
                                    'Войти',
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
                          'Нет аккаунта?',
                          style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w400,
                            color: Colors.white, decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushReplacement(
                            noAnimationRoute(const RegistrationScreen()),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Зарегистрироваться',
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
                          'Или войдите с помощью:',
                          style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w400,
                            color: Colors.white, decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialIcon(Icons.g_mobiledata, Colors.white, const Color(0xFF4285F4)),
                            const SizedBox(width: 16),
                            _buildSocialIcon(Icons.circle, const Color(0xFF0077FF), Colors.white),
                            const SizedBox(width: 16),
                            _buildSocialIcon(Icons.circle, const Color(0xFFFC3F1D), Colors.white),
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

  Widget _buildSocialIcon(IconData icon, Color iconColor, Color bgColor) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Center(child: Icon(icon, color: iconColor, size: 24)),
      ),
    );
  }
}
