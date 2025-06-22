library flutter_color_palette;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_color_palette/models/color_model.dart';
import 'package:flutter_color_palette/utils/color_frequency.dart';
import 'package:flutter_color_palette/widgets/color_item.dart';
import 'package:flutter_color_palette/widgets/data_indicator.dart';
import 'package:flutter_color_palette/widgets/flexible_image_widget.dart';

class FlutterColorPalette extends StatefulWidget {
  final ImageProvider<Object> imageProvider;
  const FlutterColorPalette({
    super.key,
    required this.imageProvider
  });

  @override
  State<FlutterColorPalette> createState() => _FlutterColorPaletteState();
}

class _FlutterColorPaletteState extends State<FlutterColorPalette> {
  final ValueNotifier<List<ColorModel>> _colorModelsNotifier = ValueNotifier<List<ColorModel>>([]);
  final ValueNotifier<ColorModel?> _colorDetectedNotifier = ValueNotifier<ColorModel?>(null);
  final ValueNotifier<Uint8List?> _imageBytesNotifier = ValueNotifier<Uint8List?>(null);
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _loadImageData();
    });
  }

  Future<void> _loadImageData() async {
    try {
      final imageBytes = await readImageData(widget.imageProvider);
      print("Get image bytes ${imageBytes.length}");
      _imageBytesNotifier.value = imageBytes;
      
      final colors = await getMostFrequentColors(widget.imageProvider, imageBytes);
      print("Get colores ${colors.length}");
      _colorModelsNotifier.value = colors;
      _isLoadingNotifier.value = false;
    } catch (e) {
      print("Error loading image data: $e");
      _isLoadingNotifier.value = false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20
      ),
      child: Column(
        children: [
          ValueListenableBuilder<Uint8List?>(
            valueListenable: _imageBytesNotifier,
            builder: (context, imageBytes, child) {
              return FlexibleImageWidget(
                width: 300,
                imageProvider: widget.imageProvider,
                imageBytes: imageBytes,
                onColorDetected: (color) {
                  _colorDetectedNotifier.value = color;
                },
              );
            },
          ),
          Container(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Color Picker", style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.7)
              )),
              Container(height: 10),
              ValueListenableBuilder<ColorModel?>(
                valueListenable: _colorDetectedNotifier,
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
                          color: colorDetected?.color ?? Colors.green
                        ),
                      ),
                      Container(width: 20),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DataIndicator(title: "HEX", value: colorDetected?.hex ?? "     "),
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
              Container(height: 30),
              Text(
                "Color Palette", 
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7)
                )
              ),
              Container(height: 10),
              ValueListenableBuilder<List<ColorModel>>(
                valueListenable: _colorModelsNotifier,
                builder: (context, colorModels, child) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: _isLoadingNotifier,
                    builder: (context, isLoading, child) {
                      return SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: colorModels.length,
                          itemBuilder: (context, index) {
                            final item = colorModels[index];
                            return ColorItem(colorModel: item);
                          },
                          separatorBuilder: (context, index) {
                            return Container(width: 10);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _colorModelsNotifier.dispose();
    _colorDetectedNotifier.dispose();
    _imageBytesNotifier.dispose();
    _isLoadingNotifier.dispose();
    super.dispose();
  }
}
