import 'package:flutter/widgets.dart';

abstract class Field extends StatefulWidget {
  final String fieldKey;
  final Map schema;
  final Map options;

  String get title =>
      this.schema.containsKey('title') ? this.schema['title'] : '';

  Map getJsonValue();

  Field({this.fieldKey, this.schema, this.options});
}