import 'package:domotica_mimmo/components/TextFieldBottomSheet.dart';
import 'package:domotica_mimmo/customClasses/NetworkHelper.dart';
import 'package:domotica_mimmo/customClasses/Spazio.dart';
import 'package:domotica_mimmo/sqLite/dbHelper.dart';
import 'package:flutter/material.dart';

class AddSpaceScreen extends StatefulWidget {
  @override
  _AddSpaceScreenState createState() => _AddSpaceScreenState();
}

class _AddSpaceScreenState extends State<AddSpaceScreen> {
  DBHelper dbHelper = DBHelper();
  NetworkHelper networkHelper = NetworkHelper();
  String nomeSpazio = '';
  String ipInterno = '';
  String ipEsterno = '';
  bool isIpInterno = false;

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
            'Nuovo spazio',
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.lightBlueAccent,
            ),
          ),
          TextFieldBottomSheet(
            hintText: 'Nome del nuovo spazio',
            onChanged: (newValue) {
              setState(() {
                nomeSpazio = newValue;
              });
            },
          ),
          TextFieldBottomSheet(
            hintText: 'Ip Interno',
            onChanged: (newValue) {
              setState(() {
                ipInterno = newValue;
              });
            },
          ),
          TextFieldBottomSheet(
            hintText: 'Ip Esterno',
            onChanged: (newValue) {
              setState(() {
                ipEsterno = newValue;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Usa ip interno',
                style: TextStyle(fontSize: 16.0),
              ),
              Checkbox(
                value: isIpInterno,
                onChanged: (newValue) {
                  setState(() {
                    isIpInterno = (newValue == true);
                  });
                },
              )
            ],
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
              Spazio nuovoSpazio = Spazio(
                nomeSpazio: nomeSpazio,
                ipInterno: ipInterno,
                ipEsterno: ipEsterno,
                ipUtilizzato: isIpInterno ? 1 : 0,
              );
              await dbHelper.saveSpazio(nuovoSpazio);
              bool added = true;

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
