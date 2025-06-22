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

  List<ColorModel> colorModels = [];
  ColorModel? _colorDetected;  
  Uint8List? imageBytes;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      readImageData(widget.imageProvider).then((value) {
        print("Get image bytes ${value.length}");
        setState(() {
          imageBytes = value;
        });
        getMostFrequentColors(widget.imageProvider, imageBytes!).then((value) {
          print("Get colores ${value.length}");
          setState(() {
            colorModels = value;
          });
        });
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20
      ),
      child: Column(
        children: [
          FlexibleImageWidget(
            width: 300,
            imageProvider: widget.imageProvider,
            imageBytes: imageBytes,
            onColorDetected: (color) {
              setState(() {
                _colorDetected = color;
              });
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _colorDetected?.color ?? Colors.green
                    ),
                  ),
                  Container(width: 20),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DataIndicator(title: "HEX", value: _colorDetected?.hex ?? "     "),
                        Row(
                          children: [
                            DataIndicator(title: "R", value: (_colorDetected?.red.toString() ?? "0").padLeft(3, '0')),
                            Container(width: 10),
                            DataIndicator(title: "G", value: (_colorDetected?.green.toString() ?? "0").padLeft(3, '0')),
                            Container(width: 10),
                            DataIndicator(title: "B", value: (_colorDetected?.blue.toString() ?? "0").padLeft(3, '0')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(width: 30),
                ],
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
              SizedBox(
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
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator()
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
