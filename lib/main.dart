import 'package:domotica_mimmo/models/OggettiData.dart';
import 'package:domotica_mimmo/models/SpaziData.dart';
import 'package:domotica_mimmo/models/StanzeData.dart';
import 'package:domotica_mimmo/models/http_provider/http_provider.dart';
import 'package:domotica_mimmo/models/login_provider/login_provider.dart';
import 'package:domotica_mimmo/screens/pin_page.dart';
import 'package:flutter/material.dart';
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
          create: (_) => HttpProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
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
