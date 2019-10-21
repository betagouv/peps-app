import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app/form/fields/base_field.dart';

class RadioField extends Field {

  String selected;

  RadioField({String fieldKey, Map schema, Map options})
      : super(fieldKey: fieldKey, schema: schema, options: options);

  @override
  _RadioFieldState createState() {
    var _state = _RadioFieldState();
    _state._onChanged = onChanged;
    return _state;
  }

  onChanged(_selected) {
    this.selected = _selected;
    notifyListeners();
  }

  @override
  Map getJsonValue() {
    return {fieldKey: this.selected};
  }

  @override
  void logAnswer(FirebaseAnalytics analytics) {
    if (this.shouldLogAnswer && this.selected != null && this.selected != '') {
      analytics.logEvent(
        name: this.selected,
        parameters: <String, dynamic>{},
      );
    }
  }

  @override
  String getReadableAnswer() {
    var dataSource = options.containsKey('dataSource')
        ? options['dataSource']
        : schema['enum'].map((x) => {'text': x, 'value': x}).toList();
    if (this.selected != null) {
      for (var item in dataSource) {
        if(item['value'] == this.selected) {
          return item['text'].toString();
        }
      }
    }
    return '';
  }
}

class _RadioFieldState extends State<RadioField> {
  String _value;
  Function _onChanged;

  Widget get radioList {
    List<Widget> radioListTiles = [];

    List dataSource = widget.options.containsKey('dataSource')
        ? widget.options['dataSource']
        : widget.schema['enum'].map((x) => {'text': x, 'value': x}).toList();

    if (widget.options['sort'] == true) {
      dataSource.sort((a, b) => a['text'].compareTo(b['text']));
    }

    for (var item in dataSource) {
      radioListTiles.add(
        RadioListTile<String>(
          title: Text(item['text']),
          value: item['value'],
          groupValue: _value,
          onChanged: (String newValue) {
            setState(() => _value = newValue);
            _onChanged(newValue);
          },
        ),
      );
    }
    return Column(
      children: radioListTiles,
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
        this.radioList,
      ],
    );
  }
}
