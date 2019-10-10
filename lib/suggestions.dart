import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:app/suggestion_card.dart';

class Suggestions extends StatefulWidget {
  final Map formResults;
  final List<String> practiceBlacklist;
  final List<String> typeBlacklist;

  Suggestions({this.formResults, this.practiceBlacklist = const [], this.typeBlacklist = const []})
      : assert(formResults != null),
        assert(practiceBlacklist != null),
        assert(typeBlacklist != null);

  @override
  State<StatefulWidget> createState() {
    var _state = _SuggestionsState();
    _state.formResults = formResults;
    _state.practiceBlacklist = practiceBlacklist;
    _state.typeBlacklist = typeBlacklist;
    return _state;
  }
}

class _SuggestionsState extends State<Suggestions> {
  Map formResults;
  List<String> practiceBlacklist;
  List<String> typeBlacklist;
  Future _loadSuggestions;

  List<Widget> getSuggestionWidgets(List suggestions, BuildContext context) {
    List<Widget> widgets = List<Widget>();

    Function hidePracticeType = (String typeId) {
      setState(() {
        List<String> newBlacklist = [typeId];
        newBlacklist.addAll(typeBlacklist);
        typeBlacklist = newBlacklist;
        _assignFuture();
      });
      Navigator.pop(context);
    };

    for (var suggestion in suggestions) {
      Function hidePractice = () {
        setState(() {
          List<String> newBlacklist = [suggestion['practice']['id'].toString()];
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
        answers: formResults,
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
        'answers': this.formResults,
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Résultats'),
      ),
      body: Center(
        child: new FutureBuilder(
          future: _loadSuggestions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final jsonBody = jsonDecode(utf8.decode(snapshot.data.bodyBytes));
              final suggestions = jsonBody['suggestions'];
              return ListView(
                children: getSuggestionWidgets(suggestions, context),
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
