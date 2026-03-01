import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/navigation_utils.dart';

/// Экран Premium подписки
class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  int _currentGiftIndex = 0; // Индекс текущего подарка в карусели

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Фоновое изображение на весь экран
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/loading_screen.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Кнопка "Назад" слева вверху
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.back,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Кнопка "О приложении" справа вверху
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: () {
                // Можно добавить навигацию на экран "О приложении"
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppLocalizations.of(context)!.aboutApp,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Скроллируемый контент
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  
                  // Золотая карточка с изображением и стрелками
                  _buildGiftCard(),
                  
                  const SizedBox(height: 40),
                  
                  // Заголовок "ПОДАРИТЕ ПРЕМИУМ СЕРТИФИКАТ"
                  Text(
                    AppLocalizations.of(context)!.giftPremiumCertTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      letterSpacing: 0.4,
                      color: const Color(0xFF202020),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Подзаголовок "HARMONY PREMIUM НА 30 ДНЕЙ"
                  Text(
                    AppLocalizations.of(context)!.harmonyPremium30Days,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      letterSpacing: 0.36,
                      color: const Color(0xFF202020),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Описание
                  Text(
                    AppLocalizations.of(context)!.forLovedOne,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      letterSpacing: 0.32,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Кнопка "Купить за 249 р."
                  _buildBuyButton(AppLocalizations.of(context)!.buyFor249),
                  
                  const SizedBox(height: 40),
                  
                  // Нижняя секция с белым фоном
                  _buildSubscriptionSection(),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGiftCard() {
    return Container(
      height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          // Золотая карточка с градиентом
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFD700), // Золотой
                  Color(0xFFFFA500), // Оранжевый
                  Color(0xFFFF8C00), // Темно-оранжевый
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Эффект лучей света
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: RadialGradient(
                        center: const Alignment(0.5, 0.3),
                        radius: 1.2,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Контент карточки - изображение gif1.png по центру
                Center(
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset(
                      'assets/icons/gif1.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Стрелка влево
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentGiftIndex = (_currentGiftIndex - 1).clamp(0, 2);
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          
          // Стрелка вправо
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentGiftIndex = (_currentGiftIndex + 1).clamp(0, 2);
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyButton(String text) {
    return GestureDetector(
      onTap: () {
        // Логика покупки
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFD700), // Золотой
              Color(0xFFFFA500), // Оранжевый
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.36,
              color: const Color(0xFF202020),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumBadge() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Круг с логотипом Harmony (светло-голубой) — компактный размер
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xFF5BB8E8),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              child: Image.asset(
                'assets/icons/harmonyicon.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.apps, color: Colors.white, size: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: -2),
        // Pill с текстом PREMIUM — меньше
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF5BB8E8),
                Color(0xFF46E4E3),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            AppLocalizations.of(context)!.premiumBadge,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionSection() {
    final fullText = AppLocalizations.of(context)!.feelFullHarmonyWith;
    final line1 = fullText
        .replaceAll(RegExp(r' ГАРМОНИЮ С$| HARMONY WITH$'), '')
        .trim();
    final line2 = fullText.contains('ГАРМОНИЮ С') ? 'ГАРМОНИЮ С' : (fullText.contains('HARMONY WITH') ? 'HARMONY WITH' : '');

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: -20),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок: "ПОЧУВСТВУЙ ПОЛНУЮ" / "ГАРМОНИЮ С" + знак PREMIUM
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line1,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: const Color(0xFF202020),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    line2,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: const Color(0xFF202020),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildPremiumBadge(),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Подзаголовок "ПОДПИШИСЬ ВСЕГО ОТ 199Р ЗА МЕС."
          Text(
            AppLocalizations.of(context)!.subscribeFrom199.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.2,
              color: const Color(0xFF202020),
            ),
          ),
              
              const SizedBox(height: 24),
              
              _buildSubscriptionCard(
                title: AppLocalizations.of(context)!.monthPlan,
                price: AppLocalizations.of(context)!.price265PerMonth,
                showTryButton: true,
                onTry: () {},
                onBuy: () {},
              ),
              
              const SizedBox(height: 16),
              
              _buildSubscriptionCard(
                title: AppLocalizations.of(context)!.yearPlan,
                price: AppLocalizations.of(context)!.price199PerMonth,
                priceYear: AppLocalizations.of(context)!.price2390PerYear,
                showDiscount: true,
                discountPercent: 20,
                onBuy: () {},
              ),
            ],
          ),
        );
  }

  Widget _buildSubscriptionCard({
    required String title,
    required String price,
    String? priceYear,
    bool showTryButton = false,
    bool showDiscount = false,
    int? discountPercent,
    VoidCallback? onTry,
    required VoidCallback onBuy,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF44AAED),
            Color(0xFF46E4E3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      if (priceYear != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          priceYear,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (showTryButton)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB3E5FC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.tryButton,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0277BD),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onBuy,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.buy,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF44AAED),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Бейдж "Выгода 20%" — жёлтый, тёмный текст (как на примере)
          if (showDiscount && discountPercent != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD54F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppLocalizations.of(context)!.discountPercent(discountPercent!),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF202020),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

