// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flowlytics - Business Analysis Tools';

  @override
  String get businessToolsTitle => 'Business Analysis\nTools';

  @override
  String get selectToolSubtitle =>
      'Select the tool you need for your strategic analysis';

  @override
  String get businessModelCanvas => 'Business Model Canvas';

  @override
  String get businessModelCanvasSubtitle =>
      'Design and visualize your business model';

  @override
  String get businessModelCanvasDescription =>
      'Complete tool to map the 9 fundamental blocks of your business';

  @override
  String get fodaAnalysis => 'SWOT Analysis';

  @override
  String get fodaAnalysisSubtitle =>
      'Evaluate strengths, opportunities, weaknesses and threats';

  @override
  String get fodaAnalysisDescription =>
      'Strategic matrix to analyze internal and external factors of your organization';

  @override
  String get valuePropositionCanvas => 'Value Proposition Canvas';

  @override
  String get valuePropositionCanvasSubtitle =>
      'Define your unique value proposition';

  @override
  String get valuePropositionCanvasDescription =>
      'Visual tool to create products that customers really want';

  @override
  String get teamCanvas => 'Team Canvas';

  @override
  String get teamCanvasSubtitle =>
      'Define the structure and dynamics of your team';

  @override
  String get teamCanvasDescription =>
      'Tool to align teams by defining roles, purpose and ways of working';

  @override
  String get ideaNapkinCanvas => 'Idea Napkin Canvas';

  @override
  String get ideaNapkinCanvasSubtitle =>
      'Capture and validate your business ideas';

  @override
  String get ideaNapkinCanvasDescription =>
      'Simple tool to structure ideas with value formula and sketch';

  @override
  String get autoSaveInfo => 'All tools automatically save your progress';

  @override
  String get versionInfo => 'Flutter Version - Multiplatform';

  @override
  String get home => 'Home';
}
