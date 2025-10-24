import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'business_model_canvas_page.dart';
import 'foda_analysis_page.dart';
import 'value_proposition_canvas_page.dart';
import 'team_canvas_page.dart';
import 'idea_napkin_canvas_page.dart';
import '../widgets/app_navigation_drawer.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.analytics_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'FLOWLYTICS',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Lato',
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: 1.2,
                color: AppTheme.gray900,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (Locale locale) {
              final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
              localeProvider.setLocale(locale);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(locale.languageCode == 'es' 
                    ? 'Idioma cambiado a Español' 
                    : 'Language changed to English'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
              const PopupMenuItem<Locale>(
                value: Locale('es'),
                child: Row(
                  children: [
                    Text('🇪🇸'),
                    SizedBox(width: 8),
                    Text('Español'),
                  ],
                ),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('en'),
                child: Row(
                  children: [
                    Text('🇺🇸'),
                    SizedBox(width: 8),
                    Text('English'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: const AppNavigationDrawer(selectedIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header con logo y título
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.purple.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade200,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.business_center,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.businessToolsTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Lato',
                      color: AppTheme.gray900,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.selectToolSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      color: AppTheme.gray600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
                  
                  // Opciones principales - Grid responsivo con altura automática
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double cardWidth;
                      double spacing;

                      if (constraints.maxWidth > 1200) {
                        // Desktop: 3 columnas
                        cardWidth = (constraints.maxWidth - 48) / 3; // 24px spacing each side
                        spacing = 24;
                      } else if (constraints.maxWidth > 900) {
                        // Tablet grande: 3 columnas
                        cardWidth = (constraints.maxWidth - 40) / 3; // 20px spacing
                        spacing = 20;
                      } else if (constraints.maxWidth > 600) {
                        // Tablet: 2 columnas
                        cardWidth = (constraints.maxWidth - 16) / 2; // 16px spacing
                        spacing = 16;
                      } else {
                        // Móvil: 1 columna
                        cardWidth = constraints.maxWidth;
                        spacing = 16;
                      }

                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: [
                          SizedBox(
                            width: cardWidth,
                            child: _buildToolCard(
                              context,
                              title: AppLocalizations.of(context)!.businessModelCanvas,
                              subtitle: AppLocalizations.of(context)!.businessModelCanvasSubtitle,
                              description: AppLocalizations.of(context)!.businessModelCanvasDescription,
                              icon: Icons.dashboard_outlined,
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade400, Colors.cyan.shade400],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const BusinessModelCanvasPage()),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: _buildToolCard(
                              context,
                              title: AppLocalizations.of(context)!.fodaAnalysis,
                              subtitle: AppLocalizations.of(context)!.fodaAnalysisSubtitle,
                              description: AppLocalizations.of(context)!.fodaAnalysisDescription,
                              icon: Icons.analytics_outlined,
                              gradient: LinearGradient(
                                colors: [Colors.purple.shade400, Colors.pink.shade400],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FodaAnalysisPage()),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: _buildToolCard(
                              context,
                              title: AppLocalizations.of(context)!.valuePropositionCanvas,
                              subtitle: AppLocalizations.of(context)!.valuePropositionCanvasSubtitle,
                              description: AppLocalizations.of(context)!.valuePropositionCanvasDescription,
                              icon: Icons.track_changes,
                              gradient: LinearGradient(
                                colors: [Colors.orange.shade400, Colors.amber.shade400],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ValuePropositionCanvasPage()),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: _buildToolCard(
                              context,
                              title: AppLocalizations.of(context)!.teamCanvas,
                              subtitle: AppLocalizations.of(context)!.teamCanvasSubtitle,
                              description: AppLocalizations.of(context)!.teamCanvasDescription,
                              icon: Icons.groups,
                              gradient: LinearGradient(
                                colors: [Colors.teal.shade400, Colors.green.shade400],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TeamCanvasPage()),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: _buildToolCard(
                              context,
                              title: AppLocalizations.of(context)!.ideaNapkinCanvas,
                              subtitle: AppLocalizations.of(context)!.ideaNapkinCanvasSubtitle,
                              description: AppLocalizations.of(context)!.ideaNapkinCanvasDescription,
                              icon: Icons.lightbulb_outline,
                              gradient: LinearGradient(
                                colors: [Colors.indigo.shade400, Colors.purple.shade400],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const IdeaNapkinCanvasPage()),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              
              const SizedBox(height: 40),
              
              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.autoSaveInfo,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'Roboto',
                          color: AppTheme.gray600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.versionInfo,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'Roboto',
                  color: AppTheme.gray500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono con gradiente
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              
              // Contenido
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      color: AppTheme.gray800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                      color: AppTheme.gray700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      fontFamily: 'Roboto',
                      color: AppTheme.gray600,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Flecha en la esquina inferior derecha
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}