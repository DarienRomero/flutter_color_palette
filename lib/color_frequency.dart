import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

quantize(int r, int g, int b, {int levels = 8}) {
  int factor = 256 ~/ levels;
  r = (r ~/ factor) * factor;
  g = (g ~/ factor) * factor;
  b = (b ~/ factor) * factor;
  return (r << 16) | (g << 8) | b;
}

Color quantizeToColor(int r, int g, int b, {int levels = 8}) {
  final quantizedValue = quantize(r, g, b, levels: levels);
  return Color(0xFF000000 | quantizedValue); // Agregamos alpha = 255 (0xFF)
}

/// Esta función se ejecuta en un isolate separado.
Map<int, int> computeColorFrequency(Uint8List imageBytes) {
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
      final qColor = quantize(r, g, b);
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