import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app/form/fields/base_field.dart';

class CheckboxField extends Field {

  List<String> selected = List<String>();

  CheckboxField({String fieldKey, Map schema, Map options})
      : super(fieldKey: fieldKey, schema: schema, options: options);

  @override
  _CheckboxFieldState createState() {
    var state = _CheckboxFieldState();
    state._onChanged = onChanged;
    return state;
  }

  onChanged(_selected) {
    this.selected = [];
    for (var item in _selected) {
      this.selected.add(item);
    }
    notifyListeners();
  }

  @override
  Map getJsonValue() {
    var isEmpty = selected.length == 0;
    return {fieldKey: isEmpty ? null : selected.join(',')};
  }

  @override
  void logAnswer(FirebaseAnalytics analytics) {
    if (this.shouldLogAnswer && this.selected != null) {
      for (var item in this.selected) {
        analytics.logEvent(
          name: item,
          parameters: <String, dynamic>{},
        );
      }
    }
  }

  @override
  String getReadableAnswer() {
    List<String> readableAnswers = <String>[];
    if (this.selected == null) {
      return '';
    }
    for (var selectedItem in this.selected) {
      for (var item in options['dataSource']) {
        if (item['value'] == selectedItem) {
          readableAnswers.add(item['text']);
        }
      }
    }
    return readableAnswers.join(', ');
  }
}

class _CheckboxFieldState extends State<CheckboxField> {
  List<String> _selected = List<String>();
  Function _onChanged;

  void toggleValue(String value, bool toggle) {
    toggle ? _selected.add(value) : _selected.remove(value);
    setState(() => _selected);
    _onChanged(_selected);
  }

  Widget get checkboxList {
    List<Widget> checkboxList = [];

    List dataSource = widget.options['dataSource'];

    if (widget.options['sort'] == true) {
      dataSource.sort((a, b) => a['text'].compareTo(b['text']));
    }

    for (var item in dataSource) {
      var text = item['text'];
      var value = item['value'];
      var checked = _selected.contains(item['value']);

      checkboxList.add(CheckboxListTile(
        title: Text(text),
        value: checked,
        onChanged: (bool newValue) {
          toggleValue(value, newValue);
        },
      ));
    }
    return Column(
      children: checkboxList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          widget.title,
          style: widget.titleStyle,
        ),
        this.checkboxList,
      ],
    );
  }
}
