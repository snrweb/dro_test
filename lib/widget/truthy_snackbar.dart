import 'package:flutter/material.dart';

SnackBar buildSnackBar(BuildContext context, String info, bool type) {
  return SnackBar(
    backgroundColor:
        type ? Theme.of(context).primaryColor : Theme.of(context).errorColor,
    content: Container(
      width: MediaQuery.of(context).size.width,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(
          child: Text(
            "$info",
            maxLines: 3,
            softWrap: true,
            style: TextStyle(color: Theme.of(context).primaryColorLight),
          ),
        ),
        type
            ? Icon(Icons.check, color: Theme.of(context).primaryColorLight)
            : Icon(Icons.error, color: Theme.of(context).primaryColorLight)
      ]),
    ),
  );
}
