import 'package:flutter/material.dart';
import 'package:flutter_color_palette/models/color_model.dart';
import 'package:flutter_color_palette/widgets/custom_rounded_button.dart';
import 'package:flutter_color_palette/widgets/skeleton_widget.dart';

class ColorItem extends StatelessWidget {
  final ColorModel? colorModel;
  final bool isLoading;
  final Function(String)? onHexSelected;

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