import 'package:flutter/material.dart';

enum PTextType { h1, h2, h3, h4, h5, h6 }

final Map<PTextType, double> palladioTextSizes = {
  PTextType.h1: 20,
  PTextType.h2: 18,
  PTextType.h3: 16,
  PTextType.h4: 14,
  PTextType.h5: 12,
  PTextType.h6: 10,
};

class PalladioText extends StatelessWidget {
  const PalladioText(this.text,
      {required this.type,
      this.bold = false,
      this.italic = false,
      this.maxLines = 5,
      this.textAlign = TextAlign.left,
      this.textColor,
      this.overflow = TextOverflow.ellipsis,
      key});

  final String text;
  final PTextType type;
  final bool bold;
  final bool italic;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? textColor;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      softWrap: true,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
          fontSize: palladioTextSizes[type],
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: textColor),
    );
  }
}
