import 'package:flutter/material.dart';
import 'package:flutter_color_palette/models/color_model.dart';
import 'package:flutter_color_palette/widgets/color_item.dart';

/// A widget that displays a horizontal scrollable list with navigation indicators.
/// 
/// This component provides a horizontal ListView of color items with left and right
/// scroll indicators that appear/disappear based on scroll position. It uses
/// ValueNotifier for reactive state management and smooth scroll animations.
/// 
/// Key features:
/// - Horizontal scrolling with smooth animations
/// - Dynamic scroll indicators (left/right arrows)
/// - Reactive visibility based on scroll position
/// - Customizable indicator styling
/// 
/// Example usage:
/// ```dart
/// ScrollIndicatorWidget(
///   colorModels: colorList,
///   height: 120,
///   onHexSelected: (hex) => print('Selected: $hex'),
/// )
/// ```
class ScrollIndicatorWidget extends StatefulWidget {
  /// List of color models to display in the horizontal list
  final List<ColorModel> colorModels;
  
  /// Height of the scrollable container
  final double height;
  
  /// Color of the scroll indicators
  final Color indicatorColor;
  
  /// Width of the scroll indicator buttons
  final double indicatorWidth;
  
  /// Height of the scroll indicator buttons
  final double indicatorHeight;
  
  /// Opacity of the scroll indicators
  final double indicatorOpacity;
  
  /// Callback function triggered when a hex color is selected
  final Function(String) onHexSelected;

  /// Creates a ScrollIndicatorWidget.
  /// 
  /// [colorModels] must not be null and contains the list of colors to display.
  /// [onHexSelected] must not be null and handles hex color selection events.
  /// [height] defaults to 100 and determines the container height.
  /// [indicatorColor] defaults to Colors.white.
  /// [indicatorWidth] defaults to 30.
  /// [indicatorHeight] defaults to 60.
  /// [indicatorOpacity] defaults to 0.8.
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

  /// Updates indicator visibility based on scroll position
  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    
    _showLeftIndicatorNotifier.value = currentScroll > 0;
    _showRightIndicatorNotifier.value = currentScroll < maxScroll;
  }

  /// Scrolls the list to the left with smooth animation
  void _scrollLeft() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset - 200,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Scrolls the list to the right with smooth animation
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
        // Child widget (ListView)
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
        
        // Left indicator
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
        
        // Right indicator
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