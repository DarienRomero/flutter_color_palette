import 'package:flutter/material.dart';
import 'package:flutter_color_palette/models/color_model.dart';
import 'package:flutter_color_palette/widgets/skeleton_widget.dart';

class ColorItem extends StatelessWidget {
  final ColorModel? colorModel;
  final bool isLoading;

  const ColorItem({
    super.key, 
    this.colorModel,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading || colorModel == null) {
      return const ColorItemSkeleton();
    }

    return Column(
      key: Key(colorModel!.hex),
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: colorModel!.color,
            shape: BoxShape.circle
          ),
        ),
        Container(height: 5),
        Text(colorModel!.hex, style: TextStyle(
          fontSize: 14,
          color: Colors.black.withOpacity(0.7)
        )),
      ],
    );
  }
}