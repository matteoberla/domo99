import 'package:domotica_mimmo/styles.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';

class PalladioLoading extends StatelessWidget {
  const PalladioLoading({
    required this.absorbing,
    this.backgroundColor = opaqueColor,
    this.loaderColor = mainColor,
    key,
  });

  final bool absorbing;
  final Color backgroundColor;
  final Color loaderColor;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: absorbing,
      child: Container(
        color: backgroundColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GFLoader(
              androidLoaderColor: AlwaysStoppedAnimation<Color>(loaderColor),
              size: 70,
              loaderstrokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }
}
