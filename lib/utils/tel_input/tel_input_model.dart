import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './tel_input_data.dart';
import './tel_input.dart';

abstract class TelInputViewModel extends State<TelInput>  with AutomaticKeepAliveClientMixin<TelInput> {
  @override
  bool get wantKeepAlive => true;

  String _selectedDialCode;
  String _phoneNumberHintText;
  String _phoneNumber;
  bool _includeDialCode;
  String _filter;
  final String _defaultDialCode = '+33';
  final Map<String, String> _dialCodeHintTextMapping =
      TelInputData().getDialCodeHintTextMapping();
  final List<String> _validDialCodes = TelInputData().getValidDialCode();
  TextEditingController _searchTextController = new TextEditingController();
  FocusNode _inputFocusNode;

  @override
  void initState() {
    super.initState();

    _searchTextController.addListener(() {
      setState(() {
        _filter = _searchTextController.text;
      });
    });

    _selectedDialCode = ![null, false].contains(widget.dialCode)
        ? widget.dialCode
        : _defaultDialCode;

    if (!_selectedDialCode.startsWith('+')) {
      _selectedDialCode = '+' + _selectedDialCode;
    }

    if (!_validDialCodes.contains(_selectedDialCode)) {
      throw new Exception('Invalid Dial Code');
    }

    _includeDialCode =
        widget.includeDialCode == null ? false : widget.includeDialCode;

    String val = _getHintTextByDialCode();
    _updatePhoneNumberHintText(val);

    _inputFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  Widget buildTelInputField(BuildContext context) {
    return (TextField(
      onChanged: (String val) => _onTextChange(val),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(hintText: _phoneNumberHintText),
      focusNode: _inputFocusNode,
    ));
  }

  void _onTextChange(String val) {
    _phoneNumber = val;

    if (widget.onChange is Function) {
      widget.onChange(
          _includeDialCode ? _selectedDialCode + _phoneNumber : _phoneNumber);
    }
  }

  void _updatePhoneNumberHintText(val) {
    _phoneNumberHintText = val;
  }

  String _getHintTextByDialCode() {
    return ![null, false].contains(_dialCodeHintTextMapping[_selectedDialCode])
        ? _dialCodeHintTextMapping[_selectedDialCode]
        : _dialCodeHintTextMapping[_defaultDialCode];
  }
}
