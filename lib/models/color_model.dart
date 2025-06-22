import 'dart:ui';

/// A data model representing a color with multiple format representations.
/// 
/// This model encapsulates a color value and provides access to it in different
/// formats including Flutter Color object, hexadecimal string, and individual
/// RGB components. It's used throughout the color palette system for consistent
/// color representation and manipulation.
/// 
/// ## Color Formats
/// 
/// * **Flutter Color**: Native Flutter Color object for UI rendering
/// * **Hexadecimal**: String representation in "#FFFFFF" format
/// * **RGB Components**: Individual red, green, and blue values (0-255)
/// 
/// Example usage:
/// ```dart
/// ColorModel(
///   color: Colors.red,
///   hex: "#FF0000",
///   red: 255,
///   green: 0,
///   blue: 0,
/// )
/// ```
class ColorModel {
  /// The Flutter Color object for UI rendering and manipulation
  final Color color;
  
  /// Hexadecimal color representation in "#FFFFFF" format
  /// 
  /// This string always starts with "#" followed by 6 hexadecimal characters
  /// representing the RGB values in uppercase format.
  final String hex;
  
  /// Red component of the color
  /// 
  /// Value ranges from 0 to 255, where 0 is no red and 255 is maximum red.
  final int red;
  
  /// Green component of the color
  /// 
  /// Value ranges from 0 to 255, where 0 is no green and 255 is maximum green.
  final int green;
  
  /// Blue component of the color
  /// 
  /// Value ranges from 0 to 255, where 0 is no blue and 255 is maximum blue.
  final int blue;

  /// Creates a ColorModel with all color representations.
  /// 
  /// All parameters are required to ensure complete color information is available.
  /// 
  /// [color] - The Flutter Color object for UI operations
  /// [hex] - Hexadecimal string in "#FFFFFF" format
  /// [red] - Red component value (0-255)
  /// [green] - Green component value (0-255)
  /// [blue] - Blue component value (0-255)
  ColorModel({
    required this.color,
    required this.hex,
    required this.red,
    required this.green,
    required this.blue,
  });
}