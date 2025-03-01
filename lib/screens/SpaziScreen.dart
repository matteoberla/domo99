import 'package:domotica_mimmo/components/AppBarNavigator.dart';
import 'package:domotica_mimmo/components/LoadingWidget.dart';
import 'package:domotica_mimmo/components/SpazioTile.dart';
import 'package:domotica_mimmo/models/OggettiData.dart';
import 'package:domotica_mimmo/models/SpaziData.dart';
import 'package:domotica_mimmo/sqLite/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'addSpaceScreen.dart';

class SpaziScreen extends StatefulWidget {
  @override
  _SpaziScreenState createState() => _SpaziScreenState();
}

class _SpaziScreenState extends State<SpaziScreen> {
  DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    var oggettiDataProvider = Provider.of<OggettiData>(context, listen: true);


    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBarNavigator(
          isDark: isDark,
          textToDisplay: 'Benvenuto, ${context.read<SpaziData>().nomeUtente}',
          onAddTap: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  child: AddSpaceScreen(),
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                ),
              ),
            ).then((value) async => await dbHelper.getSpazi(context));
          },
        ),
      ),
      body: oggettiDataProvider.isLoading
          ? LoadingWidget(
              textToDisplay: 'Carico Spazi',
            )
          : Consumer<SpaziData>(
              builder: (context, spaziData, child) {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final spazioTile = spaziData.listSpazi[index];
                    return SpazioTile(spazioTile);
                  },
                  itemCount: spaziData.spaziCount,
                );
              },
            ),
    );
  }
}
