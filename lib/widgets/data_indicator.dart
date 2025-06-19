import 'package:flutter/material.dart';

class DataIndicator extends StatelessWidget {
  final String title;
  final String value;

  const DataIndicator({
    super.key, 
    required this.title, 
    required this.value
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
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 10)
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)
          ),
          padding: const EdgeInsets.all(5),
          child: Text(value),
        ),
      ],
    );
  }
}