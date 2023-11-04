import 'package:blog/helper/constants.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/router/routes.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashVC extends StatefulWidget {
  const SplashVC({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashVC();
  }
}

class _SplashVC extends State<SplashVC> with WidgetsBindingObserver {
  var delayInSeconds = const Duration(seconds: 3);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(onCreate);
  }

  onCreate(_) {
    _timer?.cancel();
    _timer = Timer(delayInSeconds, () {
      checkAuth();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            backgroundColor: Colors.indigo,
            body: SafeArea(
                child: Container(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  logo(),
                  const SizedBox(height: 20.0),
                  Text("BLOGGER",
                      style: UI.textStyleBold(Colors.white, 25.0),
                      textAlign: TextAlign.center),
                ],
              ),
            ))));
  }

  Widget logo() {
    Widget placeHolder = SizedBox(
      width: 120,
      height: 120,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset("assets/images/ph_user.png", color: Colors.black),
        decoration: UI.circleDecoration(
            Colors.white, Colors.transparent, Colors.transparent),
      ),
    );

    return Center(
      child: placeHolder,
    );
  }

  checkAuth() async {
    Map<String, dynamic> json = await Constants.getUser();
    if (json.isEmpty) {
      Navigator.pushNamed(context, Routes.LOGIN);
      return;
    }
    Navigator.pushNamed(context, Routes.DASHBOARD);
  }
}
