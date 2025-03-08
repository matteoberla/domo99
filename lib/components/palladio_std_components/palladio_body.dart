import 'package:domotica_mimmo/components/palladio_std_components/palladio_loading.dart';
import 'package:domotica_mimmo/models/http_provider/http_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PalladioBody extends StatelessWidget {
  const PalladioBody({
    key,
    required this.child,
    this.showBottomBar = true,
  });

  final Widget child;
  final bool? showBottomBar;

  @override
  Widget build(BuildContext context) {
    var httpProvider = Provider.of<HttpProvider>(context, listen: true);

    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(child: child),
            ],
          ),
          if (httpProvider.isLoading)
            PalladioLoading(absorbing: httpProvider.isLoading),
        ],
      ),
    );
  }
}
