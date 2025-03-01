import 'package:domotica_mimmo/models/OggettiData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Oggetto.dart';
import 'package:provider/provider.dart';

class NetworkHelper {
  final int timeoutSeconds = 10;

  Future<Color> objectRequest(
      {required String ip,
      required String estensione,
      required String risposta}) async {
    try {
      print("http://$ip/$estensione");
      final response = await http
          .get(Uri.parse("http://$ip/$estensione"))
          .timeout(Duration(seconds: timeoutSeconds), onTimeout: () async {
        return await Future.delayed(
            Duration.zero, () => http.Response("Timeout", 408));
      });
      return getColor(response, risposta);
    } catch (error) {
      print("objReq: " + error.toString());
      return Colors.blue;
    }
  }

  Color getColor(dynamic response, String risposta) {
    //verde acceso
    //rosso spento
    //giallo richiesta fatta ma risposta non trovata
    //blu errore nella richiesta (!=200)
    //bianco richiesta ip fallita

    if (response == null) {
      return Colors.blue;
    }
    if (response.statusCode == 200) {
      //print(response.body);
      //print(risposta);
      //print(response.body.contains('${risposta}ON'));
      //print(response.body.contains('${risposta}OFF'));
      if (response.body.contains('${risposta}ON')) {
        return Colors.green;
      } else if (response.body.contains('${risposta}OFF')) {
        return Colors.red;
      } else {
        return Colors.yellow;
      }
    } else {
      print(response.statusCode);
      return Colors.blue;
    }
  }

  Future<bool> updateObjectColors(
      List<Oggetto> listOggetti, int ipUsato, BuildContext context) async {
    //print(listOggetti.isNotEmpty);
    var oggettiDataProvider = Provider.of<OggettiData>(context, listen: false);
    Color rowColor;
    String ipRichiesto = '';
    String ipRichiestoPrecedente = '';
    dynamic responsePrecedente;

    if (listOggetti.isNotEmpty) {
      for (var oggetto in listOggetti) {
        ipUsato == 1
            ? ipRichiesto = oggetto.ipInterno ?? ""
            : ipRichiesto = oggetto.ipEsterno ?? "";
        if (listOggetti.first.id != oggetto.id) {
          ipUsato == 1
              ? ipRichiestoPrecedente =
                  listOggetti[listOggetti.indexOf(oggetto)].ipInterno ?? ""
              : ipRichiestoPrecedente =
                  listOggetti[listOggetti.indexOf(oggetto)].ipEsterno ?? "";
        }

        //evito di fare richieste quando ho ip uguali
        if (ipRichiesto != ipRichiestoPrecedente) {
          print('http://$ipRichiesto');

          try {
            final response = await http
                .get(
              Uri.parse("http://$ipRichiesto")
            )
                .timeout(Duration(seconds: timeoutSeconds),
                    onTimeout: () async {
              return await Future.delayed(
                  Duration.zero, () => http.Response("Timeout", 408),);
            },);
            //print(response);
            responsePrecedente = response;
            rowColor = getColor(response, oggetto.risposta ?? "");
          } catch (error) {
            print("req: $error");
            responsePrecedente = null;
            rowColor = Colors.white;
          }
        } else {
          rowColor = getColor(responsePrecedente, oggetto.risposta ?? "");
        }
        oggettiDataProvider.updateOggettoColor(oggetto, rowColor);
      }
    }
    return true;
  }
}
