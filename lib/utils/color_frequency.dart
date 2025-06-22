import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import '../models/color_model.dart';

_quantize(int r, int g, int b, {int levels = 8}) {
  int factor = 256 ~/ levels;
  r = (r ~/ factor) * factor;
  g = (g ~/ factor) * factor;
  b = (b ~/ factor) * factor;
  return (r << 16) | (g << 8) | b;
}

/// Esta función se ejecuta en un isolate separado.
Map<int, int> _computeColorFrequency(Uint8List imageBytes) {
  final original = img.decodeImage(imageBytes);
  if (original == null) return {};

  // Reducción de resolución para rendimiento
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

Future<Uint8List> readImage(ImageProvider imageProvider) async {
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
    throw Exception("No se pudo convertir la imagen a ByteData.");
  }

  return byteData.buffer.asUint8List();
}

/// Obtiene los colores más frecuentes de una imagen
/// 
/// [imageProvider] - El proveedor de imagen a analizar
/// [maxColors] - Número máximo de colores a retornar (por defecto 10)
/// 
/// Retorna una lista de [ColorModel] ordenados por frecuencia descendente
Future<List<ColorModel>> getMostFrequentColors(
  ImageProvider imageProvider, {
  int maxColors = 10,
}) async {
  try {
    // Convertir ImageProvider a Uint8List
    final imageBytes = await readImage(imageProvider);
    
    // Calcular frecuencia de colores directamente
    final colorFrequencyMap = _computeColorFrequency(imageBytes);
    
    // Convertir el mapa de frecuencia a lista de ColorModel
    final List<ColorModel> colorModels = [];
    
    for (final entry in colorFrequencyMap.entries) {
      final colorValue = entry.key;
      
      // Extraer componentes RGB del valor cuantizado
      final r = (colorValue >> 16) & 0xFF;
      final g = (colorValue >> 8) & 0xFF;
      final b = colorValue & 0xFF;
      
      // Crear Color object
      final color = Color(0xFF000000 | colorValue);
      
      // Crear ColorModel
      final colorModel = ColorModel(
        color: color,
        hex: '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
        red: r,
        green: g,
        blue: b,
      );
      
      colorModels.add(colorModel);
    }
    
    // Ordenar por frecuencia descendente y limitar al número máximo solicitado
    colorModels.sort((a, b) {
      final freqA = colorFrequencyMap[((a.red << 16) | (a.green << 8) | a.blue)] ?? 0;
      final freqB = colorFrequencyMap[((b.red << 16) | (b.green << 8) | b.blue)] ?? 0;
      return freqB.compareTo(freqA);
    });
    
    return colorModels.take(maxColors).toList();
    
  } catch (e) {
    // En caso de error, retornar lista vacía
    return [];
  }
}
