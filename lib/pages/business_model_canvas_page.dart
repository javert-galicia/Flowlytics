import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/canvas_models.dart';
import '../widgets/canvas_section.dart';

class BusinessModelCanvasPage extends StatefulWidget {
  const BusinessModelCanvasPage({super.key});

  @override
  State<BusinessModelCanvasPage> createState() => _BusinessModelCanvasPageState();
}

class _BusinessModelCanvasPageState extends State<BusinessModelCanvasPage> {
  static const String storageKey = 'businessModelCanvas';
  BusinessModelCanvas canvas = BusinessModelCanvas.empty();

  final List<CanvasBlock> initialBlocks = [
    CanvasBlock(
      id: 'keyPartners',
      title: 'Key Partners',
      content: [],
      area: CanvasArea.infrastructure,
      gridArea: const GridArea(colSpan: 2, rowSpan: 2),
    ),
    CanvasBlock(
      id: 'keyActivities',
      title: 'Key Activities',
      content: [],
      area: CanvasArea.infrastructure,
      gridArea: const GridArea(colSpan: 2, rowSpan: 1),
    ),
    CanvasBlock(
      id: 'valuePropositions',
      title: 'Value Propositions',
      content: [],
      area: CanvasArea.offer,
      gridArea: const GridArea(colSpan: 4, rowSpan: 2),
    ),
    CanvasBlock(
      id: 'customerRelationships',
      title: 'Customer Relationships',
      content: [],
      area: CanvasArea.customers,
      gridArea: const GridArea(colSpan: 2, rowSpan: 1),
    ),
    CanvasBlock(
      id: 'customerSegments',
      title: 'Customer Segments',
      content: [],
      area: CanvasArea.customers,
      gridArea: const GridArea(colSpan: 2, rowSpan: 2),
    ),
    CanvasBlock(
      id: 'keyResources',
      title: 'Key Resources',
      content: [],
      area: CanvasArea.infrastructure,
      gridArea: const GridArea(colSpan: 2, rowSpan: 1),
    ),
    CanvasBlock(
      id: 'channels',
      title: 'Channels',
      content: [],
      area: CanvasArea.customers,
      gridArea: const GridArea(colSpan: 2, rowSpan: 1),
    ),
    CanvasBlock(
      id: 'costStructure',
      title: 'Cost Structure',
      content: [],
      area: CanvasArea.finance,
      gridArea: const GridArea(colSpan: 6, rowSpan: 1),
    ),
    CanvasBlock(
      id: 'revenueStreams',
      title: 'Revenue Streams',
      content: [],
      area: CanvasArea.finance,
      gridArea: const GridArea(colSpan: 6, rowSpan: 1),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedCanvas();
  }

  Future<void> _loadSavedCanvas() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(storageKey);
    if (savedData != null) {
      try {
        final Map<String, dynamic> jsonData = json.decode(savedData);
        setState(() {
          canvas = BusinessModelCanvas.fromJson(jsonData);
        });
      } catch (e) {
        // If there's an error loading, keep the empty canvas
        debugPrint('Error loading saved canvas: $e');
      }
    }
  }

