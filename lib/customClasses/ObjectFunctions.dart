import 'dart:async';

import 'package:domotica_mimmo/customClasses/NetworkHelper.dart';
import 'package:domotica_mimmo/models/OggettiData.dart';
import 'package:domotica_mimmo/models/SpaziData.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ObjectFunction {
  final NetworkHelper networkHelper = NetworkHelper();

  Timer? timer;
  final int timerDuration = 3;

  void initialize(BuildContext context) async {
    var oggettiDataProvider = Provider.of<OggettiData>(context, listen: false);
    var spaziDataProvider = Provider.of<SpaziData>(context, listen: false);
    await networkHelper.updateObjectColors(
        oggettiDataProvider.listOggetti,
        spaziDataProvider.spazioSelected.ipUtilizzato ?? 0,
        context);
  }

  void updateObjectColor(BuildContext context) async {
    var oggettiDataProvider = Provider.of<OggettiData>(context, listen: false);
    var spaziDataProvider = Provider.of<SpaziData>(context, listen: false);
    //print(context.read<OggettiData>().listOggetti);
    await networkHelper.updateObjectColors(
        oggettiDataProvider.listOggetti,
        spaziDataProvider.spazioSelected.ipUtilizzato ?? 0,
        context);
  }
}
