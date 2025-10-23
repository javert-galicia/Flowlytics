import 'package:flutter/material.dart';

class TeamCanvasSection extends StatefulWidget {
  final String id;
  final String title;
  final String subtitle;
  final List<String> content;
  final Function(List<String>) onContentChanged;
  final Color color;
  final IconData icon;
  final double? height;

  const TeamCanvasSection({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.onContentChanged,
    required this.color,
    required this.icon,
    this.height,
  });

  @override
  State<TeamCanvasSection> createState() => _TeamCanvasSectionState();
}

class _TeamCanvasSectionState extends State<TeamCanvasSection> {
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
      widget.onContentChanged([...widget.content, text]);
      _controller.clear();
    }
  }

  void _removeItem(int index) {
    final newContent = List<String>.from(widget.content);
    newContent.removeAt(index);
    widget.onContentChanged(newContent);
    setState(() {
      _selectedItemIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 300;
        final containerHeight = widget.height ?? (isSmall ? 280.0 : 350.0);
        
        return Container(
          height: containerHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.color.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(isSmall ? 12 : 16),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmall ? 6 : 8),
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: isSmall ? 16 : 20,
                      ),
                    ),
                    SizedBox(width: isSmall ? 8 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: isSmall ? 14 : 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.subtitle,
                            style: TextStyle(
                              fontSize: isSmall ? 10 : 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content list
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(isSmall ? 8 : 12),
                  child: widget.content.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                widget.icon,
                                color: Colors.grey.shade300,
                                size: isSmall ? 24 : 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No hay elementos aún',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: isSmall ? 12 : 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: widget.content.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedItemIndex = _selectedItemIndex == index ? null : index;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: isSmall ? 6 : 8),
                                padding: EdgeInsets.all(isSmall ? 8 : 12),
                                decoration: BoxDecoration(
                                  color: _selectedItemIndex == index 
                                      ? widget.color.withOpacity(0.1)
                                      : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: _selectedItemIndex == index
                                      ? Border.all(color: widget.color.withOpacity(0.5), width: 1)
                                      : Border.all(color: Colors.grey.shade200, width: 1),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: isSmall ? 6 : 8,
                                      height: isSmall ? 6 : 8,
                                      decoration: BoxDecoration(
                                        color: widget.color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: isSmall ? 8 : 12),
                                    Expanded(
                                      child: Text(
                                        widget.content[index],
                                        style: TextStyle(
                                          fontSize: isSmall ? 12 : 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    if (_selectedItemIndex == index)
                                      InkWell(
                                        onTap: () => _removeItem(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            size: isSmall ? 14 : 16,
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

              // Add item section
              Container(
                padding: EdgeInsets.all(isSmall ? 8 : 12),
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
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500, 
                            fontSize: isSmall ? 12 : 14
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: widget.color, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: isSmall ? 8 : 12,
                            vertical: isSmall ? 6 : 8,
                          ),
                          isDense: true,
                        ),
                        style: TextStyle(
                          fontSize: isSmall ? 12 : 14, 
                          color: Colors.black87
                        ),
                        onSubmitted: (_) => _addItem(),
                      ),
                    ),
                    SizedBox(width: isSmall ? 6 : 8),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [widget.color, widget.color.withOpacity(0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: _addItem,
                        icon: const Icon(Icons.add, color: Colors.white),
                        iconSize: isSmall ? 16 : 20,
                        constraints: BoxConstraints(
                          minWidth: isSmall ? 32 : 40,
                          minHeight: isSmall ? 32 : 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}