  Future<void> _saveCanvas() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, json.encode(canvas.toJson()));
  }

  Function(List<String>) _handleChange(String key) {
    return (List<String> value) {
      setState(() {
        canvas = canvas.updateById(key, value);
      });
      _saveCanvas();
      // Forzar actualización de cualquier diálogo abierto
      _notifyDialogUpdate();
    };
  }

  // Variable para mantener referencia al callback del diálogo
  void Function()? _dialogUpdateCallback;

  void _notifyDialogUpdate() {
    if (_dialogUpdateCallback != null) {
      _dialogUpdateCallback!();
    }
  }

  Widget _buildCanvasSection(String id, String title, CanvasArea area, {bool isLarge = false}) {
    return Container(
      constraints: BoxConstraints(
        minHeight: isLarge ? 300 : 150,
        maxHeight: isLarge ? 500 : 300,
      ),
      child: CanvasSection(
        id: id,
        title: title,
        content: canvas.getContentById(id),
        onChange: _handleChange(id),
        area: area,
      ),
    );
  }

  Widget _buildCanvasSectionExpanded(String id, String title, CanvasArea area) {
    return CanvasSection(
      id: id,
      title: title,
      content: canvas.getContentById(id),
      onChange: _handleChange(id),
      area: area,
    );
  }

  Widget _buildPreviewSection(String id, String title, CanvasArea area) {
    // Determinar cuántos elementos mostrar según la sección
    int maxItems = 3;
    if (id == 'valuePropositions') {
      maxItems = 6; // Mostrar hasta 6 elementos en Value Propositions
    }
    
    final content = canvas.getContentById(id);
    final displayItems = content.take(maxItems).toList();
    
    return Container(
      decoration: BoxDecoration(
        color: _getPreviewAreaColor(area),
        border: Border.all(color: _getPreviewBorderColor(area), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: _getPreviewTextColor(area),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              child: displayItems.isEmpty
                  ? Center(
                      child: Text(
                        'Vacío',
                        style: TextStyle(
                          fontSize: 7,
                          color: _getPreviewTextColor(area).withOpacity(0.5),
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
                                style: const TextStyle(fontSize: 7),
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
                                  fontSize: 6,
                                  color: _getPreviewTextColor(area).withOpacity(0.7),
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

  Color _getPreviewAreaColor(CanvasArea area) {
    switch (area) {
      case CanvasArea.infrastructure:
        return Colors.blue.shade50;
      case CanvasArea.offer:
        return Colors.green.shade50;
      case CanvasArea.customers:
        return Colors.orange.shade50;
      case CanvasArea.finance:
        return Colors.purple.shade50;
    }
  }

  Color _getPreviewBorderColor(CanvasArea area) {
    switch (area) {
      case CanvasArea.infrastructure:
        return Colors.blue.shade200;
      case CanvasArea.offer:
        return Colors.green.shade200;
      case CanvasArea.customers:
        return Colors.orange.shade200;
      case CanvasArea.finance:
        return Colors.purple.shade200;
    }
  }

  Color _getPreviewTextColor(CanvasArea area) {
    switch (area) {
      case CanvasArea.infrastructure:
        return Colors.blue.shade800;
      case CanvasArea.offer:
        return Colors.green.shade800;
      case CanvasArea.customers:
        return Colors.orange.shade800;
      case CanvasArea.finance:
        return Colors.purple.shade800;
    }
  }

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
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.close),
                        iconSize: 20,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        onPressed: () {
                          _dialogUpdateCallback = null; // Limpiar callback
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
                            'Vista actualizada automáticamente',
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
      // Limpiar callback cuando se cierre el diálogo
      _dialogUpdateCallback = null;
    });
  }

  Widget _buildPreviewGrid() {
    return Column(
      children: [
        // Primera fila - 2/3 del espacio
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: _buildPreviewSection('keyPartners', 'Key Partners', CanvasArea.infrastructure),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _buildPreviewSection('keyActivities', 'Key Activities', CanvasArea.infrastructure),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: _buildPreviewSection('keyResources', 'Key Resources', CanvasArea.infrastructure),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 4,
                child: _buildPreviewSection('valuePropositions', 'Value Propositions', CanvasArea.offer),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _buildPreviewSection('customerRelationships', 'Customer Relationships', CanvasArea.customers),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: _buildPreviewSection('channels', 'Channels', CanvasArea.customers),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 2,
                child: _buildPreviewSection('customerSegments', 'Customer Segments', CanvasArea.customers),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Fila inferior - 1/3 del espacio
        Expanded(
          flex: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildPreviewSection('costStructure', 'Cost Structure', CanvasArea.finance),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildPreviewSection('revenueStreams', 'Revenue Streams', CanvasArea.finance),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopGrid() {
    return Column(
      children: [
        // First row - takes 2/3 of available height
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: _buildCanvasSectionExpanded('keyPartners', 'Key Partners', CanvasArea.infrastructure),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _buildCanvasSectionExpanded('keyActivities', 'Key Activities', CanvasArea.infrastructure),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _buildCanvasSectionExpanded('keyResources', 'Key Resources', CanvasArea.infrastructure),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: _buildCanvasSectionExpanded('valuePropositions', 'Value Propositions', CanvasArea.offer),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _buildCanvasSectionExpanded('customerRelationships', 'Customer Relationships', CanvasArea.customers),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _buildCanvasSectionExpanded('channels', 'Channels', CanvasArea.customers),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: _buildCanvasSectionExpanded('customerSegments', 'Customer Segments', CanvasArea.customers),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Bottom row - takes 1/3 of available height
        Expanded(
          flex: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildCanvasSectionExpanded('costStructure', 'Cost Structure', CanvasArea.finance),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCanvasSectionExpanded('revenueStreams', 'Revenue Streams', CanvasArea.finance),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Business Model Canvas',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Business Model Canvas'),
                  content: const Text(
                    'Herramienta para diseñar y visualizar modelos de negocio.\n\n'
                    'Añade elementos en cada sección y estos se guardarán automáticamente.\n\n'
                    'Versión Flutter - Multiplataforma',
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
          constraints: const BoxConstraints(maxWidth: 1400), // Max width for very wide screens
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenHeight = MediaQuery.of(context).size.height;
                final appBarHeight = AppBar().preferredSize.height;
                final statusBarHeight = MediaQuery.of(context).padding.top;
                final availableHeight = screenHeight - appBarHeight - statusBarHeight - 32;
                
                // Responsive breakpoints:
                // < 600px: Single column (mobile)
                // 600-1024px: Two columns (tablet/mobile landscape)
                // ≥ 1024px: Full canvas grid (desktop)
                
                // For mobile: single column
                if (constraints.maxWidth < 600) {
                  return Column(
                    children: [
                      _buildCanvasSection('keyPartners', 'Key Partners', CanvasArea.infrastructure),
                      const SizedBox(height: 8),
                      _buildCanvasSection('keyActivities', 'Key Activities', CanvasArea.infrastructure),
                      const SizedBox(height: 8),
                      _buildCanvasSection('keyResources', 'Key Resources', CanvasArea.infrastructure),
                      const SizedBox(height: 8),
                      _buildCanvasSection('valuePropositions', 'Value Propositions', CanvasArea.offer),
                      const SizedBox(height: 8),
                      _buildCanvasSection('customerRelationships', 'Customer Relationships', CanvasArea.customers),
                      const SizedBox(height: 8),
                      _buildCanvasSection('channels', 'Channels', CanvasArea.customers),
                      const SizedBox(height: 8),
                      _buildCanvasSection('customerSegments', 'Customer Segments', CanvasArea.customers),
                      const SizedBox(height: 8),
                      _buildCanvasSection('costStructure', 'Cost Structure', CanvasArea.finance),
                      const SizedBox(height: 8),
                      _buildCanvasSection('revenueStreams', 'Revenue Streams', CanvasArea.finance),
                    ],
                  );
                }
                
                // For tablets/mobile landscape (600-1024px): two columns
                if (constraints.maxWidth < 1024) {
                  return Column(
                    children: [
                      // First row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildCanvasSection('keyPartners', 'Key Partners', CanvasArea.infrastructure),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildCanvasSection('valuePropositions', 'Value Propositions', CanvasArea.offer),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Second row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildCanvasSection('keyActivities', 'Key Activities', CanvasArea.infrastructure),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildCanvasSection('customerRelationships', 'Customer Relationships', CanvasArea.customers),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Third row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildCanvasSection('keyResources', 'Key Resources', CanvasArea.infrastructure),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildCanvasSection('channels', 'Channels', CanvasArea.customers),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Fourth row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildCanvasSection('customerSegments', 'Customer Segments', CanvasArea.customers),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildCanvasSection('costStructure', 'Cost Structure', CanvasArea.finance),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Fifth row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildCanvasSection('revenueStreams', 'Revenue Streams', CanvasArea.finance),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(), // Empty space to maintain symmetry
                          ),
                        ],
                      ),
                    ],
                  );
                }
            
            // For desktop (≥1024px): full canvas grid layout
            return Container(
              width: double.infinity,
              height: availableHeight < 500 
                  ? null // Let it scroll if too small
                  : availableHeight.clamp(500.0, double.infinity),
              child: availableHeight < 500
                  ? SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        height: 500, // Minimum height for grid
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