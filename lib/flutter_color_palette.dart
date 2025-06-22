library flutter_color_palette;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_color_palette/models/color_model.dart';
import 'package:flutter_color_palette/utils/color_frequency.dart';
import 'package:flutter_color_palette/widgets/flexible_image_widget.dart';
import 'package:flutter_color_palette/widgets/color_item_list.dart';
import 'package:flutter_color_palette/widgets/color_palette_selectables.dart';

/// A comprehensive color palette widget for Flutter applications.
/// 
/// This widget provides an interactive color detection and palette generation
/// system that allows users to extract colors from images and view them in
/// an organized palette format. It combines image analysis with real-time
/// color detection capabilities.
/// 
/// ## Features
/// 
/// * **Interactive Color Detection**: Touch and drag over images to detect
///   colors at specific pixel positions
/// * **Automatic Palette Generation**: Extracts the most frequent colors
///   from images automatically
/// * **Real-time Color Feedback**: Visual indicators show detected colors
///   with hex and RGB values
/// * **Responsive Design**: Adapts to different screen sizes and orientations
/// * **Performance Optimized**: Background image processing for smooth UX
/// 
/// ## Usage
/// 
/// ```dart
/// import 'package:flutter_color_palette/flutter_color_palette.dart';
/// 
/// FlutterColorPalette(
///   imageProvider: AssetImage('assets/image.jpg'),
///   onHexSelected: (hex) {
///     print('Selected hex color: $hex');
///   },
///   onRedSelected: (red) {
///     print('Selected red component: $red');
///   },
///   onGreenSelected: (green) {
///     print('Selected green component: $green');
///   },
///   onBlueSelected: (blue) {
///     print('Selected blue component: $blue');
///   },
///   width: 400,
/// )
/// ```
/// 
/// ## Parameters
/// 
/// * [imageProvider] - The image source to analyze and display
/// * [onHexSelected] - Callback when a hex color is selected (format: "#FFFFFF")
/// * [onRedSelected] - Callback when red component is selected (0-255)
/// * [onGreenSelected] - Callback when green component is selected (0-255)
/// * [onBlueSelected] - Callback when blue component is selected (0-255)
/// * [width] - Width of the widget (minimum 250px)
/// 
/// ## Example
/// 
/// ```dart
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: Scaffold(
///         appBar: AppBar(title: Text('Color Palette Demo')),
///         body: Center(
///           child: FlutterColorPalette(
///             imageProvider: NetworkImage('https://example.com/image.jpg'),
///             onHexSelected: (hex) => Clipboard.setData(ClipboardData(text: hex)),
///             onRedSelected: (red) => print('Red: $red'),
///             onGreenSelected: (green) => print('Green: $green'),
///             onBlueSelected: (blue) => print('Blue: $blue'),
///             width: 350,
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
/// 
/// ## Performance Considerations
/// 
/// * Image processing is performed in background threads
/// * Color detection uses optimized pixel sampling
/// * Widget rebuilds are minimized through ValueNotifier usage
/// * Memory is properly managed with automatic disposal
/// 
/// ## Dependencies
/// 
/// This widget requires the following dependencies:
/// * `flutter/material.dart`
/// * `image` package for image processing
/// * `dart:typed_data` for byte manipulation
class FlutterColorPalette extends StatefulWidget {
  /// The image provider for the image to analyze and display
  final ImageProvider<Object> imageProvider;
  
  /// Callback function triggered when a hex color is selected
  /// Returns a string in "#FFFFFF" format
  final Function(String) onHexSelected;
  
  /// Callback function triggered when red component is selected
  /// Returns an integer value between 0-255
  final Function(int) onRedSelected;
  
  /// Callback function triggered when green component is selected
  /// Returns an integer value between 0-255
  final Function(int) onGreenSelected;
  
  /// Callback function triggered when blue component is selected
  /// Returns an integer value between 0-255
  final Function(int) onBlueSelected;
  
  /// Width of the widget container
  /// Must be at least 250px for proper functionality
  final double width;

  /// Creates a FlutterColorPalette widget.
  /// 
  /// All callback parameters are required and handle different color selection events.
  /// The [width] parameter must be at least 250px to ensure proper layout and functionality.
  /// 
  /// Throws an [AssertionError] if width is less than 250px.
  const FlutterColorPalette({
    super.key,
    required this.imageProvider,
    required this.onHexSelected,
    required this.onRedSelected,
    required this.onGreenSelected,
    required this.onBlueSelected,
    this.width = 300,
  }) : assert(width >= 250, 'Width must be at least 250px for proper functionality');

  @override
  State<FlutterColorPalette> createState() => _FlutterColorPaletteState();
}

class _FlutterColorPaletteState extends State<FlutterColorPalette> {
  /// Notifier for the list of most frequent colors from the image
  final ValueNotifier<List<ColorModel>> _colorModelsNotifier = ValueNotifier<List<ColorModel>>([]);
  
  /// Notifier for the currently detected color from user interaction
  final ValueNotifier<ColorModel?> _colorDetectedNotifier = ValueNotifier<ColorModel?>(null);
  
  /// Notifier for the processed image bytes
  final ValueNotifier<Uint8List?> _imageBytesNotifier = ValueNotifier<Uint8List?>(null);
  
  /// Notifier for the loading state of the widget
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    // Load image data after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_){
      _loadImageData();
    });
  }

  /// Loads and processes image data for color analysis
  /// 
  /// This method reads the image bytes and extracts the most frequent colors
  /// from the image, updating the UI state accordingly.
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
            width: widget.width,
          ),
          Container(height: 30),
          Row(
            children: [
              Text(
                "Color Palette", 
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7)
                )
              ),
            ],
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
