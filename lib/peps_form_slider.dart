import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class PepsFormSlider extends StatelessWidget {
  final String str;

  PepsFormSlider({this.str});

  List<Widget> _getChildren() {
    final jsonBody = jsonDecode(this.str);
    final jsonProperties = jsonBody['schema']['properties'];
    final jsonOptions = jsonBody['options']['fields'];

    List<Widget> children = [];

    for (var key in jsonProperties.keys) {
      // TODO: check for options[key] not being there (it's optional)
      children.add(FormFieldCard(
          schema: jsonProperties[key], options: jsonOptions[key]));
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: PageController(
        initialPage: 0,
      ),
      children: _getChildren(),
    );
  }
}

class FormFieldCard extends StatelessWidget {
  final Map schema;
  final Map options;

  FormFieldCard({this.schema, this.options});

  @override
  Widget build(BuildContext context) {
    Widget field = Text('Schema\n\n' +
        JsonEncoder.withIndent("  ").convert(this.schema) +
        '\n\nOptions:\n\n' +
        JsonEncoder.withIndent("  ").convert(this.options));

    if (this.options['type'] == 'radio') {
      field = RadioField(schema: this.schema, options: this.options);
    }

    return ListView(
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          Card(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: field,
            ),
          )
        ],
    );
  }
}

abstract class Field extends StatelessWidget {
  final Map schema;
  final Map options;

  String get title =>
      this.schema.containsKey('title') ? this.schema['title'] : '';

  Field({this.schema, this.options});
}

class RadioField extends Field {
  RadioField({Map schema, Map options})
      : super(schema: schema, options: options);

  @override
  Widget build(BuildContext context) {
    return Text(this.title +
        '\n\n' +
        'Schema\n\n' +
        JsonEncoder.withIndent("  ").convert(this.schema) +
        '\n\nOptions:\n\n' +
        JsonEncoder.withIndent("  ").convert(this.options));
  }
}

class CheckboxField extends FormFieldCard {}

class SelectField extends FormFieldCard {}

class ArrayField extends FormFieldCard {}
