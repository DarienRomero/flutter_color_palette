import 'package:flutter/material.dart';
import 'package:flutter_color_palette/flutter_color_palette.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Center(
          child: FlutterColorPalette(
            width: 350,
            imageProvider: const AssetImage("assets/big-image.jpg"),
            onHexSelected: (hex) {
              print("Hex selected: $hex");
            },
            onRedSelected: (red) {
              print("Red selected: $red");
            },
            onGreenSelected: (green) {
              print("Green selected: $green");
            },
            onBlueSelected: (blue) {
              print("Blue selected: $blue");
            },
          )
        ),
      ),
    );
  }
}