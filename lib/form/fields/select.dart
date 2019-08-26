import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app/form/fields/base_field.dart';

class SelectField extends Field {
  _SelectFieldState _state;

  SelectField({String fieldKey, Map schema, Map options})
      : super(fieldKey: fieldKey, schema: schema, options: options);

  @override
  _SelectFieldState createState() {
    _state = _SelectFieldState();
    _state._onChanged = this.notifyListeners;
    return _state;
  }

  @override
  Map getJsonValue() {
    return {fieldKey: _state._value};
  }
}

class _SelectFieldState extends State<SelectField> {
  String _value;
  Function _onChanged;

  /// Will display the fullscreen list view to choose from the
  /// different options.
  void showSelectionScreen(BuildContext context) {
    List<Widget> widgets = List<Widget>();
    for (var item in widget.options['dataSource']) {
      widgets.add(
        ListTile(
          title: Text(item['text']),
          onTap: () {
            setState(() => _value = item['value']);
            _onChanged();
            Navigator.of(context).pop();
          },
        ),
      );
    }

    showBottomSheet(
        context: context,
        builder: (context) {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: widgets.length,
            itemBuilder: (context, index) => widgets[index],
            shrinkWrap: true,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String displayText = _value == null
        ? null
        : widget.options['dataSource']
            .firstWhere((x) => x['value'] == _value)['text'];

    return Column(
      children: <Widget>[
        Padding(
          child: Text(
            widget.title,
            style: widget.titleStyle,
          ),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
        ),
        Divider(),
        Padding(
          child: Text(displayText == null ? 'Pas de sélection' : displayText,
              style: TextStyle(
                  height: 1.3,
                  color: displayText == null ? Colors.grey : Colors.black)),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        ),
        Divider(),
        RaisedButton(
          child: Text(
            displayText == null ? 'Choisir' : 'Modifier',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.green,
          onPressed: () => showSelectionScreen(context),
        ),
      ],
    );
  }
}
