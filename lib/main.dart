import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app/form_slider.dart';

Future main() async {
  await DotEnv().load();
  runApp(MyApp());
}

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: new FutureBuilder(
                future: http.get(
                    new Uri.http(
                        DotEnv().env['BACKEND_URL'], '/api/v1/formSchema'),
                    headers: {
                      'Authorization': 'Api-Key ' + DotEnv().env['API_KEY']
                    }),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final jsonBody = jsonDecode(snapshot.data.body);
                    final jsonProperties = jsonBody['schema']['properties'];
                    final jsonOptions = jsonBody['options']['fields'];
                    return FormSlider(
                      properties: jsonProperties,
                      options: jsonOptions,
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                })));
  }
}
