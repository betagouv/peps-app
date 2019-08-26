import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app/form/fields/base_field.dart';

/// The array field allows choosing an ordered list of
/// elements from options (implements Alpaca's array field
/// http://www.alpacajs.org/docs/fields/array.html).
class ArrayField extends Field {
  _ArrayFieldState _state;

  ArrayField({String fieldKey, Map schema, Map options})
      : super(fieldKey: fieldKey, schema: schema, options: options);

  @override
  _ArrayFieldState createState() {
    _state = _ArrayFieldState();
    _state._onChanged = this.notifyListeners;
    return _state;
  }

  @override
  Map getJsonValue() {
    var isEmpty = _state._selected.length == 0;
    return {fieldKey: isEmpty ? null : _state._selected.map((item) => item['value']).join(',')};
  }
}

class _ArrayFieldState extends State<ArrayField> {
  List<Map> _selected = List<Map>();
  Function _onChanged;

  /// Allows is to swap places in the state array to move
  /// items up and down. If we specify out-of-bounds positions
  /// the function will just ignore the request.
  void swap(int index1, int index2) {
    if (index1 < 0 ||
        index2 < 0 ||
        index1 >= _selected.length ||
        index2 >= _selected.length) {
      return;
    }
    var tmp = _selected[index1];
    setState(() {
      _selected[index1] = _selected[index2];
      _selected[index2] = tmp;
    });
    _onChanged();
  }

  /// Returns the list of items to be displayed in the
  /// list view.
  List<Widget> getListItems() {
    List<Widget> widgets = List<Widget>();
    for (var i = 0; i < _selected.length; i++) {
      var item = _selected[i];
      widgets.add(ListItem(
        text: item['text'],
        swapUp: () => swap(i, i - 1),
        swapDown: () => swap(i, i + 1),
        onDismissed: (dir) {
          setState(() => _selected.removeAt(i));
          _onChanged();
        },
      ));
    }
    return widgets;
  }

  /// Will display the fullscreen list view to choose from the
  /// different options.
  void showSelectionScreen(BuildContext context) {
    List<Widget> widgets = List<Widget>();
    for (var item in widget.options['items']['dataSource']) {
      widgets.add(
        ListTile(
          title: Text(item['text']),
          onTap: () {
            setState(() {
              _selected.add(item);
            });
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
    var listItems = getListItems();

    return Column(
      children: <Widget>[
        Padding(
          child: Text(
            widget.title,
            style: widget.titleStyle,
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
          color: Theme.of(context).primaryColor,
          onPressed: () => showSelectionScreen(context),
        ),
      ],
    );
  }
}

/// This widget is the list item we display in the list
/// view. It contains the display text as well as arrows
/// to move it up and down. It is also swipable to remove
/// the item from the list.
class ListItem extends StatelessWidget {
  final String text;
  final Function swapUp;
  final Function swapDown;
  final Function onDismissed;
  final bool showDivider;

  ListItem(
      {this.text,
      this.swapUp,
      this.swapDown,
      this.onDismissed,
      this.showDivider});

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
              child:
                  IconButton(icon: Icon(Icons.arrow_upward), onPressed: swapUp),
              padding: EdgeInsets.fromLTRB(16, 0, 4, 0)),
          Padding(
              child: IconButton(
                  icon: Icon(Icons.arrow_downward), onPressed: swapDown),
              padding: EdgeInsets.fromLTRB(4, 0, 16, 0)),
        ],
      ),
    );
  }
}

/// This ScrollBehavior removes the bounce glow displayed when
/// we get to the edge of the screen. It is necessary because the list
/// should not be scrollable, so the display of these glows can confuse
/// the user.
class PlainScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
