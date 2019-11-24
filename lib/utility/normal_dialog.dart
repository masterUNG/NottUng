import 'package:flutter/material.dart';

Widget showTitle(String title) {
  return ListTile(
    leading: Icon(
      Icons.add_alert,
      size: 36.0,
      color: Colors.red,
    ),
    title: Text(
      title,
      style: TextStyle(color: Colors.red),
    ),
  );
}

Widget okButton(BuildContext buildContext) {
  return FlatButton(
    child: Text('OK'),
    onPressed: () {
      Navigator.of(buildContext).pop();
    },
  );
}

Future<void> normalDialog(
    BuildContext buildContext, String title, String message) async {
  showDialog(
    context: buildContext,
    builder: (BuildContext buildContext) {
      return AlertDialog(
        title: showTitle(title),
        content: Text(message),
        actions: <Widget>[okButton(buildContext)],
      );
    },
  );
}
