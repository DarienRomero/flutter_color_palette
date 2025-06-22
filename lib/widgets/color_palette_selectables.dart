import 'package:flutter/material.dart';
import 'package:flutter_color_palette/models/color_model.dart';
import 'package:flutter_color_palette/widgets/custom_rounded_button.dart';
import 'package:flutter_color_palette/widgets/data_indicator.dart';

/// A widget that displays a color picker with interactive color information.
/// 
/// This component shows a color circle and displays the color's hex value and RGB
/// components as clickable indicators. It adapts its layout based on the available width
/// and provides callbacks for color selection events.
/// 
/// Example usage:
/// ```dart
/// ColorPaletteSelectables(
///   colorDetectedNotifier: colorNotifier,
///   onHexSelected: (hex) => print('Hex: $hex'), // Returns "#FFFFFF" format
///   onRedSelected: (red) => print('Red: $red'),
///   onGreenSelected: (green) => print('Green: $green'),
///   onBlueSelected: (blue) => print('Blue: $blue'),
///   width: 400,
/// )
/// ```
class ColorPaletteSelectables extends StatelessWidget {
  /// Notifier containing the currently detected color model
  final ValueNotifier<ColorModel?> colorDetectedNotifier;
  
  /// Callback function triggered when hex value is selected
  /// Returns a string in "#FFFFFF" format
  final Function(String) onHexSelected;
  
  /// Callback function triggered when red component is selected
  final Function(int) onRedSelected;
  
  /// Callback function triggered when green component is selected
  final Function(int) onGreenSelected;
  
  /// Callback function triggered when blue component is selected
  final Function(int) onBlueSelected;
  
  /// Available width for the component layout
  final double width;

  /// Creates a ColorPaletteSelectables widget.
  /// 
  /// [colorDetectedNotifier] must not be null and contains the current color.
  /// [onHexSelected] must not be null and returns hex value in "#FFFFFF" format.
  /// [onRedSelected], [onGreenSelected], [onBlueSelected] must not be null.
  /// [width] must not be null and determines the layout adaptation.
  const ColorPaletteSelectables({
    super.key,
    required this.colorDetectedNotifier,
    required this.onHexSelected,
    required this.onRedSelected,
    required this.onGreenSelected,
    required this.onBlueSelected,
    required this.width,
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
                if(width < 300) Column(
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
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                  ],
                ),
                if(width >= 300) Expanded(
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