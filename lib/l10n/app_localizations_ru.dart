// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Harmony';

  @override
  String get back => 'Назад';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get add => 'Добавить';

  @override
  String get buy => 'Купить';

  @override
  String get restorePurchases => 'Восстановить покупки';

  @override
  String get purchaseSuccess => 'Подписка активирована';

  @override
  String get purchaseCancelled => 'Покупка отменена';

  @override
  String get purchaseError => 'Ошибка покупки. Попробуйте снова.';

  @override
  String get restoreSuccess => 'Покупки восстановлены';

  @override
  String get restoreError => 'Нечего восстанавливать или ошибка';

  @override
  String get storeNotAvailable => 'Магазин недоступен';

  @override
  String get all => 'Все';

  @override
  String get next => 'Далее';

  @override
  String get homeTitle => 'Главная';

  @override
  String get powerOfThoughts => 'О силе мышления';

  @override
  String get popularFromHarmony => 'Популярное от Harmony';

  @override
  String get appBrandName => 'HARMONY';

  @override
  String get loadingTagline => 'ОСОЗНАЙ ЭТОТ МОМЕНТ';

  @override
  String get nextButton => 'Далее';

  @override
  String get registrationTitle => 'РЕГИСТРАЦИЯ';

  @override
  String get nameHint => 'Имя';

  @override
  String get surnameHint => 'Фамилия';

  @override
  String get emailHint => 'Почта';

  @override
  String get passwordHint => 'Пароль';

  @override
  String get errorEnterName => 'Введите имя';

  @override
  String get errorNameTooLong => 'Имя не длиннее 50 символов';

  @override
  String get errorEnterSurname => 'Введите фамилию';

  @override
  String get errorSurnameTooLong => 'Фамилия не длиннее 50 символов';

  @override
  String get errorEnterEmail => 'Введите почту';

  @override
  String get errorInvalidEmail => 'Введите корректный email';

  @override
  String get errorEnterPassword => 'Введите пароль';

  @override
  String get errorPasswordTooLong => 'Пароль не длиннее 128 символов';

  @override
  String get errorRegistration => 'Ошибка регистрации';

  @override
  String errorServerPasswordShort(int count) {
    return 'Сервер отклонил пароль как короткий. Отправленная длина: $count.';
  }

  @override
  String get errorConnection => 'Не удалось подключиться. Проверьте интернет.';

  @override
  String get registerButton => 'Зарегистрироваться';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get loginLink => 'Войти';

  @override
  String get orLoginWith => 'Или войдите с помощью:';

  @override
  String get verifyCodeTitle => 'Введите код подтверждения';

  @override
  String get verifyCodeDescription =>
      'Введите 6 цифр кода, которые пришли на вашу почту';

  @override
  String get confirmButton => 'Подтвердить';

  @override
  String get errorEnterSixDigits => 'Введите 6 цифр кода';

  @override
  String get errorInvalidCode => 'Неверный код';

  @override
  String get spamHint =>
      'Отправленный код мог попасть в папку «Спам». Проверьте спам и нежелательную почту.';

  @override
  String get codePlaceholder => '000000';

  @override
  String get loginTitle => 'ВХОД';

  @override
  String get phoneOrEmailHint => 'Телефон или почта';

  @override
  String get errorWrongCredentials => 'Неверная почта или пароль';

  @override
  String errorBackendPasswordShort(int count) {
    return 'Бэкенд отклонил пароль как короткий. Отправленная длина: $count.';
  }

  @override
  String get loginButton => 'Войти';

  @override
  String get noAccount => 'Нет аккаунта?';

  @override
  String get registerLink => 'Зарегистрироваться';

  @override
  String get profileTitle => 'ПРОФИЛЬ';

  @override
  String get profileDataSection => 'Данные профиля';

  @override
  String get documentsSection => 'Документы';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get privacyPolicyPlaceholder =>
      'Здесь будет текст политики конфиденциальности.';

  @override
  String get termsOfUse => 'Пользовательское соглашение';

  @override
  String get termsOfUsePlaceholder =>
      'Здесь будет текст пользовательского соглашения.';

  @override
  String get notificationsSection => 'Уведомления';

  @override
  String get notifications => 'Уведомления';

  @override
  String get settingsSection => 'Настройки';

  @override
  String get premium => 'Premium';

  @override
  String get language => 'Язык';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get helpAndSupport => 'Помощь и поддержка';

  @override
  String get aboutApp => 'О приложении';

  @override
  String get versionFormat => 'Версия 1.0.0';

  @override
  String get nameLabel => 'Имя';

  @override
  String get emailLabel => 'Почта';

  @override
  String get logout => 'Выйти';

  @override
  String errorSavePhoto(String error) {
    return 'Не удалось сохранить фото: $error';
  }

  @override
  String get editNameTitle => 'Изменить имя';

  @override
  String get snackbarNeedLogin => 'Нужно войти в аккаунт';

  @override
  String get errorSaveProfile => 'Ошибка сохранения';

  @override
  String get logoutDialogTitle => 'Выйти из аккаунта?';

  @override
  String get logoutDialogMessage => 'Вы уверены, что хотите выйти?';

  @override
  String get meditationsTitle => 'МЕДИТАЦИИ';

  @override
  String get forRelaxation => 'ДЛЯ ОТДЫХА';

  @override
  String get forInspiration => 'ДЛЯ ВДОХНОВЕНИЯ';

  @override
  String get forFindingLove => 'ДЛЯ ПОИСКА ЛЮБВИ';

  @override
  String get premiumBadge => 'PREMIUM';

  @override
  String get sleepTitle => 'СОН';

  @override
  String get nightmareExclusion => 'ИСКЛЮЧЕНИЕ КОШМАРОВ';

  @override
  String get otherDirection => 'ДРУГОЕ НАПРАВЛЕНИЕ';

  @override
  String get listenedTitle => 'Прослушанные';

  @override
  String get allTracks => 'Все треки';

  @override
  String get trackTitlePlaceholder => 'Название трека';

  @override
  String get artistPlaceholder => 'Исполнитель';

  @override
  String get activityTrackerTitle => 'ТРЕКЕР ЗАНЯТИЙ';

  @override
  String get wishes => 'Желания';

  @override
  String get monthJanuary => 'Январь';

  @override
  String get monthFebruary => 'Февраль';

  @override
  String get monthMarch => 'Март';

  @override
  String get monthApril => 'Апрель';

  @override
  String get monthMay => 'Май';

  @override
  String get monthJune => 'Июнь';

  @override
  String get monthJuly => 'Июль';

  @override
  String get monthAugust => 'Август';

  @override
  String get monthSeptember => 'Сентябрь';

  @override
  String get monthOctober => 'Октябрь';

  @override
  String get monthNovember => 'Ноябрь';

  @override
  String get monthDecember => 'Декабрь';

  @override
  String get dayMon => 'Пн';

  @override
  String get dayTue => 'Вт';

  @override
  String get dayWed => 'Ср';

  @override
  String get dayThu => 'Чт';

  @override
  String get dayFri => 'Пт';

  @override
  String get daySat => 'Сб';

  @override
  String get daySun => 'Вс';

  @override
  String get wishesTitle => 'ЖЕЛАНИЯ';

  @override
  String get currentWishes => 'Текущие';

  @override
  String get fulfilledWishes => 'Исполненные';

  @override
  String get noCurrentWishes => 'Нет текущих желаний';

  @override
  String get noFulfilledWishes => 'Нет исполненных желаний';

  @override
  String get newWishTitle => 'Новое желание';

  @override
  String get categoryLabel => 'Категория';

  @override
  String get titleLabel => 'Заголовок';

  @override
  String get descriptionOptional => 'Описание (необязательно)';

  @override
  String get snackbarEnterWishTitle => 'Введите заголовок желания';

  @override
  String get categoryNamePlaceholder => 'Название категории';

  @override
  String get giftPremiumCertTitle => 'ПОДАРИТЕ ПРЕМИУМ СЕРТИФИКАТ';

  @override
  String get harmonyPremium30Days => 'HARMONY PREMIUM НА 30 ДНЕЙ';

  @override
  String get forLovedOne => 'Близкому или родному человеку';

  @override
  String get buyFor249 => 'Купить за 249 р.';

  @override
  String get buyFor299 => 'Купить за 299 р.';

  @override
  String get feelFullHarmonyWith => 'ПОЧУВСТВУЙ ПОЛНУЮ ГАРМОНИЮ С';

  @override
  String get subscribeFrom199 => 'подпишись ВСЕГО ОТ 199Р ЗА МЕС.';

  @override
  String get monthPlan => 'МЕСЯЦ';

  @override
  String get price265PerMonth => '265 р. / мес';

  @override
  String get price299PerMonth => '299₽ / мес';

  @override
  String get tryButton => 'ПОПРОБУЙТЕ';

  @override
  String get yearPlan => 'ГОД';

  @override
  String get price199PerMonth => '199р. / мес';

  @override
  String get price2390PerYear => '2390р. / год';

  @override
  String get price2388PerYear => '2388₽ / год';

  @override
  String get premiumYearDiscount => 'со скидкой 33%/1200₽';

  @override
  String discountPercent(int percent) {
    return 'ВЫГОДА $percent%';
  }

  @override
  String get proBadge => 'Pro';

  @override
  String get coursesProTitle => 'КУРСЫ — ПОДПИСКА PRO';

  @override
  String get feelFullHarmonyWithPro => 'ПОЛНЫЙ ДОСТУП К КУРСАМ С';

  @override
  String get subscribeProFrom => 'подписка Pro от 2599₽/мес';

  @override
  String get price2599Month => '2599₽ / мес';

  @override
  String get price5997ThreeMonths => '5997₽ / 3 мес';

  @override
  String get price8994SixMonths => '8994₽ / 6 мес';

  @override
  String get price12475Year => '12475₽ / 12 мес';

  @override
  String get threeMonthsPlan => '3 МЕС';

  @override
  String get sixMonthsPlan => '6 МЕС';

  @override
  String get twelveMonthsPlan => '12 МЕС';

  @override
  String get perMonthShort => 'в мес';

  @override
  String get errorBackgroundNotLoaded => 'Фон не загружен';

  @override
  String get planHarmony => 'Гармония';

  @override
  String get planFinance => 'Финансы';

  @override
  String get planHealth => 'Здоровье';

  @override
  String get planSleep => 'Сон';

  @override
  String get planLove => 'Любовь';

  @override
  String get continueButton => 'Продолжить';
}
