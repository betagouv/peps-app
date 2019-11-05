import 'package:flutter_driver/driver_extension.dart';
import 'package:app/main.dart' as app;

void main() async {
  enableFlutterDriverExtension();
  app.main(test: true);
}
