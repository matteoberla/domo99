import 'dart:async';
import 'package:domotica_mimmo/components/AppBarNavigator.dart';
import 'package:domotica_mimmo/components/LoadingWidget.dart';
import 'package:domotica_mimmo/components/OggettoTile.dart';
import 'package:domotica_mimmo/customClasses/NetworkHelper.dart';
import 'package:domotica_mimmo/customClasses/ObjectFunctions.dart';
import 'package:domotica_mimmo/models/OggettiData.dart';
import 'package:domotica_mimmo/models/SpaziData.dart';
import 'package:domotica_mimmo/models/StanzeData.dart';
import 'package:domotica_mimmo/screens/addObjectScreen.dart';
import 'package:domotica_mimmo/sqLite/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OggettiScreen extends StatefulWidget {
  @override
  _OggettiScreenState createState() => _OggettiScreenState();
}

class _OggettiScreenState extends State<OggettiScreen> {
  final DBHelper dbHelper = DBHelper();
  final NetworkHelper networkHelper = NetworkHelper();
  final ObjectFunction objectFunction = ObjectFunction();

  @override
  void initState() {
    super.initState();
    objectFunction.timer = Timer.periodic(
        Duration(seconds: objectFunction.timerDuration),
        (Timer t) => objectFunction.updateObjectColor(context));
  }

  /*@override
  void setState(fn) {
    //per prevenire errori quando esco dalla pagina
    if (mounted) {
      super.setState(fn);
    }
  }*/

  @override
  void dispose() {
    objectFunction.timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var oggettiDataProvider = Provider.of<OggettiData>(context, listen: true);
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBarNavigator(
          isDark: isDark,
          textToDisplay:
              '${context.read<StanzeData>().stanzaSelected.nomeStanza}',
          onAddTap: () async {
            objectFunction.timer?.cancel();

            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  child: AddObjectScreen(),
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                ),
              ),
            ).then(
              (value) async {
                await dbHelper.getOggetti(
                    context,
                    context.read<SpaziData>().spazioSelected.nomeSpazio ?? "",
                    context.read<StanzeData>().stanzaSelected.nomeStanza ?? "");
                objectFunction.initialize(context);

                objectFunction.timer = Timer.periodic(
                    Duration(seconds: objectFunction.timerDuration),
                    (Timer t) => objectFunction.updateObjectColor(context));
              },
            );
          },
        ),
      ),
      body: oggettiDataProvider.isLoading
          ? LoadingWidget(
              textToDisplay: 'Richiesta...',
            )
          : Consumer<OggettiData>(
              builder: (context, oggettiData, child) {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final oggettoTile = oggettiData.listOggetti[index];
                    return OggettoTile(oggettoTile, objectFunction);
                  },
                  itemCount: oggettiData.oggettiCount,
                );
              },
            ),
    );
  }
}
