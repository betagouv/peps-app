import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/peps_form_slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peps',
      theme: ThemeData(
        primarySwatch: Colors.green,
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: new FutureBuilder(
        future: http.get(new Uri.http('10.0.2.2:8000', '/api/v1/formSchema')),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return PepsFormSlider(str: snapshot.data.body);
          } else {
            return CircularProgressIndicator();
          }
        })
      )
    );
  }
}
