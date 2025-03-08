import 'package:domotica_mimmo/styles.dart';
import 'package:flutter/material.dart';

class PinNumber extends StatelessWidget {
  final TextEditingController textEditingController;
  const PinNumber({
    key,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: transparent,
      width: 50.0,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            filled: true,
            fillColor: highlightColor),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 21.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
