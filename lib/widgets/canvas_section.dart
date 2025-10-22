import 'package:flutter/material.dart';
import '../models/canvas_models.dart';

class CanvasSection extends StatefulWidget {
  final String id;
  final String title;
  final List<String> content;
  final Function(List<String>) onChange;
  final CanvasArea area;

  const CanvasSection({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.onChange,
    required this.area,
  });

  @override
  State<CanvasSection> createState() => _CanvasSectionState();
}

class _CanvasSectionState extends State<CanvasSection> {
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

  MaterialColor _getAreaColor(CanvasArea area) {
    switch (area) {
      case CanvasArea.infrastructure:
        return Colors.blue;
      case CanvasArea.offer:
        return Colors.green;
      case CanvasArea.customers:
        return Colors.orange;
      case CanvasArea.finance:
        return Colors.purple;
    }
  }

  Color _getAreaLightColor(CanvasArea area) {
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

  @override
  Widget build(BuildContext context) {
    final areaColor = _getAreaColor(widget.area);
    final areaLightColor = _getAreaLightColor(widget.area);

    return Container(
      decoration: BoxDecoration(
        color: areaLightColor,
        border: Border.all(color: areaColor.shade200, width: 2),
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
                  Icons.drag_indicator,
                  color: areaColor.shade400,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: areaColor.shade800,
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
                        'No items yet',
                        style: TextStyle(
                          color: _getAreaColor(widget.area).shade400,
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
                          thumbColor: areaColor.shade400,
                          trackColor: areaColor.shade200,
                          trackBorderColor: areaColor.shade300,
                          interactive: true,
                          child: Listener(
                            onPointerSignal: (pointerSignal) {
                              // Bloquea el scroll con rueda del mouse
                            },
                            child: ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: false,
                              physics: const ClampingScrollPhysics(), // Permite scroll pero sin bounce
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
                                      ? areaColor.shade100
                                      : Colors.white.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(4),
                                  border: _selectedItemIndex == index
                                      ? Border.all(color: areaColor.shade300, width: 1)
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: areaColor.shade400,
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
                        hintText: 'Add item...',
                        hintStyle: TextStyle(color: areaColor.shade600, fontSize: 12),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.7),
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
                      style: TextStyle(fontSize: 12, color: areaColor.shade800),
                      onSubmitted: (_) => _addItem(),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: areaColor.shade500,
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
}