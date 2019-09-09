import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app/form_slider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

Future main() async {
  await DotEnv().load();
  Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(MyApp());
}

MaterialColor primarySwatch = MaterialColor(0xFFFFFFFF, {
  50: Color(0xFF11F0B3),
  100: Color(0xFF04D49B),
  200: Color(0xFF00C28D),
  300: Color(0xFF00A679),
  400: Color(0xFF009C72),
  500: Color(0xFF008763),
  600: Color(0xFF006E50),
  700: Color(0xFF005C43),
  800: Color(0xFF004D38),
  900: Color(0xFF004230),
});

class MyApp extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Peps',
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      theme: ThemeData(
        primarySwatch: primarySwatch,
        primaryColor: primarySwatch.shade500,
        fontFamily: 'Roboto',
      ),
      home: PepsHomePage(title: 'Peps'),
    );
  }
}

class PepsHomePage extends StatefulWidget {
  PepsHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PepsHomePageState createState() => _PepsHomePageState();
}

class _PepsHomePageState extends State<PepsHomePage> {
  Future getFormSchema() async {
    try {
      return await http.get(
          new Uri.http(DotEnv().env['BACKEND_URL'], '/api/v1/formSchema'),
          headers: {'Authorization': 'Api-Key ' + DotEnv().env['API_KEY']});
    } catch (e) {
      print(e);
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: new FutureBuilder(
          future: getFormSchema(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            }
            if (snapshot == null ||
                snapshot.data is Exception ||
                snapshot.data == null) {
              return Padding(
                padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.signal_wifi_off,
                      size: 50,
                      color: Colors.grey[400],
                    ),
                    Padding(
                      child:
                          Text('Oops ! Une erreur de connexion est survenue'),
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    ),
                    RaisedButton(
                      child: Text('Ressayer'),
                      onPressed: () => setState(() {}),
                    ),
                  ],
                ),
              );
            }

            final jsonBody = jsonDecode(snapshot.data.body);
            final jsonProperties = jsonBody['schema']['properties'];
            final jsonOptions = jsonBody['options']['fields'];
            return FormSlider(
              properties: jsonProperties,
              options: jsonOptions,
            );
          },
        ),
      ),
    );
  }
}
