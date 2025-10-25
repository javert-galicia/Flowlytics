import 'package:flutter/material.dart';
import '../models/value_proposition_models.dart';

class ValuePropositionSection extends StatefulWidget {
  final String id;
  final String title;
  final String subtitle;
  final List<String> content;
  final Function(List<String>) onChange;
  final ValuePropositionArea area;

  const ValuePropositionSection({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.onChange,
    required this.area,
  });

  @override
  State<ValuePropositionSection> createState() => _ValuePropositionSectionState();
}

class _ValuePropositionSectionState extends State<ValuePropositionSection> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  int? _selectedItemIndex;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addItem() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onChange([...widget.content, text]);
      _controller.clear();
    }
  }

  void _removeItem(int index) {
    final newContent = List<String>.from(widget.content);
    newContent.removeAt(index);
    widget.onChange(newContent);
    setState(() {
      _selectedItemIndex = null;
    });
  }

  Color _getSectionColor(String id) {
    switch (id) {
      // Customer Profile (lado derecho) - Tonos cálidos
      case 'customerJobs':
        return Colors.indigo.shade600; // Azul profundo para trabajos
      case 'pains':
        return Colors.red.shade600; // Rojo para frustraciones
      case 'gains':
        return Colors.green.shade600; // Verde para alegrías
      
      // Value Map (lado izquierdo) - Tonos fríos/complementarios
      case 'products':
        return Colors.purple.shade600; // Púrpura para productos
      case 'painRelievers':
        return Colors.orange.shade600; // Naranja para aliviadores (complemento del rojo)
      case 'gainCreators':
        return Colors.teal.shade600; // Teal para creadores (complemento del verde)
      
      default:
        return Colors.grey.shade600;
    }
  }

  Color _getSectionLightColor(String id) {
    switch (id) {
      case 'customerJobs':
        return Colors.indigo.shade50;
      case 'pains':
        return Colors.red.shade50;
      case 'gains':
        return Colors.green.shade50;
      case 'products':
        return Colors.purple.shade50;
      case 'painRelievers':
        return Colors.orange.shade50;
      case 'gainCreators':
        return Colors.teal.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  Color _getSectionBorderColor(String id) {
    switch (id) {
      case 'customerJobs':
        return Colors.indigo.shade200;
      case 'pains':
        return Colors.red.shade200;
      case 'gains':
        return Colors.green.shade200;
      case 'products':
        return Colors.purple.shade200;
      case 'painRelievers':
        return Colors.orange.shade200;
      case 'gainCreators':
        return Colors.teal.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  IconData _getSectionIcon(String id) {
    switch (id) {
      case 'customerJobs':
        return Icons.work_outline; // Trabajo
      case 'pains':
        return Icons.sentiment_very_dissatisfied; // Frustración
      case 'gains':
        return Icons.sentiment_very_satisfied; // Alegría
      case 'products':
        return Icons.inventory_2_outlined; // Productos
      case 'painRelievers':
        return Icons.healing_outlined; // Alivio
      case 'gainCreators':
        return Icons.auto_awesome_outlined; // Creación
      default:
        return Icons.circle;
    }
  }

  String _getPlaceholderText(String id) {
    switch (id) {
      case 'customerJobs':
        return 'Ej: Gestionar finanzas personales...';
      case 'pains':
        return 'Ej: Perder tiempo en tareas repetitivas...';
      case 'gains':
        return 'Ej: Ahorrar tiempo y dinero...';
      case 'products':
        return 'Ej: App móvil de gestión...';
      case 'painRelievers':
        return 'Ej: Automatización de procesos...';
      case 'gainCreators':
        return 'Ej: Reportes automáticos...';
      default:
        return 'Agregar elemento...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sectionColor = _getSectionColor(widget.id);
    final sectionLightColor = _getSectionLightColor(widget.id);
    final sectionBorderColor = _getSectionBorderColor(widget.id);

    return Container(
      // Sin altura fija - se adapta al contenido disponible
      constraints: const BoxConstraints(
        minHeight: 200,
      ),
      decoration: BoxDecoration(
        color: sectionLightColor,
        border: Border.all(color: sectionBorderColor, width: 2),
        borderRadius: BorderRadius.circular(16), // Bordes más redondeados
        boxShadow: [
          BoxShadow(
            color: sectionColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header más compacto - altura ajustada
          Container(
            height: 38, // Aumentado ligeramente para acomodar texto
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: sectionColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Icon(
                    _getSectionIcon(widget.id),
                    color: Colors.white,
                    size: 12, // Reducido de 14 a 12
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 12, // Aumentado a 12 para mejor legibilidad
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: 9, // Aumentado a 9 para mejor legibilidad
                          color: Colors.white.withOpacity(0.9),
                          fontStyle: FontStyle.italic,
                          height: 1.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${widget.content.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content list - altura flexible sin Expanded
          Container(
            constraints: const BoxConstraints(
              minHeight: 104, // Ajustado por el header de 38px
              maxHeight: 144, // Ajustado proporcionalmente
            ),
            padding: const EdgeInsets.all(4),
            child: widget.content.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getSectionIcon(widget.id),
                          color: sectionColor.withOpacity(0.3),
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sin elementos',
                          style: TextStyle(
                            color: sectionColor.withOpacity(0.5),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Agrega elementos usando el botón +',
                          style: TextStyle(
                            color: sectionColor.withOpacity(0.4),
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (notification) => notification.depth == 0,
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(scrollbars: false),
                        child: RawScrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          trackVisibility: true,
                          thickness: 8.0,
                          radius: const Radius.circular(4),
                          thumbColor: sectionColor.withOpacity(0.6),
                          trackColor: sectionColor.withOpacity(0.1),
                          trackBorderColor: sectionColor.withOpacity(0.2),
                          interactive: true,
                          child: Listener(
                            onPointerSignal: (pointerSignal) {},
                            child: ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: false,
                              physics: const ClampingScrollPhysics(),
                              itemCount: widget.content.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedItemIndex = _selectedItemIndex == index ? null : index;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 4),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _selectedItemIndex == index 
                                          ? sectionColor.withOpacity(0.1)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _selectedItemIndex == index
                                            ? sectionColor.withOpacity(0.3)
                                            : sectionBorderColor.withOpacity(0.3),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 3,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: sectionColor,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            widget.content[index],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                        if (_selectedItemIndex == index)
                                          InkWell(
                                            onTap: () => _removeItem(index),
                                            borderRadius: BorderRadius.circular(12),
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade50,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                size: 12,
                                                color: Colors.red.shade600,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
          ),

          // Add item section - altura reducida para evitar overflow
          Container(
            height: 48, // Reducido de 55 a 48
            padding: const EdgeInsets.all(4), // Reducido padding
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 32, // Altura fija para el TextField
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      maxLines: 1, // Solo una línea para evitar overflow
                      decoration: InputDecoration(
                        hintText: _getPlaceholderText(widget.id),
                        hintStyle: TextStyle(
                          color: sectionColor.withOpacity(0.6),
                          fontSize: 10,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: sectionBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: sectionColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 10, color: sectionColor),
                      onSubmitted: (_) => _addItem(),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        sectionColor,
                        sectionColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: sectionColor.withOpacity(0.3),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _addItem,
                    icon: const Icon(Icons.add, color: Colors.white),
                    iconSize: 14,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.expand(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}