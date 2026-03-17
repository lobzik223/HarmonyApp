import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Harmony'**
  String get appName;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  String get restorePurchases;
  String get purchaseSuccess;
  String get purchaseCancelled;
  String get purchaseError;
  String get restoreSuccess;
  String get restoreError;
  String get storeNotAvailable;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @powerOfThoughts.
  ///
  /// In en, this message translates to:
  /// **'About the power of thinking'**
  String get powerOfThoughts;

  /// No description provided for @popularFromHarmony.
  ///
  /// In en, this message translates to:
  /// **'Popular from Harmony'**
  String get popularFromHarmony;

  /// No description provided for @appBrandName.
  ///
  /// In en, this message translates to:
  /// **'HARMONY'**
  String get appBrandName;

  /// No description provided for @loadingTagline.
  ///
  /// In en, this message translates to:
  /// **'BE AWARE OF THIS MOMENT'**
  String get loadingTagline;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @registrationTitle.
  ///
  /// In en, this message translates to:
  /// **'REGISTRATION'**
  String get registrationTitle;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameHint;

  /// No description provided for @surnameHint.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surnameHint;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @errorEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get errorEnterName;

  /// No description provided for @errorNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name must be at most 50 characters'**
  String get errorNameTooLong;

  /// No description provided for @errorEnterSurname.
  ///
  /// In en, this message translates to:
  /// **'Please enter your surname'**
  String get errorEnterSurname;

  /// No description provided for @errorSurnameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Surname must be at most 50 characters'**
  String get errorSurnameTooLong;

  /// No description provided for @errorEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get errorEnterEmail;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get errorInvalidEmail;

  /// No description provided for @errorEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get errorEnterPassword;

  /// No description provided for @errorPasswordTooLong.
  ///
  /// In en, this message translates to:
  /// **'Password must be at most 128 characters'**
  String get errorPasswordTooLong;

  /// No description provided for @errorRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration error'**
  String get errorRegistration;

  /// No description provided for @errorServerPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Server rejected password as too short. Sent length: {count}.'**
  String errorServerPasswordShort(int count);

  /// No description provided for @errorConnection.
  ///
  /// In en, this message translates to:
  /// **'Could not connect. Please check your internet connection.'**
  String get errorConnection;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get registerButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginLink;

  /// No description provided for @orLoginWith.
  ///
  /// In en, this message translates to:
  /// **'Or sign in with:'**
  String get orLoginWith;

  /// No description provided for @verifyCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get verifyCodeTitle;

  /// No description provided for @verifyCodeDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to your email'**
  String get verifyCodeDescription;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @errorEnterSixDigits.
  ///
  /// In en, this message translates to:
  /// **'Please enter 6 digits of the code'**
  String get errorEnterSixDigits;

  /// No description provided for @errorInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid code'**
  String get errorInvalidCode;

  /// No description provided for @spamHint.
  ///
  /// In en, this message translates to:
  /// **'The code may have gone to Spam. Check spam and junk folders.'**
  String get spamHint;

  /// No description provided for @codePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'000000'**
  String get codePlaceholder;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'LOG IN'**
  String get loginTitle;

  /// No description provided for @phoneOrEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Phone or email'**
  String get phoneOrEmailHint;

  /// No description provided for @errorWrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password'**
  String get errorWrongCredentials;

  /// No description provided for @errorBackendPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Backend rejected password as too short. Sent length: {count}.'**
  String errorBackendPasswordShort(int count);

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @registerLink.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get registerLink;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get profileTitle;

  /// No description provided for @profileDataSection.
  ///
  /// In en, this message translates to:
  /// **'Profile data'**
  String get profileDataSection;

  /// No description provided for @documentsSection.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsSection;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy text will appear here.'**
  String get privacyPolicyPlaceholder;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @termsOfUsePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Terms of use text will appear here.'**
  String get termsOfUsePlaceholder;

  /// No description provided for @notificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSection;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @settingsSection.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsSection;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About app'**
  String get aboutApp;

  /// No description provided for @versionFormat.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get versionFormat;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @errorSavePhoto.
  ///
  /// In en, this message translates to:
  /// **'Could not save photo: {error}'**
  String errorSavePhoto(String error);

  /// No description provided for @editNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get editNameTitle;

  /// No description provided for @snackbarNeedLogin.
  ///
  /// In en, this message translates to:
  /// **'You need to log in'**
  String get snackbarNeedLogin;

  /// No description provided for @errorSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save error'**
  String get errorSaveProfile;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out of account?'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutDialogMessage;

  /// No description provided for @meditationsTitle.
  ///
  /// In en, this message translates to:
  /// **'MEDITATIONS'**
  String get meditationsTitle;

  /// No description provided for @forRelaxation.
  ///
  /// In en, this message translates to:
  /// **'FOR RELAXATION'**
  String get forRelaxation;

  /// No description provided for @forInspiration.
  ///
  /// In en, this message translates to:
  /// **'FOR INSPIRATION'**
  String get forInspiration;

  /// No description provided for @forFindingLove.
  ///
  /// In en, this message translates to:
  /// **'FOR FINDING LOVE'**
  String get forFindingLove;

  /// No description provided for @premiumBadge.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get premiumBadge;

  /// No description provided for @sleepTitle.
  ///
  /// In en, this message translates to:
  /// **'SLEEP'**
  String get sleepTitle;

  /// No description provided for @nightmareExclusion.
  ///
  /// In en, this message translates to:
  /// **'NIGHTMARE EXCLUSION'**
  String get nightmareExclusion;

  /// No description provided for @otherDirection.
  ///
  /// In en, this message translates to:
  /// **'OTHER DIRECTION'**
  String get otherDirection;

  /// No description provided for @listenedTitle.
  ///
  /// In en, this message translates to:
  /// **'Recently played'**
  String get listenedTitle;

  /// No description provided for @allTracks.
  ///
  /// In en, this message translates to:
  /// **'All tracks'**
  String get allTracks;

  /// No description provided for @trackTitlePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Track title'**
  String get trackTitlePlaceholder;

  /// No description provided for @artistPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artistPlaceholder;

  /// No description provided for @activityTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'ACTIVITY TRACKER'**
  String get activityTrackerTitle;

  /// No description provided for @wishes.
  ///
  /// In en, this message translates to:
  /// **'Wishes'**
  String get wishes;

  /// No description provided for @monthJanuary.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJanuary;

  /// No description provided for @monthFebruary.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFebruary;

  /// No description provided for @monthMarch.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMarch;

  /// No description provided for @monthApril.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApril;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJune.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJune;

  /// No description provided for @monthJuly.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJuly;

  /// No description provided for @monthAugust.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAugust;

  /// No description provided for @monthSeptember.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSeptember;

  /// No description provided for @monthOctober.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOctober;

  /// No description provided for @monthNovember.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNovember;

  /// No description provided for @monthDecember.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDecember;

  /// No description provided for @dayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get daySun;

  /// No description provided for @wishesTitle.
  ///
  /// In en, this message translates to:
  /// **'WISHES'**
  String get wishesTitle;

  /// No description provided for @currentWishes.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentWishes;

  /// No description provided for @fulfilledWishes.
  ///
  /// In en, this message translates to:
  /// **'Fulfilled'**
  String get fulfilledWishes;

  /// No description provided for @noCurrentWishes.
  ///
  /// In en, this message translates to:
  /// **'No current wishes'**
  String get noCurrentWishes;

  /// No description provided for @noFulfilledWishes.
  ///
  /// In en, this message translates to:
  /// **'No fulfilled wishes'**
  String get noFulfilledWishes;

  /// No description provided for @newWishTitle.
  ///
  /// In en, this message translates to:
  /// **'New wish'**
  String get newWishTitle;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @snackbarEnterWishTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a wish title'**
  String get snackbarEnterWishTitle;

  /// No description provided for @categoryNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryNamePlaceholder;

  /// No description provided for @giftPremiumCertTitle.
  ///
  /// In en, this message translates to:
  /// **'GIVE A PREMIUM CERTIFICATE'**
  String get giftPremiumCertTitle;

  /// No description provided for @harmonyPremium30Days.
  ///
  /// In en, this message translates to:
  /// **'HARMONY PREMIUM FOR 30 DAYS'**
  String get harmonyPremium30Days;

  /// No description provided for @forLovedOne.
  ///
  /// In en, this message translates to:
  /// **'For a loved one or family member'**
  String get forLovedOne;

  /// No description provided for @buyFor249.
  ///
  /// In en, this message translates to:
  /// **'Buy for 249 ₽'**
  String get buyFor249;

  String get buyFor299;

  /// No description provided for @feelFullHarmonyWith.
  ///
  /// In en, this message translates to:
  /// **'FEEL FULL HARMONY WITH'**
  String get feelFullHarmonyWith;

  /// No description provided for @subscribeFrom199.
  ///
  /// In en, this message translates to:
  /// **'subscribe FROM 199₽/MONTH'**
  String get subscribeFrom199;

  /// No description provided for @monthPlan.
  ///
  /// In en, this message translates to:
  /// **'MONTH'**
  String get monthPlan;

  /// No description provided for @price265PerMonth.
  ///
  /// In en, this message translates to:
  /// **'265 ₽/month'**
  String get price265PerMonth;

  String get price299PerMonth;

  /// No description provided for @tryButton.
  ///
  /// In en, this message translates to:
  /// **'TRY'**
  String get tryButton;

  /// No description provided for @yearPlan.
  ///
  /// In en, this message translates to:
  /// **'YEAR'**
  String get yearPlan;

  /// No description provided for @price199PerMonth.
  ///
  /// In en, this message translates to:
  /// **'199₽/month'**
  String get price199PerMonth;

  /// No description provided for @price2390PerYear.
  ///
  /// In en, this message translates to:
  /// **'2390₽/year'**
  String get price2390PerYear;

  String get price2388PerYear;

  String get premiumYearDiscount;

  /// No description provided for @discountPercent.
  ///
  /// In en, this message translates to:
  /// **'SAVE {percent}%'**
  String discountPercent(int percent);

  String get proBadge;

  String get coursesProTitle;

  String get feelFullHarmonyWithPro;

  String get subscribeProFrom;

  String get price2599Month;

  String get price5997ThreeMonths;

  String get price8994SixMonths;

  String get price12475Year;

  String get threeMonthsPlan;

  String get sixMonthsPlan;

  String get twelveMonthsPlan;

  String get perMonthShort;

  /// No description provided for @errorBackgroundNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Background failed to load'**
  String get errorBackgroundNotLoaded;

  /// No description provided for @planHarmony.
  ///
  /// In en, this message translates to:
  /// **'Harmony'**
  String get planHarmony;

  /// No description provided for @planFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get planFinance;

  /// No description provided for @planHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get planHealth;

  /// No description provided for @planSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get planSleep;

  /// No description provided for @planLove.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get planLove;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
