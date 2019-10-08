import 'package:app/utils/phone_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImplementationView extends StatefulWidget {
  _ImplementationViewState _state;

  @override
  State<StatefulWidget> createState() {
    _state = _ImplementationViewState();
    return _state;
  }
}

class _ImplementationViewState extends State<ImplementationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Mise en place'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Text(
              'Comment pouvons-nous vous aider à la mise en place ?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 30.0,
                fontFamily: 'SourceSansPro',
              ),
            ),
            padding: EdgeInsets.all(20),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.contacts,
                size: 40.0,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Échanger avec un conseiller'),
              trailing: Icon(Icons.keyboard_arrow_right),
              subtitle:
                  Text('Mettez-vous en relation avec un expert dans le sujet'),
              isThreeLine: true,
              onTap: () => openDialog(context, 'Échanger avec un conseiller',
                  'Nous reviendrons vers vous avec le contact d\'un expert du sujet.'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.build,
                size: 40.0,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Trouver du matériel'),
              trailing: Icon(Icons.keyboard_arrow_right),
              subtitle: Text(
                  'Renseignez-vous sur les options pour le matériel nécessaire'),
              isThreeLine: true,
              onTap: () => openDialog(context, 'Trouver du matériel',
                  'Nous reviendrons vers vous avec des options pour vous procurer du matériel nécessaire.'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.group,
                size: 40.0,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Parler à un agriculteur'),
              trailing: Icon(Icons.keyboard_arrow_right),
              subtitle: Text(
                  'Partagez le retour d\'expérience d\'un agriculteur ayant mis en place la pratique'),
              isThreeLine: true,
              onTap: () => openDialog(context, 'Parler à un agriculteur',
                  'Nous reviendrons vers vous pour vous mettre en contact avec des autres agriculteurs.'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.help,
                size: 40.0,
                color: Colors.black54,
              ),
              title: Text('J\'ai une autre question'),
              trailing: Icon(Icons.keyboard_arrow_right),
              isThreeLine: false,
              onTap: () => openDialog(context, 'J\'ai une autre question', ''),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.check,
                size: 40.0,
                color: Colors.black54,
              ),
              title: Text('J\'ai tout ce qu\'il faut'),
              trailing: Icon(Icons.keyboard_arrow_right),
              isThreeLine: false,
              onTap: () => openDialog(context, 'J\'ai tout', ''),
            ),
          ),
        ],
      ),
    );
  }

  openDialog(BuildContext context, String title, String body) {
    var today = DateTime.now();
    var selectedDate = today;

    TextField dateField = TextField(
      readOnly: true,
      decoration:
          InputDecoration(hintText: '', icon: Icon(Icons.calendar_today)),
      keyboardType: TextInputType.datetime,
      controller: TextEditingController(),
    );

    showDialog(
        context: context,
        builder: (context) {
          return ContactDialog(title: title, body: body);
        });
  }
}

class ContactDialog extends StatefulWidget {
  final String title;
  final String body;

  ContactDialog({this.title, this.body});

  _ContactDialogState _state;

  @override
  State<StatefulWidget> createState() {
    _state = _ContactDialogState();
    _state.selectedDate = DateTime.now();
    _state.timeFrame = 'Matin';
    _state.phoneNumber = '';
    _state.title = title;
    _state.body = body;
    return _state;
  }
}

class _ContactDialogState extends State<ContactDialog> {
  DateTime selectedDate;
  String timeFrame;
  String phoneNumber;
  String title;
  String body;

  final DateTime today = DateTime.now();
  final List<String> timeFrames = ['Matin', 'Après-midi', 'Soir'];
  final FocusNode _focusNode = FocusNode();
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() => phoneNumber = textController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    textController.text = phoneNumber;

    return SimpleDialog(title: Text(title), children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: <Widget>[
            Text(
              body,
              style: TextStyle(height: 1.3),
            ),
            Padding(
              child: TextField(
                decoration: InputDecoration(
                    hintText: '06 12 34 56 78', icon: Icon(Icons.phone), counter: Offstage()),
                keyboardType: TextInputType.number,
                maxLength: 14,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  PhoneTextInputFormatter(),
                ],
                controller: textController,
                focusNode: _focusNode,
              ),
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            ),
            Text(
              'Quelle jour seriez-vous disponible pour être contacté par notre équipe ?',
            ),
            Padding(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  DateTime picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: today.subtract(new Duration(days: 1)),
                    lastDate: DateTime(today.year + 1),
                  );
                  setState(() {
                    selectedDate = picked != null ? picked : selectedDate;
                  });
                },
                child: IgnorePointer(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                        hintText: 'Choisissez une date',
                        icon: Icon(Icons.calendar_today)),
                    keyboardType: TextInputType.datetime,
                    controller: TextEditingController(
                        text: DateFormat('dd-MM-yyyy').format(selectedDate)),
                  ),
                ),
              ),
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            ),
            Row(
              children: <Widget>[
                Padding(
                  child: Icon(Icons.watch_later, size: 24, color: Colors.black38,),
                  padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                ),
                DropdownButton<String>(
                  value: timeFrame,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 1,
                    color: Colors.black26,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      timeFrame = newValue;
                    });
                  },
                  items:
                      timeFrames.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ),
          ],
        ),
      ),
      ButtonBar(
        children: <Widget>[
          RaisedButton(
            child: Text('Annuler'),
            onPressed: () => print('Annuler'),
          ),
          RaisedButton(
            color: Theme.of(context).accentColor,
            child: Text(
              'Confirmer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            onPressed: () => print('Confirmer'),
          ),
        ],
      )
    ]);
  }
}
