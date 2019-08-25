import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app/form/fields/radio.dart';
import 'package:app/form/fields/checkbox.dart';
import 'package:app/form/fields/array.dart';
import 'package:app/results.dart';
import 'package:app/form/fields/base_field.dart';

class PepsFormSlider extends StatelessWidget {
  final Map properties;
  final Map options;
  final PageController pageController;
  final List<Field> fields;
  List<int> fieldStack = [0];

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
      } else if (options[key]['type'] == 'array') {
        fields.add(ArrayField(fieldKey: key, schema: properties[key], options: options[key]));
      }
    }
    return fields;
  }

  List<Widget> _getChildren(BuildContext context) {
    List<Widget> children = [];

      var nextCallback = () {
          var nextPage = pageController.page.toInt();

          /// We need to find the next page that has its dependencies satisfied
          /// from the answers provided so far.
          while (nextPage < fields.length - 1) {
            nextPage += 1;

            var answers = {};
            for (var i = 0; i <= pageController.page.toInt(); i++) {
              answers.addAll(fields[i].getJsonValue());
            }

            if (fields[nextPage].dependenciesAreMet(answers)) {
              pageController.animateToPage(nextPage, duration: Duration(milliseconds: 200), curve: Curves.ease);
              fieldStack.add(nextPage);
              return;
            }
          }
          /// We reached the end of the pages, we need to go to the suggestions page.
          goToSuggestions(context);
        };

      var previousCallback = () {
        if (fieldStack.length > 1) {
          fieldStack.removeLast();
          pageController.animateToPage(fieldStack.last, duration: Duration(milliseconds: 200), curve: Curves.ease);
        }
      };

      for (var field in this.fields) {
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
      physics: NeverScrollableScrollPhysics(),
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
