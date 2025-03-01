import 'package:domotica_mimmo/models/OggettiData.dart';
import 'package:domotica_mimmo/models/SpaziData.dart';
import 'package:domotica_mimmo/models/StanzeData.dart';
import 'package:flutter/material.dart';
import 'screens/LoginPage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SpaziData(),
        ),
        ChangeNotifierProvider(
          create: (_) => StanzeData(),
        ),
        ChangeNotifierProvider(
          create: (_) => OggettiData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        theme: ThemeData.light().copyWith(canvasColor: Colors.transparent),
        darkTheme: ThemeData.dark().copyWith(canvasColor: Colors.transparent),
      ),
    );
  }
}
