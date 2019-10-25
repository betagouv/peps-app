import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app/form/fields/base_field.dart';
import 'package:app/searchable_list.dart';

/// The array field allows choosing an ordered list of
/// elements from options (implements Alpaca's array field
/// http://www.alpacajs.org/docs/fields/array.html).
class ArrayField extends Field {

  List<String> selected;
  PersistentBottomSheetController bottomSheetController;

  ArrayField({String fieldKey, Map schema, Map options})
      : super(fieldKey: fieldKey, schema: schema, options: options);

  @override
  _ArrayFieldState createState() {
    var _state = _ArrayFieldState();
    _state._onChanged = onChanged;
    return _state;
  }

  onChanged(_selected) {
    if (_selected.length == 0) {
      this.selected = null;
    } else {
      this.selected = _selected.map<String>((item) => item['value'].toString()).toList();
    }
    notifyListeners();
  }

  @override
  Map getJsonValue() {
    return {fieldKey: this.selected};
  }

  @override
  String getReadableAnswer() {
    var dataSource = options['items']['dataSource'];
    List<String> readableAnswers = <String>[];
    if (this.selected == null) {
      return '';
    }
    for (var selectedItem in this.selected) {
      for (var item in dataSource) {
        if (item['value'] == selectedItem) {
          readableAnswers.add(item['text']);
        }
      }
    }
    return readableAnswers.join(', ');
  }

  @override
  bool canGoBack() {
    if (bottomSheetController != null) {
      bottomSheetController.close();
      bottomSheetController = null;
      return false;
    }
    return super.canGoBack();
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
    _onChanged(_selected);
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
          _onChanged(_selected);
        },
      ));
    }
    return widgets;
  }

  /// Will display the fullscreen list view to choose from the
  /// different options.
  void showSelectionScreen(BuildContext context) {
    List<SearchableListTile> widgets = List<SearchableListTile>();

    var dataSource = widget.options['items']['dataSource'];
    dataSource
        .sort((a, b) => a['text'].toString().compareTo(b['text'].toString()));

    for (var item in dataSource) {
      widgets.add(
        SearchableListTile(
          title: Text(item['text']),
          searchTerm: item['text'],
          onTap: () {
            setState(() {
              _selected.add(item);
            });
            _onChanged(_selected);
            Navigator.of(context).pop();
          },
        ),
      );
    }

    widget.bottomSheetController = showBottomSheet(
        context: context,
        builder: (context) {
          return SearchableList(tiles: widgets);
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
  final void Function() swapUp;
  final void Function() swapDown;
  final void Function(DismissDirection direction) onDismissed;
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
                  IconButton(icon: Icon(Icons.delete_forever), onPressed: () { 
                    this.onDismissed(DismissDirection.horizontal);
                  }),
              padding: EdgeInsets.fromLTRB(16, 0, 4, 0)),
          Padding(
              child:
                  IconButton(icon: Icon(Icons.arrow_upward), onPressed: swapUp),
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0)),
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
