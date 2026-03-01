import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../main.dart';
import '../premium/premium_screen.dart';
import '../loading/loading_screen.dart';
import '../legal/legal_text_screen.dart';
import '../../core/utils/navigation_utils.dart';
import '../../core/auth/auth_storage.dart';
import '../../core/api/auth_api.dart';

/// Экран "Профиль"
/// Фон: assets/images/fon1.jpg
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Пользователь';
  String _userSurname = '';
  String _userEmail = 'user@example.com';
  bool _notificationsEnabled = true;
  String? _profilePhotoPath;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = await AuthStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        final user = await AuthApi.me(token);
        if (user != null) {
          final name = user['name'] as String? ?? '';
          final surname = user['surname'] as String? ?? '';
          final email = user['email'] as String? ?? '';
          await AuthStorage.saveUserProfile(name: name, surname: surname);
          if (mounted) {
            setState(() {
              _userName = name.isNotEmpty ? name : (await AuthStorage.getUserName() ?? 'Пользователь');
              _userSurname = surname;
              _userEmail = email.isNotEmpty ? email : (await AuthStorage.getUserEmail() ?? '');
            });
          }
        }
      }
      if (mounted) {
        final authName = await AuthStorage.getUserName();
        final authEmail = await AuthStorage.getUserEmail();
        final authSurname = await AuthStorage.getUserSurname();
        final photoPath = await AuthStorage.getProfilePhotoPath();
        setState(() {
          _userName = authName ?? prefs.getString('user_name') ?? _userName;
          _userSurname = authSurname ?? _userSurname;
          _userEmail = authEmail ?? prefs.getString('user_email') ?? _userEmail;
          _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
          _profilePhotoPath = photoPath;
        });
      }
    } catch (e) {
      print('Ошибка загрузки данных профиля: $e');
    }
  }

  Future<void> _saveProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _userName);
      await prefs.setString('user_email', _userEmail);
      await prefs.setBool('notifications_enabled', _notificationsEnabled);
    } catch (e) {
      print('Ошибка сохранения данных профиля: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final scrollViewHeight = screenHeight - 110 - 100; // top: 110, bottom: 100
    
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Фоновое изображение на весь экран
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fon1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Кнопка "Назад" вверху слева
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
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Назад',
                          style: TextStyle(
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

          // Заголовок "ПРОФИЛЬ" в верхней части
          Positioned(
            top: 62,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'ПРОФИЛЬ',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),

          // Скроллируемый контент
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            child: SizedBox(
              height: scrollViewHeight,
              child: ClipRect(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Карточка профиля
                  _buildProfileCard(),
                  const SizedBox(height: 20),
                  
                  // Раздел "Данные профиля"
                  _buildSectionTitle('Данные профиля'),
                  const SizedBox(height: 12),
                  _buildProfileDataCard(),
                  const SizedBox(height: 20),
                  
                  // Политика конфиденциальности и Пользовательское соглашение
                  _buildSectionTitle('Документы'),
                  const SizedBox(height: 12),
                  _buildLegalCard(),
                  const SizedBox(height: 20),
                  
                  // Раздел "Уведомления"
                  _buildSectionTitle('Уведомления'),
                  const SizedBox(height: 12),
                  _buildNotificationsCard(),
                  const SizedBox(height: 20),
                  
                  // Раздел "Настройки"
                  _buildSectionTitle('Настройки'),
                  const SizedBox(height: 12),
                  _buildSettingsCard(),
                  const SizedBox(height: 20),
                  
                  // Кнопка выхода
                  _buildLogoutButton(),
                  const SizedBox(height: 32),
                ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildProfileCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Аватар (локальное фото или заглушка)
              GestureDetector(
                onTap: _pickProfilePhoto,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: _profilePhotoPath != null
                        ? Image.file(
                            File(_profilePhotoPath!),
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                            errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(),
                          )
                        : _buildAvatarPlaceholder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userSurname.isEmpty ? _userName : '$_userName $_userSurname'.trim(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _userEmail,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showEditNameDialog(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person, size: 40, color: Colors.white),
      ),
    );
  }

  Widget _buildProfileDataCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildSettingItem(
                icon: Icons.person_outline,
                title: 'Имя',
                value: _userSurname.isEmpty ? _userName : '$_userName $_userSurname'.trim(),
                onTap: () => _showEditNameDialog(),
              ),
              const Divider(color: Colors.white24, height: 24),
              _buildSettingItem(
                icon: Icons.email_outlined,
                title: 'Почта',
                value: _userEmail,
                onTap: null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegalCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildSettingItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Политика конфиденциальности',
                value: '',
                onTap: () {
                  Navigator.of(context).push(
                    noAnimationRoute(const LegalTextScreen(
                      title: 'Политика конфиденциальности',
                      body: 'Здесь будет текст политики конфиденциальности.',
                    )),
                  );
                },
              ),
              const Divider(color: Colors.white24, height: 24),
              _buildSettingItem(
                icon: Icons.description_outlined,
                title: 'Пользовательское соглашение',
                value: '',
                onTap: () {
                  Navigator.of(context).push(
                    noAnimationRoute(const LegalTextScreen(
                      title: 'Пользовательское соглашение',
                      body: 'Здесь будет текст пользовательского соглашения.',
                    )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildSwitchItem(
            icon: Icons.notifications_outlined,
            title: 'Уведомления',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              _saveProfileData();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildSettingItem(
                icon: Icons.star_outline,
                title: 'Premium',
                value: '',
                onTap: () {
                  Navigator.of(context).push(
                    noAnimationRoute(const PremiumScreen()),
                  );
                },
              ),
              const Divider(color: Colors.white24, height: 24),
              _buildSettingItem(
                icon: Icons.language_outlined,
                title: 'Язык',
                value: 'Русский',
                onTap: () {},
              ),
              const Divider(color: Colors.white24, height: 24),
              _buildSettingItem(
                icon: Icons.help_outline,
                title: 'Помощь и поддержка',
                value: '',
                onTap: () {},
              ),
              const Divider(color: Colors.white24, height: 24),
              _buildSettingItem(
                icon: Icons.info_outline,
                title: 'О приложении',
                value: 'Версия 1.0.0',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          const SizedBox(width: 8),
          if (onTap != null)
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.white70,
            )
          else
            const Icon(
              Icons.lock_outline,
              size: 18,
              color: Colors.white54,
            ),
        ],
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.white),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF04FF5C),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () => _showLogoutDialog(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout,
                  size: 24,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  'Выйти',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickProfilePhoto() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null || !mounted) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      const filename = 'profile_photo.jpg';
      final dest = File('${dir.path}/$filename');
      await File(file.path).copy(dest.path);
      await AuthStorage.setProfilePhotoPath(dest.path);
      if (mounted) setState(() => _profilePhotoPath = dest.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось сохранить фото: $e')),
        );
      }
    }
  }

  void _showEditNameDialog() {
    final displayName = _userSurname.isEmpty ? _userName : '$_userName $_userSurname'.trim();
    final controller = TextEditingController(text: displayName);
    showDialog(
      context: context,
      builder: (context) => _EditDialog(
        title: 'Изменить имя',
        controller: controller,
        onSave: (value) async {
          final name = value.trim();
          if (name.isEmpty) return;
          final token = await AuthStorage.getAccessToken();
          if (token == null || token.isEmpty) {
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Нужно войти в аккаунт')),
            );
            return;
          }
          final parts = name.split(RegExp(r'\s+'));
          final newName = parts.isNotEmpty ? parts.first : name;
          final newSurname = parts.length > 1 ? parts.sublist(1).join(' ') : _userSurname;
          final result = await AuthApi.updateProfile(token, name: newName, surname: newSurname);
          if (!mounted) return;
          if (result.success && result.name != null) {
            await AuthStorage.saveUserProfile(name: result.name, surname: result.surname ?? '');
            setState(() {
              _userName = result.name!;
              _userSurname = result.surname ?? '';
            });
            _saveProfileData();
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result.error ?? 'Ошибка сохранения')),
            );
          }
        },
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Выйти из аккаунта?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF202020),
          ),
        ),
        content: Text(
          'Вы уверены, что хотите выйти?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF424242),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Отмена',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1976D2),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await AuthStorage.clearAuth();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  noAnimationRoute(const LoadingScreen()),
                  (_) => false,
                );
              }
            },
            child: Text(
              'Выйти',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFD32F2F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Диалог редактирования одного поля
class _EditDialog extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final Future<void> Function(String) onSave;

  const _EditDialog({
    required this.title,
    required this.controller,
    required this.onSave,
  });

  @override
  State<_EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: widget.controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Отмена', style: TextStyle(color: Colors.white70)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        await widget.onSave(widget.controller.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                      ),
                      child: const Text('Сохранить'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

