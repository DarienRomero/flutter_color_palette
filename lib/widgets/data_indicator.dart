import 'package:flutter/material.dart';

class DataIndicator extends StatelessWidget {
  final String title;
  final String value;
  final double width;
  final Function() onPressed;

  const DataIndicator({
    super.key, 
    required this.title, 
    required this.value,
    this.width = 40,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.7)
        )),
        SizedBox(
          width: width,
          child: RawMaterialButton(
            onPressed: onPressed,
            elevation: 0,
            fillColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(5),
            child: Text(value),
          ),
        ),
      ],
    );
  }
}