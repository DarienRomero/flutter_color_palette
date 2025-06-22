import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_color_palette/models/color_model.dart';
import 'package:flutter_color_palette/utils/color_frequency.dart';
import 'dart:async';
import 'package:image/image.dart' as img;

class FlexibleImageWidget extends StatefulWidget {
  final ImageProvider imageProvider;
  final Uint8List? imageBytes;
  final double width;
  final Function(ColorModel color)? onColorDetected;

  const FlexibleImageWidget({
    super.key,
    required this.imageProvider,
    required this.imageBytes,
    this.width = 100,
    this.onColorDetected,
  });

  @override
  State<FlexibleImageWidget> createState() => _FlexibleImageWidgetState();
}

class _FlexibleImageWidgetState extends State<FlexibleImageWidget> {
  final ValueNotifier<ColorModel?> _detectedColorNotifier = ValueNotifier<ColorModel?>(null);
  final ValueNotifier<Offset?> _touchPositionNotifier = ValueNotifier<Offset?>(null);
  final ValueNotifier<img.Image?> _imageDataNotifier = ValueNotifier<img.Image?>(null);
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<double?> _dynamicHeightNotifier = ValueNotifier<double?>(null);

  @override
  void didUpdateWidget(FlexibleImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageBytes != widget.imageBytes && widget.imageBytes != null) {
      _loadImageData();
    }
  }

  Future<void> _loadImageData() async {
    try {
      final image = await compute(decodeImage, widget.imageBytes!);
      if (image != null) {
        _imageDataNotifier.value = image;
        // Calcular la altura dinámica basada en las proporciones de la imagen
        _dynamicHeightNotifier.value = (widget.width * image.height) / image.width;
        _isLoadingNotifier.value = false;
      }
    } catch (e) {
      _isLoadingNotifier.value = false;
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final imageData = _imageDataNotifier.value;
    final isLoading = _isLoadingNotifier.value;
    final dynamicHeight = _dynamicHeightNotifier.value;
    
    if (imageData == null || isLoading || dynamicHeight == null) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    
    // Verificar que el toque esté dentro del widget
    if (localPosition.dx >= 0 && 
        localPosition.dx <= widget.width && 
        localPosition.dy >= 0 && 
        localPosition.dy <= dynamicHeight) {
      
      // Obtener el color real del pixel en la posición
      final color = _getColorAtPosition(localPosition, imageData, dynamicHeight);

      final colorModel = ColorModel(
        color: color, 
        hex: '#${color.value.toRadixString(16).substring(2).toUpperCase()}', 
        red: color.red, 
        green: color.green, 
        blue: color.blue);
      
      _detectedColorNotifier.value = colorModel;
      _touchPositionNotifier.value = localPosition;
      
      widget.onColorDetected?.call(colorModel);
    }
  }

  Color _getColorAtPosition(Offset position, img.Image imageData, double dynamicHeight) {
    // Calcular la posición relativa en la imagen original
    final normalizedX = position.dx / widget.width;
    final normalizedY = position.dy / dynamicHeight;
    
    // Mapear a coordenadas de la imagen
    final imageX = (normalizedX * imageData.width).round();
    final imageY = (normalizedY * imageData.height).round();
    
    // Asegurar que las coordenadas estén dentro de los límites
    final clampedX = imageX.clamp(0, imageData.width - 1);
    final clampedY = imageY.clamp(0, imageData.height - 1);
    
    // Obtener el pixel de la imagen
    final pixel = imageData.getPixel(clampedX, clampedY);
    
    // Convertir a Color de Flutter
    return Color.fromARGB(
      pixel.a.toInt(),
      pixel.r.toInt(),
      pixel.g.toInt(),
      pixel.b.toInt(),
    );
  }

  void _handlePanEnd(DragEndDetails details) {
    _detectedColorNotifier.value = null;
    _touchPositionNotifier.value = null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: _isLoadingNotifier,
          builder: (context, isLoading, child) {
            return GestureDetector(
              onPanUpdate: isLoading ? null : _handlePanUpdate,
              onPanEnd: isLoading ? null : _handlePanEnd,
              child: Image(
                image: widget.imageProvider,
                width: widget.width,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
        ValueListenableBuilder<ColorModel?>(
          valueListenable: _detectedColorNotifier,
          builder: (context, detectedColor, child) {
            return ValueListenableBuilder<Offset?>(
              valueListenable: _touchPositionNotifier,
              builder: (context, touchPosition, child) {
                if (detectedColor != null && touchPosition != null) {
                  return Positioned(
                    left: touchPosition.dx - 15, // Centrar el círculo (radio = 15)
                    top: touchPosition.dy - 15,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: detectedColor.color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _detectedColorNotifier.dispose();
    _touchPositionNotifier.dispose();
    _imageDataNotifier.dispose();
    _isLoadingNotifier.dispose();
    _dynamicHeightNotifier.dispose();
    super.dispose();
  }
}