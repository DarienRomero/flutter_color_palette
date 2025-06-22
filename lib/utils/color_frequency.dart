import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import '../models/color_model.dart';

/// Quantizes RGB color values to reduce color space for frequency analysis.
/// 
/// This function reduces the precision of RGB values by dividing them into
/// discrete levels, which helps group similar colors together for better
/// frequency analysis.
/// 
/// [r] - Red component (0-255)
/// [g] - Green component (0-255) 
/// [b] - Blue component (0-255)
/// [levels] - Number of quantization levels (default: 8)
/// 
/// Returns a quantized color value as an integer.
int _quantize(int r, int g, int b, {int levels = 8}) {
  int factor = 256 ~/ levels;
  r = (r ~/ factor) * factor;
  g = (g ~/ factor) * factor;
  b = (b ~/ factor) * factor;
  return (r << 16) | (g << 8) | b;
}

/// Computes color frequency from image bytes in a separate isolate.
/// 
/// This function is designed to run in a background isolate using compute()
/// to avoid blocking the main UI thread. It processes the image by:
/// 1. Decoding the image from bytes
/// 2. Resizing to 100px width for performance
/// 3. Quantizing colors to reduce color space
/// 4. Counting frequency of each quantized color
/// 
/// [imageBytes] - Raw image data as Uint8List
/// 
/// Returns a map of quantized color values to their frequency counts.
Map<int, int> _computeColorFrequency(Uint8List imageBytes) {
  final original = decodeImage(imageBytes);
  if (original == null) return {};

  // Reduce resolution for performance
  final resized = img.copyResize(original, width: 100);

  final Map<int, int> colorMap = {};
  

  for (int y = 0; y < resized.height; y++) {
    for (int x = 0; x < resized.width; x++) {
      final pixel = resized.getPixel(x, y);
      final r = pixel.r.toInt();
      final g = pixel.g.toInt();
      final b = pixel.b.toInt();
      final qColor = _quantize(r, g, b);
      colorMap[qColor] = (colorMap[qColor] ?? 0) + 1;
    }
  }

  return colorMap;
}

/// Converts an ImageProvider to Uint8List in a separate isolate.
/// 
/// This function loads an image from an ImageProvider and converts it to
/// raw bytes for processing. It handles the asynchronous image loading
/// process and error cases.
/// 
/// [imageProvider] - The image provider to convert
/// 
/// Returns the image data as Uint8List.
/// 
/// Throws an Exception if the image cannot be converted to ByteData.
Future<Uint8List> readImage(ImageProvider imageProvider) async {
  try{
    final Completer<ui.Image> completer = Completer<ui.Image>();

    final ImageStream stream = imageProvider.resolve(const ImageConfiguration());
    final listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }, onError: (dynamic error, StackTrace? stackTrace) {
      completer.completeError(error, stackTrace);
    });

    stream.addListener(listener);
    ui.Image image;

    try {
      image = await completer.future;
    } finally {
      stream.removeListener(listener);
    }

    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception("Could not convert image to ByteData.");
    }

    return byteData.buffer.asUint8List();
  }catch(e){
   return Uint8List(0);
  }
}

/// Wrapper function for readImage to provide a cleaner API.
/// 
/// [imageProvider] - The image provider to convert
/// 
/// Returns the image data as Uint8List.
Future<Uint8List> readImageData(ImageProvider imageProvider) async {
  final data = await readImage(imageProvider);
  return data;
}

/// Extracts the most frequent colors from an image.
/// 
/// This function analyzes an image to find the most commonly occurring colors.
/// It uses color quantization to group similar colors and processes the image
/// in a background isolate for performance.
/// 
/// ## Process
/// 1. Converts image to raw bytes
/// 2. Processes image in background isolate
/// 3. Quantizes colors to reduce color space
/// 4. Counts frequency of each color
/// 5. Returns sorted list of most frequent colors
/// 
/// [imageProvider] - The image provider to analyze
/// [imageBytes] - Raw image data for processing
/// [maxColors] - Maximum number of colors to return (default: 10)
/// 
/// Returns a list of [ColorModel] objects sorted by frequency in descending order.
/// Returns an empty list if processing fails.
/// 
/// Example usage:
/// ```dart
/// final colors = await getMostFrequentColors(
///   AssetImage('assets/image.jpg'),
///   imageBytes,
///   maxColors: 15,
/// );
/// ```
Future<List<ColorModel>> getMostFrequentColors(
  ImageProvider imageProvider, Uint8List imageBytes, {
  int maxColors = 10,
}) async {
  try {
    
    // Calculate color frequency using compute in a separate isolate
    final colorFrequencyMap = await compute(_computeColorFrequency, imageBytes);
    
    // Convert frequency map to list of ColorModel
    final List<ColorModel> colorModels = [];
    
    for (final entry in colorFrequencyMap.entries) {
      final colorValue = entry.key;
      
      // Extract RGB components from quantized value
      final r = (colorValue >> 16) & 0xFF;
      final g = (colorValue >> 8) & 0xFF;
      final b = colorValue & 0xFF;
      
      // Create Color object
      final color = Color(0xFF000000 | colorValue);
      
      // Create ColorModel
      final colorModel = ColorModel(
        color: color,
        hex: '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
        red: r,
        green: g,
        blue: b,
      );
      
      colorModels.add(colorModel);
    }
    
    // Sort by frequency in descending order and limit to requested maximum
    colorModels.sort((a, b) {
      final freqA = colorFrequencyMap[((a.red << 16) | (a.green << 8) | a.blue)] ?? 0;
      final freqB = colorFrequencyMap[((b.red << 16) | (b.green << 8) | b.blue)] ?? 0;
      return freqB.compareTo(freqA);
    });
    
    return colorModels.take(maxColors).toList();
    
  } catch (e) {
    // Return empty list in case of error
    return [];
  }
}

/// Decodes an image from bytes in a separate isolate.
/// 
/// This function is designed to run in a background isolate using compute()
/// because decoding large images can be slow and would block the main UI thread.
/// 
/// [imageBytes] - Raw image data as Uint8List
/// 
/// Returns the decoded image or null if decoding fails.
img.Image? decodeImage(Uint8List imageBytes) {
  return img.decodeImage(imageBytes);
}
