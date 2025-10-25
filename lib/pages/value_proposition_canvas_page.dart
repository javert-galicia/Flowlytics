import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/value_proposition_models.dart';
import '../widgets/value_proposition_section.dart';
import '../widgets/app_navigation_drawer.dart';
import '../l10n/app_localizations.dart';

class ValuePropositionCanvasPage extends StatefulWidget {
  const ValuePropositionCanvasPage({super.key});

  @override
  State<ValuePropositionCanvasPage> createState() => _ValuePropositionCanvasPageState();
}

class _ValuePropositionCanvasPageState extends State<ValuePropositionCanvasPage> {
  ValuePropositionCanvas canvas = ValuePropositionCanvas.empty();
  bool _showPreview = false;

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
    _saveCanvas();
  }

  String _getLocalizedTitle(BuildContext context, String section) {
    final localizations = AppLocalizations.of(context)!;
    switch (section) {
      case 'products':
        return localizations.products;
      case 'painRelievers':
        return localizations.painRelievers;
      case 'gainCreators':
        return localizations.gainCreators;
      case 'customerJobs':
        return localizations.customerJobs;
      case 'pains':
        return localizations.painPoints;
      case 'gains':
        return localizations.gains;
      default:
        return section;
    }
  }

  String _getLocalizedSubtitle(BuildContext context, String section) {
    final localizations = AppLocalizations.of(context)!;
    switch (section) {
      case 'products':
        return localizations.productsDescription;
      case 'painRelievers':
        return localizations.painRelieversDescription;
      case 'gainCreators':
        return localizations.gainCreatorsDescription;
      case 'customerJobs':
        return localizations.customerJobsDescription;
      case 'pains':
        return localizations.painsDescription;
      case 'gains':
        return localizations.gainsDescription;
      default:
        return '';
    }
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
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Altura fija para evitar movimientos al cambiar contenido
        const double canvasHeight = 700.0;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            height: canvasHeight,
            child: Row(
              children: [
                // Value Map (lado izquierdo) - Círculo de la propuesta de valor
                Expanded(
                  flex: 1,
                  child: Container(
                    height: canvasHeight,
                    constraints: const BoxConstraints(
                      minHeight: canvasHeight,
                      maxHeight: canvasHeight,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.shade50,
                          Colors.orange.shade50,
                          Colors.teal.shade50,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(200),
                        bottomLeft: Radius.circular(200),
                      ),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 16,
                          offset: const Offset(-4, 0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título del Value Map - altura fija
                          Container(
                            height: 70,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.purple.shade600, Colors.purple.shade400],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.lightbulb_outline, color: Colors.white, size: 24),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Value Map',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Productos y Servicios - se adapta al espacio
                          ValuePropositionSection(
                              id: 'products',
                              title: _getLocalizedTitle(context, 'products'),
                              subtitle: _getLocalizedSubtitle(context, 'products'),
                              content: canvas.getContentById('products'),
                              onChange: (content) => _updateSection('products', content),
                              area: ValuePropositionArea.valueMap,
                            ),
                          const SizedBox(height: 16),
                          
                          // Aliviadores de Frustraciones y Creadores de Alegrías en fila - altura fija
                          SizedBox(
                            height: 240,
                            child: Row(
                              children: [
                                Expanded(
                                  child: ValuePropositionSection(
                                    id: 'painRelievers',
                                    title: _getLocalizedTitle(context, 'painRelievers'),
                                    subtitle: _getLocalizedSubtitle(context, 'painRelievers'),
                                    content: canvas.getContentById('painRelievers'),
                                    onChange: (content) => _updateSection('painRelievers', content),
                                    area: ValuePropositionArea.valueMap,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ValuePropositionSection(
                                    id: 'gainCreators',
                                    title: _getLocalizedTitle(context, 'gainCreators'),
                                    subtitle: _getLocalizedSubtitle(context, 'gainCreators'),
                                    content: canvas.getContentById('gainCreators'),
                                    onChange: (content) => _updateSection('gainCreators', content),
                                    area: ValuePropositionArea.valueMap,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Conexión central - altura fija
                Container(
                  width: 80,
                  height: canvasHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.shade100,
                        Colors.indigo.shade100,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple.shade400, Colors.indigo.shade400],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.sync_alt,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          'FIT',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Customer Profile (lado derecho) - Círculo del cliente
                Expanded(
                  flex: 1,
                  child: Container(
                    height: canvasHeight,
                    constraints: const BoxConstraints(
                      minHeight: canvasHeight,
                      maxHeight: canvasHeight,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigo.shade50,
                          Colors.red.shade50,
                          Colors.green.shade50,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(200),
                        bottomRight: Radius.circular(200),
                      ),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 16,
                          offset: const Offset(4, 0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título del Customer Profile - altura fija
                          Container(
                            height: 70,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.indigo.shade600, Colors.indigo.shade400],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.indigo.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.person_outline, color: Colors.white, size: 24),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Customer Profile',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Trabajos del Cliente - se adapta al espacio
                          ValuePropositionSection(
                              id: 'customerJobs',
                              title: _getLocalizedTitle(context, 'customerJobs'),
                              subtitle: _getLocalizedSubtitle(context, 'customerJobs'),
                              content: canvas.getContentById('customerJobs'),
                              onChange: (content) => _updateSection('customerJobs', content),
                              area: ValuePropositionArea.customerProfile,
                            ),
                          const SizedBox(height: 16),
                          
                          // Frustraciones y Alegrías en fila - altura fija
                          SizedBox(
                            height: 240,
                            child: Row(
                              children: [
                                Expanded(
                                  child: ValuePropositionSection(
                                    id: 'pains',
                                    title: _getLocalizedTitle(context, 'pains'),
                                    subtitle: _getLocalizedSubtitle(context, 'pains'),
                                    content: canvas.getContentById('pains'),
                                    onChange: (content) => _updateSection('pains', content),
                                    area: ValuePropositionArea.customerProfile,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ValuePropositionSection(
                                    id: 'gains',
                                    title: _getLocalizedTitle(context, 'gains'),
                                    subtitle: _getLocalizedSubtitle(context, 'gains'),
                                    content: canvas.getContentById('gains'),
                                    onChange: (content) => _updateSection('gains', content),
                                    area: ValuePropositionArea.customerProfile,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade600, Colors.indigo.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.track_changes, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Value Proposition Canvas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Diseña tu propuesta de valor',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Layout vertical único para móvil - evita overflow horizontal
          
          // 1. Productos y Servicios (principal)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: ValuePropositionSection(
              id: 'products',
              title: _getLocalizedTitle(context, 'products'),
              subtitle: _getLocalizedSubtitle(context, 'products'),
              content: canvas.getContentById('products'),
              onChange: (content) => _updateSection('products', content),
              area: ValuePropositionArea.valueMap,
            ),
          ),
          
          // 2. Aliviadores de Frustraciones
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: ValuePropositionSection(
              id: 'painRelievers',
              title: _getLocalizedTitle(context, 'painRelievers'),
              subtitle: _getLocalizedSubtitle(context, 'painRelievers'),
              content: canvas.getContentById('painRelievers'),
              onChange: (content) => _updateSection('painRelievers', content),
              area: ValuePropositionArea.valueMap,
            ),
          ),
          
          // 3. Creadores de Alegrías
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: ValuePropositionSection(
              id: 'gainCreators',
              title: _getLocalizedTitle(context, 'gainCreators'),
              subtitle: _getLocalizedSubtitle(context, 'gainCreators'),
              content: canvas.getContentById('gainCreators'),
              onChange: (content) => _updateSection('gainCreators', content),
              area: ValuePropositionArea.valueMap,
            ),
          ),
          
          // Separador visual
          Container(
            height: 2,
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade200,
                  Colors.indigo.shade200,
                  Colors.purple.shade200,
                ],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          
          // 4. Trabajos del Cliente (principal)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: ValuePropositionSection(
              id: 'customerJobs',
              title: _getLocalizedTitle(context, 'customerJobs'),
              subtitle: _getLocalizedSubtitle(context, 'customerJobs'),
              content: canvas.getContentById('customerJobs'),
              onChange: (content) => _updateSection('customerJobs', content),
              area: ValuePropositionArea.customerProfile,
            ),
          ),
          
          // 5. Frustraciones
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: ValuePropositionSection(
              id: 'pains',
              title: _getLocalizedTitle(context, 'pains'),
              subtitle: _getLocalizedSubtitle(context, 'pains'),
              content: canvas.getContentById('pains'),
              onChange: (content) => _updateSection('pains', content),
              area: ValuePropositionArea.customerProfile,
            ),
          ),
          
          // 6. Alegrías
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: ValuePropositionSection(
              id: 'gains',
              title: _getLocalizedTitle(context, 'gains'),
              subtitle: _getLocalizedSubtitle(context, 'gains'),
              content: canvas.getContentById('gains'),
              onChange: (content) => _updateSection('gains', content),
              area: ValuePropositionArea.customerProfile,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade600, Colors.indigo.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.track_changes, color: Colors.white, size: 36),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Value Proposition Canvas',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Diseña tu propuesta de valor perfecta',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Layout mejorado en 2 filas para tablet - evita overflow vertical
          
          // Primera fila: Productos principales
          Row(
            children: [
              // Productos y Servicios
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: ValuePropositionSection(
                    id: 'products',
                    title: _getLocalizedTitle(context, 'products'),
                    subtitle: _getLocalizedSubtitle(context, 'products'),
                    content: canvas.getContentById('products'),
                    onChange: (content) => _updateSection('products', content),
                    area: ValuePropositionArea.valueMap,
                  ),
                ),
              ),
              
              // Trabajos del Cliente
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: ValuePropositionSection(
                    id: 'customerJobs',
                    title: _getLocalizedTitle(context, 'customerJobs'),
                    subtitle: _getLocalizedSubtitle(context, 'customerJobs'),
                    content: canvas.getContentById('customerJobs'),
                    onChange: (content) => _updateSection('customerJobs', content),
                    area: ValuePropositionArea.customerProfile,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Segunda fila: Aliviadores y Frustraciones
          Row(
            children: [
              // Aliviadores de Frustraciones
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: ValuePropositionSection(
                    id: 'painRelievers',
                    title: _getLocalizedTitle(context, 'painRelievers'),
                    subtitle: _getLocalizedSubtitle(context, 'painRelievers'),
                    content: canvas.getContentById('painRelievers'),
                    onChange: (content) => _updateSection('painRelievers', content),
                    area: ValuePropositionArea.valueMap,
                  ),
                ),
              ),
              
              // Frustraciones
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: ValuePropositionSection(
                    id: 'pains',
                    title: _getLocalizedTitle(context, 'pains'),
                    subtitle: _getLocalizedSubtitle(context, 'pains'),
                    content: canvas.getContentById('pains'),
                    onChange: (content) => _updateSection('pains', content),
                    area: ValuePropositionArea.customerProfile,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Tercera fila: Creadores y Alegrías
          Row(
            children: [
              // Creadores de Alegrías
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: ValuePropositionSection(
                    id: 'gainCreators',
                    title: _getLocalizedTitle(context, 'gainCreators'),
                    subtitle: _getLocalizedSubtitle(context, 'gainCreators'),
                    content: canvas.getContentById('gainCreators'),
                    onChange: (content) => _updateSection('gainCreators', content),
                    area: ValuePropositionArea.valueMap,
                  ),
                ),
              ),
              
              // Alegrías
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: ValuePropositionSection(
                    id: 'gains',
                    title: _getLocalizedTitle(context, 'gains'),
                    subtitle: _getLocalizedSubtitle(context, 'gains'),
                    content: canvas.getContentById('gains'),
                    onChange: (content) => _updateSection('gains', content),
                    area: ValuePropositionArea.customerProfile,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      width: 320,
      height: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Value Map mini
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade100, Colors.purple.shade200],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                ),
                border: Border.all(color: Colors.purple.shade300),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Value Map',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  '${canvas.getContentById('products').length}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${canvas.getContentById('painRelievers').length}',
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange.shade600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${canvas.getContentById('gainCreators').length}',
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal.shade600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Connection
          Container(
            width: 20,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sync_alt,
                  size: 8,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
          
          // Customer Profile mini
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade100, Colors.indigo.shade200],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                border: Border.all(color: Colors.indigo.shade300),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Customer',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  '${canvas.getContentById('customerJobs').length}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${canvas.getContentById('pains').length}',
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${canvas.getContentById('gains').length}',
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      drawer: const AppNavigationDrawer(selectedIndex: 3),
      appBar: AppBar(
        title: Text(
          localizations.valuePropositionCanvas,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey.shade800,
        actions: [
          if (MediaQuery.of(context).size.width < 1024)
            IconButton(
              onPressed: () {
                setState(() {
                  _showPreview = !_showPreview;
                });
              },
              icon: Icon(_showPreview ? Icons.preview : Icons.preview_outlined),
              tooltip: 'Vista previa',
            ),
          IconButton(
            onPressed: _clearCanvas,
            icon: const Icon(Icons.clear_all),
            tooltip: 'Limpiar canvas',
          ),
        ],
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 1024) {
                return _buildDesktopLayout();
              } else if (constraints.maxWidth >= 600) {
                return _buildTabletLayout();
              } else {
                return _buildMobileLayout();
              }
            },
          ),
          
          // Preview overlay for mobile/tablet
          if (_showPreview && MediaQuery.of(context).size.width < 1024)
            Positioned(
              top: 20,
              right: 20,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: _buildPreview(),
              ),
            ),
        ],
      ),
    );
  }
}