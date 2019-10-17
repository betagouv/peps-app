import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConnectionErrorWidget extends StatelessWidget {
  final String message;
  final Function retryFunction;

  ConnectionErrorWidget({this.message, this.retryFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.signal_wifi_off,
            size: 50,
            color: Colors.grey[400],
          ),
          Padding(
            child: Center(
              child: Text(
                message,
                textAlign: TextAlign.center,
              ),
            ),
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          ),
          RaisedButton(
            child: Text('Ressayer'),
            onPressed: this.retryFunction,
          ),
        ],
      ),
    );
  }
}
