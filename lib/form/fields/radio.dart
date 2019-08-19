import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app/form/fields/base_field.dart';

class RadioField extends Field {

  _RadioFieldState _state;

  RadioField({String fieldKey, Map schema, Map options})
      : super(fieldKey: fieldKey, schema: schema, options: options);

  @override
  _RadioFieldState createState() {
    _state = _RadioFieldState();
    return _state;
  }

  @override
  Map getJsonValue() {
    return {fieldKey: _state._value};
  }
}

class _RadioFieldState extends State<RadioField> {
  String _value;

  Widget get radioList {
    List<Widget> radioListTiles = [];

    var dataSource = widget.options.containsKey('dataSource')
        ? widget.options['dataSource']
        : widget.schema['enum'].map((x) => {'text': x, 'value': x});

    for (var item in dataSource) {
      radioListTiles.add(
        RadioListTile<String>(
          title: Text(item['text']),
          value: item['value'],
          groupValue: _value,
          onChanged: (String newValue) => setState(() => _value = newValue),
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
          style: TextStyle(fontSize: 30.0),
        ),
        this.radioList,
      ],
    );
  }
}
