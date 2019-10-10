import 'package:app/try_contact_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class ImplementationView extends StatefulWidget {
  final Map answers;
  final String practiceId;

  ImplementationView({this.answers, this.practiceId})
      : assert(answers != null),
        assert(practiceId != null);

  @override
  State<StatefulWidget> createState() {
    return _ImplementationViewState();
  }
}

class _ImplementationViewState extends State<ImplementationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('Implementation'),
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
              subtitle: Text('Mettez-vous en relation avec un expert dans le sujet'),
              isThreeLine: true,
              onTap: () => openDialog(context, 'Échanger avec un conseiller', 'Nous reviendrons vers vous avec le contact d\'un expert du sujet.'),
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
              subtitle: Text('Renseignez-vous sur les options pour le matériel nécessaire'),
              isThreeLine: true,
              onTap: () => openDialog(
                  context, 'Trouver du matériel', 'Nous reviendrons vers vous avec des options pour vous procurer du matériel nécessaire.'),
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
              subtitle: Text('Partagez le retour d\'expérience d\'un agriculteur ayant mis en place la pratique'),
              isThreeLine: true,
              onTap: () => openDialog(
                  context, 'Parler à un agriculteur', 'Nous reviendrons vers vous pour vous mettre en contact avec des autres agriculteurs.'),
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
              onTap: () => openDialog(context, 'J\'ai une autre question',
                  'Besoin d\'échanger ? Avez-vous un frein pour la mise en place de cette pratique ? Notre équipe reviendra vers vous pour en discuter.'),
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
    showDialog(
      context: context,
      builder: (context) {
        return TryContactDialog(
          title: title,
          body: body,
          answers: widget.answers,
          practiceId: widget.practiceId,
        );
      },
    );
  }
}
