import 'package:domotica_mimmo/components/palladio_std_components/palladio_text.dart';
import 'package:flutter/material.dart';

enum ButtonSize { small, medium, big }

class PalladioIconButton extends StatelessWidget {
  PalladioIconButton(
      {key,
      required this.title,
      required this.icon,
      required this.onPressed,
      this.backgroundColor,
      this.size = ButtonSize.small});

  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final ButtonSize size;

  final Map<ButtonSize, double> sizes = {
    ButtonSize.small: 0,
    ButtonSize.medium: 5,
    ButtonSize.big: 8,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: const StadiumBorder(),
            ),
            onPressed: onPressed,
            icon: Icon(icon),
            label: Padding(
              padding: EdgeInsets.all(sizes[size]!),
              child: PalladioText(
                title,
                type: PTextType.h3,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
