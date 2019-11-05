import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Peps app', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Contact button is present', () async {
      final contactUsButton = find.byValueKey('contact_us_button');

      // Contact us button should be present
      expect(await isPresent(contactUsButton, driver), true);
    });

    test('Information on the team is present', () async {
      final aboutUsButton = find.byValueKey('about_us_button');
      final publicServiceHeader = find.text('Un service public numérique');
      final backButton = find.byTooltip('Back');

      // Click button to see the about us section
      await driver.waitFor(aboutUsButton);
      await driver.tap(aboutUsButton);

      // First header should be about the public service
      expect(await isPresent(publicServiceHeader, driver), true);

      // Go back to the home view
      driver.tap(backButton);
    });

    test('Form can be started', () async {
      final startFormButtonFinder = find.byValueKey('landing_form_button');

      // Click form start button
      expect(await isPresent(startFormButtonFinder, driver), true);
      await driver.tap(startFormButtonFinder);
    });

    test('Problem question works', () async {
      final problemQuestion = find.text('Quel problème souhaitez-vous résoudre actuellement ?');

      // First question should be about the problem to solve
      expect(await isPresent(problemQuestion, driver), true);
    });
  });
}

isPresent(SerializableFinder finder, FlutterDriver driver, {Duration timeout = const Duration(seconds: 1)}) async {
  try {
    await driver.waitFor(finder, timeout: timeout);
    return true;
  } catch (exception) {
    return false;
  }
}
