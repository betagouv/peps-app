import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app/form/fields/base_field.dart';

class ArrayField extends Field {
  _ArrayFieldState _state;

  ArrayField({String fieldKey, Map schema, Map options})
      : super(fieldKey: fieldKey, schema: schema, options: options);

  @override
  _ArrayFieldState createState() {
    _state = _ArrayFieldState();
    return _state;
  }

  @override
  Map getJsonValue() {
    return {fieldKey: _state._selected.map((item) => item['value']).join(',')};
  }
}

class _ArrayFieldState extends State<ArrayField> {
  List<Map> _selected = List<Map>();

  void swap(int index1, int index2) {
    if (index1 < 0 || index2 < 0 || index1 >= _selected.length || index2 >= _selected.length) {
      return;
    }
    var tmp = _selected[index1];
    setState(() {
      _selected[index1] = _selected[index2];
      _selected[index2] = tmp;
    });
  }

  List<Widget> getListItems() {
    List<Widget> widgets = List<Widget>();
    for (var i = 0; i < _selected.length; i++) {
      var item = _selected[i];
      widgets.add(ListItem(
        text: item['text'],
        swapUp: () => swap(i, i - 1),
        swapDown: () => swap(i, i + 1),
        onDismissed: (dir) => setState(() => _selected.removeAt(i)),
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    var listItems = getListItems();

    return Column(
      children: <Widget>[
        Padding(
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 30.0),
          ),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
        ),
        Padding(
            child: ScrollConfiguration(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: _selected.length,
                itemBuilder: (context, index) => listItems[index],
                shrinkWrap: true,
              ),
              behavior: PlainScrollBehavior(),
            ),
            padding:
                EdgeInsets.fromLTRB(0, 0, 0, _selected.length > 0 ? 10 : 0)),
        RaisedButton(
          child: Text(
            'Ajouter une culture',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.green,
          onPressed: () {
            setState(() {
              _selected.add(
                  widget.options['items']['dataSource'][Random().nextInt(5)]);
            });
          },
        ),
      ],
    );
  }
}


class ListItem extends StatelessWidget {

  final String text;
  final Function swapUp;
  final Function swapDown;
  final Function onDismissed;


  ListItem({this.text, this.swapUp, this.swapDown, this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
          key: UniqueKey(),
          background: Container(color: Colors.red),
          direction: DismissDirection.horizontal,
          onDismissed: this.onDismissed,
          child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    child: Text(text),
                    padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                  ),
                ),
                Padding(
                    child: IconButton(
                        icon: Icon(Icons.arrow_upward),
                        onPressed: swapUp
                      ),
                    padding: EdgeInsets.fromLTRB(16, 0, 4, 0)),
                Padding(
                    child: IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: swapDown
                    ),
                    padding: EdgeInsets.fromLTRB(4, 0, 16, 0)),
              ],
            ),
          );
  }
  
}

// Removes glow in the array list when reaching the edges of the scroll
class PlainScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
