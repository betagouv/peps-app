import 'package:flutter/services.dart';

class PhoneTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;

    final StringBuffer newText = new StringBuffer();

    while ((newTextLength - usedSubstringIndex) >= 3) {
      newText.write(
          newValue.text.substring(usedSubstringIndex, usedSubstringIndex += 2) +
              ' ');
      if (newValue.selection.end >= 2) {
        selectionIndex += 1;
      }
    }

    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));

    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
