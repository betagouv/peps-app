import 'dart:convert';
import 'package:app/utils/connectionerrorwidget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:app/suggestion_card.dart';

class Suggestions extends StatefulWidget {
  final Map formResults;
  final List<Map<String, String>> readableAnswers;
  final List<String> practiceBlacklist;
  final List<String> typeBlacklist;
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  Suggestions(
      {this.formResults, this.practiceBlacklist = const [], this.typeBlacklist = const [], this.analytics, this.observer, this.readableAnswers})
      : assert(formResults != null),
        assert(readableAnswers != null),
        assert(practiceBlacklist != null),
        assert(analytics != null),
        assert(observer != null),
        assert(typeBlacklist != null);

  @override
  State<StatefulWidget> createState() {
    var _state = _SuggestionsState(analytics: analytics, observer: observer);
    _state.readableAnswers = readableAnswers;
    _state.practiceBlacklist = practiceBlacklist;
    _state.typeBlacklist = typeBlacklist;
    return _state;
  }
}

class _SuggestionsState extends State<Suggestions> {
  List<Map<String, String>> readableAnswers;
  List<String> practiceBlacklist;
  List<String> typeBlacklist;
  Future _loadSuggestions;

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  _SuggestionsState({this.analytics, this.observer})
      : assert(analytics != null),
        assert(observer != null);

  List<Widget> getSuggestionWidgets(List suggestions, BuildContext context) {
    List<Widget> widgets = List<Widget>();

    Function hidePracticeType = (String typeId) {
      analytics.logEvent(
        name: 'hide_practice_type',
        parameters: <String, dynamic>{
          'practice_type': typeId,
        },
      );

      setState(() {
        List<String> newBlacklist = [typeId];
        newBlacklist.addAll(typeBlacklist);
        typeBlacklist = newBlacklist;
        _assignFuture();
      });
      Navigator.pop(context);
    };

    for (var suggestion in suggestions) {
      var blacklistedPracticeId = suggestion['practice']['id'].toString();

      Function hidePractice = () {
        analytics.logEvent(
          name: 'hide_practice',
          parameters: <String, dynamic>{
            'practice': blacklistedPracticeId,
          },
        );

        setState(() {
          List<String> newBlacklist = [blacklistedPracticeId];
          newBlacklist.addAll(practiceBlacklist);
          practiceBlacklist = newBlacklist;
          _assignFuture();
        });
        Navigator.pop(context);
      };

      widgets.add(SuggestionCard(
        json: suggestion,
        hidePractice: hidePractice,
        hidePracticeType: hidePracticeType,
        answers: readableAnswers,
        analytics: analytics,
        observer: observer,
      ));
    }
    return widgets;
  }

  @override
  void initState() {
    _assignFuture();
    super.initState();
  }

  void _assignFuture() {
    _loadSuggestions = http.post(
      new Uri.http(DotEnv().env['BACKEND_URL'], '/api/v1/calculateRankings'),
      body: jsonEncode({
        'answers': widget.formResults,
        'practice_blacklist': this.practiceBlacklist,
        'type_blacklist': this.typeBlacklist,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Api-Key ' + DotEnv().env['API_KEY'],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text('Résultats'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Êtes-vous sur de vouloir quitter ?'),
                  content: Text('En confirmant, vous reviendrez à l\'accueil.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Revenir à l\'accueil'),
                      onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    ),
                    FlatButton(
                      child: Text('Rester'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              },
            );
          },
        )
      ],
    );

    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: appBar,
      body: Center(
        child: new FutureBuilder(
          future: _loadSuggestions,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return ConnectionErrorWidget(
                message: 'Oops ! Une erreur de connexion est survenue lors de la récuperation des suggestions',
                retryFunction: () {
                  setState(() {
                    _assignFuture();
                  });
                },
              );
            }

            final jsonBody = jsonDecode(utf8.decode(snapshot.data.bodyBytes));
            final suggestions = jsonBody['suggestions'];
            return ListView(
              children: getSuggestionWidgets(suggestions, context),
            );
          },
        ),
      ),
    );
  }
}
