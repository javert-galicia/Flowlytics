import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/foda_models.dart';
import '../widgets/foda_section.dart';
import '../widgets/app_navigation_drawer.dart';

class FodaAnalysisPage extends StatefulWidget {
  const FodaAnalysisPage({super.key});

  @override
  State<FodaAnalysisPage> createState() => _FodaAnalysisPageState();
}

class _FodaAnalysisPageState extends State<FodaAnalysisPage> {
  static const String storageKey = 'fodaAnalysis';
  FodaAnalysis foda = FodaAnalysis.empty();

  // Variable para mantener referencia al callback del diálogo
  void Function()? _dialogUpdateCallback;

  @override
  void initState() {
    super.initState();
    _loadSavedFoda();
  }

  Future<void> _loadSavedFoda() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(storageKey);
    if (savedData != null) {
      try {
        final Map<String, dynamic> jsonData = json.decode(savedData);
        setState(() {
          foda = FodaAnalysis.fromJson(jsonData);
        });
      } catch (e) {
        debugPrint('Error loading saved FODA: $e');
      }
    }
  }

  Future<void> _saveFoda() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, json.encode(foda.toJson()));
  }

  Function(List<String>) _handleChange(String key) {
    return (List<String> value) {
      setState(() {
        foda = foda.updateById(key, value);
      });
      _saveFoda();
      _notifyDialogUpdate();
    };
  }

  void _notifyDialogUpdate() {
    if (_dialogUpdateCallback != null) {
      _dialogUpdateCallback!();
    }
  }

  Widget _buildFodaSection(String id, String title, FodaArea area, {bool isLarge = false}) {
    return Container(
      constraints: BoxConstraints(
        minHeight: isLarge ? 300 : 150,
        maxHeight: isLarge ? 500 : 300,
      ),
      child: FodaSection(
        id: id,
        title: title,
        content: foda.getContentById(id),
        onChange: _handleChange(id),
        area: area,
      ),
    );
  }

  Widget _buildFodaSectionExpanded(String id, String title, FodaArea area) {
    return FodaSection(
      id: id,
      title: title,
      content: foda.getContentById(id),
      onChange: _handleChange(id),
      area: area,
    );
  }

  Widget _buildPreviewSection(String id, String title, FodaArea area) {
    final content = foda.getContentById(id);
    final displayItems = content.take(4).toList(); // Máximo 4 elementos en preview
    
    return Container(
      decoration: BoxDecoration(
        color: _getPreviewAreaColor(id),
        border: Border.all(color: _getPreviewBorderColor(id), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            decoration: BoxDecoration(
              color: _getPreviewBorderColor(id),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              child: displayItems.isEmpty
                  ? Center(
                      child: Text(
                        'Vacío',
                        style: TextStyle(
                          fontSize: 8,
                          color: _getPreviewBorderColor(id).withOpacity(0.5),
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
                          if (content.length > 4)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: Text(
                                '+${content.length - 4} más',
                                style: TextStyle(
                                  fontSize: 7,
                                  color: _getPreviewBorderColor(id).withOpacity(0.7),
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

  Color _getPreviewAreaColor(String id) {
    switch (id) {
      case 'fortalezas':
        return Colors.green.shade50;
      case 'oportunidades':
        return Colors.blue.shade50;
      case 'debilidades':
        return Colors.orange.shade50;
      case 'amenazas':
        return Colors.red.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  Color _getPreviewBorderColor(String id) {
    switch (id) {
      case 'fortalezas':
        return Colors.green.shade600;
      case 'oportunidades':
        return Colors.blue.shade600;
      case 'debilidades':
        return Colors.orange.shade600;
      case 'amenazas':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  Widget _buildDesktopGrid() {
    return Column(
      children: [
        // Fila superior - Fortalezas y Oportunidades (Factores Positivos)
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildFodaSectionExpanded('fortalezas', 'Fortalezas\n(Strengths)', FodaArea.internal),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFodaSectionExpanded('oportunidades', 'Oportunidades\n(Opportunities)', FodaArea.external),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Fila inferior - Debilidades y Amenazas (Factores Negativos)
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildFodaSectionExpanded('debilidades', 'Debilidades\n(Weaknesses)', FodaArea.internal),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFodaSectionExpanded('amenazas', 'Amenazas\n(Threats)', FodaArea.external),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewGrid() {
    return Column(
      children: [
        // Fila superior - Factores Positivos
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildPreviewSection('fortalezas', 'Fortalezas', FodaArea.internal),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPreviewSection('oportunidades', 'Oportunidades', FodaArea.external),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Fila inferior - Factores Negativos
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildPreviewSection('debilidades', 'Debilidades', FodaArea.internal),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPreviewSection('amenazas', 'Amenazas', FodaArea.external),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFodaPreview(BuildContext context) {
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
                            const Text(
                              'Vista previa FODA',
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
                    child: _buildPreviewGrid(),
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
                            'Vista FODA actualizada automáticamente',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: const AppNavigationDrawer(selectedIndex: 2),
      appBar: AppBar(
        title: const Text(
          'Análisis FODA',
          style: TextStyle(
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
              tooltip: 'Vista previa del análisis FODA',
              onPressed: () => _showFodaPreview(context),
            ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Análisis FODA'),
                  content: const Text(
                    'Herramienta para analizar Fortalezas, Oportunidades, Debilidades y Amenazas.\n\n'
                    '• Fortalezas: Factores internos positivos\n'
                    '• Oportunidades: Factores externos positivos\n'
                    '• Debilidades: Factores internos negativos\n'
                    '• Amenazas: Factores externos negativos\n\n'
                    'Los elementos se guardan automáticamente.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cerrar'),
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
                
                // Responsive breakpoints similares al BMC
                // < 600px: Single column (mobile)
                // 600-1024px: Two columns (tablet)
                // ≥ 1024px: Full FODA grid (desktop)
                
                if (constraints.maxWidth < 600) {
                  // Mobile: una columna
                  return Column(
                    children: [
                      _buildFodaSection('fortalezas', 'Fortalezas (Strengths)', FodaArea.internal),
                      const SizedBox(height: 8),
                      _buildFodaSection('oportunidades', 'Oportunidades (Opportunities)', FodaArea.external),
                      const SizedBox(height: 8),
                      _buildFodaSection('debilidades', 'Debilidades (Weaknesses)', FodaArea.internal),
                      const SizedBox(height: 8),
                      _buildFodaSection('amenazas', 'Amenazas (Threats)', FodaArea.external),
                    ],
                  );
                }
                
                if (constraints.maxWidth < 1024) {
                  // Tablet: dos columnas
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildFodaSection('fortalezas', 'Fortalezas (Strengths)', FodaArea.internal),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildFodaSection('oportunidades', 'Oportunidades (Opportunities)', FodaArea.external),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildFodaSection('debilidades', 'Debilidades (Weaknesses)', FodaArea.internal),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildFodaSection('amenazas', 'Amenazas (Threats)', FodaArea.external),
                          ),
                        ],
                      ),
                    ],
                  );
                }
            
                // Desktop: grid completo 2x2
                return Container(
                  width: double.infinity,
                  height: availableHeight < 400 
                      ? null
                      : availableHeight.clamp(400.0, double.infinity),
                  child: availableHeight < 400
                      ? SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Container(
                            height: 400,
                            child: _buildDesktopGrid(),
                          ),
                        )
                      : _buildDesktopGrid(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}