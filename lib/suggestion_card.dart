import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SuggestionCard extends StatelessWidget {
  final Map json;

  SuggestionCard({this.json});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              child: Text(
                json['practice']['mechanism']['name'],
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
                  fontWeight: FontWeight.w600),
            ),
            Divider(),
            SuggestionTable(jsonPractice: json['practice']),
            SuggestionDrawer(json: this.json),
            ButtonRow(),
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

  SuggestionTable({this.jsonPractice});

  List<TableRow> getTableRows() {
    List<TableRow> tableRows = List<TableRow>();
    if (jsonPractice.containsKey('equipment') &&
        jsonPractice['equipment'] != null) {
      tableRows.add(getTableRow('Matériel', jsonPractice['equipment']));
    }
    if (jsonPractice.containsKey('schedule') &&
        jsonPractice['schedule'] != null) {
      tableRows.add(getTableRow('Période', jsonPractice['schedule']));
    }
    if (jsonPractice.containsKey('impact') && jsonPractice['impact'] != null) {
      tableRows.add(getTableRow('Impact', jsonPractice['impact']));
    }
    if (jsonPractice.containsKey('additional_benefits') &&
        jsonPractice['additional_benefits'] != null) {
      tableRows
          .add(getTableRow('Bénéfices', jsonPractice['additional_benefits']));
    }
    if (jsonPractice.containsKey('success_factors') &&
        jsonPractice['success_factors'] != null) {
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
      Padding(
          child: Text(body, style: TextStyle(height: 1.3)),
          padding: EdgeInsets.all(3.0)),
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

  SuggestionDrawer({this.json});

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

      if (practice.containsKey('mechanism') &&
          practice['mechanism'].containsKey('description')) {
        widgets.add(getTitle('Marge de manoeuvre'));
        widgets.add(getBody(json['practice']['mechanism']['description']));
      }

      if (practice.containsKey('description')) {
        widgets.add(getTitle('Fonctionnement'));
        widgets.add(getBody(json['practice']['description']));
      }

      if (practice.containsKey('main_resource')) {
        Map mainResource = practice['main_resource'];
        var label = practice.containsKey('main_resource_label')
            ? practice['main_resource_label']
            : 'En savoir plus';

        widgets.add(getTitle(label));
        widgets.add(ResourceLink(json: mainResource));
      }

      if (json['practice'].containsKey('secondary_resources')) {
        var shouldAddTitle =
            json['practice'].containsKey('main_resource_label');
        if (shouldAddTitle) {
          widgets.add(getTitle('En savoir plus'));
        }
        widgets.add(Column(
          children: json['practice']['secondary_resources']
              .map<Widget>((x) => ResourceLink(json: x))
              .toList(),
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
          padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
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

  ResourceLink({this.json});

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
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: Material(
        borderOnForeground: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5, color: Colors.grey),
            borderRadius: BorderRadius.circular(5)),
        color: Colors.transparent,
        child: InkWell(
          onTap: () => launch(Uri.encodeFull(this.json['url'])),
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
                              Text(this.json['name']),
                            ],
                          ),
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        ),
                        Text(this.json['description'],
                            style: TextStyle(color: Colors.grey, height: 1.3)),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_right)
                ],
              )),
        ),
      ),
    );
  }
}

/// Button row displayed in the bottom of the suggestion
/// card.
class ButtonRow extends StatelessWidget {
  final double iconSize = 35.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Icon(
            Icons.delete_outline,
            size: this.iconSize,
            color: Colors.red,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 45, 0),
            child: Icon(
              Icons.bookmark_border,
              size: this.iconSize,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
            child: RaisedButton(
              child: Text(
                'Essayer',
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () => print('pressed'),
            ),
          ),
        ),
      ],
    );
  }
}
