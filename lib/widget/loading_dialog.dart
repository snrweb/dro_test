import 'package:flutter/material.dart';

void showMDialog(BuildContext context, String text) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor),
            ),
            Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.subtitle2.color),
                )),
          ],
        ),
      );
    },
  );
}
