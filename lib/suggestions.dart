import 'dart:convert';
import 'package:app/feedback_dialog.dart';
import 'package:app/resources/api_provider.dart';
import 'package:app/utils/connectionerrorwidget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app/suggestion_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      var practiceAirtableId = suggestion['practice']['external_id'].toString();

      Function hidePractice = (String reason) {
        analytics.logEvent(
          name: 'hide_practice',
          parameters: <String, dynamic>{
            'practice': blacklistedPracticeId,
            'reason': reason,
          },
        );

        ApiProvider().createDiscardAction(practiceAirtableId, reason);

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
    _loadSuggestions = ApiProvider().calculateRankings(widget.formResults, this.practiceBlacklist, this.typeBlacklist);
  }

  void showContactDialog(BuildContext context) async {
    var key = 'feedbackAsked';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var hasBeenAsked = prefs.containsKey(key) && prefs.getBool(key);
    if (!hasBeenAsked) {
      prefs.setBool(key, true);
      showDialog(
        context: context,
        builder: (context) => FeedbackDialog(
          answers: readableAnswers,
          analytics: analytics,
        ),
      );
    }
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
              showContactDialog(context);

              return ListView(
                children: getSuggestionWidgets(suggestions, context),
              );
            }),
      ),
    );
  }
}
