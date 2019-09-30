import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImplementationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextField dateField = TextField(
      readOnly: true,
      decoration:
          InputDecoration(hintText: '', icon: Icon(Icons.calendar_today)),
      keyboardType: TextInputType.datetime,
      controller: TextEditingController(),
    );

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Text(
            'Besoin d\'aide ou des précissions supplémentaires ? Laissez nous vos coordonnées et quelqu\'un de notre équipe vous aidera pour la suite !',
            style: TextStyle(height: 1.3),
          ),
          Padding(
            child: TextField(
              decoration: InputDecoration(
                  hintText: '06 12 34 56 78', icon: Icon(Icons.phone)),
              keyboardType: TextInputType.number,
            ),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
          ),
          Text(
              'Quelle jour seriez-vous disponible pour être contacté par notre équipe ?'),
          Padding(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                DateTime picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2019),
                    lastDate: DateTime(2020));
                dateField.controller.text = DateFormat('dd-MM-yyyy').format(picked);
              },
              child: IgnorePointer(
                child: dateField,
              ),
            ),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
          ),
        ],
      ),
    );
  }
}
