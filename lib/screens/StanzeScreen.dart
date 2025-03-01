import 'package:domotica_mimmo/components/AppBarNavigator.dart';
import 'package:domotica_mimmo/components/LoadingWidget.dart';
import 'package:domotica_mimmo/components/StanzaTile.dart';
import 'package:domotica_mimmo/customClasses/NetworkHelper.dart';
import 'package:domotica_mimmo/models/OggettiData.dart';
import 'package:domotica_mimmo/models/SpaziData.dart';
import 'package:domotica_mimmo/models/StanzeData.dart';
import 'package:domotica_mimmo/screens/addRoomScreen.dart';
import 'package:domotica_mimmo/sqLite/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StanzeScreen extends StatefulWidget {
  @override
  _StanzeScreenState createState() => _StanzeScreenState();
}

class _StanzeScreenState extends State<StanzeScreen> {
  DBHelper dbHelper = DBHelper();
  NetworkHelper networkHelper = NetworkHelper();

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
              '${context.read<SpaziData>().spazioSelected.nomeSpazio}',
          onAddTap: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  child: AddRoomScreen(),
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                ),
              ),
            ).then((value) async => await dbHelper.getStanze(context,
                context.read<SpaziData>().spazioSelected.nomeSpazio ?? ""));
          },
        ),
      ),
      body: oggettiDataProvider.isLoading
          ? LoadingWidget(
              textToDisplay: 'Carico Stanze',
            )
          : Consumer<StanzeData>(builder: (context, stanzeData, child) {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final stanzaTile = stanzeData.listStanze[index];
                  return StanzaTile(stanzaTile);
                },
                itemCount: stanzeData.stanzeCount,
              );
            }),
    );
  }
}
