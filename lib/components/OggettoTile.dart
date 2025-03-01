import 'dart:async';

import 'package:domotica_mimmo/customClasses/NetworkHelper.dart';
import 'package:domotica_mimmo/customClasses/ObjectFunctions.dart';
import 'package:domotica_mimmo/customClasses/Oggetto.dart';
import 'package:domotica_mimmo/models/OggettiData.dart';
import 'package:domotica_mimmo/models/SpaziData.dart';
import 'package:domotica_mimmo/models/StanzeData.dart';
import 'package:domotica_mimmo/screens/modifyDeleteObjectScreen.dart';
import 'package:domotica_mimmo/sqLite/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'RowOggetto.dart';

class OggettoTile extends StatelessWidget {
  final Oggetto oggettiTile;
  final ObjectFunction objectFunction;
  OggettoTile(this.oggettiTile, this.objectFunction);

  final NetworkHelper networkHelper = NetworkHelper();
  final DBHelper dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    return RowOggetto(
      nomeOggetto: oggettiTile.nomeOggetto ?? "",
      immagine: 'assets/images/${oggettiTile.tipoOggetto}.png',
      colore: oggettiTile.colore,
      onTap: () async {
        var oggettiDataProvider = Provider.of<OggettiData>(context, listen: false);

        oggettiDataProvider.updateOggettoSelected(oggettiTile);
        oggettiDataProvider.updateIsLoading(true);

        //print(context.read<SpaziData>().spazioSelected.ipUtilizzato == 1);
        print(oggettiTile.ipInterno);
        print(oggettiTile.ipEsterno);
        print(oggettiTile.estensione);
        print(oggettiTile.risposta);

        Color returnedColor = await networkHelper.objectRequest(
            ip: context.read<SpaziData>().spazioSelected.ipUtilizzato == 1
                ? oggettiTile.ipInterno ?? ""
                : oggettiTile.ipEsterno ?? "",
            estensione: oggettiTile.estensione ?? "",
            risposta: oggettiTile.risposta ?? "");

        oggettiDataProvider
            .updateOggettoColor(oggettiTile, returnedColor);
        oggettiDataProvider.updateIsLoading(false);
      },
      onLongPress: () async {
        context.read<OggettiData>().updateOggettoToModify(oggettiTile);

        objectFunction.timer?.cancel();

        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => SingleChildScrollView(
            child: Container(
              child: ModifyDeleteObjectScreen(),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
            ),
          ),
        ).then((value) async {
          await dbHelper.getOggetti(
              context,
              context.read<SpaziData>().spazioSelected.nomeSpazio ?? "",
              context.read<StanzeData>().stanzaSelected.nomeStanza ?? "");
          objectFunction.initialize(context);

          objectFunction.timer = Timer.periodic(
              Duration(seconds: objectFunction.timerDuration),
              (Timer t) => objectFunction.updateObjectColor(context));
        });
      },
    );
  }
}
