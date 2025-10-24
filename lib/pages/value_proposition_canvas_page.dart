import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/value_proposition_models.dart';
import '../models/canvas_models.dart';
import '../widgets/canvas_section.dart';
import '../widgets/app_navigation_drawer.dart';

class ValuePropositionCanvasPage extends StatefulWidget {
  const ValuePropositionCanvasPage({super.key});

  @override
  State<ValuePropositionCanvasPage> createState() => _ValuePropositionCanvasPageState();
}

class _ValuePropositionCanvasPageState extends State<ValuePropositionCanvasPage> {
  ValuePropositionCanvas canvas = ValuePropositionCanvas.empty();
  Function()? _dialogUpdateCallback;

  @override
  void initState() {
    super.initState();
    _loadCanvas();
  }

  Future<void> _loadCanvas() async {
    final prefs = await SharedPreferences.getInstance();
    final canvasData = prefs.getString('value_proposition_canvas');
    if (canvasData != null) {
      setState(() {
        canvas = ValuePropositionCanvas.fromJson(json.decode(canvasData));
      });
    }
  }

  Future<void> _saveCanvas() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('value_proposition_canvas', json.encode(canvas.toJson()));
  }

  void _updateSection(String sectionId, List<String> content) {
    setState(() {
      canvas = canvas.updateById(sectionId, content);
    });
    // Actualizar diálogo si está abierto
    if (_dialogUpdateCallback != null) {
      _dialogUpdateCallback!();
    }
    _saveCanvas();
  }

  void _clearCanvas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar Canvas'),
        content: const Text('¿Estás seguro de que quieres eliminar todo el contenido?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                canvas = ValuePropositionCanvas.empty();
              });
              _saveCanvas();
              Navigator.pop(context);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }



  Widget _buildCanvasSection(String id, String title, ValuePropositionArea area) {
    return CanvasSection(
      id: id,
      title: title,
      content: canvas.getContentById(id),
      onChange: (newContent) => _updateSection(id, newContent),
      area: _convertToCanvasArea(area),
    );
  }

  Widget _buildCanvasSectionExpanded(String id, String title, ValuePropositionArea area) {
    return CanvasSection(
      id: id,
      title: title,
      content: canvas.getContentById(id),
      onChange: (newContent) => _updateSection(id, newContent),
      area: _convertToCanvasArea(area),
    );
  }

  // Convertir ValuePropositionArea a CanvasArea para reutilizar CanvasSection
  CanvasArea _convertToCanvasArea(ValuePropositionArea area) {
    switch (area) {
      case ValuePropositionArea.customerProfile:
        return CanvasArea.customers;
      case ValuePropositionArea.valueMap:
        return CanvasArea.offer;
    }
  }

  Color _getPreviewAreaColor(ValuePropositionArea area) {
    switch (area) {
      case ValuePropositionArea.customerProfile:
        return Colors.blue.shade50;
      case ValuePropositionArea.valueMap:
        return Colors.green.shade50;
    }
  }

  Color _getPreviewBorderColor(ValuePropositionArea area) {
    switch (area) {
      case ValuePropositionArea.customerProfile:
        return Colors.blue.shade300;
      case ValuePropositionArea.valueMap:
        return Colors.green.shade300;
    }
  }

  Color _getPreviewTextColor(ValuePropositionArea area) {
    switch (area) {
      case ValuePropositionArea.customerProfile:
        return Colors.blue.shade800;
      case ValuePropositionArea.valueMap:
        return Colors.green.shade800;
    }
  }

  Widget _buildPreviewSection(String id, String title, ValuePropositionArea area) {
    final content = canvas.getContentById(id);
    final displayItems = content.take(3).toList();
    
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
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: _getPreviewTextColor(area),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
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
                          if (content.length > 3)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: Text(
                                '+${content.length - 3} más',
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

  void _showCanvasPreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          _dialogUpdateCallback = () => setDialogState(() {});
          
          return Dialog(
            insetPadding: const EdgeInsets.all(16),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Vista previa - Value Proposition Canvas',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
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
      _dialogUpdateCallback = null;
    });
  }

  Widget _buildPreviewGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Columna izquierda - Customer Profile
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              border: Border.all(color: Colors.blue.shade300, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Customer Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Expanded(
                          child: _buildPreviewSection('customerJobs', 'Customer Jobs', ValuePropositionArea.customerProfile),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: _buildPreviewSection('pains', 'Pains', ValuePropositionArea.customerProfile),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: _buildPreviewSection('gains', 'Gains', ValuePropositionArea.customerProfile),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Columna derecha - Value Map
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              border: Border.all(color: Colors.green.shade300, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Value Map',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Expanded(
                          child: _buildPreviewSection('products', 'Products & Services', ValuePropositionArea.valueMap),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: _buildPreviewSection('painRelievers', 'Pain Relievers', ValuePropositionArea.valueMap),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: _buildPreviewSection('gainCreators', 'Gain Creators', ValuePropositionArea.valueMap),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Columna izquierda - Customer Profile
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border.all(color: Colors.blue.shade300, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Customer Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Expanded(
                          child: _buildCanvasSectionExpanded('customerJobs', 'Customer Jobs', ValuePropositionArea.customerProfile),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: _buildCanvasSectionExpanded('pains', 'Pains', ValuePropositionArea.customerProfile),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: _buildCanvasSectionExpanded('gains', 'Gains', ValuePropositionArea.customerProfile),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Columna derecha - Value Map
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border.all(color: Colors.green.shade300, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Value Map',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Expanded(
                          child: _buildCanvasSectionExpanded('products', 'Products & Services', ValuePropositionArea.valueMap),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: _buildCanvasSectionExpanded('painRelievers', 'Pain Relievers', ValuePropositionArea.valueMap),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: _buildCanvasSectionExpanded('gainCreators', 'Gain Creators', ValuePropositionArea.valueMap),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: const AppNavigationDrawer(selectedIndex: 3),
      appBar: AppBar(
        title: const Text(
          'Value Proposition Canvas',
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
                  title: const Text('Value Proposition Canvas'),
                  content: const Text(
                    'Herramienta para diseñar y validar propuestas de valor.\n\n'
                    'Customer Profile: Describe a tus clientes, sus trabajos, dolores y beneficios.\n\n'
                    'Value Map: Define tus productos/servicios, cómo alivias dolores y creas beneficios.\n\n'
                    'Los datos se guardan automáticamente.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            tooltip: 'Limpiar todo',
            onPressed: _clearCanvas,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight = constraints.maxHeight;
              
              // For mobile (≤600px): single column
              if (constraints.maxWidth <= 600) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Customer Profile
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade300, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                              child: Text(
                                'Customer Profile',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: _buildCanvasSection('customerJobs', 'Customer Jobs', ValuePropositionArea.customerProfile),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 200,
                                    child: _buildCanvasSection('pains', 'Pains', ValuePropositionArea.customerProfile),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 200,
                                    child: _buildCanvasSection('gains', 'Gains', ValuePropositionArea.customerProfile),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Value Map
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          border: Border.all(color: Colors.green.shade300, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                              child: Text(
                                'Value Map',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: _buildCanvasSection('products', 'Products & Services', ValuePropositionArea.valueMap),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 200,
                                    child: _buildCanvasSection('painRelievers', 'Pain Relievers', ValuePropositionArea.valueMap),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 200,
                                    child: _buildCanvasSection('gainCreators', 'Gain Creators', ValuePropositionArea.valueMap),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              // For tablets (600-1024px): two columns side by side
              if (constraints.maxWidth < 1024) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer Profile
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              border: Border.all(color: Colors.blue.shade300, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(6),
                                      topRight: Radius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    'Customer Profile',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 180,
                                        child: _buildCanvasSection('customerJobs', 'Customer Jobs', ValuePropositionArea.customerProfile),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        height: 180,
                                        child: _buildCanvasSection('pains', 'Pains', ValuePropositionArea.customerProfile),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        height: 180,
                                        child: _buildCanvasSection('gains', 'Gains', ValuePropositionArea.customerProfile),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Value Map
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              border: Border.all(color: Colors.green.shade300, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(6),
                                      topRight: Radius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    'Value Map',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 180,
                                        child: _buildCanvasSection('products', 'Products & Services', ValuePropositionArea.valueMap),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        height: 180,
                                        child: _buildCanvasSection('painRelievers', 'Pain Relievers', ValuePropositionArea.valueMap),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        height: 180,
                                        child: _buildCanvasSection('gainCreators', 'Gain Creators', ValuePropositionArea.valueMap),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              // For desktop (≥1024px): full canvas layout
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
                          child: _buildDesktopGrid(),
                        ),
                      )
                    : _buildDesktopGrid(),
              );
            },
          ),
        ),
      ),
    );
  }
}