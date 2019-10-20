import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app/form/fields/base_field.dart';
import 'package:app/searchable_list.dart';

class SelectField extends Field {
  String selected;

  SelectField({String fieldKey, Map schema, Map options}) : super(fieldKey: fieldKey, schema: schema, options: options);

  @override
  _SelectFieldState createState() {
    var _state = _SelectFieldState();
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
  String getReadableAnswer() {
    if (this.selected != null) {
      for (var item in options['dataSource']) {
        if (item['value'] == this.selected) {
          return item['text'].toString();
        }
      }
    }
    return '';
  }
}

class _SelectFieldState extends State<SelectField> {
  String _value;
  Function _onChanged;

  /// Will display the fullscreen list view to choose from the
  /// different options.
  void showSelectionScreen(BuildContext context) {
    List<SearchableListTile> widgets = List<SearchableListTile>();

    var dataSource = widget.options['dataSource'];
    dataSource.sort((a, b) => a['text'].toString().compareTo(b['text'].toString()));

    for (var item in dataSource) {
      widgets.add(
        SearchableListTile(
          title: Text(item['text']),
          searchTerm: item['text'],
          onTap: () {
            setState(() => _value = item['value']);
            _onChanged(item['value']);
            Navigator.of(context).pop();
          },
        ),
      );
    }

    showBottomSheet(
        context: context,
        builder: (context) {
          return SearchableList(tiles: widgets);
        });
  }

  @override
  Widget build(BuildContext context) {
    String displayText = _value == null ? null : widget.options['dataSource'].firstWhere((x) => x['value'] == _value)['text'];

    return Column(
      children: <Widget>[
        Padding(
          child: Text(
            widget.title,
            style: widget.titleStyle,
          ),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
        ),
        Container(
          child: displayText == null
              ? Container(height: 0)
              : Column(
                  children: <Widget>[
                    Divider(),
                    Padding(
                      child: Text(displayText, style: TextStyle(height: 1.3, color: displayText == null ? Colors.grey : Colors.black)),
                      padding: displayText == null ? EdgeInsets.all(0) : EdgeInsets.fromLTRB(0, 10, 0, 10),
                    ),
                    Divider(),
                  ],
                ),
        ),
        RaisedButton(
          child: Text(
            displayText == null ? 'Choisir' : 'Modifier',
            style: TextStyle(color: Colors.white),
          ),
          color: Theme.of(context).primaryColor,
          onPressed: () => showSelectionScreen(context),
        ),
      ],
    );
  }
}
