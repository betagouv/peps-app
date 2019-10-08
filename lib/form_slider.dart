import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app/form/fields/radio.dart';
import 'package:app/form/fields/checkbox.dart';
import 'package:app/form/fields/array.dart';
import 'package:app/form/fields/select.dart';
import 'package:app/suggestions.dart';
import 'package:app/form/fields/base_field.dart';

class FormSlider extends StatelessWidget {
  final Map properties;
  final Map options;
  final PageController pageController;
  final List<Field> fields;
  List<int> fieldStack = [0];

  FormSlider({this.properties, this.options})
      : pageController = PageController(initialPage: 0),
        fields = FormSlider.createFields(properties, options);

  static List<Field> createFields(Map properties, Map options) {
    List<Field> fields = [];

    for (var key in properties.keys) {
      if (options[key]['type'] == 'radio') {
        fields.add(RadioField(
            fieldKey: key, schema: properties[key], options: options[key]));
      } else if (options[key]['type'] == 'checkbox') {
        fields.add(CheckboxField(
            fieldKey: key, schema: properties[key], options: options[key]));
      } else if (options[key]['type'] == 'array') {
        fields.add(ArrayField(
            fieldKey: key, schema: properties[key], options: options[key]));
      } else if (options[key]['type'] == 'select') {
        fields.add(SelectField(
            fieldKey: key, schema: properties[key], options: options[key]));
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
          pageController.animateToPage(nextPage,
              duration: Duration(milliseconds: 200), curve: Curves.ease);
          fieldStack.add(nextPage);
          return;
        }
      }

      /// We reached the end of the pages, we need to go to the suggestions page.
      goToSuggestions(context);
    };

    for (var field in this.fields) {
      children.add(_FormFieldCard(
        field: field,
        nextCallback: nextCallback,
        previousCallback: field == this.fields.first ? null : this.goBack,
        key: PageStorageKey('Page' + this.fields.indexOf(field).toString()),
      ));
    }

    return children;
  }

  void goToSuggestions(BuildContext context) {
    Map formResults = {};
    for (var field in this.fields) {
      formResults.addAll(field.getJsonValue());
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => Suggestions(
                  formResults: formResults,
                )),
        (Route<dynamic> route) {
          return route.isFirst;
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: _getChildren(context),
      ),
    );
  }

  void goBack() {
    if (fieldStack.length > 1) {
      fieldStack.removeLast();
      pageController.animateToPage(fieldStack.last,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    }
  }

  Future<bool> _onWillPop() {
    var shouldClose = fieldStack.length == 1;
    goBack();
    return Future.value(shouldClose);
  }
}

class _FormFieldCard extends StatefulWidget {
  final Field field;
  final Function nextCallback;
  final Function previousCallback;

  _FormFieldCardState _state;
  _FormFieldCard(
      {this.field, this.nextCallback, this.previousCallback, Key key})
      : super(key: key);

  void onChanged() {
    var fieldValue = field.getJsonValue();
    var isEmpty = true;
    for (var key in fieldValue.keys) {
      if (fieldValue[key] != null) {
        isEmpty = false;
        break;
      }
    }
    _state.toggleButton(!isEmpty);
  }

  _FormFieldCardState createState() {
    _state = _FormFieldCardState();
    field.removeListener(onChanged);
    field.addListener(onChanged);
    return _state;
  }
}

class _FormFieldCardState extends State<_FormFieldCard>
    with AutomaticKeepAliveClientMixin {
  bool nextEnabled = false;

  void toggleButton(bool active) {
    setState(() => nextEnabled = active);
  }

  List<Widget> getButtons() {
    List<Widget> widgets = List<Widget>();
    if (widget.previousCallback != null) {
      widgets.add(Padding(
        child: FloatingActionButton(
          onPressed: widget.previousCallback,
          child: Icon(Icons.arrow_left),
          heroTag: 'btnP' + widget.key.toString(),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
      ));
    }
    widgets.add(FloatingActionButton(
      onPressed: nextEnabled ? widget.nextCallback : null,
      child: Icon(Icons.arrow_right),
      disabledElevation: 0,
      heroTag: 'btnN' + widget.key.toString(),
      backgroundColor:
          nextEnabled ? Theme.of(context).primaryColor : Colors.grey[300],
    ));
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: widget.field,
          ),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: getButtons(),
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
