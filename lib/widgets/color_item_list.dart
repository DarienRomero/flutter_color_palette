import 'package:flutter/material.dart';
import 'package:flutter_color_palette/models/color_model.dart';
import 'package:flutter_color_palette/widgets/color_item.dart';
import 'package:flutter_color_palette/widgets/scroll_indicator_widget.dart';

/// A widget that displays a horizontal scrollable list of color items.
/// 
/// This component shows either a loading skeleton or a scrollable list of colors
/// based on the loading state. It uses ValueNotifier for reactive state management
/// and provides smooth horizontal scrolling with navigation indicators.
/// 
/// Example usage:
/// ```dart
/// ColorItemList(
///   colorModelsNotifier: colorModelsNotifier,
///   isLoadingNotifier: isLoadingNotifier,
///   onHexSelected: (hex) => print('Selected: $hex'),
/// )
/// ```
class ColorItemList extends StatelessWidget {
  /// Notifier containing the list of color models to display
  final ValueNotifier<List<ColorModel>> colorModelsNotifier;
  
  /// Notifier indicating whether the component is in loading state
  final ValueNotifier<bool> isLoadingNotifier;
  
  /// Callback function triggered when a hex color is selected
  final Function(String) onHexSelected;

  /// Creates a ColorItemList widget.
  /// 
  /// [colorModelsNotifier] must not be null and should contain the list of colors.
  /// [isLoadingNotifier] must not be null and controls the loading state.
  /// [onHexSelected] must not be null and handles hex color selection events.
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
                  itemCount: 10, // Show 10 skeleton items
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
              height: 120,
              child: ScrollIndicatorWidget(
                height: 120,
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