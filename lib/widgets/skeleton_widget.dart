import 'package:flutter/material.dart';

class SkeletonWidget extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final bool isCircular;

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

class ColorItemSkeleton extends StatelessWidget {
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