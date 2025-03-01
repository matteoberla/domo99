import 'package:flutter/material.dart';

class LinkRaisedButton extends StatelessWidget {
  LinkRaisedButton({required this.testo, required this.isDark, required this.onTap});

  final VoidCallback onTap;
  final bool isDark;
  final String testo;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      onPressed: onTap,
      child: Text(
        testo,
        style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18),
      ),
    );
  }
}
