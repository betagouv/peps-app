import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';

/// The same as a list tile with an additional searchTerm
/// used by the SearchableList to filter.
class SearchableListTile extends ListTile {
  final String searchTerm;

  final Key key;
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final bool isThreeLine;
  final bool dense;
  final EdgeInsetsGeometry contentPadding;
  final bool enabled;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final bool selected;

  SearchableListTile(
      {this.key,
      this.leading,
      this.title,
      this.subtitle,
      this.trailing,
      this.isThreeLine: false,
      this.dense,
      this.contentPadding,
      this.enabled: true,
      this.onTap,
      this.onLongPress,
      this.selected: false,
      this.searchTerm})
      : super(
          key: key,
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          isThreeLine: isThreeLine,
          dense: dense,
          contentPadding: contentPadding,
          enabled: enabled,
          onTap: onTap,
          onLongPress: onLongPress,
          selected: selected,
        );
}

/// Will create a listView of listTiles which are searchable
/// by their title.
class SearchableList extends StatefulWidget {
  final List<SearchableListTile> tiles;

  SearchableList({this.tiles});

  @override
  State<StatefulWidget> createState() {
    var _state = _SearchableListState(completeList: tiles);
    return _state;
  }
}

class _SearchableListState extends State<SearchableList> {
  final List<SearchableListTile> completeList;
  List<SearchableListTile> visibleTiles = List<SearchableListTile>();

  _SearchableListState({this.completeList});

  @override
  void initState() {
    visibleTiles.addAll(completeList);
    super.initState();
  }

  void filterResults(String query) {
    setState(() {
      visibleTiles.clear();
      visibleTiles.addAll(completeList
          .where((x) => !!removeDiacritics(x.searchTerm)
              .toUpperCase()
              .contains(removeDiacritics(query).toUpperCase()))
          .toList());
    });
  }

  final TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: filterResults,
            controller: editingController,
            decoration: InputDecoration(
              labelText: "Chercher",
              hintText: "Chercher",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            shrinkWrap: true,
            itemCount: visibleTiles.length,
            itemBuilder: (context, index) => visibleTiles[index],
          ),
        ),
      ],
    );
  }
}
