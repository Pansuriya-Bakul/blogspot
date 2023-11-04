import 'dart:io';

import 'package:blog/repositories/MyHttpOverrides.dart';
import 'package:blog/router/restart.dart';
import 'package:blog/router/routes.dart';
import 'package:flutter/material.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(onCreate);
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  onCreate(_) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RestartWidget(
        child: MaterialApp(
            home: Routes.initial(), routes: Routes.list(), darkTheme: null));
  }
}
