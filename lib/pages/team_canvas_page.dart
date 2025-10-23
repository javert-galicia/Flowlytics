import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/canvas_models.dart';
import '../widgets/team_canvas_section.dart';
import '../widgets/team_canvas_grid_section.dart';

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

  List<Map<String, dynamic>> get _teamCanvasSections => [
    {
      'id': 'people',
      'title': 'People & Roles',
      'subtitle': '¿Quién forma parte del equipo?',
      'color': Colors.blue.shade400,
      'icon': Icons.people,
      'description': 'Miembros del equipo, roles, responsabilidades',
    },
    {
      'id': 'activities',
      'title': 'Activities & Tasks',
      'subtitle': '¿Qué hacemos?',
      'color': Colors.teal.shade400,
      'icon': Icons.work,
      'description': 'Tareas principales, procesos, deliverables',
    },
    {
      'id': 'personalGoals',
      'title': 'Personal Goals',
      'subtitle': '¿Qué quiere lograr cada uno?',
      'color': Colors.orange.shade400,
      'icon': Icons.person_pin,
      'description': 'Objetivos individuales de los miembros',
    },
    {
      'id': 'purpose',
      'title': 'Purpose',
      'subtitle': '¿Por qué existimos como equipo?',
      'color': Colors.purple.shade400,
      'icon': Icons.explore,
      'description': 'Misión, visión, razón de ser del equipo',
    },
    {
      'id': 'rules',
      'title': 'Rules & Culture',
      'subtitle': '¿Cómo trabajamos juntos?',
      'color': Colors.red.shade400,
      'icon': Icons.rule,
      'description': 'Normas, cultura, comportamientos',
    },
    {
      'id': 'skills',
      'title': 'Skills & Knowledge',
      'subtitle': '¿Qué sabemos hacer?',
      'color': Colors.indigo.shade400,
      'icon': Icons.psychology,
      'description': 'Competencias, conocimientos, experiencia',
    },
    {
      'id': 'tools',
      'title': 'Tools & Resources',
      'subtitle': '¿Qué usamos para trabajar?',
      'color': Colors.cyan.shade400,
      'icon': Icons.construction,
      'description': 'Tecnologías, software, recursos físicos',
    },
    {
      'id': 'network',
      'title': 'Network & Contacts',
      'subtitle': '¿Con quién colaboramos?',
      'color': Colors.brown.shade400,
      'icon': Icons.share,
      'description': 'Stakeholders, partners, colaboradores externos',
    },
    {
      'id': 'values',
      'title': 'Values & Principles',
      'subtitle': '¿Qué es importante para nosotros?',
      'color': Colors.pink.shade400,
      'icon': Icons.favorite,
      'description': 'Principios, valores, cultura deseada',
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Team Canvas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
        actions: [
          // Solo mostrar el botón de preview en modo móvil/tablet
          if (MediaQuery.of(context).size.width < 1024)
            IconButton(
              icon: const Icon(Icons.preview),
              tooltip: 'Vista previa del lienzo completo',
              onPressed: () => _showCanvasPreview(context),
            ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1024) {
            return _buildDesktopLayout();
          } else if (constraints.maxWidth > 600) {
            return _buildTabletLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Center(
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
              
              return Container(
                width: double.infinity,
                height: availableHeight < 600 
                    ? null
                    : availableHeight.clamp(600.0, double.infinity),
                child: availableHeight < 600
                    ? SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: SizedBox(
                          height: 600,
                          child: _buildTeamCanvasGrid(),
                        ),
                      )
                    : _buildTeamCanvasGrid(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCanvasGrid() {
    return Column(
      children: [
        // First row - takes 2/3 of available height (igual que BMC)
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // People & Roles (equivalente a Key Partners)
              Expanded(
                flex: 2,
                child: _buildCanvasSectionExpanded(_teamCanvasSections[0]), // People & Roles
              ),
              const SizedBox(width: 8),
              // Activities + Skills (equivalente a Key Activities + Key Resources)
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _buildCanvasSectionExpanded(_teamCanvasSections[1]), // Activities
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _buildCanvasSectionExpanded(_teamCanvasSections[5]), // Skills
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Purpose (equivalente a Value Propositions - sección central principal)
              Expanded(
                flex: 4,
                child: _buildCanvasSectionExpanded(_teamCanvasSections[3]), // Purpose
              ),
              const SizedBox(width: 8),
              // Rules + Tools (equivalente a Customer Relationships + Channels)
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _buildCanvasSectionExpanded(_teamCanvasSections[4]), // Rules
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _buildCanvasSectionExpanded(_teamCanvasSections[6]), // Tools
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Network (equivalente a Customer Segments)
              Expanded(
                flex: 2,
                child: _buildCanvasSectionExpanded(_teamCanvasSections[7]), // Network
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Bottom row - takes 1/3 of available height (igual que BMC)
        Expanded(
          flex: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Values (equivalente a Cost Structure)
              Expanded(
                child: _buildCanvasSectionExpanded(_teamCanvasSections[8]), // Values
              ),
              const SizedBox(width: 8),
              // Personal Goals (equivalente a Revenue Streams)
              Expanded(
                child: _buildCanvasSectionExpanded(_teamCanvasSections[2]), // Personal Goals
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          // Diseño en grid 2x4
          for (int i = 0; i < _teamCanvasSections.length; i += 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: 350,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildSection(_teamCanvasSections[i])),
                    const SizedBox(width: 16),
                    if (i + 1 < _teamCanvasSections.length)
                      Expanded(child: _buildSection(_teamCanvasSections[i + 1]))
                    else
                      const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          // Layout vertical
          ..._teamCanvasSections.map((section) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSection(section),
          )),
        ],
      ),
    );
  }

  Widget _buildSection(Map<String, dynamic> section, {double? height}) {
    return TeamCanvasSection(
      id: section['id'],
      title: section['title'],
      subtitle: section['subtitle'],
      content: teamCanvas.getContentById(section['id']),
      color: section['color'],
      icon: section['icon'],
      onContentChanged: (content) => _updateSection(section['id'], content),
      height: height,
    );
  }

  Widget _buildCanvasSectionExpanded(Map<String, dynamic> section) {
    return TeamCanvasGridSection(
      id: section['id'],
      title: section['title'],
      subtitle: section['subtitle'],
      content: teamCanvas.getContentById(section['id']),
      color: section['color'],
      icon: section['icon'],
      onContentChanged: (content) => _updateSection(section['id'], content),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.purple.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.groups,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Team Canvas',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Define la estructura y dinámicas de tu equipo',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.blue.shade600,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'El Team Canvas te ayuda a alinear a tu equipo definiendo roles, propósito, valores y formas de trabajo.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Acerca del Team Canvas'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'El Team Canvas es una herramienta visual para definir y alinear equipos de trabajo efectivos.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                const Text('Las 8 secciones del Team Canvas:'),
                const SizedBox(height: 12),
                ..._teamCanvasSections.map((section) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        section['icon'],
                        size: 16,
                        color: section['color'],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section['title'],
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              section['description'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Métodos para vista previa
  void _showCanvasPreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          // Configurar callback para actualizaciones automáticas
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
                            const Text(
                              'Vista previa del lienzo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Actualización automática',
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
                              'En vivo',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        iconSize: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildPreviewGrid(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).then((_) {
      // Limpiar callback cuando se cierre el dialog
      _dialogUpdateCallback = null;
    });
  }

  Widget _buildPreviewGrid() {
    return Column(
      children: [
        // First row - takes 2/3 of available height (igual que BMC)
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // People & Roles
              Expanded(
                flex: 2,
                child: _buildPreviewSection(_teamCanvasSections[0]),
              ),
              const SizedBox(width: 4),
              // Activities + Skills
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _buildPreviewSection(_teamCanvasSections[1]),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: _buildPreviewSection(_teamCanvasSections[5]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              // Purpose (sección central principal)
              Expanded(
                flex: 4,
                child: _buildPreviewSection(_teamCanvasSections[3]),
              ),
              const SizedBox(width: 4),
              // Rules + Tools
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _buildPreviewSection(_teamCanvasSections[4]),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: _buildPreviewSection(_teamCanvasSections[6]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              // Network
              Expanded(
                flex: 2,
                child: _buildPreviewSection(_teamCanvasSections[7]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Bottom row - takes 1/3 of available height
        Expanded(
          flex: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Values
              Expanded(
                child: _buildPreviewSection(_teamCanvasSections[8]),
              ),
              const SizedBox(width: 4),
              // Personal Goals
              Expanded(
                child: _buildPreviewSection(_teamCanvasSections[2]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewSection(Map<String, dynamic> section) {
    final content = teamCanvas.getContentById(section['id']);
    const int maxItems = 6;
    final List<String> displayItems = content.take(maxItems).toList();

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: (section['color'] as Color).withOpacity(0.08),
        border: Border.all(color: (section['color'] as Color).withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: section['color'],
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Icon(
                  section['icon'],
                  color: Colors.white,
                  size: 8,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  section['title'],
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: (section['color'] as Color).withOpacity(0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Expanded(
            child: content.isEmpty
                ? Center(
                    child: Text(
                      'No items yet',
                      style: TextStyle(
                        color: (section['color'] as Color).withOpacity(0.4),
                        fontSize: 6,
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
                            margin: const EdgeInsets.only(bottom: 1),
                            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 6),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ).toList(),
                        if (content.length > maxItems)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: Text(
                              '+${content.length - maxItems} más',
                              style: TextStyle(
                                fontSize: 5,
                                color: (section['color'] as Color).withOpacity(0.7),
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}