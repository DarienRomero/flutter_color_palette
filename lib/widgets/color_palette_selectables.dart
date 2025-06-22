import 'package:flutter/material.dart';
import 'package:flutter_color_palette/models/color_model.dart';
import 'package:flutter_color_palette/widgets/custom_rounded_button.dart';
import 'package:flutter_color_palette/widgets/data_indicator.dart';

class ColorPaletteSelectables extends StatelessWidget {
  final ValueNotifier<ColorModel?> colorDetectedNotifier;
  final Function(String) onHexSelected;
  final Function(int) onRedSelected;
  final Function(int) onGreenSelected;
  final Function(int) onBlueSelected;

  const ColorPaletteSelectables({
    super.key,
    required this.colorDetectedNotifier,
    required this.onHexSelected,
    required this.onRedSelected,
    required this.onGreenSelected,
    required this.onBlueSelected,
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
                CustomRoundedButton(
                  onPressed: () {
                    onHexSelected(colorDetected?.hex ?? "#D0D0D0");
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorDetected?.color ?? const Color(0xFFD0D0D0)
                    ),
                  ),
                ),
                Container(width: 20),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DataIndicator(
                        title: "HEX", 
                        width: 80,
                        value: colorDetected?.hex ?? "#D0D0D0",
                        onPressed: () {
                          onHexSelected(colorDetected?.hex ?? "#D0D0D0");
                        },
                      ),
                      Row(
                        children: [
                          DataIndicator(
                            title: "R", 
                            width: 40,
                            value: (colorDetected?.red.toString() ?? "0").padLeft(3, '0'),
                            onPressed: () {
                              onRedSelected(colorDetected?.red ?? 0);
                            },
                          ),
                          Container(width: 10),
                          DataIndicator(
                            title: "G", 
                            width: 40,
                            value: (colorDetected?.green.toString() ?? "0").padLeft(3, '0'),
                            onPressed: () {
                              onGreenSelected(colorDetected?.green ?? 0);
                            },
                          ),
                          Container(width: 10),
                          DataIndicator(
                            title: "B", 
                            width: 40,
                            value: (colorDetected?.blue.toString() ?? "0").padLeft(3, '0'),
                            onPressed: () {
                              onBlueSelected(colorDetected?.blue ?? 0);
                            },
                          ),
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