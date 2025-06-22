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
  final ValueNotifier<bool> _showLeftIndicatorNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _showRightIndicatorNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    
    _showLeftIndicatorNotifier.value = currentScroll > 0;
    _showRightIndicatorNotifier.value = currentScroll < maxScroll;
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
        ValueListenableBuilder<bool>(
          valueListenable: _showLeftIndicatorNotifier,
          builder: (context, showLeftIndicator, child) {
            if (!showLeftIndicator) return const SizedBox.shrink();
            
            return Positioned(
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
            );
          },
        ),
        
        // Indicador derecho
        ValueListenableBuilder<bool>(
          valueListenable: _showRightIndicatorNotifier,
          builder: (context, showRightIndicator, child) {
            if (!showRightIndicator) return const SizedBox.shrink();
            
            return Positioned(
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
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _showLeftIndicatorNotifier.dispose();
    _showRightIndicatorNotifier.dispose();
    super.dispose();
  }
} 