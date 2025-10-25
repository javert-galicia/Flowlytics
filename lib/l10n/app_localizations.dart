import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
    Locale('es'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Flowlytics - Business Analysis Tools'**
  String get appTitle;

  /// Main title on homepage
  ///
  /// In en, this message translates to:
  /// **'Business Analysis\nTools'**
  String get businessToolsTitle;

  /// Subtitle on homepage
  ///
  /// In en, this message translates to:
  /// **'Select the tool you need for your strategic analysis'**
  String get selectToolSubtitle;

  /// Business Model Canvas tool name
  ///
  /// In en, this message translates to:
  /// **'Business Model Canvas'**
  String get businessModelCanvas;

  /// Business Model Canvas subtitle
  ///
  /// In en, this message translates to:
  /// **'Design and visualize your business model'**
  String get businessModelCanvasSubtitle;

  /// Business Model Canvas description
  ///
  /// In en, this message translates to:
  /// **'Complete tool to map the 9 fundamental blocks of your business'**
  String get businessModelCanvasDescription;

  /// SWOT Analysis tool name
  ///
  /// In en, this message translates to:
  /// **'SWOT Analysis'**
  String get fodaAnalysis;

  /// SWOT Analysis subtitle
  ///
  /// In en, this message translates to:
  /// **'Evaluate strengths, opportunities, weaknesses and threats'**
  String get fodaAnalysisSubtitle;

  /// SWOT Analysis description
  ///
  /// In en, this message translates to:
  /// **'Strategic matrix to analyze internal and external factors of your organization'**
  String get fodaAnalysisDescription;

  /// Value Proposition Canvas tool name
  ///
  /// In en, this message translates to:
  /// **'Value Proposition Canvas'**
  String get valuePropositionCanvas;

  /// Value Proposition Canvas subtitle
  ///
  /// In en, this message translates to:
  /// **'Define your unique value proposition'**
  String get valuePropositionCanvasSubtitle;

  /// Value Proposition Canvas description
  ///
  /// In en, this message translates to:
  /// **'Visual tool to create products that customers really want'**
  String get valuePropositionCanvasDescription;

  /// Team Canvas tool name
  ///
  /// In en, this message translates to:
  /// **'Team Canvas'**
  String get teamCanvas;

  /// Team Canvas subtitle
  ///
  /// In en, this message translates to:
  /// **'Define the structure and dynamics of your team'**
  String get teamCanvasSubtitle;

  /// Team Canvas description
  ///
  /// In en, this message translates to:
  /// **'Tool to align teams by defining roles, purpose and ways of working'**
  String get teamCanvasDescription;

  /// Idea Napkin Canvas tool name
  ///
  /// In en, this message translates to:
  /// **'Idea Napkin Canvas'**
  String get ideaNapkinCanvas;

  /// Idea Napkin Canvas subtitle
  ///
  /// In en, this message translates to:
  /// **'Capture and validate your business ideas'**
  String get ideaNapkinCanvasSubtitle;

  /// Idea Napkin Canvas description
  ///
  /// In en, this message translates to:
  /// **'Simple tool to structure ideas with value formula and sketch'**
  String get ideaNapkinCanvasDescription;

  /// Information about auto-save feature
  ///
  /// In en, this message translates to:
  /// **'All tools automatically save your progress'**
  String get autoSaveInfo;

  /// Version information
  ///
  /// In en, this message translates to:
  /// **'Flowlytics by Javier Galicia'**
  String get versionInfo;

  /// About section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// About dialog title
  ///
  /// In en, this message translates to:
  /// **'About Flowlytics'**
  String get aboutTitle;

  /// About dialog description
  ///
  /// In en, this message translates to:
  /// **'Flowlytics is a suite of business analysis tools to promote Design Thinking and help entrepreneurs and business owners structure and analyze their business ideas.'**
  String get aboutDescription;

  /// Developer credit
  ///
  /// In en, this message translates to:
  /// **'Developed by Javier Galicia'**
  String get developedBy;

  /// GitHub link text
  ///
  /// In en, this message translates to:
  /// **'View code on GitHub'**
  String get visitGithub;

  /// Website link text
  ///
  /// In en, this message translates to:
  /// **'Visit my website'**
  String get visitWebsite;

  /// License section
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// License information
  ///
  /// In en, this message translates to:
  /// **'Licensed under GPL v3'**
  String get licenseInfo;

  /// View license link text
  ///
  /// In en, this message translates to:
  /// **'View License'**
  String get viewLicense;

  /// FAQ section
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// FAQ dialog title
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faqTitle;

  /// FAQ question 1
  ///
  /// In en, this message translates to:
  /// **'What is Flowlytics?'**
  String get faqQ1;

  /// FAQ answer 1
  ///
  /// In en, this message translates to:
  /// **'Flowlytics is a suite of business analysis tools to promote Design Thinking and help entrepreneurs and business owners structure and analyze their business ideas using methodologies like Business Model Canvas, SWOT, Value Proposition Canvas, Team Canvas and Idea Napkin Canvas.'**
  String get faqA1;

  /// FAQ question 2
  ///
  /// In en, this message translates to:
  /// **'Is my data saved automatically?'**
  String get faqQ2;

  /// FAQ answer 2
  ///
  /// In en, this message translates to:
  /// **'Yes, all tools save your progress automatically as you work. Data is stored locally on your device using SharedPreferences.'**
  String get faqA2;

  /// FAQ question 3
  ///
  /// In en, this message translates to:
  /// **'Can I use Flowlytics offline?'**
  String get faqQ3;

  /// FAQ answer 3
  ///
  /// In en, this message translates to:
  /// **'Yes, Flowlytics works completely offline. You only need internet to download the app initially.'**
  String get faqA3;

  /// FAQ question 4
  ///
  /// In en, this message translates to:
  /// **'What platforms is it available on?'**
  String get faqQ4;

  /// FAQ answer 4
  ///
  /// In en, this message translates to:
  /// **'Flowlytics is a cross-platform application compatible with Windows, macOS, Linux, Android and iOS.'**
  String get faqA4;

  /// FAQ question 5
  ///
  /// In en, this message translates to:
  /// **'Can I export my data?'**
  String get faqQ5;

  /// FAQ answer 5
  ///
  /// In en, this message translates to:
  /// **'Currently data is saved locally. Future versions will include export and import options.'**
  String get faqA5;

  /// FAQ question 6
  ///
  /// In en, this message translates to:
  /// **'How can I participate in the community?'**
  String get faqQ6;

  /// FAQ answer 6
  ///
  /// In en, this message translates to:
  /// **'You can participate in GitHub discussions (https://github.com/javert-galicia/Flowlytics/issues), report bugs in Issues (https://github.com/javert-galicia/Flowlytics/issues), suggest improvements or contribute to the code. Connect with other users in our forum and report bugs directly on GitHub.'**
  String get faqA6;

  /// Visit forum link text
  ///
  /// In en, this message translates to:
  /// **'Visit Forum'**
  String get visitForum;

  /// Report issue link text
  ///
  /// In en, this message translates to:
  /// **'Report Bug'**
  String get reportIssue;

  /// Home navigation item
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Business Model Canvas - Key Partners section
  ///
  /// In en, this message translates to:
  /// **'Key Partners'**
  String get keyPartners;

  /// Business Model Canvas - Key Activities section
  ///
  /// In en, this message translates to:
  /// **'Key Activities'**
  String get keyActivities;

  /// Business Model Canvas - Key Resources section
  ///
  /// In en, this message translates to:
  /// **'Key Resources'**
  String get keyResources;

  /// Business Model Canvas - Value Propositions section
  ///
  /// In en, this message translates to:
  /// **'Value Propositions'**
  String get valuePropositions;

  /// Business Model Canvas - Customer Relationships section
  ///
  /// In en, this message translates to:
  /// **'Customer Relationships'**
  String get customerRelationships;

  /// Business Model Canvas - Channels section
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get channels;

  /// Business Model Canvas - Customer Segments section
  ///
  /// In en, this message translates to:
  /// **'Customer Segments'**
  String get customerSegments;

  /// Business Model Canvas - Cost Structure section
  ///
  /// In en, this message translates to:
  /// **'Cost Structure'**
  String get costStructure;

  /// Business Model Canvas - Revenue Streams section
  ///
  /// In en, this message translates to:
  /// **'Revenue Streams'**
  String get revenueStreams;

  /// Text shown when a section is empty
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// Text shown for additional items in preview
  ///
  /// In en, this message translates to:
  /// **'more'**
  String get more;

  /// Title for canvas preview dialog
  ///
  /// In en, this message translates to:
  /// **'Canvas Preview'**
  String get canvasPreview;

  /// Subtitle for automatic update feature
  ///
  /// In en, this message translates to:
  /// **'Automatic Update'**
  String get automaticUpdate;

  /// Live update indicator
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get liveUpdate;

  /// Information about automatic view updates
  ///
  /// In en, this message translates to:
  /// **'View updated automatically'**
  String get viewUpdatedAutomatically;

  /// Tooltip for preview button
  ///
  /// In en, this message translates to:
  /// **'Full canvas preview'**
  String get fullCanvasPreview;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Information text for Business Model Canvas
  ///
  /// In en, this message translates to:
  /// **'Tool to design and visualize business models.\n\nAdd elements in each section and they will be saved automatically.\n\nFlowlytics by Javier Galicia'**
  String get businessModelCanvasInfo;

  /// SWOT Analysis - Strengths section
  ///
  /// In en, this message translates to:
  /// **'Strengths'**
  String get strengths;

  /// SWOT Analysis - Opportunities section
  ///
  /// In en, this message translates to:
  /// **'Opportunities'**
  String get opportunities;

  /// SWOT Analysis - Weaknesses section
  ///
  /// In en, this message translates to:
  /// **'Weaknesses'**
  String get weaknesses;

  /// SWOT Analysis - Threats section
  ///
  /// In en, this message translates to:
  /// **'Threats'**
  String get threats;

  /// Title for SWOT preview dialog
  ///
  /// In en, this message translates to:
  /// **'SWOT Preview'**
  String get swotPreview;

  /// Tooltip for SWOT preview button
  ///
  /// In en, this message translates to:
  /// **'Full SWOT preview'**
  String get fullSwotPreview;

  /// Information text for SWOT Analysis
  ///
  /// In en, this message translates to:
  /// **'Strategic tool to analyze internal and external factors.\n\nAdd elements in each quadrant and they will be saved automatically.\n\nFlowlytics by Javier Galicia'**
  String get swotAnalysisInfo;

  /// Value Proposition Canvas - Customer Jobs section
  ///
  /// In en, this message translates to:
  /// **'Customer Jobs'**
  String get customerJobs;

  /// Value Proposition Canvas - Pain Points section
  ///
  /// In en, this message translates to:
  /// **'Pain Points'**
  String get painPoints;

  /// Value Proposition Canvas - Gain Creators section
  ///
  /// In en, this message translates to:
  /// **'Gain Creators'**
  String get gainCreators;

  /// Value Proposition Canvas - Products section
  ///
  /// In en, this message translates to:
  /// **'Products & Services'**
  String get products;

  /// Value Proposition Canvas - Pain Relievers section
  ///
  /// In en, this message translates to:
  /// **'Pain Relievers'**
  String get painRelievers;

  /// Value Proposition Canvas - Customer Gains section
  ///
  /// In en, this message translates to:
  /// **'Customer Gains'**
  String get gains;

  /// Title for Value Proposition preview dialog
  ///
  /// In en, this message translates to:
  /// **'Value Proposition Preview'**
  String get valuePropositionPreview;

  /// Tooltip for Value Proposition preview button
  ///
  /// In en, this message translates to:
  /// **'Full Value Proposition preview'**
  String get fullValuePropositionPreview;

  /// Information text for Value Proposition Canvas
  ///
  /// In en, this message translates to:
  /// **'Visual tool to create products that customers really want.\n\nAdd elements in each section and they will be saved automatically.\n\nFlowlytics by Javier Galicia'**
  String get valuePropositionCanvasInfo;

  /// Team Canvas - People section
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get people;

  /// Team Canvas - Purpose section
  ///
  /// In en, this message translates to:
  /// **'Purpose & Mission'**
  String get purpose;

  /// Team Canvas - Personality section
  ///
  /// In en, this message translates to:
  /// **'Personality & Culture'**
  String get personality;

  /// Team Canvas - Rules section
  ///
  /// In en, this message translates to:
  /// **'Rules & Activities'**
  String get rules;

  /// Team Canvas - Roles section
  ///
  /// In en, this message translates to:
  /// **'Roles & Skills'**
  String get roles;

  /// Team Canvas - Rituals section
  ///
  /// In en, this message translates to:
  /// **'Rituals & Meetings'**
  String get rituals;

  /// Title for Team preview dialog
  ///
  /// In en, this message translates to:
  /// **'Team Preview'**
  String get teamPreview;

  /// Tooltip for Team preview button
  ///
  /// In en, this message translates to:
  /// **'Full Team preview'**
  String get fullTeamPreview;

  /// Information text for Team Canvas
  ///
  /// In en, this message translates to:
  /// **'Tool to align teams by defining roles, purpose and ways of working.\n\nAdd elements in each section and they will be saved automatically.\n\nFlowlytics by Javier Galicia'**
  String get teamCanvasInfo;

  /// Idea Napkin Canvas - Problems section
  ///
  /// In en, this message translates to:
  /// **'Problems'**
  String get problems;

  /// Idea Napkin Canvas - Solutions section
  ///
  /// In en, this message translates to:
  /// **'Solution Ideas'**
  String get solutions;

  /// Idea Napkin Canvas - Key Metrics section
  ///
  /// In en, this message translates to:
  /// **'Key Metrics'**
  String get keyMetrics;

  /// Idea Napkin Canvas - Unique Value Proposition section
  ///
  /// In en, this message translates to:
  /// **'Unique Value Proposition'**
  String get uniqueValueProposition;

  /// Idea Napkin Canvas - Unfair Advantage section
  ///
  /// In en, this message translates to:
  /// **'Unfair Advantage'**
  String get unfairAdvantage;

  /// Title for Idea Napkin preview dialog
  ///
  /// In en, this message translates to:
  /// **'Idea Preview'**
  String get ideaPreview;

  /// Tooltip for Idea Napkin preview button
  ///
  /// In en, this message translates to:
  /// **'Full Idea preview'**
  String get fullIdeaPreview;

  /// Information text for Idea Napkin Canvas
  ///
  /// In en, this message translates to:
  /// **'Simple tool to structure ideas with value formula and sketch.\n\nAdd elements in each section and they will be saved automatically.\n\nFlowlytics by Javier Galicia'**
  String get ideaNapkinCanvasInfo;

  /// Title for idea title section
  ///
  /// In en, this message translates to:
  /// **'Idea Title'**
  String get ideaTitle;

  /// Hint text for idea title input
  ///
  /// In en, this message translates to:
  /// **'Enter your idea title...'**
  String get ideaTitleHint;

  /// Title for short description section
  ///
  /// In en, this message translates to:
  /// **'Short Description'**
  String get shortDescription;

  /// Hint text for description input
  ///
  /// In en, this message translates to:
  /// **'Briefly describe your idea...'**
  String get shortDescriptionHint;

  /// Title for target audience section
  ///
  /// In en, this message translates to:
  /// **'Target Audience'**
  String get targetAudience;

  /// Hint text for audience input
  ///
  /// In en, this message translates to:
  /// **'Who is this idea for?'**
  String get targetAudienceHint;

  /// Title for innovation aspect section
  ///
  /// In en, this message translates to:
  /// **'Innovation Aspect'**
  String get innovationAspect;

  /// Hint text for innovation input
  ///
  /// In en, this message translates to:
  /// **'What makes your idea unique?'**
  String get innovationAspectHint;

  /// Title for value formula section
  ///
  /// In en, this message translates to:
  /// **'Value Formula'**
  String get valueFormula;

  /// Label for business value input
  ///
  /// In en, this message translates to:
  /// **'Business Value'**
  String get businessValue;

  /// Label for innovation power input
  ///
  /// In en, this message translates to:
  /// **'Innovation Power'**
  String get innovationPower;

  /// Label for user value input
  ///
  /// In en, this message translates to:
  /// **'User Value'**
  String get userValue;

  /// Title for sketch section
  ///
  /// In en, this message translates to:
  /// **'Idea Sketch'**
  String get ideaSketch;

  /// Title for clear canvas dialog
  ///
  /// In en, this message translates to:
  /// **'Clear Canvas'**
  String get clearCanvas;

  /// Confirmation message for clearing canvas
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all content from the Idea Napkin Canvas?'**
  String get clearCanvasConfirm;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Clear button text
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Message shown when canvas is saved
  ///
  /// In en, this message translates to:
  /// **'Canvas saved automatically'**
  String get canvasSaved;

  /// Description for products section
  ///
  /// In en, this message translates to:
  /// **'List of products and services you offer'**
  String get productsDescription;

  /// Description for pain relievers section
  ///
  /// In en, this message translates to:
  /// **'How you alleviate customer frustrations'**
  String get painRelieversDescription;

  /// Description for gain creators section
  ///
  /// In en, this message translates to:
  /// **'How you create joy for the customer'**
  String get gainCreatorsDescription;

  /// Description for customer jobs section
  ///
  /// In en, this message translates to:
  /// **'What tasks the customer is trying to accomplish'**
  String get customerJobsDescription;

  /// Description for pains section
  ///
  /// In en, this message translates to:
  /// **'What frustrates or bothers the customer'**
  String get painsDescription;

  /// Description for gains section
  ///
  /// In en, this message translates to:
  /// **'What excites or benefits the customer'**
  String get gainsDescription;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
