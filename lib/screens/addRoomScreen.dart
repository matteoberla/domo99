// ignore_for_file: unnecessary_import

import 'package:domotica_mimmo/components/TextFieldBottomSheet.dart';
import 'package:domotica_mimmo/customClasses/NetworkHelper.dart';
import 'package:domotica_mimmo/customClasses/SelectTypeWidget.dart';
import 'package:domotica_mimmo/customClasses/Stanza.dart';
import 'package:domotica_mimmo/models/SpaziData.dart';
import 'package:domotica_mimmo/sqLite/dbHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:domotica_mimmo/components/tipologieStanzeOggetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class AddRoomScreen extends StatefulWidget {
  @override
  _AddRoomScreenState createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  SelectTypeWidget selectTypeWidget = SelectTypeWidget();
  DBHelper dbHelper = DBHelper();
  NetworkHelper networkHelper = NetworkHelper();
  String nomeStanza = '';
  String tipoStanza = tipiStanze.first;

  void onChangedCallback(String tipo) {
    setState(() {
      tipoStanza = tipo;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
          color: isDark ? Colors.black87 : Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))),
      child: Column(
        children: [
          Text(
            'Nuova stanza',
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.lightBlueAccent,
            ),
          ),
          TextFieldBottomSheet(
            hintText: 'Nome della nuova stanza',
            onChanged: (newValue) {
              setState(() {
                nomeStanza = newValue;
              });
            },
          ),
          Container(
            height: 50,
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              color: Colors.lightBlueAccent,
            ),
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Platform.isIOS
                ? selectTypeWidget.iOSPickerRoom(
                    onChangedCallback, tipiStanze.indexOf(tipoStanza))
                : selectTypeWidget.androidDropdownRoom(
                    tipoStanza, onChangedCallback),
          ),
          TextButton(
            child: Text(
              'Aggiungi',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
            ),
            onPressed: () async {
              Stanza nuovaStanza = Stanza(
                  spazioParente:
                      context.read<SpaziData>().spazioSelected.nomeSpazio,
                  nomeStanza: nomeStanza,
                  tipoStanza: tipoStanza);
              await dbHelper.saveStanza(nuovaStanza);
              bool added = true;
//              bool added = await networkHelper.addRoomSuccess(
//                  user: widget.nomeUtente,
//                  parentSpace: widget.spazioParente,
//                  roomName: nomeStanza,
//                  roomType: tipoStanza);
              if (added) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
