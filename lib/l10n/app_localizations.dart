import 'package:flutter/material.dart';

/// Локализация приложения: русский и английский.
/// Язык берётся с устройства; при любом другом языке используется английский.
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ru'),
  ];

  bool get isRussian => locale.languageCode == 'ru';
  String get _lang => locale.languageCode == 'ru' ? 'ru' : 'en';

  String _t(String en, String ru) => _lang == 'ru' ? ru : en;

  String get appName => _t('Harmony', 'Harmony');
  String get back => _t('Back', 'Назад');
  String get cancel => _t('Cancel', 'Отмена');
  String get save => _t('Save', 'Сохранить');
  String get add => _t('Add', 'Добавить');
  String get buy => _t('Buy', 'Купить');
  String get all => _t('All', 'Все');
  String get next => _t('Next', 'Далее');

  String get homeTitle => _t('Home', 'Главная');
  String get powerOfThoughts => _t('Power of Thoughts', 'Сила мыслей');
  String get popularFromHarmony => _t('Popular from Harmony', 'Популярное от Harmony');

  String get appBrandName => _t('HARMONY', 'HARMONY');
  String get loadingTagline => _t('BE AWARE OF THIS MOMENT', 'ОСОЗНАЙ ЭТОТ МОМЕНТ');
  String get nextButton => _t('Next', 'Далее');

  String get registrationTitle => _t('REGISTRATION', 'РЕГИСТРАЦИЯ');
  String get nameHint => _t('Name', 'Имя');
  String get surnameHint => _t('Surname', 'Фамилия');
  String get emailHint => _t('Email', 'Почта');
  String get passwordHint => _t('Password', 'Пароль');
  String get errorEnterName => _t('Please enter your name', 'Введите имя');
  String get errorNameTooLong => _t('Name must be at most 50 characters', 'Имя не длиннее 50 символов');
  String get errorEnterSurname => _t('Please enter your surname', 'Введите фамилию');
  String get errorSurnameTooLong => _t('Surname must be at most 50 characters', 'Фамилия не длиннее 50 символов');
  String get errorEnterEmail => _t('Please enter your email', 'Введите почту');
  String get errorInvalidEmail => _t('Please enter a valid email', 'Введите корректный email');
  String get errorEnterPassword => _t('Please enter your password', 'Введите пароль');
  String get errorPasswordTooLong => _t('Password must be at most 128 characters', 'Пароль не длиннее 128 символов');
  String get errorRegistration => _t('Registration error', 'Ошибка регистрации');
  String errorServerPasswordShort(int count) => _lang == 'ru'
      ? 'Сервер отклонил пароль как короткий. Отправленная длина: $count.'
      : 'Server rejected password as too short. Sent length: $count.';
  String get errorConnection => _t('Could not connect. Please check your internet connection.', 'Не удалось подключиться. Проверьте интернет.');
  String get registerButton => _t('Sign up', 'Зарегистрироваться');
  String get alreadyHaveAccount => _t('Already have an account?', 'Уже есть аккаунт?');
  String get loginLink => _t('Log in', 'Войти');
  String get orLoginWith => _t('Or sign in with:', 'Или войдите с помощью:');

  String get verifyCodeTitle => _t('Enter verification code', 'Введите код подтверждения');
  String get verifyCodeDescription => _t('Enter the 6-digit code sent to your email', 'Введите 6 цифр кода, которые пришли на вашу почту');
  String get confirmButton => _t('Confirm', 'Подтвердить');
  String get errorEnterSixDigits => _t('Please enter 6 digits of the code', 'Введите 6 цифр кода');
  String get errorInvalidCode => _t('Invalid code', 'Неверный код');
  String get spamHint => _t('The code may have gone to Spam. Check spam and junk folders.', 'Отправленный код мог попасть в папку «Спам». Проверьте спам и нежелательную почту.');
  String get codePlaceholder => '000000';

  String get loginTitle => _t('LOG IN', 'ВХОД');
  String get phoneOrEmailHint => _t('Phone or email', 'Телефон или почта');
  String get errorWrongCredentials => _t('Wrong email or password', 'Неверная почта или пароль');
  String errorBackendPasswordShort(int count) => _lang == 'ru'
      ? 'Бэкенд отклонил пароль как короткий. Отправленная длина: $count.'
      : 'Backend rejected password as too short. Sent length: $count.';
  String get loginButton => _t('Log in', 'Войти');
  String get noAccount => _t("Don't have an account?", 'Нет аккаунта?');
  String get registerLink => _t('Sign up', 'Зарегистрироваться');

  String get profileTitle => _t('PROFILE', 'ПРОФИЛЬ');
  String get profileDataSection => _t('Profile data', 'Данные профиля');
  String get documentsSection => _t('Documents', 'Документы');
  String get privacyPolicy => _t('Privacy Policy', 'Политика конфиденциальности');
  String get privacyPolicyPlaceholder => _t('Privacy policy text will appear here.', 'Здесь будет текст политики конфиденциальности.');
  String get termsOfUse => _t('Terms of Use', 'Пользовательское соглашение');
  String get termsOfUsePlaceholder => _t('Terms of use text will appear here.', 'Здесь будет текст пользовательского соглашения.');
  String get notificationsSection => _t('Notifications', 'Уведомления');
  String get notifications => _t('Notifications', 'Уведомления');
  String get settingsSection => _t('Settings', 'Настройки');
  String get premium => _t('Premium', 'Premium');
  String get language => _t('Language', 'Язык');
  String get languageRussian => _t('Russian', 'Русский');
  String get languageEnglish => _t('English', 'Английский');
  String get helpAndSupport => _t('Help & Support', 'Помощь и поддержка');
  String get aboutApp => _t('About app', 'О приложении');
  String get versionFormat => _t('Version 1.0.0', 'Версия 1.0.0');
  String get nameLabel => _t('Name', 'Имя');
  String get emailLabel => _t('Email', 'Почта');
  String get defaultUserName => _t('User', 'Пользователь');
  String get logout => _t('Log out', 'Выйти');
  String errorSavePhoto(String error) => _lang == 'ru'
      ? 'Не удалось сохранить фото: $error'
      : 'Could not save photo: $error';
  String get editNameTitle => _t('Edit name', 'Изменить имя');
  String get snackbarNeedLogin => _t('You need to log in', 'Нужно войти в аккаунт');
  String get errorSaveProfile => _t('Save error', 'Ошибка сохранения');
  String get logoutDialogTitle => _t('Log out of account?', 'Выйти из аккаунта?');
  String get logoutDialogMessage => _t('Are you sure you want to log out?', 'Вы уверены, что хотите выйти?');

  String get meditationsTitle => _t('MEDITATIONS', 'МЕДИТАЦИИ');
  String get forRelaxation => _t('FOR RELAXATION', 'ДЛЯ ОТДЫХА');
  String get forInspiration => _t('FOR INSPIRATION', 'ДЛЯ ВДОХНОВЕНИЯ');
  String get forFindingLove => _t('FOR FINDING LOVE', 'ДЛЯ ПОИСКА ЛЮБВИ');
  String get premiumBadge => _t('PREMIUM', 'PREMIUM');

  String get sleepTitle => _t('SLEEP', 'СОН');
  String get nightmareExclusion => _t('NIGHTMARE EXCLUSION', 'ИСКЛЮЧЕНИЕ КОШМАРОВ');
  String get otherDirection => _t('OTHER DIRECTION', 'ДРУГОЕ НАПРАВЛЕНИЕ');

  String get listenedTitle => _t('Recently played', 'Прослушанные');
  String get allTracks => _t('All tracks', 'Все треки');

  String get trackTitlePlaceholder => _t('Track title', 'Название трека');
  String get artistPlaceholder => _t('Artist', 'Исполнитель');

  String get activityTrackerTitle => _t('ACTIVITY TRACKER', 'ТРЕКЕР ЗАНЯТИЙ');
  String get wishes => _t('Wishes', 'Желания');
  String get monthJanuary => _t('January', 'Январь');
  String get monthFebruary => _t('February', 'Февраль');
  String get monthMarch => _t('March', 'Март');
  String get monthApril => _t('April', 'Апрель');
  String get monthMay => _t('May', 'Май');
  String get monthJune => _t('June', 'Июнь');
  String get monthJuly => _t('July', 'Июль');
  String get monthAugust => _t('August', 'Август');
  String get monthSeptember => _t('September', 'Сентябрь');
  String get monthOctober => _t('October', 'Октябрь');
  String get monthNovember => _t('November', 'Ноябрь');
  String get monthDecember => _t('December', 'Декабрь');
  String get dayMon => _t('Mon', 'Пн');
  String get dayTue => _t('Tue', 'Вт');
  String get dayWed => _t('Wed', 'Ср');
  String get dayThu => _t('Thu', 'Чт');
  String get dayFri => _t('Fri', 'Пт');
  String get daySat => _t('Sat', 'Сб');
  String get daySun => _t('Sun', 'Вс');

  String get wishesTitle => _t('WISHES', 'ЖЕЛАНИЯ');
  String get currentWishes => _t('Current', 'Текущие');
  String get fulfilledWishes => _t('Fulfilled', 'Исполненные');
  String get noCurrentWishes => _t('No current wishes', 'Нет текущих желаний');
  String get noFulfilledWishes => _t('No fulfilled wishes', 'Нет исполненных желаний');
  String get newWishTitle => _t('New wish', 'Новое желание');
  String get categoryLabel => _t('Category', 'Категория');
  String get titleLabel => _t('Title', 'Заголовок');
  String get descriptionOptional => _t('Description (optional)', 'Описание (необязательно)');
  String get snackbarEnterWishTitle => _t('Please enter a wish title', 'Введите заголовок желания');
  String get categoryNamePlaceholder => _t('Category name', 'Название категории');

  String get giftPremiumCertTitle => _t('GIVE A PREMIUM CERTIFICATE', 'ПОДАРИТЕ ПРЕМИУМ СЕРТИФИКАТ');
  String get harmonyPremium30Days => _t('HARMONY PREMIUM FOR 30 DAYS', 'HARMONY PREMIUM НА 30 ДНЕЙ');
  String get forLovedOne => _t('For a loved one or family member', 'Близкому или родному человеку');
  String get buyFor249 => _t('Buy for 249 ₽', 'Купить за 249 р.');
  String get feelFullHarmonyWith => _t('FEEL FULL\nHARMONY WITH', 'ПОЧУВСТВУЙ ПОЛНУЮ\nГАРМОНИЮ С');
  String get subscribeFrom199 => _t('subscribe FROM 199₽/MONTH', 'подпишись ВСЕГО ОТ 199Р ЗА МЕС.');
  String get monthPlan => _t('MONTH', 'МЕСЯЦ');
  String get price265PerMonth => _t('265 ₽/month', '265 р. / мес');
  String get tryButton => _t('TRY', 'ПОПРОБУЙТЕ');
  String get yearPlan => _t('YEAR', 'ГОД');
  String get price199PerMonth => _t('199₽/month', '199р. / мес');
  String get price2390PerYear => _t('2390₽/year', '2390р. / год');
  String discountPercent(int percent) => _lang == 'ru' ? 'ВЫГОДА $percent%' : 'SAVE $percent%';

  String get errorBackgroundNotLoaded => _t('Background failed to load', 'Фон не загружен');
  String get planHarmony => _t('Harmony', 'Гармония');
  String get planFinance => _t('Finance', 'Финансы');
  String get planHealth => _t('Health', 'Здоровье');
  String get planSleep => _t('Sleep', 'Сон');
  String get planLove => _t('Love', 'Любовь');
  String get continueButton => _t('Continue', 'Продолжить');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'en' || locale.languageCode == 'ru';

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// Делегат для регистрации в MaterialApp.
LocalizationsDelegate<AppLocalizations> get appLocalizationsDelegate =>
    _AppLocalizationsDelegate();
