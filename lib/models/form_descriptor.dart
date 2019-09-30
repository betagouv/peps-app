import 'package:app/models/base_model.dart';

class FormDescriptor extends BaseModel {

  String description;
  String type;
  List<Schema> fieldsSchema = [];
  Map dependencies = {};

  static FormDescriptor fromJson(Map jsonRepresentation) {
    var formDescriptor = FormDescriptor();
    var jsonSchema = jsonRepresentation['schema'];
    var jsonOptions = jsonRepresentation['options'];

    if (jsonSchema.containsKey('description')) {
      formDescriptor.description = jsonSchema['description'];
    }
    if (jsonSchema.containsKey('type')) {
      formDescriptor.type = jsonSchema['type'];
    }
    if (jsonSchema.containsKey('dependencies')) {
      formDescriptor.dependencies = jsonSchema['dependencies'];
    }
    if (jsonSchema.containsKey('properties')) {
      for (var key in jsonSchema['properties'].keys) {
        var jsonField = jsonSchema['properties'][key];
        if (jsonOptions['fields'].containsKey(key)) {
          jsonField.addAll(jsonOptions['fields'][key]);
        }
        formDescriptor.fieldsSchema.add(Schema.fromJson(jsonField, key));
      }
    }
    return formDescriptor;
  }
}

class Schema {
  String key;
  String title;
  bool mandatory;
  List<String> choices;
  bool uniqueItems;
  bool sort;
  bool hideNone;
  String type;
  List<Map> dataSource;
  Map dependencies;

  static Schema fromJson(Map jsonRepresentation, String key) {
    var schema = Schema();
    schema.key = key;
    if (jsonRepresentation.containsKey('title')) {
      schema.title = jsonRepresentation['title'];
    }
    if (jsonRepresentation.containsKey('required')) {
      schema.mandatory = jsonRepresentation['required'];
    }
    if (jsonRepresentation.containsKey('enum')) {
      schema.choices = jsonRepresentation['enum'];
    }
    if (jsonRepresentation.containsKey('uniqueItems')) {
      schema.uniqueItems = jsonRepresentation['uniqueItems'];
    }
    if (jsonRepresentation.containsKey('sort')) {
      schema.sort = jsonRepresentation['sort'];
    }
    if (jsonRepresentation.containsKey('hideNone')) {
      schema.hideNone = jsonRepresentation['hideNone'];
    }
    if (jsonRepresentation.containsKey('type')) {
      schema.type = jsonRepresentation['type'];
    }
    if (jsonRepresentation.containsKey('dataSource')) {
      schema.dataSource = jsonRepresentation['dataSource'];
    }
    if (jsonRepresentation.containsKey('dependencies')) {
      schema.dependencies = jsonRepresentation['dependencies'];
    }
    return schema;
  }
}
