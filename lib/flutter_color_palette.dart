library flutter_color_palette;

import 'package:flutter/material.dart';

class FlutterColorPalette extends StatefulWidget {
  const FlutterColorPalette({super.key});

  @override
  State<FlutterColorPalette> createState() => _FlutterColorPaletteState();
}

class _FlutterColorPaletteState extends State<FlutterColorPalette> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 300,
          color: Colors.red,
        ),
        Container(height: 20),
        Column(
          children: [
            const Text("Color Picker"),
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green
                  ),
                ),
                Column(
                  children: [
                    Text("HEX"),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Text("#DED5E6"),
                    ),
                  ],
                ),
                Container(
                  width: 20,
                ),
                Column(
                  children: [
                    Text("R"),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Text("222"),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("G"),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Text("213"),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("B"),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Text("230"),
                    ),
                  ],
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
