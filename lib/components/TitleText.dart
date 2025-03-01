import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  TitleText({required this.testo, required this.isDark});
  final String testo;
  final bool isDark;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Text(
        testo,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
