import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app/form/fields/base_field.dart';

class CheckboxField extends Field {

  _CheckboxFieldState _state;

  CheckboxField({String fieldKey, Map schema, Map options})
      : super(fieldKey: fieldKey, schema: schema, options: options);

  @override
  _CheckboxFieldState createState() {
    _state = _CheckboxFieldState();
    return _state;
  }

  @override
  Map getJsonValue() {
    return {fieldKey: _state._selected.join(',')};
  }
}

class _CheckboxFieldState extends State<CheckboxField> {
  List<String> _selected = List<String>();

  void toggleValue(String value, bool toggle) {
    setState(() {
      toggle ? _selected.add(value) : _selected.remove(value);
    });
  }

  Widget get checkboxList {
    List<Widget> checkboxList = [];
    for (var item in widget.options['dataSource']) {
      var text = item['text'];
      var value = item['value'];
      var checked = _selected.contains(item['value']);

      checkboxList.add(CheckboxListTile(
        title: Text(text),
        value: checked,
        onChanged: (bool newValue) => toggleValue(value, newValue),
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
          style: TextStyle(fontSize: 30.0),
        ),
        this.checkboxList,
      ],
    );
  }
}
