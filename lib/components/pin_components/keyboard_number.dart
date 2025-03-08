import 'package:domotica_mimmo/components/palladio_std_components/palladio_text.dart';
import 'package:domotica_mimmo/styles.dart';
import 'package:flutter/material.dart';

class KeyboardNumber extends StatelessWidget {
  final int n;
  final VoidCallback onPressed;

  const KeyboardNumber({key, required this.n, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(shape: BoxShape.circle, color: highlightColor),
      alignment: Alignment.center,
      child: MaterialButton(
        padding: EdgeInsets.all(8.0),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60.0),
        ),
        height: 90.0,
        child: PalladioText(
          "$n",
          type: PTextType.h3,
          bold: true,
        ),
      ),
    );
  }
}
