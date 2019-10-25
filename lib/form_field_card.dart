
import 'package:app/form/fields/base_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FormFieldCard extends StatefulWidget {
  final Field field;
  final void Function() nextCallback;
  final void Function() previousCallback;

  FormFieldCard({this.field, this.nextCallback, this.previousCallback, Key key})
      : assert(field != null),
        assert(nextCallback != null),
        assert(key != null),
        super(key: key);

  _FormFieldCardState createState() {
    return _FormFieldCardState();
  }
}

class _FormFieldCardState extends State<FormFieldCard> with AutomaticKeepAliveClientMixin {
  bool nextEnabled = false;

  @override
  void initState() {
    super.initState();
    widget.field.removeListener(onChanged);
    widget.field.addListener(onChanged);
  }

  void onChanged() {
    var fieldValue = widget.field.getJsonValue();
    var isEmpty = true;
    for (var key in fieldValue.keys) {
      if (fieldValue[key] != null) {
        isEmpty = false;
        break;
      }
    }
    setState(() => nextEnabled = !isEmpty);
  }

  List<Widget> getButtons() {
    List<Widget> widgets = List<Widget>();
    if (widget.previousCallback != null) {
      widgets.add(Padding(
        child: FloatingActionButton(
          onPressed: widget.previousCallback,
          child: Icon(Icons.arrow_left),
          heroTag: 'btnP' + widget.key.toString(),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
      ));
    }
    widgets.add(FloatingActionButton(
      onPressed: nextEnabled ? widget.nextCallback : null,
      child: Icon(Icons.arrow_right),
      disabledElevation: 0,
      heroTag: 'btnN' + widget.key.toString(),
      backgroundColor: nextEnabled ? Theme.of(context).primaryColor : Colors.grey[300],
    ));
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: widget.field,
          ),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: getButtons(),
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
