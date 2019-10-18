import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:http/http.dart' as http;
import 'package:app/utils/phone_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TryContactDialog extends StatefulWidget {
  final String title;
  final String body;
  final List<Map<String, String>> answers;
  final String practiceId;
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  TryContactDialog({this.title, this.body, this.answers, this.practiceId, this.analytics, this.observer})
      : assert(title != null),
        assert(body != null),
        assert(answers != null),
        assert(practiceId != null),
        assert(analytics != null),
        assert(observer != null);

  Future createTask(String name, String phoneNumber, String datetime) async {

    var _answers = '';

    for (var item in answers) {
      _answers += (item['title'] + '\n' + item['answer'] + '\n\n');
    }

    return await http.post(
      new Uri.http(DotEnv().env['BACKEND_URL'], '/api/v1/sendTask'),
      body: jsonEncode({
        'answers': _answers,
        'email': '',
        'name': name,
        'phone_number': phoneNumber,
        'datetime': datetime,
        'practice_id': practiceId,
        'problem': title,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Api-Key ' + DotEnv().env['API_KEY'],
      },
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _TryContactDialogState(title: title, body: body, createTask: createTask);
  }
}

class _TryContactDialogState extends State<TryContactDialog> {
  DateTime selectedDate;
  String timeFrame;
  String phoneNumber;
  String name;

  bool loading;

  final String title;
  final String body;
  final Function createTask;
  final DateTime today = DateTime.now();

  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final TextEditingController phoneTextController = TextEditingController();
  final TextEditingController nameTextController = TextEditingController();
  final Color borderColor = Colors.black26;

  final Color errorBorderColor = Colors.red[200];
  final List<DropdownMenuItem<int>> timeFrames = [
    DropdownMenuItem<int>(value: 10, child: Text('Matin')),
    DropdownMenuItem<int>(value: 14, child: Text('Après-midi')),
    DropdownMenuItem<int>(value: 17, child: Text('Soir')),
  ];

  _TryContactDialogState({this.title, this.body, this.createTask})
      : assert(title != null),
        assert(body != null),
        assert(createTask != null);

  @override
  void initState() {
    super.initState();
    populateUserInfo();
    var now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day, timeFrames[0].value);
    loading = false;

    phoneFocusNode.addListener(() {
      if (!phoneFocusNode.hasFocus) {
        setState(() => phoneNumber = phoneTextController.text);
      }
    });

    nameFocusNode.addListener(() {
      if (!nameFocusNode.hasFocus) {
        setState(() => name = nameTextController.text);
      }
    });
  }

  populateUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      phoneNumber = prefs.getString('phoneNumber') ?? '';
      name = prefs.getString('name') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SimpleDialog(
        contentPadding: EdgeInsets.fromLTRB(0, 30, 0, 30),
        children: <Widget>[
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      );
    }

    phoneTextController.text = phoneNumber;
    nameTextController.text = name;

    if (phoneFocusNode.hasFocus) {
      phoneTextController.selection = TextSelection(baseOffset:0, extentOffset:phoneTextController.text.length);
    }
    if (nameFocusNode.hasFocus) {
      nameTextController.selection = TextSelection(baseOffset:0, extentOffset:nameTextController.text.length);
    }

    TextField nameTextField = TextField(
      decoration: InputDecoration(
        hintText: 'Nom et prénom',
        icon: Icon(Icons.account_circle),
        counter: Offstage(),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: _isNameValid() ? borderColor : errorBorderColor,
          ),
        ),
      ),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      controller: nameTextController,
      focusNode: nameFocusNode,
    );

    TextField phoneTextField = TextField(
      decoration: InputDecoration(
        hintText: '06 12 34 56 78',
        icon: Icon(Icons.phone),
        counter: Offstage(),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: _isPhoneValid() ? borderColor : errorBorderColor,
          ),
        ),
      ),
      keyboardType: TextInputType.number,
      maxLength: 14,
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly,
        PhoneTextInputFormatter(),
      ],
      controller: phoneTextController,
      focusNode: phoneFocusNode,
    );

    // We have to use a GestureDetector to avoir issues with the dialog
    GestureDetector calendarInput = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        DateTime date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: today.subtract(new Duration(days: 1)),
          lastDate: DateTime(today.year + 1),
        );
        if (date != null) {
          setState(() {
            selectedDate = DateTime(date.year, date.month, date.day, selectedDate.hour);
          });
        }
      },
      child: IgnorePointer(
        child: TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Choisissez une date',
            icon: Icon(Icons.calendar_today),
          ),
          keyboardType: TextInputType.datetime,
          controller: TextEditingController(
            text: DateFormat('dd-MM-yyyy').format(selectedDate),
          ),
        ),
      ),
    );

    DropdownButton<int> hourDropdown = DropdownButton<int>(
      value: selectedDate.hour,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 1,
        color: borderColor,
      ),
      onChanged: (int hour) {
        setState(() {
          selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, hour);
        });
      },
      items: timeFrames,
    );

    return SimpleDialog(title: Text(title), children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: Column(
          children: <Widget>[
            Text(
              body,
              style: TextStyle(height: 1.3),
            ),
            Padding(
              child: nameTextField,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            ),
            Padding(
              child: phoneTextField,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            ),
            Text(
              'Quelle jour seriez-vous disponible pour être contacté par notre équipe ?',
            ),
            Padding(
              child: calendarInput,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            ),
            Row(
              children: <Widget>[
                Padding(
                  child: Icon(
                    Icons.watch_later,
                    size: 24,
                    color: Colors.black38,
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                ),
                hourDropdown
              ],
            ),
          ],
        ),
      ),
      ButtonBar(
        children: <Widget>[
          RaisedButton(
            child: Text('Annuler'),
            onPressed: () => Navigator.pop(context),
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
            onPressed: _isButtonDisabled() ? null : () async => _onConfirmPressed(),
          ),
        ],
      )
    ]);
  }

  _isButtonDisabled() {
    return !_isNameValid() || !_isPhoneValid() || !_isDateValid();
  }

  _isNameValid() {
    return nameTextController.text != '' && nameTextController.text != null;
  }

  _isPhoneValid() {
    return phoneTextController.text != null && phoneTextController.text.length == 14;
  }

  _isDateValid() {
    return selectedDate != null;
  }

  _onConfirmPressed() async {
    setState(() => loading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var name = nameTextController.text;
    var phoneNumber = phoneTextController.text;

    prefs.setString('name', name);
    prefs.setString('phoneNumber', phoneNumber);

    var response = await createTask(name, phoneNumber, selectedDate.toIso8601String());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      showDialog(
        context: context,
        builder: _getSuccessBuilder,
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => _getFailBuilder(context, response),
      );
    }
    setState(() => loading = false);
  }

  Widget _getSuccessBuilder(BuildContext context) {

    widget.analytics.logEvent(
      name: 'contact_request_sent',
      parameters: <String, dynamic>{
        'title': title,
      },
    );

    return AlertDialog(
      title: Text('👍 C\'est noté'),
      content: Text('Notre équipe vous contactera pour faciliter la mise en place.'),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).popUntil((Route<dynamic> route) {
              return route.settings.name == 'try_practice';
            });
          },
        )
      ],
    );
  }

  Widget _getFailBuilder(BuildContext context, http.Response response) {

    widget.analytics.logEvent(
      name: 'contact_request_failed',
      parameters: <String, dynamic>{
        'title': title,
      },
    );

    return AlertDialog(
      title: Text('🙁 Oops !'),
      content: Text('Une erreur est survenue lors de la prise de rendez-vous.'),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
