import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_color_palette/models/color_model.dart';
import 'package:flutter_color_palette/utils/color_frequency.dart';
import 'dart:async';
import 'package:image/image.dart' as img;

/// A widget that displays an image with interactive color detection capabilities.
/// 
/// This component allows users to touch and drag over an image to detect colors
/// at specific pixel positions. It provides real-time color feedback with a visual
/// indicator and supports dynamic height calculation based on image aspect ratio.
/// 
/// Key features:
/// - Real-time color detection on touch/drag
/// - Visual color indicator with border and shadow
/// - Dynamic height calculation maintaining aspect ratio
/// - Background image processing for performance
/// - Reactive state management with ValueNotifier
/// 
/// Example usage:
/// ```dart
/// FlexibleImageWidget(
///   imageProvider: AssetImage('assets/image.jpg'),
///   imageBytes: imageBytes,
///   width: 300,
///   onColorDetected: (colorModel) => print('Detected: ${colorModel.hex}'),
/// )
/// ```
class FlexibleImageWidget extends StatefulWidget {
  /// The image provider for displaying the image
  final ImageProvider imageProvider;
  
  /// Raw image bytes for color detection processing
  final Uint8List? imageBytes;
  
  /// The width of the image widget
  final double width;
  
  /// Callback function triggered when a color is detected
  final Function(ColorModel color)? onColorDetected;

  /// Creates a FlexibleImageWidget.
  /// 
  /// [imageProvider] must not be null and provides the image for display.
  /// [imageBytes] can be null but is required for color detection functionality.
  /// [width] defaults to 100 and determines the widget width.
  /// [onColorDetected] is optional and handles color detection events.
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
  /// Notifier for the currently detected color
  final ValueNotifier<ColorModel?> _detectedColorNotifier = ValueNotifier<ColorModel?>(null);
  
  /// Notifier for the current touch position
  final ValueNotifier<Offset?> _touchPositionNotifier = ValueNotifier<Offset?>(null);
  
  /// Notifier for the processed image data
  final ValueNotifier<img.Image?> _imageDataNotifier = ValueNotifier<img.Image?>(null);
  
  /// Notifier for the loading state
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(true);
  
  /// Notifier for the calculated dynamic height
  final ValueNotifier<double?> _dynamicHeightNotifier = ValueNotifier<double?>(null);

  @override
  void didUpdateWidget(FlexibleImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload image data when image bytes change
    if (oldWidget.imageBytes != widget.imageBytes && widget.imageBytes != null) {
      _loadImageData();
    }
  }

  /// Loads and processes image data in the background for color detection
  Future<void> _loadImageData() async {
    try {
      final image = await compute(decodeImage, widget.imageBytes!);
      if (image != null) {
        _imageDataNotifier.value = image;
        // Calculate dynamic height based on image proportions
        _dynamicHeightNotifier.value = (widget.width * image.height) / image.width;
        _isLoadingNotifier.value = false;
      }
    } catch (e) {
      _isLoadingNotifier.value = false;
    }
  }

  /// Handles pan update events for real-time color detection
  void _handlePanUpdate(DragUpdateDetails details) {
    final imageData = _imageDataNotifier.value;
    final isLoading = _isLoadingNotifier.value;
    final dynamicHeight = _dynamicHeightNotifier.value;
    
    if (imageData == null || isLoading || dynamicHeight == null) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    
    // Verify that the touch is within the widget bounds
    if (localPosition.dx >= 0 && 
        localPosition.dx <= widget.width && 
        localPosition.dy >= 0 && 
        localPosition.dy <= dynamicHeight) {
      
      // Get the actual pixel color at the position
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

  /// Extracts the color at a specific position in the image
  /// 
  /// This method converts touch coordinates to image pixel coordinates
  /// and retrieves the actual color value from the image data.
  Color _getColorAtPosition(Offset position, img.Image imageData, double dynamicHeight) {
    // Calculate relative position in the original image
    final normalizedX = position.dx / widget.width;
    final normalizedY = position.dy / dynamicHeight;
    
    // Map to image coordinates
    final imageX = (normalizedX * imageData.width).round();
    final imageY = (normalizedY * imageData.height).round();
    
    // Ensure coordinates are within bounds
    final clampedX = imageX.clamp(0, imageData.width - 1);
    final clampedY = imageY.clamp(0, imageData.height - 1);
    
    // Get the pixel from the image
    final pixel = imageData.getPixel(clampedX, clampedY);
    
    // Convert to Flutter Color
    return Color.fromARGB(
      pixel.a.toInt(),
      pixel.r.toInt(),
      pixel.g.toInt(),
      pixel.b.toInt(),
    );
  }

  /// Handles pan end events to clear the color indicator
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
                    left: touchPosition.dx - 15, // Center the circle (radius = 15)
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