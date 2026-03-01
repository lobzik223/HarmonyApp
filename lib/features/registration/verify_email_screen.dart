import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/navigation_utils.dart';
import '../../core/api/auth_api.dart';
import '../../core/auth/auth_storage.dart';
import '../plan/plan_selection_section.dart';

/// Экран ввода 6-значного кода подтверждения email (после нажатия «Зарегистрироваться»).
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _codeController = TextEditingController();
  String? _errorText;
  bool _loading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onVerify() async {
    final l10n = AppLocalizations.of(context)!;
    final code = _codeController.text.trim().replaceAll(RegExp(r'\D'), '');
    setState(() {
      _errorText = null;
      if (code.length != 6) {
        _errorText = l10n.errorEnterSixDigits;
        return;
      }
      _loading = true;
    });

    try {
      final res = await AuthApi.verifyEmail(email: widget.email, code: code);
      if (!mounted) return;
      if (res.success && res.accessToken != null && res.refreshToken != null) {
        await AuthStorage.saveAuth(
          accessToken: res.accessToken!,
          refreshToken: res.refreshToken!,
          userEmail: res.userEmail ?? widget.email,
          userName: res.userName,
          userSurname: res.userSurname,
        );
        Navigator.of(context).pushAndRemoveUntil(
          noAnimationRoute(const PlanSelectionSection()),
          (_) => false,
        );
      } else {
        setState(() {
          _errorText = res.error ?? l10n.errorInvalidCode;
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),
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
                            child: const Icon(Icons.mail_outline, color: Colors.white, size: 40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.verifyCodeTitle,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.verifyCodeDescription,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.email,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildCodeField(),
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
                      onPressed: _loading ? null : _onVerify,
                      child: _loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              AppLocalizations.of(context)!.confirmButton,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF202020),
                                decoration: TextDecoration.none,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      AppLocalizations.of(context)!.spamHint,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                        decoration: TextDecoration.none,
                      ),
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

  Widget _buildCodeField() {
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
            controller: _codeController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 8,
              color: const Color(0xFF202020),
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.codePlaceholder,
              hintStyle: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 8,
                color: const Color(0xFF757575),
              ),
              contentPadding: const EdgeInsets.only(top: 13, bottom: 13, left: 16, right: 16),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onChanged: (_) => setState(() => _errorText = null),
          ),
        ),
      ),
    );
  }
}
