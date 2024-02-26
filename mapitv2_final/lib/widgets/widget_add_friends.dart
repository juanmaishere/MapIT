import 'package:flutter/material.dart';

class TextAlertDialog extends StatefulWidget {
  @override
  _TextAlertDialogState createState() => _TextAlertDialogState();
}

class _TextAlertDialogState extends State<TextAlertDialog> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Text'),
      content: TextField(
        controller: _textController,
        decoration: InputDecoration(labelText: 'Type something'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String enteredText = _textController.text;
            print('Entered text: $enteredText');
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

// Call this method to show the dialog
void showTextAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return TextAlertDialog();
    },
  );
}