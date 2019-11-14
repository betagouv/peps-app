import 'package:app/resources/api_provider.dart';
import 'package:app/utils/phone_formatter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackDialog extends StatefulWidget {
  final String title = '';
  final String body = '';
  final List<Map<String, String>> answers;
  final FirebaseAnalytics analytics;

  FeedbackDialog({this.answers, this.analytics}) : assert(analytics != null);

  @override
  State<StatefulWidget> createState() {
    return _FeedbackDialogState();
  }
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final PageController pageController = PageController(initialPage: 0);
  bool loading = false;
  bool canContact = false;

  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  final TextEditingController phoneTextController = TextEditingController();
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();

  final Color borderColor = Colors.black26;
  final Color errorBorderColor = Colors.red[200];

  @override
  void initState() {
    super.initState();
    populateUserInfo();
  }

  populateUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      phoneTextController.text = prefs.getString('phoneNumber') ?? '';
      nameTextController.text = prefs.getString('name') ?? '';
      emailTextController.text = prefs.getString('email') ?? '';
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

    if (phoneFocusNode.hasFocus) {
      phoneTextController.selection = TextSelection(baseOffset: 0, extentOffset: phoneTextController.text.length);
    }
    if (nameFocusNode.hasFocus) {
      nameTextController.selection = TextSelection(baseOffset: 0, extentOffset: nameTextController.text.length);
    }
    if (emailFocusNode.hasFocus) {
      emailTextController.selection = TextSelection(baseOffset: 0, extentOffset: emailTextController.text.length);
    }

    return SimpleDialog(
      title: Text('🎙️ Votre avis nous intéresse'),
      children: canContact ? getContactWidgets(context) : getAuthorizationWidgets(context),
    );
  }

  List<Widget> getAuthorizationWidgets(BuildContext context) {
    return <Widget>[
      Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Pouvons-nous vous contacter pour avoir votre retour sur notre application ?',
                style: TextStyle(height: 1.3),
              ),
              ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    child: Text('Non'),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                  RaisedButton(
                    child: Text('Oui', style: TextStyle(color: Colors.white)),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        canContact = true;
                      });
                    },
                  ),
                ],
              ),
            ],
          )),
    ];
  }

  List<Widget> getContactWidgets(BuildContext context) {
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

    TextField emailTextField = TextField(
      decoration: InputDecoration(
        hintText: 'Adresse email',
        icon: Icon(Icons.email),
        counter: Offstage(),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: _isEmailValid() ? borderColor : errorBorderColor,
          ),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      controller: emailTextController,
      focusNode: emailFocusNode,
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

    return [
      Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Column(
            children: <Widget>[
              Text('Merci ! Veuillez remplir les champs ci-desous et nous reviendrons vers vous.'),
              Padding(
                child: nameTextField,
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              ),
              Padding(
                child: phoneTextField,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
              Padding(
                child: emailTextField,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              ),
              ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    child: Text('Confirmer', style: TextStyle(color: Colors.white)),
                    color: Theme.of(context).primaryColor,
                    onPressed: _isButtonDisabled() ? null : () async => _onConfirmPressed(),
                  ),
                ],
              ),
            ],
          )),
    ];
  }

  _onConfirmPressed() async {
    setState(() => loading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var name = nameTextController.text;
    var phoneNumber = phoneTextController.text;
    var email = emailTextController.text;
    var answers = widget.answers == null ? {} : widget.answers;
    var reason = 'Donner du feedback (utilisation depuis l\'app)';

    var _answers = '';

    for (var item in answers) {
      _answers += (item['title'] + '\n' + item['answer'] + '\n\n');
    }

    prefs.setString('name', name);
    prefs.setString('phoneNumber', phoneNumber);
    prefs.setString('email', email);

    try {
      var response = await ApiProvider().sendTask(answers: _answers, email: email, name: name, phone: phoneNumber, reason: reason);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        showDialog(
          context: context,
          builder: _getSuccessBuilder,
        );
      } else {
        Navigator.of(context, rootNavigator: true).pop();
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Widget _getSuccessBuilder(BuildContext context) {
    widget.analytics.logEvent(
      name: 'contact_request_sent',
      parameters: <String, dynamic>{
        'title': 'feedback',
      },
    );

    return AlertDialog(
      title: Text('👍 C\'est noté'),
      content: Text('Notre équipe vous contactera pour avoir vos retours.'),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context, rootNavigator: true).pop();
          },
        )
      ],
    );
  }

  _isButtonDisabled() {
    return !_isNameValid() || !_isPhoneValid() || !_isEmailValid();
  }

  _isNameValid() {
    return nameTextController.text != '' && nameTextController.text != null;
  }

  _isPhoneValid() {
    return phoneTextController.text != null && phoneTextController.text.length == 14;
  }

  _isEmailValid() {
    if (emailTextController.text == null || emailTextController.text == '') {
      return false;
    }
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(emailTextController.text);
  }
}
