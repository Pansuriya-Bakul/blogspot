import 'package:blog/helper/ui.dart';
import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  final void Function() onLogout;

  const LogoutDialog({Key? key, required this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var actionCancel = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("Cancel",
            textAlign: TextAlign.center,
            style: UI.textStyleNormal(Colors.black, 15.0)));
    var actionDelete = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          onLogout.call();
        },
        child: Text("Logout",
            textAlign: TextAlign.center,
            style: UI.textStyleBold(Colors.red, 15.0)));

    var alert = AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.power_settings_new, size: 60, color: Colors.red),
            const SizedBox(height: 10.0),
            Text("Logout",
                textAlign: TextAlign.center,
                style: UI.textStyleBold(Colors.red, 20.0)),
            const SizedBox(height: 10.0),
            Text("Are you sure want to logout?",
                textAlign: TextAlign.center,
                style: UI.textStyleNormal(Colors.black, 15.0)),
            const SizedBox(height: 5.0),
            Text("Note: All saved data will be erased.",
                textAlign: TextAlign.center,
                style: UI.textStyleNormal(Colors.black, 11.0))
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 10.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        actions: [actionCancel, actionDelete]);

    return alert;
  }

  static show(BuildContext context, void Function() onLogout) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return LogoutDialog(onLogout: onLogout);
        });
  }
}
