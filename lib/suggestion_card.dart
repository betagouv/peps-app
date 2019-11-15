import 'package:app/implementation_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SuggestionCard extends StatelessWidget {
  final Map json;
  final List<Map<String, String>> answers;
  final void Function(String reason) hidePractice;
  final void Function(String typeId) hidePracticeType;
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  SuggestionCard({this.json, this.answers, this.hidePractice, this.hidePracticeType, this.analytics, this.observer})
      : assert(json != null),
        assert(answers != null),
        assert(hidePracticeType != null),
        assert(hidePracticeType != null),
        assert(analytics != null),
        assert(observer != null);

  void tryPractice(BuildContext context) {
    analytics.logEvent(
      name: 'try_practice',
      parameters: <String, dynamic>{
        'practice': json['practice']['id'].toString(),
      },
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(
          name: 'try_practice',
        ),
        builder: (context) => ImplementationView(
          answers: answers,
          practiceId: json['practice']['external_id'],
          analytics: analytics,
          observer: observer,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var practice = json['practice'];
    var mechanism = practice.containsKey('mechanism') && practice['mechanism'] != null && practice['mechanism'].containsKey('name')
        ? practice['mechanism']['name']
        : '';

    // This weird mapping is because of Dart's inability to cast
    // List<dynamic> into List<Map>.
    var _types = practice.containsKey('types') ? practice['types'] : [];
    List<Map> types = _types.map<Map>((x) => Map.from(x)).toList();
    ///////

    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              child: Text(
                mechanism,
                style: TextStyle(fontSize: 12.0, color: Colors.grey),
                textAlign: TextAlign.left,
              ),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 7.0),
            ),
            Text(
              json['practice']['title'],
              style: TextStyle(
                fontSize: 24.0,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.w600,
              ),
            ),
            Divider(),
            SuggestionTable(jsonPractice: json['practice']),
            SuggestionDrawer(json: this.json),
            ButtonRow(
              hidePractice: hidePractice,
              hidePracticeType: hidePracticeType,
              practiceTypes: types.map<Map>((x) => x).toList(),
              tryPractice: tryPractice,
            ),
          ],
        ),
      ),
    );
  }
}

/// This widget displays quick information in a table. This info is
/// equipment, schedule, impact, benefits and success factors.
class SuggestionTable extends StatelessWidget {
  final Map jsonPractice;

  SuggestionTable({this.jsonPractice}) : assert(jsonPractice != null);

  List<TableRow> getTableRows() {
    List<TableRow> tableRows = List<TableRow>();
    if (jsonPractice.containsKey('equipment') && jsonPractice['equipment'] != null) {
      tableRows.add(getTableRow('Matériel', jsonPractice['equipment']));
    }
    if (jsonPractice.containsKey('schedule') && jsonPractice['schedule'] != null) {
      tableRows.add(getTableRow('Période', jsonPractice['schedule']));
    }
    if (jsonPractice.containsKey('impact') && jsonPractice['impact'] != null) {
      tableRows.add(getTableRow('Impact', jsonPractice['impact']));
    }
    if (jsonPractice.containsKey('additional_benefits') && jsonPractice['additional_benefits'] != null) {
      tableRows.add(getTableRow('Bénéfices', jsonPractice['additional_benefits']));
    }
    if (jsonPractice.containsKey('success_factors') && jsonPractice['success_factors'] != null) {
      tableRows.add(getTableRow('Réussite', jsonPractice['success_factors']));
    }

    return tableRows;
  }

