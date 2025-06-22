import 'package:flutter/material.dart';

/// A widget that displays an animated skeleton loading placeholder.
/// 
/// This component creates a shimmer effect skeleton that can be used as a loading
/// placeholder for various UI elements. It supports both circular and rectangular
/// shapes with customizable dimensions and border radius.
/// 
/// Key features:
/// - Animated shimmer effect with gradient
/// - Support for circular and rectangular shapes
/// - Customizable dimensions and border radius
/// - Smooth animation loop
/// 
/// Example usage:
/// ```dart
/// SkeletonWidget(
///   width: 100,
///   height: 100,
///   borderRadius: 8.0,
///   isCircular: false,
/// )
/// ```
class SkeletonWidget extends StatefulWidget {
  /// Width of the skeleton widget
  final double width;
  
  /// Height of the skeleton widget
  final double height;
  
  /// Border radius for rectangular skeletons
  final double borderRadius;
  
  /// Whether the skeleton should be circular
  final bool isCircular;

  /// Creates a SkeletonWidget.
  /// 
  /// [width] defaults to 60 and determines the widget width.
  /// [height] defaults to 60 and determines the widget height.
  /// [borderRadius] defaults to 8.0 and applies to rectangular shapes.
  /// [isCircular] defaults to false and determines the shape type.
  const SkeletonWidget({
    super.key,
    this.width = 60,
    this.height = 60,
    this.borderRadius = 8.0,
    this.isCircular = false,
  });

  @override
  State<SkeletonWidget> createState() => _SkeletonWidgetState();
}

class _SkeletonWidgetState extends State<SkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.isCircular ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: widget.isCircular ? null : BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: [
                0.0,
                _animation.value,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A specialized skeleton widget for color item loading states.
/// 
/// This component displays a skeleton that mimics the layout of a ColorItem,
/// showing a circular skeleton for the color circle and a rectangular skeleton
/// for the hex text below it.
/// 
/// Example usage:
/// ```dart
/// ColorItemSkeleton()
/// ```
class ColorItemSkeleton extends StatelessWidget {
  /// Creates a ColorItemSkeleton widget.
  const ColorItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SkeletonWidget(
          width: 60,
          height: 60,
          isCircular: true,
        ),
        SizedBox(height: 5),
        SkeletonWidget(
          width: 50,
          height: 16,
          borderRadius: 4,
        ),
      ],
    );
  }
} 