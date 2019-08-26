import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:app/suggestion_card.dart';

class Results extends StatelessWidget {
  final Map formResults;

  Results({this.formResults});

  List<Widget> getSuggestionWidgets(List suggestions) {
    List<Widget> widgets = List<Widget>();
    for (var suggestion in suggestions) {
      widgets.add(SuggestionCard(
        json: suggestion,
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Résultats'),
      ),
      body: Center(
        child: new FutureBuilder(
          future: http.post(
            new Uri.http(DotEnv().env['BACKEND_URL'], '/api/v1/calculateRankings'),
            body: jsonEncode({'answers': this.formResults, 'blacklist': []}),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Api-Key ' + DotEnv().env['API_KEY']
            },
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final jsonBody = jsonDecode(utf8.decode(snapshot.data.bodyBytes));
              final suggestions = jsonBody['suggestions'];
              return ListView(
                children: getSuggestionWidgets(suggestions),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
