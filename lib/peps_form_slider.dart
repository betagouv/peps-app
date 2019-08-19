import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app/form/fields/radio.dart';
import 'package:app/form/fields/checkbox.dart';
import 'package:app/results.dart';
import 'package:app/form/fields/base_field.dart';

class PepsFormSlider extends StatelessWidget {
  final Map properties;
  final Map options;
  final PageController pageController;
  final List<Field> fields;

  PepsFormSlider({this.properties, this.options}) :
    pageController = PageController(initialPage: 0),
    fields = PepsFormSlider.createFields(properties, options);

  static List<Field> createFields(Map properties, Map options) {
    List<Field> fields = [];

    for (var key in properties.keys) {
      if (options[key]['type'] == 'radio') {
        fields.add(RadioField(fieldKey: key, schema: properties[key], options: options[key]));
      } else if (options[key]['type'] == 'checkbox') {
        fields.add(CheckboxField(fieldKey: key, schema: properties[key], options: options[key]));
      }
    }
    return fields;
  }

  List<Widget> _getChildren(BuildContext context) {
    List<Widget> children = [];

    for (var field in this.fields) {
      var isLast = this.fields.last == field;
      var nextCallback = isLast
          ? () => goToSuggestions(context)
          : () => pageController.nextPage(
              duration: Duration(milliseconds: 200), curve: Curves.ease);
      var previousCallback = () => pageController.previousPage(
          duration: Duration(milliseconds: 200), curve: Curves.ease);

      children.add(_FormFieldCard(
        field: field,
        nextCallback: nextCallback,
        previousCallback: previousCallback,
      ));
    }

    return children;
  }

  void goToSuggestions(BuildContext context) {
    Map formResults = {};
    for (var field in this.fields) {
      formResults.addAll(field.getJsonValue());
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Results(formResults: formResults,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: _getChildren(context),
    );
  }
}

class _FormFieldCard extends StatelessWidget {
  final Field field;
  final Function nextCallback;
  final Function previousCallback;

  _FormFieldCard({this.field, this.nextCallback, this.previousCallback});

  @override
  Widget build(BuildContext context) {

    return ListView(
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: this.field,
          ),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FloatingActionButton(
                    onPressed: previousCallback,
                    child: Icon(Icons.arrow_left),
                    heroTag: 'btnP',
                  ),
                ),
                Expanded(
                  child: FloatingActionButton(
                    onPressed: nextCallback,
                    child: Icon(Icons.arrow_right),
                    heroTag: 'btnN',
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
