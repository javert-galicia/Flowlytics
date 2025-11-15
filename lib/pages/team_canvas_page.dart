import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/canvas_models.dart';
import '../widgets/team_canvas_section.dart';
import '../widgets/team_canvas_grid_section.dart';
import '../widgets/app_navigation_drawer.dart';
import '../l10n/app_localizations.dart';

class TeamCanvasPage extends StatefulWidget {
  const TeamCanvasPage({super.key});

  @override
  State<TeamCanvasPage> createState() => _TeamCanvasPageState();
}

class _TeamCanvasPageState extends State<TeamCanvasPage> {
  TeamCanvas teamCanvas = TeamCanvas.empty();
  bool isLoading = true;
  VoidCallback? _dialogUpdateCallback;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? canvasData = prefs.getString('team_canvas');
    
    if (canvasData != null) {
      final Map<String, dynamic> jsonData = json.decode(canvasData);
      setState(() {
        teamCanvas = TeamCanvas.fromJson(jsonData);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String canvasData = json.encode(teamCanvas.toJson());
    await prefs.setString('team_canvas', canvasData);
  }

  void _updateSection(String sectionId, List<String> content) {
    setState(() {
      teamCanvas = teamCanvas.updateById(sectionId, content);
    });
    _saveData();
    
    // Actualizar el dialog de preview si está abierto
    if (_dialogUpdateCallback != null) {
      _dialogUpdateCallback!();
    }
  }

  String _getLocalizedTitle(BuildContext context, String id) {
    final localizations = AppLocalizations.of(context)!;
    switch (id) {
      case 'people':
        return localizations.people;
      case 'activities':
        return localizations.activities;
      case 'personalGoals':
        return localizations.personalGoals;
      case 'purpose':
        return localizations.purpose;
      case 'rules':
        return localizations.rules;
      case 'skills':
        return localizations.skills;
      case 'tools':
        return localizations.tools;
      case 'network':
        return localizations.network;
      case 'values':
        return localizations.values;
      default:
        return id;
    }
  }

  List<Map<String, dynamic>> _getTeamCanvasSections(BuildContext context) => [
    {
      'id': 'people',
      'title': _getLocalizedTitle(context, 'people'),
      'subtitle': '¿Quién forma parte del equipo?',
      'color': Colors.blue.shade400,
      'icon': Icons.group,
      'description': 'Miembros del equipo, roles, responsabilidades',
    },
    {
      'id': 'activities',
      'title': _getLocalizedTitle(context, 'activities'),
      'subtitle': '¿Qué hacemos como equipo?',
      'color': Colors.green.shade400,
      'icon': Icons.directions_run,
      'description': 'Actividades principales del equipo',
    },
    {
      'id': 'personalGoals',
      'title': _getLocalizedTitle(context, 'personalGoals'),
      'subtitle': '¿Cuáles son nuestros objetivos individuales?',
      'color': Colors.amber.shade400,
      'icon': Icons.emoji_events,
      'description': 'Objetivos y metas personales',
    },
    {
      'id': 'purpose',
      'title': _getLocalizedTitle(context, 'purpose'),
      'subtitle': '¿Por qué existimos como equipo?',
      'color': Colors.purple.shade400,
      'icon': Icons.center_focus_strong,
      'description': 'Misión, visión, razón de ser del equipo',
    },
    {
      'id': 'rules',
      'title': _getLocalizedTitle(context, 'rules'),
      'subtitle': '¿Cómo trabajamos juntos?',
      'color': Colors.red.shade400,
      'icon': Icons.gavel,
      'description': 'Normas, reglas, comportamientos',
    },
    {
      'id': 'skills',
      'title': _getLocalizedTitle(context, 'skills'),
      'subtitle': '¿Qué habilidades tenemos?',
      'color': Colors.cyan.shade400,
      'icon': Icons.lightbulb,
      'description': 'Habilidades y competencias del equipo',
    },
    {
      'id': 'tools',
      'title': _getLocalizedTitle(context, 'tools'),
      'subtitle': '¿Qué herramientas usamos?',
      'color': Colors.teal.shade400,
      'icon': Icons.handyman,
      'description': 'Herramientas, tecnologías y recursos',
    },
    {
      'id': 'network',
      'title': _getLocalizedTitle(context, 'network'),
      'subtitle': '¿Con quién nos conectamos?',
      'color': Colors.indigo.shade400,
      'icon': Icons.account_tree,
      'description': 'Red de contactos y conexiones',
    },
    {
      'id': 'values',
      'title': _getLocalizedTitle(context, 'values'),
      'subtitle': '¿Qué valores nos guían?',
      'color': Colors.orange.shade400,
      'icon': Icons.balance,
      'description': 'Valores y principios del equipo',
    },
  ];

  Widget _buildTeamSection(BuildContext context, Map<String, dynamic> section) {
    return TeamCanvasSection(
      id: section['id'],
      title: section['title'],
      subtitle: section['subtitle'],
      color: section['color'],
      icon: section['icon'],
      content: teamCanvas.getContentById(section['id']),
      onContentChanged: (content) => _updateSection(section['id'], content),
    );
  }

  Widget _buildPreviewSection(BuildContext context, Map<String, dynamic> section) {
    final content = teamCanvas.getContentById(section['id']);
    final displayItems = content.take(3).toList();
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        color: section['color'].withOpacity(0.1),
        border: Border.all(color: section['color'], width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            decoration: BoxDecoration(
              color: section['color'],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  section['icon'],
                  size: 12,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    section['title'],
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              child: displayItems.isEmpty
                  ? Center(
                      child: Text(
                        localizations.empty,
                        style: TextStyle(
                          fontSize: 8,
                          color: section['color'].withOpacity(0.5),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ...displayItems.map((item) => 
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 2),
                              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 8),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ).toList(),
                          if (content.length > 3)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: Text(
                                '+${content.length - 3} ${localizations.more}',
                                style: TextStyle(
                                  fontSize: 7,
                                  color: section['color'].withOpacity(0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTeamPreview(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final sections = _getTeamCanvasSections(context);
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          _dialogUpdateCallback = () => setDialogState(() {});
          
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.teamPreview,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              localizations.automaticUpdate,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.sync,
                              size: 12,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              localizations.liveUpdate,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.close),
                        iconSize: 20,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        onPressed: () {
                          _dialogUpdateCallback = null;
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildPreviewGrid(context, sections),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 12,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            localizations.viewUpdatedAutomatically,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).then((_) {
      _dialogUpdateCallback = null;
    });
  }

  Widget _buildPreviewGrid(BuildContext context, List<Map<String, dynamic>> sections) {
    return Column(
      children: [
        // Primera fila (2/3 del espacio)
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: _buildPreviewSection(context, sections[0]), // People
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _buildPreviewSection(context, sections[1]), // Activities
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: _buildPreviewSection(context, sections[2]), // Personal Goals
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 4,
                child: _buildPreviewSection(context, sections[3]), // Purpose (center, larger)
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _buildPreviewSection(context, sections[4]), // Rules
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: _buildPreviewSection(context, sections[5]), // Skills
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 2,
                child: _buildPreviewSection(context, sections[6]), // Tools
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Fila inferior (1/3 del espacio)
        Expanded(
          flex: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildPreviewSection(context, sections[7]), // Network
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildPreviewSection(context, sections[8]), // Values
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopGrid(BuildContext context) {
    final sections = _getTeamCanvasSections(context);
    
    return Column(
      children: [
        // Primera fila (2/3 del espacio) - Layout similar al BMC
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: TeamCanvasGridSection(
                  id: sections[0]['id'],
                  title: sections[0]['title'],
                  subtitle: sections[0]['subtitle'],
                  content: teamCanvas.getContentById(sections[0]['id']),
                  onContentChanged: (content) => _updateSection(sections[0]['id'], content),
                  color: sections[0]['color'],
                  icon: sections[0]['icon'],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: TeamCanvasGridSection(
                        id: sections[1]['id'],
                        title: sections[1]['title'],
                        subtitle: sections[1]['subtitle'],
                        content: teamCanvas.getContentById(sections[1]['id']),
                        onContentChanged: (content) => _updateSection(sections[1]['id'], content),
                        color: sections[1]['color'],
                        icon: sections[1]['icon'],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: TeamCanvasGridSection(
                        id: sections[2]['id'],
                        title: sections[2]['title'],
                        subtitle: sections[2]['subtitle'],
                        content: teamCanvas.getContentById(sections[2]['id']),
                        onContentChanged: (content) => _updateSection(sections[2]['id'], content),
                        color: sections[2]['color'],
                        icon: sections[2]['icon'],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: TeamCanvasGridSection(
                  id: sections[3]['id'],
                  title: sections[3]['title'],
                  subtitle: sections[3]['subtitle'],
                  content: teamCanvas.getContentById(sections[3]['id']),
                  onContentChanged: (content) => _updateSection(sections[3]['id'], content),
                  color: sections[3]['color'],
                  icon: sections[3]['icon'],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: TeamCanvasGridSection(
                        id: sections[4]['id'],
                        title: sections[4]['title'],
                        subtitle: sections[4]['subtitle'],
                        content: teamCanvas.getContentById(sections[4]['id']),
                        onContentChanged: (content) => _updateSection(sections[4]['id'], content),
                        color: sections[4]['color'],
                        icon: sections[4]['icon'],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: TeamCanvasGridSection(
                        id: sections[5]['id'],
                        title: sections[5]['title'],
                        subtitle: sections[5]['subtitle'],
                        content: teamCanvas.getContentById(sections[5]['id']),
                        onContentChanged: (content) => _updateSection(sections[5]['id'], content),
                        color: sections[5]['color'],
                        icon: sections[5]['icon'],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TeamCanvasGridSection(
                  id: sections[6]['id'],
                  title: sections[6]['title'],
                  subtitle: sections[6]['subtitle'],
                  content: teamCanvas.getContentById(sections[6]['id']),
                  onContentChanged: (content) => _updateSection(sections[6]['id'], content),
                  color: sections[6]['color'],
                  icon: sections[6]['icon'],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Fila inferior (1/3 del espacio)
        Expanded(
          flex: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TeamCanvasGridSection(
                  id: sections[7]['id'],
                  title: sections[7]['title'],
                  subtitle: sections[7]['subtitle'],
                  content: teamCanvas.getContentById(sections[7]['id']),
                  onContentChanged: (content) => _updateSection(sections[7]['id'], content),
                  color: sections[7]['color'],
                  icon: sections[7]['icon'],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TeamCanvasGridSection(
                  id: sections[8]['id'],
                  title: sections[8]['title'],
                  subtitle: sections[8]['subtitle'],
                  content: teamCanvas.getContentById(sections[8]['id']),
                  onContentChanged: (content) => _updateSection(sections[8]['id'], content),
                  color: sections[8]['color'],
                  icon: sections[8]['icon'],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final sections = _getTeamCanvasSections(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: const AppNavigationDrawer(selectedIndex: 4),
      appBar: AppBar(
        title: Text(
          localizations.teamCanvas,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (MediaQuery.of(context).size.width < 1024)
            IconButton(
              icon: const Icon(Icons.preview),
              tooltip: localizations.fullTeamPreview,
              onPressed: () => _showTeamPreview(context),
            ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(localizations.teamCanvas),
                  content: Text(localizations.teamCanvasInfo),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(localizations.close),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenHeight = MediaQuery.of(context).size.height;
                final appBarHeight = AppBar().preferredSize.height;
                final statusBarHeight = MediaQuery.of(context).padding.top;
                final availableHeight = screenHeight - appBarHeight - statusBarHeight - 32;
                
                // Mobile: lista vertical
                if (constraints.maxWidth < 600) {
                  return Column(
                    children: sections.map((section) =>
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildTeamSection(context, section),
                      ),
                    ).toList(),
                  );
                }
                
                // Tablet: dos columnas
                if (constraints.maxWidth < 1024) {
                  return Column(
                    children: [
                      for (int i = 0; i < sections.length; i += 2)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildTeamSection(context, sections[i]),
                              ),
                              const SizedBox(width: 16),
                              if (i + 1 < sections.length)
                                Expanded(
                                  child: _buildTeamSection(context, sections[i + 1]),
                                )
                              else
                                const Expanded(child: SizedBox()),
                            ],
                          ),
                        ),
                    ],
                  );
                }
            
                // Desktop: grid completo
                return Container(
                  width: double.infinity,
                  height: availableHeight < 500 
                      ? null
                      : availableHeight.clamp(500.0, double.infinity),
                  child: availableHeight < 500
                      ? SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Container(
                            height: 500,
                            child: _buildDesktopGrid(context),
                          ),
                        )
                      : _buildDesktopGrid(context),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}