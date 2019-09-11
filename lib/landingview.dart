import 'package:flutter/material.dart';
import 'package:app/form_slider.dart';
import 'package:app/utils/clipshadowpath.dart';

class LandingView extends StatefulWidget {
  final Map jsonProperties;
  final Map jsonOptions;

  LandingView({this.jsonProperties, this.jsonOptions});

  @override
  State<StatefulWidget> createState() {
    var state = _LandingViewState();
    state.startQuestionnaire = this.startQuestionnaire;
    return state;
  }

  void startQuestionnaire(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Peps'),
        ),
        body: Center(
          child: FormSlider(
            properties: this.jsonProperties,
            options: this.jsonOptions,
          ),
        ),
      );
    }));
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
        padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
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
              child: Icon(Icons.bookmark),
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            ),
            title: Padding(
              child: Text('Pratiques sauvegardées'),
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        Card(
          child: ListTile(
            leading: Padding(
              child: Icon(Icons.access_time),
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            ),
            title: Padding(
              child: Text('Historique'),
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            ),
            trailing: Icon(Icons.chevron_right),
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
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
