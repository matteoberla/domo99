import 'package:domotica_mimmo/components/AppBarNavigator.dart';
import 'package:domotica_mimmo/components/HintText.dart';
import 'package:domotica_mimmo/components/LinkRaisedButton.dart';
import 'package:domotica_mimmo/components/TitleText.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  final String emailAddress = 'elettronicamimmo@gmail.com';
  final String siteUrl =
      'https://sites.google.com/view/berlatomatteo/domotica-pro?authuser=0';
  // ignore: non_constant_identifier_names
  final String FacebUrl =
      'https://sites.google.com/view/berlatomatteo/domotica-pro?authuser=0';

  void sendEmail() async {
    final Uri email = Uri(
      scheme: 'mailto',
      path: emailAddress,
      query: 'subject=Richiesta aiuto&body=Buongiorno,',
    );
    if (await canLaunchUrl(email)) {
      await launchUrl(email);
    } else {
      throw 'Could not launch $email';
    }
  }

  void openSite() async {
    if (await canLaunchUrl(Uri.parse(siteUrl))) {
      await launchUrl(Uri.parse(siteUrl));
    } else {
      throw 'Could not launch $siteUrl';
    }
  }

  void openFB() async {
    if (await canLaunchUrl(Uri.parse(FacebUrl))) {
      await launchUrl(Uri.parse(FacebUrl));
    } else {
      throw 'Could not launch $FacebUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBarNavigator(
          isDark: isDark,
          textToDisplay: 'Risoluzione problemi',
          showAddButton: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TitleText(
                testo: 'Elettronica Mimmo',
                isDark: isDark,
              ),
              HintText(isDark: isDark, testo: 'Via balestri 23, Carrè(VI)'),
              HintText(
                isDark: isDark,
                testo: '392 845 7419',
              ),
              SizedBox(
                height: 10,
              ),
              HintText(
                isDark: isDark,
                testo: 'Il nostro indirizzo:',
              ),
              HintText(
                isDark: isDark,
                testo: emailAddress,
              ),
              LinkRaisedButton(
                testo: 'Scrivi una mail!',
                isDark: isDark,
                onTap: sendEmail,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      color: Colors.blueAccent,
                      iconSize: 60,
                      // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                      icon: FaIcon(FontAwesomeIcons.squareFacebook),
                      onPressed: () {
                        openFB();
                      }),
                  IconButton(
                      color: Colors.blueAccent,
                      iconSize: 60,
                      // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                      icon: FaIcon(FontAwesomeIcons.google),
                      onPressed: () {
                        openSite();
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
