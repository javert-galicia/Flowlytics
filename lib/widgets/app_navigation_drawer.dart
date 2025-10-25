import 'package:flutter/material.dart';
import '../pages/business_model_canvas_page.dart';
import '../pages/foda_analysis_page.dart';
import '../pages/value_proposition_canvas_page.dart';
import '../pages/team_canvas_page.dart';
import '../pages/idea_napkin_canvas_page.dart';
import '../pages/home_page.dart';
import '../l10n/app_localizations.dart';

class AppNavigationDrawer extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback? onFaqPressed;
  
  const AppNavigationDrawer({
    super.key,
    this.selectedIndex = 0,
    this.onFaqPressed,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: selectedIndex,
      children: [
        // Header del drawer
        Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.purple.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/logo_400.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'FLOWLYTICS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.appTitle.split(' - ')[1], // Solo la parte "Herramientas..."
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Opciones del drawer
        NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined, color: Colors.blue.shade600),
          selectedIcon: Icon(Icons.home, color: Colors.blue.shade600),
          label: Text(AppLocalizations.of(context)!.home),
        ),
        
        const Divider(),
        
        NavigationDrawerDestination(
          icon: Icon(Icons.dashboard_outlined, color: Colors.blue.shade400),
          selectedIcon: Icon(Icons.dashboard, color: Colors.blue.shade400),
          label: Text(AppLocalizations.of(context)!.businessModelCanvas),
        ),
        
        NavigationDrawerDestination(
          icon: Icon(Icons.analytics_outlined, color: Colors.purple.shade400),
          selectedIcon: Icon(Icons.analytics, color: Colors.purple.shade400),
          label: Text(AppLocalizations.of(context)!.fodaAnalysis),
        ),
        
        NavigationDrawerDestination(
          icon: Icon(Icons.track_changes, color: Colors.orange.shade400),
          selectedIcon: Icon(Icons.track_changes, color: Colors.orange.shade400),
          label: Text(AppLocalizations.of(context)!.valuePropositionCanvas),
        ),
        
        NavigationDrawerDestination(
          icon: Icon(Icons.groups, color: Colors.teal.shade400),
          selectedIcon: Icon(Icons.groups, color: Colors.teal.shade400),
          label: Text(AppLocalizations.of(context)!.teamCanvas),
        ),
        
        NavigationDrawerDestination(
          icon: Icon(Icons.lightbulb_outline, color: Colors.indigo.shade400),
          selectedIcon: Icon(Icons.lightbulb, color: Colors.indigo.shade400),
          label: Text(AppLocalizations.of(context)!.ideaNapkinCanvas),
        ),
        
        const Divider(),
        
        // Botón FAQ
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                Navigator.pop(context); // Cerrar drawer
                if (onFaqPressed != null) {
                  onFaqPressed!();
                }
              },
              icon: Icon(Icons.help_outline, color: Colors.grey.shade600),
              label: Text(
                AppLocalizations.of(context)!.faq,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ),
        
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Todas las herramientas guardan tu progreso automáticamente',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      ],
      onDestinationSelected: (index) {
        Navigator.pop(context); // Cerrar drawer
        _navigateToTool(context, index);
      },
    );
  }

  void _navigateToTool(BuildContext context, int index) {
    // Si ya estamos en la página seleccionada, no hacer nada
    if (index == selectedIndex) return;
    
    Widget page;
    switch (index) {
      case 0: // Inicio
        page = const HomePage();
        break;
      case 1: // Business Model Canvas
        page = const BusinessModelCanvasPage();
        break;
      case 2: // Análisis FODA
        page = const FodaAnalysisPage();
        break;
      case 3: // Value Proposition Canvas
        page = const ValuePropositionCanvasPage();
        break;
      case 4: // Team Canvas
        page = const TeamCanvasPage();
        break;
      case 5: // Idea Napkin Canvas
        page = const IdeaNapkinCanvasPage();
        break;
      default:
        return;
    }
    
    // Reemplazar la página actual en lugar de hacer push
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}