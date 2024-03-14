import 'package:flutter/material.dart';
import 'package:ientrada_new/constants/color.dart';

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
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
    // Color backgroundColor;
    Color iconColor;

    switch (type) {
      case ResponseType.Success:
        icon = Icons.check_circle;
        // backgroundColor = Colors.green[100]!;
        iconColor = Color.fromARGB(255, 2, 177, 8);
        break;
      case ResponseType.Failed:
        icon = Icons.error;
        // backgroundColor = Colors.red[100]!;
        iconColor = Colors.red;
        break;
      case ResponseType.Invalid:
        icon = Icons.warning;
        // backgroundColor = Colors.yellow[100]!;
        iconColor = Color.fromARGB(255, 248, 226, 24);
        break;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                size: 50,
                color: iconColor,
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
