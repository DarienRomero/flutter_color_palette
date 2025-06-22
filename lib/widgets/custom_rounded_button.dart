import 'package:flutter/material.dart';

/// A custom rounded button widget with predefined styling.
/// 
/// This component provides a consistent button design with rounded corners,
/// fixed dimensions, and minimal padding. It's built on top of RawMaterialButton
/// for better performance and customization.
/// 
/// Example usage:
/// ```dart
/// CustomRoundedButton(
///   onPressed: () => print('Button pressed'),
///   child: Icon(Icons.add),
/// )
/// ```
class CustomRoundedButton extends StatelessWidget {
  /// Callback function triggered when the button is pressed
  final Function() onPressed;
  
  /// The widget to display inside the button
  final Widget child;

  /// Creates a CustomRoundedButton widget.
  /// 
  /// [onPressed] must not be null and handles button press events.
  /// [child] must not be null and represents the button's content.
  const CustomRoundedButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints.tightFor(width: 56, height: 56),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: child,
    );
  }
}