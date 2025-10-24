import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import '../models/canvas_models.dart';
import '../widgets/app_navigation_drawer.dart';

class IdeaNapkinCanvasPage extends StatefulWidget {
  const IdeaNapkinCanvasPage({super.key});

  @override
  State<IdeaNapkinCanvasPage> createState() => _IdeaNapkinCanvasPageState();
}

class _IdeaNapkinCanvasPageState extends State<IdeaNapkinCanvasPage> {
  static const String storageKey = 'ideaNapkinCanvas';
  IdeaNapkinCanvas canvas = IdeaNapkinCanvas.empty();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _audienceController = TextEditingController();
  final TextEditingController _innovationController = TextEditingController();
  final TextEditingController _businessValueController = TextEditingController();
  final TextEditingController _innovationPowerController = TextEditingController();
  final TextEditingController _userValueController = TextEditingController();

  List<Offset> _points = [];
  bool _isDrawing = false;
  Timer? _saveTimer;
  bool _showSaveMessage = false;
  bool _isDrawingInCanvas = false;
  bool _isScrollLocked = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadCanvas();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _audienceController.dispose();
    _innovationController.dispose();
    _businessValueController.dispose();
    _innovationPowerController.dispose();
    _userValueController.dispose();
    _scrollController.dispose();
    _saveTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadCanvas() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final canvasData = prefs.getString(storageKey);
      
      if (canvasData != null) {
        final json = jsonDecode(canvasData);
        canvas = IdeaNapkinCanvas.fromJson(json);
        _loadSketchFromCanvas();
        _updateControllers();
      }
      
