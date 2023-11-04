import 'dart:convert';

import 'package:blog/helper/apis.dart';
import 'package:blog/helper/connector.dart';
import 'package:blog/helper/constants.dart';
import 'package:blog/models/model_comment.dart';
import 'package:blog/models/model_follow.dart';
import 'package:blog/models/model_like.dart';
import 'package:blog/models/model_post.dart';
import 'package:blog/models/model_user.dart';
import 'package:flutter/material.dart';

typedef ListFollowCallback = Function(List<FollowModel> list);
typedef ListUserCallback = Function(List<UserModel> list);

class RepoFollow {
  static getMyFollowers(
      BuildContext context, ListFollowCallback? callback) async {
    var user = await Constants.getUser();

    Connector connect =
        Connector(context, "get_my_followers", APIs.GET_MY_FOLLOWERS);
    connect.loaderText = "Loading";
    connect.body = {"uid": user["uid"]};
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      var dataList = body["data"] as List;
      List<FollowModel> list =
          dataList.map((e) => FollowModel.fromJson(e)).toList();
      callback?.call(list);
    };
    connect.post();
  }

  static getAllUsers(BuildContext context, ListUserCallback? callback) async {
    Connector connect = Connector(context, "get_users", APIs.GET_ALL_USERS);
    connect.loaderText = "Fetching Users";
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      var dataList = body["data"] as List;
      List<UserModel> list =
          dataList.map((e) => UserModel.fromJson(e)).toList();
      callback?.call(list);
    };
    connect.post();
  }

  static insertFollow(BuildContext context, String userId, String userName,
      RepoCallback? callback) async {
    var user = await Constants.getUser();

    Connector connect =
        Connector(context, "insert_follower", APIs.INSERT_FOLLOWER);
    connect.loaderText = "Following";
    connect.body = {
      "personid": userId,
      "personname": userName,
      "followerid": user["uid"],
      "followedby": user["uname"],
    };
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      final success = body["response"];
      final message = body["message"];
      callback?.call(success == 1, message);
    };
    connect.post();
  }

  static deleteFollow(
      BuildContext context, String userId, RepoCallback? callback) async {
    var user = await Constants.getUser();

    Connector connect =
        Connector(context, "delete_follower", APIs.DELETE_FOLLOWER);
    connect.loaderText = "Unfollowing";
    connect.body = {"uid": user["uid"], "pid": userId};
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      final success = body["response"];
      final message = body["message"];
      callback?.call(success == 1, message);
    };
    connect.post();
  }
}
