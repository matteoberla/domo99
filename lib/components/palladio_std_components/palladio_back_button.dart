import 'package:flutter/material.dart';

class PalladioBackButton extends StatelessWidget {
  const PalladioBackButton({key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(Icons.arrow_back),
    );
  }
}