      setState(() {}); // Force rebuild to show loaded data
    } catch (e) {
      debugPrint('Error loading Idea Napkin Canvas: $e');
    }
  }

  void _updateControllers() {
    _titleController.text = canvas.title;
    _descriptionController.text = canvas.shortDescription;
    _audienceController.text = canvas.targetAudience;
    _innovationController.text = canvas.innovationAspect;
    _businessValueController.text = canvas.businessValue == 0 ? '' : canvas.businessValue.toString();
    _innovationPowerController.text = canvas.innovationPower == 0 ? '' : canvas.innovationPower.toString();
    _userValueController.text = canvas.userValue == 0 ? '' : canvas.userValue.toString();
  }

  void _loadSketchFromCanvas() {
    if (canvas.sketchData.isNotEmpty) {
      try {
        final List<dynamic> pointsJson = jsonDecode(canvas.sketchData);
        _points = pointsJson.map((point) {
          if (point == null) {
            return Offset.infinite;
          } else {
            return Offset(point['dx'], point['dy']);
          }
        }).toList();
      } catch (e) {
        debugPrint('Error loading sketch: $e');
        _points = [];
      }
    }
  }

  void _saveSketchToCanvas() {
    final pointsJson = _points.map((point) {
      if (point == Offset.infinite) {
        return null;
      } else {
        return {'dx': point.dx, 'dy': point.dy};
      }
    }).toList();
    
    canvas = canvas.copyWith(sketchData: jsonEncode(pointsJson));
  }

  Future<void> _saveCanvas({bool showMessage = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final canvasData = jsonEncode(canvas.toJson());
      await prefs.setString(storageKey, canvasData);
      
      if (mounted && showMessage && !_showSaveMessage) {
        setState(() {
          _showSaveMessage = true;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Canvas guardado automáticamente'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        // Reset flag after a delay
        Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showSaveMessage = false;
            });
          }
        });
      }
    } catch (e) {
      debugPrint('Error saving Idea Napkin Canvas: $e');
    }
  }

  void _updateCanvas() {
    setState(() {
      canvas = canvas.copyWith(
        title: _titleController.text,
        shortDescription: _descriptionController.text,
        targetAudience: _audienceController.text,
        innovationAspect: _innovationController.text,
        businessValue: int.tryParse(_businessValueController.text) ?? 0,
        innovationPower: int.tryParse(_innovationPowerController.text) ?? 0,
        userValue: int.tryParse(_userValueController.text) ?? 0,
      );
    });
    
    // Cancel existing timer
    _saveTimer?.cancel();
    
    // Set a new timer to save after a delay (debounce)
    _saveTimer = Timer(const Duration(milliseconds: 1000), () {
      _saveCanvas(showMessage: true);
    });
  }

  void _clearSketch() {
    setState(() {
      _points.clear();
    });
    _saveSketchToCanvas();
    _saveCanvas(showMessage: false);
  }

  void _toggleScrollLock() {
    setState(() {
      _isScrollLocked = !_isScrollLocked;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isScrollLocked 
            ? 'Scroll bloqueado - Ideal para dibujar' 
            : 'Scroll desbloqueado - Navegación normal'
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _isScrollLocked ? Colors.orange : Colors.green,
      ),
    );
  }

  Future<void> _clearCanvas() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar Canvas'),
        content: const Text('¿Estás seguro de que quieres limpiar todo el contenido del Idea Napkin Canvas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        canvas = IdeaNapkinCanvas.empty();
        _points.clear();
        _updateControllers();
      });
      await _saveCanvas(showMessage: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      drawer: const AppNavigationDrawer(selectedIndex: 5),
      appBar: AppBar(
        title: const Text(
          'Idea Napkin Canvas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            tooltip: 'Limpiar Canvas',
            onPressed: _clearCanvas,
          ),
        ],
      ),
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // Bloquear scroll si está activado el lock o si se está dibujando
            return _isScrollLocked || _isDrawingInCanvas;
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: (_isScrollLocked || _isDrawingInCanvas) 
                ? const NeverScrollableScrollPhysics() 
                : const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header informativo
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade400, Colors.purple.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Idea Napkin Canvas',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Captura rápidamente los elementos clave de tu idea de negocio',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Contenido principal
                  if (isWide)
                    _buildWideLayout()
                  else
                    _buildNarrowLayout(),
                ],
              );
            },
          ),
        ),
      ),
    ));
  }

  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Columna izquierda
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildTitleSection(),
              const SizedBox(height: 16),
              _buildDescriptionSection(),
              const SizedBox(height: 16),
              _buildAudienceSection(),
              const SizedBox(height: 16),
              _buildInnovationSection(),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Columna derecha
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildFormulaSection(),
              const SizedBox(height: 16),
              _buildSketchSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        _buildTitleSection(),
        const SizedBox(height: 16),
        _buildDescriptionSection(),
        const SizedBox(height: 16),
        _buildAudienceSection(),
        const SizedBox(height: 16),
        _buildInnovationSection(),
        const SizedBox(height: 16),
        _buildFormulaSection(),
        const SizedBox(height: 16),
        _buildSketchSection(),
      ],
    );
  }

  Widget _buildTitleSection() {
    return _buildSection(
      title: 'Título de la Idea',
      icon: Icons.lightbulb_outline,
      color: Colors.blue,
      child: TextField(
        controller: _titleController,
        onChanged: (_) => _updateCanvas(),
        decoration: const InputDecoration(
          hintText: 'Ingresa el título de tu idea...',
          border: OutlineInputBorder(),
        ),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return _buildSection(
      title: 'Descripción Corta',
      icon: Icons.description_outlined,
      color: Colors.green,
      child: TextField(
        controller: _descriptionController,
        onChanged: (_) => _updateCanvas(),
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Describe brevemente tu idea...',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildAudienceSection() {
    return _buildSection(
      title: 'A Quiénes Va Dirigida',
      icon: Icons.people_outline,
      color: Colors.orange,
      child: TextField(
        controller: _audienceController,
        onChanged: (_) => _updateCanvas(),
        maxLines: 2,
        decoration: const InputDecoration(
          hintText: 'Define tu público objetivo...',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildInnovationSection() {
    return _buildSection(
      title: 'Aspecto de Innovación',
      icon: Icons.auto_awesome,
      color: Colors.purple,
      child: TextField(
        controller: _innovationController,
        onChanged: (_) => _updateCanvas(),
        maxLines: 2,
        decoration: const InputDecoration(
          hintText: 'Qué hace innovadora tu idea...',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildFormulaSection() {
    return _buildSection(
      title: 'Fórmula de Valor',
      icon: Icons.calculate_outlined,
      color: Colors.teal,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _businessValueController,
                  onChanged: (_) => _updateCanvas(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Valor de Negocio',
                    border: OutlineInputBorder(),
                    hintText: '1-99',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('+', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: TextField(
                  controller: _innovationPowerController,
                  onChanged: (_) => _updateCanvas(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Poder de Innovación',
                    border: OutlineInputBorder(),
                    hintText: '1-99',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('+', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: TextField(
                  controller: _userValueController,
                  onChanged: (_) => _updateCanvas(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Valor para el Usuario',
                    border: OutlineInputBorder(),
                    hintText: '1-99',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Column(
              children: [
                const Text(
                  'Valor Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${canvas.totalValue}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
                Text(
                  '${canvas.businessValue} + ${canvas.innovationPower} + ${canvas.userValue}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSketchSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título personalizado con botón
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.draw_outlined, color: Colors.indigo, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Idea Sketch',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ),
              // Botón de bloqueo/desbloqueo junto al título
              Container(
                decoration: BoxDecoration(
                  color: _isScrollLocked ? Colors.orange.shade50 : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isScrollLocked ? Colors.orange.shade200 : Colors.blue.shade200,
                  ),
                ),
                child: IconButton(
                  icon: Icon(_isScrollLocked ? Icons.lock : Icons.lock_open),
                  tooltip: _isScrollLocked ? 'Desbloquear scroll' : 'Bloquear scroll',
                  onPressed: _toggleScrollLock,
                  color: _isScrollLocked ? Colors.orange.shade700 : Colors.blue.shade700,
                  iconSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
            Column(
              children: [
                // Indicador de estado del scroll
                if (_isScrollLocked)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lock, color: Colors.orange.shade700, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Scroll bloqueado - Modo dibujo activo',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                      onTapDown: (details) {
                        setState(() {
                          _isDrawingInCanvas = true;
                        });
                      },
                      onTapUp: (details) {
                        if (!_isDrawing) {
                          setState(() {
                            _isDrawingInCanvas = false;
                          });
                        }
                      },
                      onTapCancel: () {
                        if (!_isDrawing) {
                          setState(() {
                            _isDrawingInCanvas = false;
                          });
                        }
                      },
                      onPanStart: (details) {
                        setState(() {
                          _isDrawing = true;
                          _isDrawingInCanvas = true;
                          _points.add(details.localPosition);
                        });
                      },
                      onPanUpdate: (details) {
                        if (_isDrawing) {
                          setState(() {
                            _points.add(details.localPosition);
                          });
                        }
                      },
                      onPanEnd: (details) {
                        setState(() {
                          _isDrawing = false;
                          _isDrawingInCanvas = false;
                          _points.add(Offset.infinite);
                        });
                        _saveSketchToCanvas();
                        _saveCanvas(showMessage: false);
                      },
                      child: CustomPaint(
                        painter: SketchPainter(_points),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _clearSketch,
                      icon: const Icon(Icons.clear),
                      label: const Text('Limpiar Dibujo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class SketchPainter extends CustomPainter {
  final List<Offset> points;

  SketchPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}