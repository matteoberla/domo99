import 'package:domotica_mimmo/customClasses/NetworkHelper.dart';
import 'package:domotica_mimmo/customClasses/Stanza.dart';
import 'package:domotica_mimmo/models/OggettiData.dart';
import 'package:domotica_mimmo/models/SpaziData.dart';
import 'package:domotica_mimmo/models/StanzeData.dart';
import 'package:domotica_mimmo/screens/OggettiScreen.dart';
import 'package:domotica_mimmo/screens/modifyDeleteRoomScreen.dart';
import 'package:domotica_mimmo/sqLite/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'RowStanza.dart';

class StanzaTile extends StatelessWidget {
  final Stanza stanzaTile;

  StanzaTile(this.stanzaTile);

  final NetworkHelper networkHelper = NetworkHelper();
  final DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return RowStanza(
      nomeStanza: stanzaTile.nomeStanza ?? "",
      immagine: 'assets/images/${stanzaTile.tipoStanza}.png',
      onTap: () async {
        context.read<StanzeData>().updateStanzaSelected(stanzaTile);
        await dbHelper.getOggetti(
            context,
            context.read<SpaziData>().spazioSelected.nomeSpazio ?? "",
            stanzaTile.nomeStanza ?? "");
        await networkHelper.updateObjectColors(
            context.read<OggettiData>().listOggetti,
            context.read<SpaziData>().spazioSelected.ipUtilizzato ?? 0,
            context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OggettiScreen();
        }));
      },
      onLongPress: () async {
        context.read<StanzeData>().updateStanzaToModify(stanzaTile);
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => SingleChildScrollView(
            child: Container(
              child: ModifyDeleteRoomScreen(),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
            ),
          ),
        ).then((value) => dbHelper.getStanze(context,
            context.read<SpaziData>().spazioSelected.nomeSpazio ?? ""));
      },
    );
  }
}
