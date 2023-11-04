import 'package:flutter/material.dart';

import 'ui.dart';

class Toast {
  static snackBarSuccess(
      {required BuildContext context,
      String title = "Success",
      required String message}) {
    if (message.isEmpty) {
      return;
    }

    var snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      content: Container(
        decoration: UI.boxDecoration(
            Colors.green, Colors.black, Colors.transparent, 10.0),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                size: 45, color: Colors.white),
            const SizedBox(width: 15.0),
            Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: UI.textStyleBold(Colors.white, 15)),
                    const SizedBox(height: 2),
                    Text(message, style: UI.textStyleNormal(Colors.white, 12))
                  ],
                ),
                flex: 1)
          ],
        ),
        padding: const EdgeInsets.all(15.0),
      ),
      elevation: 0.0,
      margin: const EdgeInsets.all(12.0),
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static snackBarError(
      {required BuildContext context,
      String title = "Error",
      required String message}) {
    if (message.isEmpty) {
      return;
    }
    var snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      content: Container(
        decoration: UI.boxDecoration(
            Colors.redAccent, Colors.black, Colors.transparent, 10.0),
        child: Row(
          children: [
            const Icon(Icons.remove_circle_outline,
                size: 45, color: Colors.white),
            const SizedBox(width: 15.0),
            Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: UI.textStyleBold(Colors.white, 15)),
                    const SizedBox(height: 2),
                    Text(message, style: UI.textStyleNormal(Colors.white, 12))
                  ],
                ),
                flex: 1)
          ],
        ),
        padding: const EdgeInsets.all(15.0),
      ),
      elevation: 0.0,
      margin: const EdgeInsets.all(12.0),
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static alertSuccess(
      {required BuildContext context,
      String title = "Success",
      required String message}) {
    if (message.isEmpty) {
      return;
    }
    var actionOk = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("OK",
            textAlign: TextAlign.center,
            style: UI.textStyleNormal(Colors.black, 15.0)));

    var alert = AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.check_circle_outline,
                size: 60, color: Colors.green),
            const SizedBox(height: 10.0),
            Text(title,
                textAlign: TextAlign.center,
                style: UI.textStyleBold(Colors.green, 20.0))
          ],
        ),
        content: Text(message,
            textAlign: TextAlign.center,
            style: UI.textStyleNormal(Colors.black, 15.0)),
        backgroundColor: Colors.white,
        elevation: 10.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        actions: [actionOk]);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  static alertError(
      {required BuildContext context,
      String title = "Error",
      required String message}) {
    if (message.isEmpty) {
      return;
    }
    var actionOk = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("OK",
            textAlign: TextAlign.center,
            style: UI.textStyleNormal(Colors.black, 15.0)));

    var alert = AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.remove_circle_outline,
                size: 60, color: Colors.redAccent),
            const SizedBox(height: 10.0),
            Text(title,
                textAlign: TextAlign.center,
                style: UI.textStyleBold(Colors.redAccent, 20.0))
          ],
        ),
        content: Text(message,
            textAlign: TextAlign.center,
            style: UI.textStyleNormal(Colors.black, 15.0)),
        backgroundColor: Colors.white,
        elevation: 10.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        actions: [actionOk]);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
