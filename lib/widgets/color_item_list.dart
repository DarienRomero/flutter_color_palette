import 'package:flutter/material.dart';
import 'package:flutter_color_palette/models/color_model.dart';
import 'package:flutter_color_palette/widgets/color_item.dart';
import 'package:flutter_color_palette/widgets/scroll_indicator_widget.dart';

class ColorItemList extends StatelessWidget {
  final ValueNotifier<List<ColorModel>> colorModelsNotifier;
  final ValueNotifier<bool> isLoadingNotifier;
  final Function(String) onHexSelected;

  const ColorItemList({
    super.key,
    required this.colorModelsNotifier,
    required this.isLoadingNotifier,
    required this.onHexSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ColorModel>>(
      valueListenable: colorModelsNotifier,
      builder: (context, colorModels, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: isLoadingNotifier,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10, // Mostrar 10 skeletons
                  itemBuilder: (context, index) {
                    return const ColorItem(isLoading: true);
                  },
                  separatorBuilder: (context, index) {
                    return Container(width: 10);
                  },
                ),
              );
            }
            
            return SizedBox(
              height: 90,
              child: ScrollIndicatorWidget(
                height: 90,
                colorModels: colorModels,
                onHexSelected: onHexSelected,
              ),
            );
          },
        );
      },
    );
  }
} 