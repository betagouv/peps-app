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
    _state._onChanged = this.notifyListeners;
    return _state;
  }

  @override
  Map getJsonValue() {
    var isEmpty = _state._selected.length == 0;
    return {fieldKey: isEmpty ? null : _state._selected.join(',')};
  }
}

class _CheckboxFieldState extends State<CheckboxField> {
  List<String> _selected = List<String>();
  Function _onChanged;

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
        onChanged: (bool newValue) {
          toggleValue(value, newValue);
          _onChanged();
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
