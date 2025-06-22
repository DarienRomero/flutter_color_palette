import 'package:flutter/material.dart';
import 'package:flutter_color_palette/models/color_model.dart';
import 'package:flutter_color_palette/widgets/data_indicator.dart';

class ColorPaletteSelectables extends StatelessWidget {
  final ValueNotifier<ColorModel?> colorDetectedNotifier;

  const ColorPaletteSelectables({
    super.key,
    required this.colorDetectedNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color Picker", style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.7)
        )),
        Container(height: 10),
        ValueListenableBuilder<ColorModel?>(
          valueListenable: colorDetectedNotifier,
          builder: (context, colorDetected, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorDetected?.color ?? const Color(0xFFD0D0D0)
                  ),
                ),
                Container(width: 20),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DataIndicator(title: "HEX", value: colorDetected?.hex ?? "#D0D0D0"),
                      Row(
                        children: [
                          DataIndicator(title: "R", value: (colorDetected?.red.toString() ?? "0").padLeft(3, '0')),
                          Container(width: 10),
                          DataIndicator(title: "G", value: (colorDetected?.green.toString() ?? "0").padLeft(3, '0')),
                          Container(width: 10),
                          DataIndicator(title: "B", value: (colorDetected?.blue.toString() ?? "0").padLeft(3, '0')),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(width: 30),
              ],
            );
          },
        ),
      ],
    );
  }
} 