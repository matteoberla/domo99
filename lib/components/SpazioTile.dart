import 'package:domotica_mimmo/customClasses/Spazio.dart';
import 'package:domotica_mimmo/models/SpaziData.dart';
import 'package:domotica_mimmo/screens/StanzeScreen.dart';
import 'package:domotica_mimmo/screens/modifyDeleteSpaceScreen.dart';
import 'package:domotica_mimmo/sqLite/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'RowSpazio.dart';

class SpazioTile extends StatelessWidget {
  final Spazio spaziTile;

  SpazioTile(this.spaziTile);

  final DBHelper dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    return RowSpazio(
      nomeSpazio: spaziTile.nomeSpazio ?? "",
      immagine: 'assets/images/Home.png',
      onTap: () async {
        context.read<SpaziData>().updateSpazioSelected(spaziTile);
        await dbHelper.getStanze(
            context, context.read<SpaziData>().spazioSelected.nomeSpazio ?? "");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return StanzeScreen();
            },
          ),
        );
      },
      onLongPress: () async {
        context.read<SpaziData>().updateSpazioToModify(spaziTile);
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => SingleChildScrollView(
            child: Container(
              child: ModifyDeleteSpaceScreen(),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
            ),
          ),
        ).then((value) async => await dbHelper.getSpazi(context));
      },
    );
  }
}
