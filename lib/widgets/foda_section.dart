import 'package:flutter/material.dart';
import '../models/foda_models.dart';

class FodaSection extends StatefulWidget {
  final String id;
  final String title;
  final List<String> content;
  final Function(List<String>) onChange;
  final FodaArea area;

  const FodaSection({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.onChange,
    required this.area,
  });

  @override
  State<FodaSection> createState() => _FodaSectionState();
}

class _FodaSectionState extends State<FodaSection> {
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
      _selectedItemIndex = null; // Limpiar selección después de eliminar
    });
  }

  MaterialColor _getAreaColor(FodaArea area) {
    switch (area) {
      case FodaArea.internal:
        return Colors.teal; // Para Fortalezas y Debilidades
      case FodaArea.external:
        return Colors.deepPurple; // Para Oportunidades y Amenazas
    }
  }

  Color _getAreaLightColor(FodaArea area) {
    switch (area) {
      case FodaArea.internal:
        return Colors.teal.shade50;
      case FodaArea.external:
        return Colors.deepPurple.shade50;
    }
  }

  Color _getSpecificSectionColor(String id) {
    switch (id) {
      case 'fortalezas':
        return Colors.green.shade600; // Verde para fortalezas
      case 'oportunidades':
        return Colors.blue.shade600; // Azul para oportunidades
      case 'debilidades':
        return Colors.orange.shade600; // Naranja para debilidades
      case 'amenazas':
        return Colors.red.shade600; // Rojo para amenazas
      default:
        return _getAreaColor(widget.area).shade600;
    }
  }

  Color _getSpecificSectionLightColor(String id) {
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
        return _getAreaLightColor(widget.area);
    }
  }

  Color _getSpecificSectionBorderColor(String id) {
    switch (id) {
      case 'fortalezas':
        return Colors.green.shade200;
      case 'oportunidades':
        return Colors.blue.shade200;
      case 'debilidades':
        return Colors.orange.shade200;
      case 'amenazas':
        return Colors.red.shade200;
      default:
        return _getAreaColor(widget.area).shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sectionColor = _getSpecificSectionColor(widget.id);
    final sectionLightColor = _getSpecificSectionLightColor(widget.id);
    final sectionBorderColor = _getSpecificSectionBorderColor(widget.id);

    return Container(
      decoration: BoxDecoration(
        color: sectionLightColor,
        border: Border.all(color: sectionBorderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Icon(
                  _getSectionIcon(widget.id),
                  color: sectionColor,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: sectionColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          
          // Content list
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: widget.content.isEmpty
                  ? Center(
                      child: Text(
                        'Sin elementos',
                        style: TextStyle(
                          color: sectionColor.withOpacity(0.5),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        // Solo permite scroll si viene de la scrollbar
                        return notification.depth == 0;
                      },
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(
                          scrollbars: false,
                          overscroll: false,
                        ),
                        child: RawScrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          trackVisibility: true,
                          thickness: 12.0,
                          radius: const Radius.circular(6),
                          thumbColor: sectionColor.withOpacity(0.7),
                          trackColor: sectionColor.withOpacity(0.2),
                          trackBorderColor: sectionColor.withOpacity(0.3),
                          interactive: true,
                          child: Listener(
                            onPointerSignal: (pointerSignal) {
                              // Bloquea el scroll con rueda del mouse
                            },
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
                                          : Colors.white.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(4),
                                      border: _selectedItemIndex == index
                                          ? Border.all(color: sectionColor.withOpacity(0.3), width: 1)
                                          : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: sectionColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            widget.content[index],
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        if (_selectedItemIndex == index)
                                          InkWell(
                                            onTap: () => _removeItem(index),
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              child: Icon(
                                                Icons.close,
                                                size: 16,
                                                color: Colors.red.shade500,
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
          ),

          // Add item section
          Flexible(
            flex: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Agregar elemento...',
                        hintStyle: TextStyle(color: sectionColor.withOpacity(0.6), fontSize: 12),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 12, color: sectionColor),
                      onSubmitted: (_) => _addItem(),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: sectionColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _addItem,
                      icon: const Icon(Icons.add, color: Colors.white),
                      iconSize: 16,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
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

  IconData _getSectionIcon(String id) {
    switch (id) {
      case 'fortalezas':
        return Icons.trending_up; // Tendencia hacia arriba para fortalezas
      case 'oportunidades':
        return Icons.lightbulb_outline; // Bombilla para oportunidades
      case 'debilidades':
        return Icons.trending_down; // Tendencia hacia abajo para debilidades
      case 'amenazas':
        return Icons.warning_outlined; // Advertencia para amenazas
      default:
        return Icons.circle;
    }
  }
}