  TableRow getTableRow(header, body) {
    return TableRow(children: [
      Padding(
          child: Text(
            header,
            style: TextStyle(color: Colors.grey, height: 1.3),
          ),
          padding: EdgeInsets.all(5.0)),
      Padding(child: Text(body, style: TextStyle(height: 1.3)), padding: EdgeInsets.all(3.0)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: {0: FixedColumnWidth(80)},
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: getTableRows(),
    );
  }
}

/// Collapsable drawer that containe the long text information
/// about the practice as well as the resource links.
class SuggestionDrawer extends StatelessWidget {
  final Map json;
  final TextStyle bodyStyle = TextStyle(height: 1.3);

  SuggestionDrawer({this.json}) : assert(json != null);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 18.0,
      height: 1.3,
    );

    Widget getTitle(String text) {
      return Padding(
        child: Text(
          text.trim(),
          style: titleStyle,
        ),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
      );
    }

    Widget getBody(String text) {
      return Text(text.trim(), style: bodyStyle);
    }

    List<Widget> _getColumnWidgets() {
      List<Widget> widgets = List<Widget>();

      Map practice = json['practice'];

      if (practice.containsKey('mechanism') && practice['mechanism'] != null && practice['mechanism'].containsKey('description')) {
        widgets.add(getTitle('Marge de manoeuvre'));
        widgets.add(getBody(json['practice']['mechanism']['description']));
      }

      if (practice.containsKey('description') && practice['description'] != null) {
        widgets.add(getTitle('Fonctionnement'));
        widgets.add(getBody(json['practice']['description']));
      }

      if (practice.containsKey('main_resource') && practice['main_resource'] != null) {
        Map mainResource = practice['main_resource'];
        var label = practice.containsKey('main_resource_label') ? practice['main_resource_label'] : 'En savoir plus';

        widgets.add(getTitle(label));
        widgets.add(ResourceLink(json: mainResource));
      }

      var secondaryResources = json['practice'].containsKey('secondary_resources') ? practice['secondary_resources'] : [];

      if (secondaryResources != null && secondaryResources.length > 0) {
        var shouldAddTitle = json['practice'].containsKey('main_resource_label');
        if (shouldAddTitle) {
          widgets.add(getTitle('En savoir plus'));
        }
        widgets.add(Column(
          children: json['practice']['secondary_resources'].map<Widget>((x) => ResourceLink(json: x)).toList(),
        ));
      }
      return widgets;
    }

    return ExpansionTile(
      title: Text(
        'Voir la pratique en détail',
        textAlign: TextAlign.left,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _getColumnWidgets(),
          ),
        )
      ],
    );
  }
}

/// Displays a resource (link to a pdf, site or video). Opens
/// the system's browser when tapped
class ResourceLink extends StatelessWidget {
  final Map json;

  ResourceLink({this.json}) : assert(json != null);

  Icon getIcon() {
    if (this.json['resource_type'] == 'PDF') {
      return Icon(Icons.picture_as_pdf);
    }
    if (this.json['resource_type'] == 'VIDEO') {
      return Icon(Icons.video_library);
    }
    if (this.json['resource_type'] == 'SITE_WEB') {
      return Icon(Icons.language);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Material(
        borderOnForeground: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(side: BorderSide(width: 0.5, color: Colors.grey), borderRadius: BorderRadius.circular(5)),
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            launch(this.json['url']);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              child: getIcon(),
                              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            ),
                            Flexible(
                              child: Text(
                                this.json['name'],
                                style: TextStyle(height: 1.3),
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      ),
                      Text(this.json['description'], style: TextStyle(color: Colors.grey, height: 1.3)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_right)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Button row displayed in the bottom of the suggestion
/// card.
class ButtonRow extends StatelessWidget {
  final double iconSize = 35.0;
  final void Function(String reason) hidePractice;
  final void Function(String typeId) hidePracticeType;
  final void Function(BuildContext context) tryPractice;
  final List<Map> practiceTypes;

  ButtonRow({
    this.hidePractice,
    this.hidePracticeType,
    this.practiceTypes,
    this.tryPractice,
  })  : assert(hidePractice != null),
        assert(hidePracticeType != null),
        assert(practiceTypes != null),
        assert(tryPractice != null);

  SimpleDialogOption _createDialogOption(String text, IconData icon, Function function) {
    return SimpleDialogOption(
      onPressed: function,
      child: Padding(
        child: Row(
          children: <Widget>[
            Padding(
              child: Icon(icon),
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            ),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      ),
    );
  }

  void _blacklistPractice(BuildContext context) {
    List<Widget> widgets = List<Widget>();
    widgets.add(_createDialogOption('J\'ai déjà prévu de mettre en place cette pratique', Icons.visibility_off, ()=> hidePractice('J\'ai déjà prévu de mettre en place cette pratique')));
    widgets.add(_createDialogOption('Cette pratique a été testée ou est en place sur mon exploitation', Icons.visibility_off, ()=> hidePractice('Cette pratique a été testée ou est en place sur mon exploitation')));
    widgets.add(_createDialogOption('Cette pratique n’est pas applicable pour mon exploitation', Icons.visibility_off, ()=> hidePractice('Cette pratique n’est pas applicable pour mon exploitation')));
    widgets.add(_createDialogOption('Autre', Icons.visibility_off, ()=> hidePractice('Autre')));

    widgets.add(_createDialogOption('Annuler', Icons.keyboard_backspace, () => Navigator.pop(context)));

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Cette pratique n\'est pas pertinente ?'),
          children: widgets,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Icon(
                        Icons.cancel,
                        color: Colors.redAccent,
                      ),
                    ),
                    Text(
                      'Recalculer sans cette pratique',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                color: Color.fromARGB(255, 245, 245, 245),
                onPressed: () => _blacklistPractice(context),
              )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Essayer cette pratique',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () => tryPractice(context),
              )),
        ),
      ],
    );
  }
}
