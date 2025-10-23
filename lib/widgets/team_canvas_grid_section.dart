import 'package:flutter/material.dart';

class TeamCanvasGridSection extends StatefulWidget {
  final String id;
  final String title;
  final String subtitle;
  final List<String> content;
  final Function(List<String>) onContentChanged;
  final Color color;
  final IconData icon;

  const TeamCanvasGridSection({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.onContentChanged,
    required this.color,
    required this.icon,
  });

  @override
  State<TeamCanvasGridSection> createState() => _TeamCanvasGridSectionState();
}

class _TeamCanvasGridSectionState extends State<TeamCanvasGridSection> {
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
    return Container(
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.08),
        border: Border.all(color: widget.color.withOpacity(0.4), width: 2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header similar al BMC
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: widget.color.withOpacity(0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
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
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: widget.content.isEmpty
                  ? Center(
                      child: Text(
                        'No items yet',
                        style: TextStyle(
                          color: widget.color.withOpacity(0.4),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : RawScrollbar(
                      controller: _scrollController,
                      thumbVisibility: false,
                      thickness: 8.0,
                      radius: const Radius.circular(4),
                      thumbColor: widget.color.withOpacity(0.4),
                      trackColor: widget.color.withOpacity(0.1),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
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
                                    ? widget.color.withOpacity(0.1)
                                    : Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(4),
                                border: _selectedItemIndex == index
                                    ? Border.all(color: widget.color.withOpacity(0.3), width: 1)
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: widget.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      widget.content[index],
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  if (_selectedItemIndex == index)
                                    InkWell(
                                      onTap: () => _removeItem(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.close,
                                          size: 14,
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

          // Add item section
          Container(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
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
                      hintStyle: TextStyle(color: widget.color.withOpacity(0.6), fontSize: 12),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      isDense: true,
                    ),
                    style: TextStyle(fontSize: 12, color: widget.color.withOpacity(0.8)),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(4),
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
        ],
      ),
    );
  }
}