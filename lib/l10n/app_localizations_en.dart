// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Harmony';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String get buy => 'Buy';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get purchaseSuccess => 'Subscription activated';

  @override
  String get purchaseCancelled => 'Purchase cancelled';

  @override
  String get purchaseError => 'Purchase failed. Try again.';

  @override
  String get restoreSuccess => 'Purchases restored';

  @override
  String get restoreError => 'Nothing to restore or error';

  @override
  String get storeNotAvailable => 'Store not available';

  @override
  String get all => 'All';

  @override
  String get next => 'Next';

  @override
  String get homeTitle => 'Home';

  @override
  String get powerOfThoughts => 'About the power of thinking';

  @override
  String get popularFromHarmony => 'Popular from Harmony';

  @override
  String get appBrandName => 'HARMONY';

  @override
  String get loadingTagline => 'BE AWARE OF THIS MOMENT';

  @override
  String get nextButton => 'Next';

  @override
  String get registrationTitle => 'REGISTRATION';

  @override
  String get nameHint => 'Name';

  @override
  String get surnameHint => 'Surname';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get errorEnterName => 'Please enter your name';

  @override
  String get errorNameTooLong => 'Name must be at most 50 characters';

  @override
  String get errorEnterSurname => 'Please enter your surname';

  @override
  String get errorSurnameTooLong => 'Surname must be at most 50 characters';

  @override
  String get errorEnterEmail => 'Please enter your email';

  @override
  String get errorInvalidEmail => 'Please enter a valid email';

  @override
  String get errorEnterPassword => 'Please enter your password';

  @override
  String get errorPasswordTooLong => 'Password must be at most 128 characters';

  @override
  String get errorRegistration => 'Registration error';

  @override
  String errorServerPasswordShort(int count) {
    return 'Server rejected password as too short. Sent length: $count.';
  }

  @override
  String get errorConnection =>
      'Could not connect. Please check your internet connection.';

  @override
  String get registerButton => 'Sign up';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get loginLink => 'Log in';

  @override
  String get orLoginWith => 'Or sign in with:';

  @override
  String get verifyCodeTitle => 'Enter verification code';

  @override
  String get verifyCodeDescription =>
      'Enter the 6-digit code sent to your email';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get errorEnterSixDigits => 'Please enter 6 digits of the code';

  @override
  String get errorInvalidCode => 'Invalid code';

  @override
  String get spamHint =>
      'The code may have gone to Spam. Check spam and junk folders.';

  @override
  String get codePlaceholder => '000000';

  @override
  String get loginTitle => 'LOG IN';

  @override
  String get phoneOrEmailHint => 'Phone or email';

  @override
  String get errorWrongCredentials => 'Wrong email or password';

  @override
  String errorBackendPasswordShort(int count) {
    return 'Backend rejected password as too short. Sent length: $count.';
  }

  @override
  String get loginButton => 'Log in';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get registerLink => 'Sign up';

  @override
  String get profileTitle => 'PROFILE';

  @override
  String get profileDataSection => 'Profile data';

  @override
  String get documentsSection => 'Documents';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyPlaceholder =>
      'Privacy policy text will appear here.';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get termsOfUsePlaceholder => 'Terms of use text will appear here.';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get notifications => 'Notifications';

  @override
  String get settingsSection => 'Settings';

  @override
  String get premium => 'Premium';

  @override
  String get language => 'Language';

  @override
  String get languageRussian => 'Russian';

  @override
  String get languageEnglish => 'English';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get aboutApp => 'About app';

  @override
  String get versionFormat => 'Version 1.0.0';

  @override
  String get nameLabel => 'Name';

  @override
  String get emailLabel => 'Email';

  @override
  String get logout => 'Log out';

  @override
  String errorSavePhoto(String error) {
    return 'Could not save photo: $error';
  }

  @override
  String get editNameTitle => 'Edit name';

  @override
  String get snackbarNeedLogin => 'You need to log in';

  @override
  String get errorSaveProfile => 'Save error';

  @override
  String get logoutDialogTitle => 'Log out of account?';

  @override
  String get logoutDialogMessage => 'Are you sure you want to log out?';

  @override
  String get meditationsTitle => 'MEDITATIONS';

  @override
  String get forRelaxation => 'FOR RELAXATION';

  @override
  String get forInspiration => 'FOR INSPIRATION';

  @override
  String get forFindingLove => 'FOR FINDING LOVE';

  @override
  String get premiumBadge => 'PREMIUM';

  @override
  String get sleepTitle => 'SLEEP';

  @override
  String get nightmareExclusion => 'NIGHTMARE EXCLUSION';

  @override
  String get otherDirection => 'OTHER DIRECTION';

  @override
  String get listenedTitle => 'Recently played';

  @override
  String get allTracks => 'All tracks';

  @override
  String get trackTitlePlaceholder => 'Track title';

  @override
  String get artistPlaceholder => 'Artist';

  @override
  String get activityTrackerTitle => 'ACTIVITY TRACKER';

  @override
  String get wishes => 'Wishes';

  @override
  String get monthJanuary => 'January';

  @override
  String get monthFebruary => 'February';

  @override
  String get monthMarch => 'March';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJune => 'June';

  @override
  String get monthJuly => 'July';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'October';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get daySun => 'Sun';

  @override
  String get wishesTitle => 'WISHES';

  @override
  String get currentWishes => 'Current';

  @override
  String get fulfilledWishes => 'Fulfilled';

  @override
  String get noCurrentWishes => 'No current wishes';

  @override
  String get noFulfilledWishes => 'No fulfilled wishes';

  @override
  String get newWishTitle => 'New wish';

  @override
  String get categoryLabel => 'Category';

  @override
  String get titleLabel => 'Title';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get snackbarEnterWishTitle => 'Please enter a wish title';

  @override
  String get categoryNamePlaceholder => 'Category name';

  @override
  String get giftPremiumCertTitle => 'GIVE A PREMIUM CERTIFICATE';

  @override
  String get harmonyPremium30Days => 'HARMONY PREMIUM FOR 30 DAYS';

  @override
  String get forLovedOne => 'For a loved one or family member';

  @override
  String get buyFor249 => 'Buy for 249 ₽';

  @override
  String get buyFor299 => 'Buy for 299 ₽';

  @override
  String get feelFullHarmonyWith => 'FEEL FULL HARMONY WITH';

  @override
  String get subscribeFrom199 => 'subscribe FROM 199₽/MONTH';

  @override
  String get monthPlan => 'MONTH';

  @override
  String get price265PerMonth => '265 ₽/month';

  @override
  String get price299PerMonth => '299₽/month';

  @override
  String get tryButton => 'TRY';

  @override
  String get yearPlan => 'YEAR';

  @override
  String get price199PerMonth => '199₽/month';

  @override
  String get price2390PerYear => '2390₽/year';

  @override
  String get price2388PerYear => '2388₽/year';

  @override
  String get premiumYearDiscount => '33% off/1200₽ saved';

  @override
  String discountPercent(int percent) {
    return 'SAVE $percent%';
  }

  @override
  String get proBadge => 'Pro';

  @override
  String get coursesProTitle => 'COURSES — PRO SUBSCRIPTION';

  @override
  String get feelFullHarmonyWithPro => 'FULL ACCESS TO COURSES WITH';

  @override
  String get subscribeProFrom => 'Pro subscription from 2599₽/month';

  @override
  String get price2599Month => '2599₽/month';

  @override
  String get price5997ThreeMonths => '5997₽/3 months';

  @override
  String get price8994SixMonths => '8994₽/6 months';

  @override
  String get price12475Year => '12475₽/12 months';

  @override
  String get threeMonthsPlan => '3 MONTHS';

  @override
  String get sixMonthsPlan => '6 MONTHS';

  @override
  String get twelveMonthsPlan => '12 MONTHS';

  @override
  String get perMonthShort => 'per month';

  @override
  String get errorBackgroundNotLoaded => 'Background failed to load';

  @override
  String get planHarmony => 'Harmony';

  @override
  String get planFinance => 'Finance';

  @override
  String get planHealth => 'Health';

  @override
  String get planSleep => 'Sleep';

  @override
  String get planLove => 'Love';

  @override
  String get continueButton => 'Continue';
}
