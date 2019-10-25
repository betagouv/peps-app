import 'dart:async';
import 'dart:convert';
import 'package:app/utils/connectionerrorwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app/landingview.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

Future main() async {
  await DotEnv().load();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peps',
      navigatorObservers: <NavigatorObserver>[observer],
      theme: ThemeData(
        primarySwatch: primarySwatch,
        primaryColor: primarySwatch.shade500,
        accentColor: primarySwatch.shade700,
        fontFamily: 'Roboto',
      ),
      home: PepsHomePage(
        title: 'Peps',
        analytics: analytics,
        observer: observer,
      ),
    );
  }
}

class PepsHomePage extends StatefulWidget {

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final String title;

  PepsHomePage({Key key, this.title, this.analytics, this.observer}) : super(key: key);

  @override
  _PepsHomePageState createState() => _PepsHomePageState();
}

class _PepsHomePageState extends State<PepsHomePage> {
  Future _loadForm;

  @override
  void initState() {
    _assignFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: new FutureBuilder(
          future: _loadForm,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            }
            var hasError = snapshot.hasError || snapshot == null || snapshot.data is Exception || snapshot.data == null;
            if (hasError) {
              return ConnectionErrorWidget(
                message: 'Oops ! Une erreur de connexion est survenue',
                retryFunction: () {
                  setState(() {
                    _assignFuture();
                  });
                },
              );
            }

            final jsonBody = jsonDecode(snapshot.data.body);
            final jsonProperties = jsonBody['schema']['properties'];
            final jsonOptions = jsonBody['options']['fields'];

            return LandingView(
              jsonProperties: jsonProperties,
              jsonOptions: jsonOptions,
              analytics: widget.analytics,
              observer: widget.observer,
            );
          },
        ),
      ),
    );
  }

  void _assignFuture() {
    _loadForm = http
        .get(new Uri.http(DotEnv().env['BACKEND_URL'], '/api/v1/formSchema'), headers: {'Authorization': 'Api-Key ' + DotEnv().env['API_KEY']});
  }
}
