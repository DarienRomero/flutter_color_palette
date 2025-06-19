import 'package:flutter/material.dart';

class ColorItem extends StatelessWidget {
  final Color color;
  final String hex;
  const ColorItem({super.key, required this.color, required this.hex});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key(hex),
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle
          ),
        ),
        Container(height: 5),
        Text("#$hex", style: TextStyle(
          fontSize: 14,
          color: Colors.black.withOpacity(0.7)
        )),
      ],
    );
  }
}