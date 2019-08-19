import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

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
                style: TextStyle(fontSize: 12.0),
                textAlign: TextAlign.left,
              ),
              padding: EdgeInsets.fromLTRB(0, 0, 0, 7.0),
            ),
            Text(
              json['practice']['title'],
              style: TextStyle(fontSize: 24.0),
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
            style: TextStyle(color: Colors.grey),
          ),
          padding: EdgeInsets.all(5.0)),
      Padding(child: Text(body), padding: EdgeInsets.all(5.0)),
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

class SuggestionDrawer extends StatelessWidget {
  final Map json;

  SuggestionDrawer({this.json});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'Voir la pratique en détail',
        style: TextStyle(color: Colors.green),
      ),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DetailTitleText('Marge de manoeuvre'),
            DetailBodyText(json['practice']['mechanism']['description']),
            DetailTitleText('Fonctionnement'),
            DetailBodyText(json['practice']['description']),
            DetailTitleText('En savoir plus'),
          ],
        )
      ],
    );
  }
}

class DetailTitleText extends StatelessWidget {
  final String content;

  DetailTitleText(this.content);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.content,
      style: TextStyle(
        color: Colors.green,
        fontSize: 18.0,
        height: 1.5,
      ),
    );
  }
}

class DetailBodyText extends StatelessWidget {
  final String content;

  DetailBodyText(this.content);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Text(
          this.content,
          style: TextStyle(
            height: 1.3,
          ),
        ));
  }
}

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
              color: Colors.green,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
            child: RaisedButton(
              child: Text('Essayer', style: TextStyle(color: Colors.white),),
              color: Colors.green,
              onPressed: () => print('pressed'),
            ),
          ),
        ),
      ],
    );
  }
}
