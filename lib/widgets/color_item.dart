import 'package:flutter/material.dart';
import 'package:flutter_color_palette/models/color_model.dart';

class ColorItem extends StatelessWidget {
  final ColorModel colorModel;
  const ColorItem({super.key, required this.colorModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key(colorModel.hex),
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: colorModel.color,
            shape: BoxShape.circle
          ),
        ),
        Container(height: 5),
        Text(colorModel.hex, style: TextStyle(
          fontSize: 14,
          color: Colors.black.withOpacity(0.7)
        )),
      ],
    );
  }
}