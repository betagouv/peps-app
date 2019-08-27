import 'package:flutter/widgets.dart';

abstract class Field extends StatefulWidget with ChangeNotifier {
  final String fieldKey;
  final Map schema;
  final Map options;
  TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 30.0,
    fontFamily: 'SourceSansPro',
  );

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

      if (!answers.containsKey(key)) {
        return false;
      }

      // We convert both the dependencies and the answers to lists. This makes the
      // comparison easier since dependencies and answers can be lists (in which any match 
      // counts as a successful dependency match) or values (e.g., String, int...) in which a
      // direct comparison counts as a successful dependency match. By treating only with
      // lists we can simply ask if any item of the answer list is contained in the
      // dependency list.
      var dependency = dependencies[key] is List ? dependencies[key] : [dependencies[key]];
      var answer = answers[key] is List ? answers[key] : [answers[key]];

      if (!answer.any((x) => !!dependency.contains(x))) {
        return false;
      }
    }
    return true;
  }

  Field({this.fieldKey, this.schema, this.options});
}
