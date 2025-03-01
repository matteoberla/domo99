import 'package:flutter/material.dart';

class AppBarNavigator extends StatelessWidget {
  AppBarNavigator(
      {required this.isDark,
      required this.textToDisplay,
      this.onAddTap,
      this.showAddButton = true});
  final bool isDark;
  final String textToDisplay;
  final VoidCallback? onAddTap;
  final bool showAddButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: isDark ? Colors.black : Colors.white, //change your color here
      ),
      title: Text(
        textToDisplay,
        style: TextStyle(color: isDark ? Colors.black : Colors.white),
      ),
      backgroundColor: Colors.blueAccent,
      actions: <Widget>[
        Visibility(
          visible: showAddButton,
          child: Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: onAddTap,
              child: Icon(
                Icons.add,
                size: 26.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
