import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:blog/components/loader.dart';
import 'package:blog/helper/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'apis.dart';

typedef ConnectorCallback = void Function(int statusCode, String response);

class Connector {
  static const checkInternet = "Check internet connectivity.";
  static const serverError = "Failed to connect server, try again.";

  final BuildContext context;
  final String tag;
  final String apiName;

  String baseUrl = APIs.BASE_URL;
  String pathUrl = APIs.PATH_URL;

  bool loader = true;
  String loaderText = "Loading";

  Map<String, String>? headers = {"Content-Type": "application/json"};
  Map<String, dynamic>? body;
  Map<String, String>? files;
  ConnectorCallback? callback;

  bool error = false;
  bool cancelled = false;
  Response? response;

  StreamSubscription<Object>? call;

  Connector(this.context, this.tag, this.apiName);

  static log(String tag, String value) {
    if (kDebugMode) {
      print(tag + ">>" + value);
    }
  }

  static dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Future<bool> checkConnectivity() async {
    return await InternetConnectionChecker().hasConnection;
  }

  Future<void> post() async {
    final isConnectivity = await checkConnectivity();
    if (!isConnectivity) {
      Toast.snackBarError(context: context, message: checkInternet);
      callback?.call(0, failureResponse());
      return;
    }
    var client = http.Client();
    try {
      var url = Uri.http(baseUrl, pathUrl + apiName, null);
      log(tag, "Request URL: ${url.toString()}");
      log(tag, "Request Body: $body");
      log(tag, "Request Headers: ${headers?.toString()}");

      var connect = client.post(url,
          body: jsonEncode(body),
          headers: headers,
          encoding: Encoding.getByName('utf-8'));
      startConnection(connect);
    } finally {
      client.close();
    }
  }

  Future<void> get() async {
    final isConnectivity = await checkConnectivity();
    if (!isConnectivity) {
      Toast.snackBarError(context: context, message: checkInternet);
      callback?.call(0, failureResponse());
      return;
    }

    var client = http.Client();
    try {
      var url = Uri.http(baseUrl, pathUrl + apiName, body);
      log(tag, "Request URL: ${url.toString()}");
      log(tag, "Request Body: $body");
      log(tag, "Request Headers: ${headers?.toString()}");

      var connect = client.get(url, headers: headers);
      startConnection(connect);
    } finally {
      client.close();
    }
  }

  Future<void> put() async {
    final isConnectivity = await checkConnectivity();
    if (!isConnectivity) {
      Toast.snackBarError(context: context, message: checkInternet);
      callback?.call(0, failureResponse());
      return;
    }

    var client = http.Client();
    try {
      var url = Uri.http(baseUrl, pathUrl + apiName, body);
      log(tag, "Request URL: ${url.toString()}");
      log(tag, "Request Body: $body");
      log(tag, "Request Headers: ${headers?.toString()}");

      var connect = client.put(url,
          headers: headers, encoding: Encoding.getByName('utf-8'));
      startConnection(connect);
    } finally {
      client.close();
    }
  }

  Future<void> delete() async {
    final isConnectivity = await checkConnectivity();
    if (!isConnectivity) {
      Toast.snackBarError(context: context, message: checkInternet);
      callback?.call(0, failureResponse());
      return;
    }

    var client = http.Client();
    try {
      var url = Uri.http(baseUrl, pathUrl + apiName, body);
      log(tag, "Request URL: ${url.toString()}");
      log(tag, "Request Body: $body");
      log(tag, "Request Headers: ${headers?.toString()}");

      var connect = client.delete(url, headers: headers);
      startConnection(connect);
    } finally {
      client.close();
    }
  }

  Future<void> upload() async {
    final isConnectivity = await checkConnectivity();
    if (!isConnectivity) {
      Toast.snackBarError(context: context, message: checkInternet);
      callback?.call(0, failureResponse());
      return;
    }

    var url = Uri.http(baseUrl, pathUrl + apiName, null);
    log(tag, "Request URL: ${url.toString()}");
    log(tag, "Request Body: $body");
    log(tag, "Request Files: $files");

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers ?? {});

    var fields = <String, String>{};
    body?.forEach((key, value) {
      fields[key] = "$value";
    });
    request.fields.addAll(fields);

    files?.forEach((key, value) async {
      request.files.add(http.MultipartFile.fromBytes(
          key, File(value).readAsBytesSync(),
          filename: value.split("/").last));
      //request.files.add(await http.MultipartFile.fromPath(key, value));
    });

    startLoading();
    var connect = request.send();
    call = connect.asStream().listen((response) {
      log(tag, "Response Status: ${response.statusCode}");
      convert(response);
    }, onError: (error) {
      log(tag, "Response Error: $error");
      this.error = true;
      callback?.call(0, failureResponse(message: serverError));
    }, onDone: () {
      stopLoading();
      log(tag, "Response Done");
    });
  }

  convert(StreamedResponse response) {
    response.stream.transform(utf8.decoder).listen((event) {
      log(tag, "StreamedResponse Body: $event");
      callback?.call(response.statusCode, event);
    }, onError: (error) {
      log(tag, "StreamedResponse Error: $error");
      this.error = true;
      callback?.call(0, failureResponse(message: serverError));
    }, onDone: () {
      log(tag, "StreamedResponse Done");
    });
  }

  startConnection(Future<Response> connect) {
    startLoading();
    call = connect.asStream().listen((event) {
      log(tag, "Response Status: ${event.statusCode}");
      log(tag, "Response Body: ${event.body}");
      response = event;
    }, onError: (error) {
      log(tag, "Response Error: $error");
      this.error = true;
    }, onDone: () {
      stopLoading();
      if (response != null) {
        callback?.call(response!.statusCode, response!.body);
      } else {
        if (cancelled) {
          callback?.call(0, failureResponse());
        } else {
          callback?.call(0, failureResponse(message: serverError));
        }
      }
      log(tag, "Response Done");
    });
  }

  endConnection() {
    call?.cancel().then((value) {
      cancelled = true;
      log(tag, "Cancelled");
    });
  }

  startLoading() {
    if (loader) {
      dismissKeyboard(context);
      Loader.show(context, text: loaderText);
    }
  }

  stopLoading() {
    if (loader) {
      Loader.dismiss(context);
    }
  }

  String failureResponse({String message = ""}) {
    return jsonEncode({"success": false, "message": message});
  }
}
