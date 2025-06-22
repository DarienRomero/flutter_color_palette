import 'package:flutter/material.dart';
import 'package:flutter_color_palette/models/color_model.dart';
import 'package:flutter_color_palette/widgets/color_item.dart';

class ScrollIndicatorWidget extends StatefulWidget {
  final List<ColorModel> colorModels;
  final double height;
  final Color indicatorColor;
  final double indicatorWidth;
  final double indicatorHeight;
  final double indicatorOpacity;
  final Function(String) onHexSelected;

  const ScrollIndicatorWidget({
    super.key,
    required this.colorModels,
    this.indicatorColor = Colors.white,
    this.height = 100,
    this.indicatorWidth = 30,
    this.indicatorHeight = 60,
    this.indicatorOpacity = 0.8,
    required this.onHexSelected,
  });

  @override
  State<ScrollIndicatorWidget> createState() => _ScrollIndicatorWidgetState();
}

class _ScrollIndicatorWidgetState extends State<ScrollIndicatorWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _showLeftIndicator = false;
  bool _showRightIndicator = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    
    setState(() {
      _showLeftIndicator = currentScroll > 0;
      _showRightIndicator = currentScroll < maxScroll;
    });
  }

  void _scrollLeft() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset - 200,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollRight() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset + 200,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Widget hijo (ListView)
        ListView.separated(
          physics: const ClampingScrollPhysics(),
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.colorModels.length,
          itemBuilder: (context, index) {
            final item = widget.colorModels[index];
            return ColorItem(
              colorModel: item,
              onHexSelected: widget.onHexSelected
            );
          },
          separatorBuilder: (context, index) {
            return Container(width: 10);
          },
        ),
        
        // Indicador izquierdo
        if (_showLeftIndicator)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _scrollLeft,
              child: Container(
                width: widget.indicatorWidth,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                ),
                child: Center(
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.black.withOpacity(0.6),
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        
        // Indicador derecho
        if (_showRightIndicator)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _scrollRight,
              child: Container(
                width: widget.indicatorWidth,
                decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1)
              ),
              child: Center(
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.black.withOpacity(0.6),
                  size: 24,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
} 