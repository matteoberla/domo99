import 'package:flutter/material.dart';

class TextFieldBottomSheet extends StatelessWidget {
  TextFieldBottomSheet(
      {required this.hintText, required this.onChanged, this.initialText});
  final String hintText;
  final String? initialText;
  final ValueChanged onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      initialValue: initialText,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      onChanged: onChanged,
    );
  }
}
