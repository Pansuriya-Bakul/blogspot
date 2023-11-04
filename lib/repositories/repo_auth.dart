import 'dart:convert';

import 'package:blog/helper/apis.dart';
import 'package:blog/helper/connector.dart';
import 'package:blog/helper/constants.dart';
import 'package:blog/models/model_notification.dart';
import 'package:flutter/material.dart';

typedef ListNotificationCallback = Function(List<NotificationModel> list);

class RepoAuth {
  static login(BuildContext context, String email, String password,
      RepoCallback? callback) async {
    Connector connect = Connector(context, "login", APIs.LOGIN);
    connect.loaderText = "Logging In";
    connect.body = {"uemailid": email, "upassword": password};
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      final success = body["response"];
      final message = body["message"];
      if (success == 1) {
        Constants.setUser(body["data"]);
      }
      callback?.call(success == 1, message);
    };
    connect.post();
  }

  static register(BuildContext context, String name, String email, String phone,
      String age, String password, RepoCallback? callback) async {
    Connector connect = Connector(context, "register", APIs.REGISTER);
    connect.loaderText = "Authenticating";
    connect.body = {
      "uname": name,
      "uemail": email,
      "ucontact": phone,
      "uage": age,
      "upsw": password,
    };
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      final success = body["response"];
      final message = body["message"];
      callback?.call(success == 1, message);
    };
    connect.post();
  }

  static forgotPassword(
      BuildContext context, String email, RepoCallback? callback) async {
    Connector connect =
        Connector(context, "forgot_password", APIs.FORGOT_PASSWORD);
    connect.body = {"email": email};
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      final success = body["response"];
      final message = body["message"];
      callback?.call(success == 1, message);
    };
    connect.post();
  }

  static changePassword(BuildContext context, String password,
      String confirmPassword, RepoCallback? callback) async {
    Connector connect =
        Connector(context, "change_password", APIs.CHANGE_PASSWORD);
    connect.loaderText = "Changing Password";
    connect.body = {"upsw": password, "upsw_conf": confirmPassword};
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      final success = body["response"];
      final message = body["message"];
      callback?.call(success == 1, message);
    };
    connect.post();
  }

  static getProfile(BuildContext context, RepoCallback? callback) async {
    var user = await Constants.getUser();

    Connector connect = Connector(context, "get_profile", APIs.GET_PROFILE);
    connect.loaderText = "Fetching Profile";
    connect.body = {"uid": user["uid"]};
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      var list = (body["result"] as List);
      if (list.isNotEmpty) {
        var data = list.first as Map<String, dynamic>;
        Constants.setUser(data);
        callback?.call(true, "");
      } else {
        callback?.call(false, "");
      }
    };
    connect.post();
  }

  static updateProfile(BuildContext context, String name, String email,
      String age, RepoCallback? callback) async {
    Connector connect =
        Connector(context, "update_profile", APIs.UPDATE_PROFILE);
    connect.loaderText = "Updating Profile";

    var user = await Constants.getUser();
    connect.body = {
      "uid": user["uid"],
      "name": name,
      "email": email,
      "age": age
    };
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      final success = body["response"];
      final message = body["message"];
      if (success == 1) {
        Constants.setUser(body["data"]);
      }
      callback?.call(success == 1, message);
    };
    connect.post();
  }

  static uploadProfile(
      BuildContext context, String photo, RepoCallback? callback) async {
    Connector connect =
        Connector(context, "upload_profile", APIs.UPLOAD_PROFILE);
    connect.loaderText = "Uploading Profile";

    var user = await Constants.getUser();
    connect.body = {"uid": user["uid"]};
    if (photo.isNotEmpty) {
      connect.files = {"image_file": photo};
    }
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      final success = body["response"];
      final message = body["message"];
      callback?.call(success == 1, message);
    };
    connect.upload();
  }

  static toggleNotification(
      BuildContext context, bool isEnable, RepoCallback? callback) async {
    Connector connect =
        Connector(context, "toggle_notification", APIs.TOGGLE_NOTIFICATION);
    connect.loaderText =
        isEnable ? "Enabling Notification" : "Disabling Notification";

    var user = await Constants.getUser();
    connect.body = {"uid": user["uid"], "is_notify": isEnable ? "1" : "0"};
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      final success = body["response"];
      callback?.call(success == 1, "");
    };
    connect.post();
  }

  static getNotifications(
      BuildContext context, ListNotificationCallback? callback) async {
    var user = await Constants.getUser();

    Connector connect =
        Connector(context, "get_notifications", APIs.GET_NOTIFICATIONS);
    connect.loaderText = "Fetching Notifications";
    connect.body = {"uid": user["uid"]};
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      var dataList = body["data"] as List;
      List<NotificationModel> list =
          dataList.map((e) => NotificationModel.fromJson(e)).toList();
      callback?.call(list);
    };
    connect.post();
  }
}
