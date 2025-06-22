import 'package:flutter/material.dart';
import 'package:flutter_color_palette/models/color_model.dart';
import 'package:flutter_color_palette/widgets/custom_rounded_button.dart';
import 'package:flutter_color_palette/widgets/skeleton_widget.dart';

/// A widget that displays a single color item with its hex value.
/// 
/// This component shows either a loading skeleton or a clickable color circle
/// with its corresponding hex code. When tapped, it triggers a callback with
/// the hex value of the selected color.
/// 
/// Example usage:
/// ```dart
/// ColorItem(
///   colorModel: colorModel,
///   onHexSelected: (hex) => print('Selected: $hex'),
/// )
/// ```
class ColorItem extends StatelessWidget {
  /// The color model containing color information and hex value
  final ColorModel? colorModel;
  
  /// Whether to show the loading skeleton instead of the color item
  final bool isLoading;
  
  /// Callback function triggered when the color item is tapped
  final Function(String)? onHexSelected;

  /// Creates a ColorItem widget.
  /// 
  /// [colorModel] can be null if [isLoading] is true.
  /// [isLoading] defaults to false.
  /// [onHexSelected] is optional and handles tap events.
  const ColorItem({
    super.key, 
    this.colorModel,
    this.isLoading = false,
    this.onHexSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading || colorModel == null) {
      return const ColorItemSkeleton();
    }

    return CustomRoundedButton(
      onPressed: () {
        if (onHexSelected != null) {
          onHexSelected!(colorModel!.hex);
        }
      }, 
      child: Column(
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
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(colorModel!.hex, style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.7)
            )),
          ),
        ],
      )
    );
  }
}