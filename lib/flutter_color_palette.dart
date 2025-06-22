library flutter_color_palette;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_color_palette/models/color_model.dart';
import 'package:flutter_color_palette/utils/color_frequency.dart';
import 'package:flutter_color_palette/widgets/flexible_image_widget.dart';
import 'package:flutter_color_palette/widgets/color_item_list.dart';
import 'package:flutter_color_palette/widgets/color_palette_selectables.dart';

class FlutterColorPalette extends StatefulWidget {
  final ImageProvider<Object> imageProvider;
  final Function(String) onHexSelected;
  final Function(int) onRedSelected;
  final Function(int) onGreenSelected;
  final Function(int) onBlueSelected;
  final double width;
  const FlutterColorPalette({
    super.key,
    required this.imageProvider,
    required this.onHexSelected,
    required this.onRedSelected,
    required this.onGreenSelected,
    required this.onBlueSelected,
    this.width = 300,
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
      _imageBytesNotifier.value = imageBytes;
      
      final colors = await getMostFrequentColors(widget.imageProvider, imageBytes);
      _colorModelsNotifier.value = colors;
      _isLoadingNotifier.value = false;
    } catch (e) {
      _isLoadingNotifier.value = false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        children: [
          ValueListenableBuilder<Uint8List?>(
            valueListenable: _imageBytesNotifier,
            builder: (context, imageBytes, child) {
              return FlexibleImageWidget(
                width: widget.width,
                imageProvider: widget.imageProvider,
                imageBytes: imageBytes,
                onColorDetected: (color) {
                  _colorDetectedNotifier.value = color;
                },
              );
            },
          ),
          Container(height: 20),
          ColorPaletteSelectables(
            colorDetectedNotifier: _colorDetectedNotifier,
            onHexSelected: widget.onHexSelected,
            onRedSelected: widget.onRedSelected,
            onGreenSelected: widget.onGreenSelected,
            onBlueSelected: widget.onBlueSelected,
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
          ColorItemList(
            colorModelsNotifier: _colorModelsNotifier,
            isLoadingNotifier: _isLoadingNotifier,
            onHexSelected: widget.onHexSelected,
          ),
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
