import 'package:app/about.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:app/form_slider.dart';
import 'package:app/utils/clipshadowpath.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingView extends StatefulWidget {
  final Map jsonProperties;
  final Map jsonOptions;
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  LandingView({this.jsonProperties, this.jsonOptions, this.analytics, this.observer})
      : assert(jsonProperties != null),
        assert(jsonOptions != null),
        assert(analytics != null),
        assert(observer != null);

  @override
  State<StatefulWidget> createState() {
    var state = _LandingViewState();
    state.startQuestionnaire = this.startQuestionnaire;
    return state;
  }

  void startQuestionnaire(BuildContext context) async {
    await analytics.logEvent(
      name: 'form_start',
      parameters: <String, dynamic>{},
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Peps'),
            ),
            body: Center(
              child: FormSlider(
                properties: this.jsonProperties,
                options: this.jsonOptions,
                analytics: analytics,
                observer: observer,
              ),
            ),
          );
        },
        settings: RouteSettings(name: 'form_slider'),
      ),
    );
  }
}

class _LandingViewState extends State<LandingView> {
  Function startQuestionnaire;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _getHeader(context),
        _getList(context),
      ],
    );
  }

  Widget _getHeader(BuildContext context) {
    return ClipShadowPath(
      shadow: Shadow(
        blurRadius: 5,
      ),
      child: Container(
        height: 250,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: AssetImage('assets/bg-image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            child: Column(
              children: <Widget>[
                _getMainText(context),
                _getMainButton(context),
              ],
            ),
            padding: EdgeInsets.fromLTRB(0, 85, 0, 0),
          ),
        ),
      ),
      clipper: BottomClipper(),
    );
  }

  Widget _getMainButton(BuildContext context) {
    return RaisedButton(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Text(
          'Améliorer mon système',
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 18,
          ),
        ),
      ),
      onPressed: () => startQuestionnaire(context),
    );
  }

  Widget _getMainText(BuildContext context) {
    return Padding(
      child: Text(
        'Trouvez des pratiques alternatives personalisées',
        style: TextStyle(
          color: Colors.white,
          shadows: <Shadow>[
            Shadow(
              offset: Offset(0.0, 0.0),
              blurRadius: 3,
              color: Theme.of(context).accentColor,
            ),
          ],
          fontFamily: 'SourceSansPro',
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
    );
  }

  Widget _getList(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            leading: Padding(
              child: Icon(Icons.filter_vintage),
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            ),
            title: Padding(
              child: Text('Qui sommes-nous ?'),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: RouteSettings(
                    name: 'about',
                  ),
                  builder: (context) => About(),
                ),
              );
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: Padding(
              child: Icon(Icons.email),
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            ),
            title: Padding(
              child: Text('Contacter l\'équipe'),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              String body = 'Bonjour, je vous contacte suite à l\'utilisation de l\'app Peps...\n\n[Écrivez votre message ici]';
              String emailAddress = 'peps@beta.gouv.fr';
              String subject = 'Contact depuis l\'app Peps';
              launch('mailto:$emailAddress?subject=$subject&body=$body');
            },
          ),
        ),
      ],
    );
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var curveSize = 25;
    var path = Path();
    path.lineTo(0.0, size.height - curveSize);

    var controlPoint = new Offset(size.width / 2, size.height);
    var endPoint = new Offset(size.width, size.height - curveSize);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
