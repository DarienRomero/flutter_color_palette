library flutter_color_palette;

import 'package:flutter/material.dart';
import 'package:flutter_color_palette/widgets/data_indicator.dart';

class FlutterColorPalette extends StatefulWidget {
  const FlutterColorPalette({super.key});

  @override
  State<FlutterColorPalette> createState() => _FlutterColorPaletteState();
}

class _FlutterColorPaletteState extends State<FlutterColorPalette> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20
      ),
      child: Column(
        children: [
          Container(
            height: 300,
            color: Colors.red,
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
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green
                    ),
                  ),
                  Container(width: 20),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const DataIndicator(title: "HEX", value: "#DED5E6"),
                        Row(
                          children: [
                            const DataIndicator(title: "R", value: "222"),
                            Container(width: 10),
                            const DataIndicator(title: "G", value: "213"),
                            Container(width: 10),
                            const DataIndicator(title: "B", value: "230"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(width: 30),
                ],
              ),
              Container(height: 30),
              Text("Color Palette", style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.7)
              )),
              Container(height: 10),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle
                          ),
                        ),
                        Container(height: 5),
                        Text("#DED5E6", style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.7)
                        )),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(width: 10);
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
