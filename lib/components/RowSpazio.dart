import 'package:flutter/material.dart';

class RowSpazio extends StatelessWidget {
  RowSpazio({required this.nomeSpazio, required this.immagine, required this.onTap, required this.onLongPress});
  final String nomeSpazio;
  final String immagine;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(right: 10.0, left: 10.0, top: 5.0, bottom: 5.0),
      elevation: 5.0,
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
        title: Text(nomeSpazio),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
