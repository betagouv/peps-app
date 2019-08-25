import 'package:flutter/widgets.dart';

abstract class Field extends StatefulWidget with ChangeNotifier {
  final String fieldKey;
  final Map schema;
  final Map options;
  final TextStyle titleStyle = TextStyle(fontSize: 30.0);

  String get title =>
      this.schema.containsKey('title') ? this.schema['title'] : '';

  Map getJsonValue();

  /// Some fields have dependencies to other answers. This function
  /// takes a JSON object of form answers and determines if the current
  /// field has its dependencies fulfilled from these answers.
  bool dependenciesAreMet(Map answers) {
    var hasDependencies = this.options.containsKey('dependencies');

    /// If there are no dependencies in this field, we return True.
    if (!hasDependencies || this.options['dependencies'].length == 0) {
      return true;
    }

    /// We check every dependency agains the answers provided.
    var dependencies = this.options['dependencies'];
    for (var key in dependencies.keys) {
      if (!answers.keys.contains(key) || dependencies[key] != answers[key]) {
        return false;
      }
    }
    return true;
  }

  Field({this.fieldKey, this.schema, this.options});
}
