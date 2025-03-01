import 'package:flutter/material.dart';

class RowOggetto extends StatelessWidget {
  RowOggetto(
      {required this.nomeOggetto,
      required this.immagine,
      required this.onTap,
      required this.onLongPress,
      required this.colore});

  final String nomeOggetto;
  final String immagine;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Color colore;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(right: 10.0, left: 10.0, top: 5.0, bottom: 5.0),
      elevation: 8.0,
      child: ListTile(
        leading: Container(
          margin: EdgeInsets.all(4.0),
          padding: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 3.0,
                offset: Offset(0, 0),
              )
            ],
          ),
          child: Image(
            image: AssetImage(immagine),
          ),
        ),
        title: Text(nomeOggetto),
        onTap: onTap,
        onLongPress: onLongPress,
        trailing: Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset: Offset(2.0, 2.0), // shadow direction: bottom right
              )
            ],
            color: colore,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
