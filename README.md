# FlutterColorPalette

A comprehensive Flutter widget that provides interactive color detection and palette generation from images.

![](https://github.com/DarienRomero/flutter_color_palette/blob/master/.github/art/flutter_color_palette.gif?raw=true)

**Show some ❤️ and star the repo to support the project**

### Resources:
- [Pub Package](https://pub.dev/packages/flutter_color_palette)
- [GitHub Repository](https://github.com/DarienRomero/flutter_color_palette)

## Features

- **Interactive Color Detection**: Touch and drag over images to detect colors at specific pixel positions
- **Automatic Palette Generation**: Extracts the most frequent colors from images automatically
- **Real-time Color Feedback**: Visual indicators show detected colors with hex and RGB values
- **Responsive Design**: Adapts to different screen sizes and orientations
- **Performance Optimized**: Background image processing using isolates for smooth UX
- **Color Quantization**: Intelligent color grouping for better frequency analysis

## Installation

Add this line to your `pubspec.yaml` file in the `dependencies` section:

```yaml
dependencies:
  flutter_color_palette: ^1.0.0
```

## Usage

`FlutterColorPalette` provides an interactive color detection and palette generation system that allows users to extract colors from images and view them in an organized palette format.

```dart
import 'package:flutter_color_palette/flutter_color_palette.dart';

FlutterColorPalette(
  imageProvider: AssetImage('assets/image.jpg'),
  onHexSelected: (hex) {
    print('Selected hex color: $hex');
  },
  onRedSelected: (red) {
    print('Selected red component: $red');
  },
  onGreenSelected: (green) {
    print('Selected green component: $green');
  },
  onBlueSelected: (blue) {
    print('Selected blue component: $blue');
  },
  width: 400,
)
```

**Note:** `FlutterColorPalette` widget requires a minimum width of 250 pixels. This ensures that the widget has enough space to display the image and color palette properly. If you provide a width less than 250 pixels, an assertion error will be thrown.

### Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_color_palette/flutter_color_palette.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Color Palette Demo')),
        body: Center(
          child: FlutterColorPalette(
            imageProvider: NetworkImage('https://example.com/image.jpg'),
            onHexSelected: (hex) => Clipboard.setData(ClipboardData(text: hex)),
            onRedSelected: (red) => print('Red: $red'),
            onGreenSelected: (green) => print('Green: $green'),
            onBlueSelected: (blue) => print('Blue: $blue'),
            width: 350,
          ),
        ),
      ),
    );
  }
}
```

### Interactive Color Detection

The widget allows users to touch and drag over the displayed image to detect colors at specific pixel positions. The detected color is displayed in real-time with its hex and RGB values.

### Automatic Palette Generation

The widget automatically analyzes the image and extracts the most frequent colors, displaying them in a organized palette format below the image.

### Callback Functions

The widget provides separate callback functions for different color components:

- `onHexSelected`: Triggered when a hex color is selected (format: "#FFFFFF")
- `onRedSelected`: Triggered when red component is selected (0-255)
- `onGreenSelected`: Triggered when green component is selected (0-255)
- `onBlueSelected`: Triggered when blue component is selected (0-255)

## Parameters

| Parameter | Description |
|---|---|
| `key` | Controls how one widget replaces another widget in the tree. |
| `imageProvider`* | The image source to analyze and display. |
| `onHexSelected`* | Callback when a hex color is selected (format: "#FFFFFF"). |
| `onRedSelected`* | Callback when red component is selected (0-255). |
| `onGreenSelected`* | Callback when green component is selected (0-255). |
| `onBlueSelected`* | Callback when blue component is selected (0-255). |
| `width` | Width of the widget (minimum 250px, default: 300). |

Parameters marked with \* are required

## Performance Considerations

- Image processing is performed in background threads using isolates
- Color detection uses optimized pixel sampling
- Widget rebuilds are minimized through ValueNotifier usage
- Memory is properly managed with automatic disposal
- Images are automatically resized to 100px width for performance during color analysis

## UI Considerations

- **Image Aspect Ratio**: Images with a height significantly larger than the width may occupy most of the screen space, making the color picker controls difficult to access. Consider using images with balanced aspect ratios or implementing proper image scaling.

## Dependencies

This widget requires the following dependencies:
- `flutter/material.dart`
- `image` package (^4.5.4) for image processing
- `dart:typed_data` for byte manipulation

## MIT License
```
Copyright (c) 2024 Darien Romero

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
