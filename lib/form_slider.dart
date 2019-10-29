import 'package:app/form_field_card.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app/form/fields/radio.dart';
import 'package:app/form/fields/checkbox.dart';
import 'package:app/form/fields/array.dart';
import 'package:app/form/fields/select.dart';
import 'package:app/suggestions.dart';
import 'package:app/form/fields/base_field.dart';

class FormSlider extends StatefulWidget {
  final Map properties;
  final Map options;
  final PageController pageController;
  final List<Field> fields;
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  FormSlider({this.properties, this.options, this.analytics, this.observer})
      : assert(properties != null),
        assert(options != null),
        assert(analytics != null),
        assert(observer != null),
        pageController = PageController(initialPage: 0),
        fields = FormSlider.createFields(properties, options);

  static List<Field> createFields(Map properties, Map options) {
    List<Field> fields = [];

    for (var key in properties.keys) {
      if (options[key]['type'] == 'radio') {
        fields.add(RadioField(fieldKey: key, schema: properties[key], options: options[key]));
      } else if (options[key]['type'] == 'checkbox') {
        fields.add(CheckboxField(fieldKey: key, schema: properties[key], options: options[key]));
      } else if (options[key]['type'] == 'array') {
        fields.add(ArrayField(fieldKey: key, schema: properties[key], options: options[key]));
      } else if (options[key]['type'] == 'select') {
        fields.add(SelectField(fieldKey: key, schema: properties[key], options: options[key]));
      }
    }
    return fields;
  }

  void goToSuggestions(BuildContext context) {
    analytics.logEvent(
      name: 'form_end',
      parameters: <String, dynamic>{},
    );

    Map formResults = {};
    List<Map<String, String>> readableAnswers = [];

    for (var field in this.fields) {
      if (field.shouldLogAnswer) {
        field.logAnswer(this.analytics);
      }

      formResults.addAll(field.getJsonValue());
      if (field.getReadableAnswer() != '') {
        readableAnswers.add({
          'title': field.title.toString(),
          'answer': field.getReadableAnswer().toString(),
        });
      }
    }

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => Suggestions(
            formResults: formResults,
            analytics: analytics,
            observer: observer,
            readableAnswers: readableAnswers,
          ),
          settings: RouteSettings(name: 'suggestions_view'),
        )
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _FormSliderState();
  }
}

class _FormSliderState extends State<FormSlider> {
  List<int> fieldStack = [0];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: widget.pageController,
        children: _getChildren(context),
      ),
    );
  }

  Future<bool> _onWillPop() {
    var shouldClose = fieldStack.length == 1;
    goBack();
    return Future.value(shouldClose);
  }

  void goBack() {
    if (!widget.fields[fieldStack.last].canGoBack()) {
      return;
    }
    if (fieldStack.length > 1) {
      widget.analytics.logEvent(name: 'form_question_previous', parameters: <String, dynamic>{});

      fieldStack.removeLast();
      setState(() => fieldStack = fieldStack);
      widget.pageController.animateToPage(fieldStack.last, duration: Duration(milliseconds: 200), curve: Curves.ease);
    }
  }

  List<Widget> _getChildren(BuildContext context) {
    List<Widget> children = [];

    var nextCallback = () async {
      var field = widget.fields[widget.pageController.page.toInt()];
      String fieldTitle = field.title.length >= 100 ? field.title.substring(0, 99) : field.title;
      String fieldValue = field.getReadableAnswer();
      fieldValue = fieldValue.length >= 100 ? fieldValue.substring(0, 99) : fieldValue;
      widget.analytics.logEvent(name: 'form_question_next', parameters: <String, dynamic>{
        'title': fieldTitle,
        'answer': fieldValue,
      });
      var nextPage = widget.pageController.page.toInt();

      /// We need to find the next page that has its dependencies satisfied
      /// from the answers provided so far.
      while (nextPage < widget.fields.length - 1) {
        nextPage += 1;

        var answers = {};
        for (var i = 0; i <= widget.pageController.page.toInt(); i++) {
          answers.addAll(widget.fields[i].getJsonValue());
        }

        if (!widget.fields[nextPage].dependenciesAreMet(answers)) {
          continue;
        }

        if (widget.fields[nextPage].shouldLogAnswer && (await widget.fields[nextPage].hasLoggedAnswer())) {
          continue;
        }

        widget.pageController.animateToPage(nextPage, duration: Duration(milliseconds: 200), curve: Curves.ease);
        fieldStack.add(nextPage);
        setState(() => fieldStack = fieldStack);
        return;
      }

      /// We reached the end of the pages, we need to go to the suggestions page.
      widget.goToSuggestions(context);
    };

    for (var field in widget.fields) {
      children.add(FormFieldCard(
        field: field,
        nextCallback: nextCallback,
        previousCallback: field == widget.fields.first ? null : this.goBack,
        key: PageStorageKey('Page' + widget.fields.indexOf(field).toString()),
      ));
    }

    return children;
  }
}
