import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class LoadingWidget extends StatelessWidget {
  LoadingWidget({required this.textToDisplay});

  final String textToDisplay;

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                textToDisplay,
                style: TextStyle(
                    color: isDark ? Colors.blue : Colors.lightBlueAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            LoadingBouncingGrid.square(
              backgroundColor: isDark ? Colors.blue : Colors.lightBlueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
