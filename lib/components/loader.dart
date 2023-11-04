import 'package:blog/helper/ui.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final String loadingText;

  const Loader({Key? key, required this.loadingText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 1.5,
          ),
          const SizedBox(height: 10.0),
          Text(loadingText, style: UI.textStyleNormal(Colors.white, 18.0))
        ],
      ),
    );
  }

  static void show(BuildContext context, {String text = "Loading"}) {
    showDialog(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        routeSettings: const RouteSettings(name: "loader"),
        builder: (context) {
          return Loader(loadingText: text);
        });
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop((route) {
      var settings = route.settings as RouteSettings;
      print("Route: ${settings.name}");
      return settings.name == "loader";
    });
  }
}
