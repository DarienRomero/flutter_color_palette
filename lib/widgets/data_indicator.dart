import 'package:flutter/material.dart';

/// A widget that displays a data indicator with a title and clickable value.
/// 
/// This component shows a title above a clickable button containing a value.
/// It's commonly used to display color data such as hex values in "#FFFFFF" format
/// or RGB component values like "255". The value is displayed in a fitted text
/// that scales down to fit within the button width.
/// 
/// Example usage:
/// ```dart
/// DataIndicator(
///   title: "HEX",
///   value: "#FFFFFF", // Hex color format
///   width: 80,
///   onPressed: () => print('Hex selected'),
/// )
/// 
/// DataIndicator(
///   title: "R",
///   value: "255", // RGB component format
///   width: 40,
///   onPressed: () => print('Red selected'),
/// )
/// ```
class DataIndicator extends StatelessWidget {
  /// The title displayed above the value button
  final String title;
  
  /// The value displayed inside the button (e.g., "#FFFFFF" or "255")
  final String value;
  
  /// The width of the button container
  final double width;
  
  /// Callback function triggered when the value button is pressed
  final Function() onPressed;

  /// Creates a DataIndicator widget.
  /// 
  /// [title] must not be null and represents the indicator label.
  /// [value] must not be null and can be in formats like "#FFFFFF" or "255".
  /// [width] defaults to 40 and determines the button width.
  /// [onPressed] must not be null and handles button press events.
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
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value),
            ),
          ),
        ),
      ],
    );
  }
}