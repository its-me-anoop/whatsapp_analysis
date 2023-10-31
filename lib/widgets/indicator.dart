import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  /// A widget for displaying an indicator with a color and text.
  ///
  /// The [color] parameter specifies the color of the indicator.
  ///
  /// The [text] parameter provides the text to be displayed next to the indicator.
  ///
  /// The [isSquare] parameter determines the shape of the indicator. If true,
  /// it will be a square; otherwise, it will be a circle.
  ///
  /// The [size] parameter defines the size of the indicator. The default size is 16.
  ///
  /// The [textColor] parameter sets the color of the text. If not provided, it
  /// uses the default text color.
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });

  // Color of the indicator.
  final Color color;

  // Text to be displayed next to the indicator.
  final String text;

  // Determines if the indicator shape is square or circle.
  final bool isSquare;

  // Size of the indicator (default is 16).
  final double size;

  // Color of the text (default is the default text color).
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
