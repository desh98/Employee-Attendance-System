import 'package:flutter/material.dart';

enum ResponseType {
  Success,
  Failed,
  Invalid,
}

class DialogUtils {
  static void showLoadingDialog(BuildContext context, String loadingText) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16.0),
                Text(loadingText),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showResponseDialog(
    BuildContext context,
    ResponseType type,
    String message,
  ) {
    IconData icon;
    Color backgroundColor;
    Color iconColor; // Add this line to hold the color of the icon

    switch (type) {
      case ResponseType.Success:
        icon = Icons.check_circle;
        backgroundColor = Colors.green[100]!;
        iconColor = Color.fromARGB(255, 0, 235, 8);
        break;
      case ResponseType.Failed:
        icon = Icons.error;
        backgroundColor = Colors.red[100]!;
        iconColor = Colors.red;
        break;
      case ResponseType.Invalid:
        icon = Icons.warning;
        backgroundColor = Colors.yellow[100]!;
        iconColor = const Color.fromARGB(255, 173, 156, 0);
        break;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                size: 50,
                color: iconColor, // Use the iconColor variable here
              ),
              SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
