import 'dart:convert';

import 'package:blog/helper/apis.dart';
import 'package:blog/helper/connector.dart';
import 'package:blog/helper/constants.dart';
import 'package:blog/models/model_comment.dart';
import 'package:blog/models/model_count.dart';
import 'package:blog/models/model_like.dart';
import 'package:blog/models/model_post.dart';
import 'package:flutter/material.dart';

typedef ListPostCallback = Function(List<PostModel> list);
typedef ListCommentCallback = Function(List<CommentModel> list);
typedef ListLikeCallback = Function(List<LikeModel> list);
typedef ListCountCallback = Function(List<CountModel> list);

class RepoPost {
  static createPost(
      BuildContext context,
      String photo,
      String title,
      String description,
      String category,
      double latitude,
      double longitude,
      RepoCallback? callback) async {
    var user = await Constants.getUser();

    Connector connect = Connector(context, "post_create", APIs.INSERT_POST);
    connect.loaderText = "Creating Post";
    connect.body = {
      "uid": user["uid"],
      "uname": user["uname"],
      "post_title": title,
      "post_details": description,
      "category": category,
      "latitude": "$latitude",
      "longitude": "$longitude",
      "is_image": photo.isNotEmpty ? "1" : "0"
    };

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

  static getMyPosts(BuildContext context, ListPostCallback? callback) async {
    var user = await Constants.getUser();

    Connector connect = Connector(context, "get_my_posts", APIs.GET_MY_POSTS);
    connect.loaderText = "Fetching Posts";
    connect.body = {"Uid": user["uid"]};
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      var dataList = body["data"] as List;
      List<PostModel> list =
          dataList.map((e) => PostModel.fromJson(e)).toList();
      callback?.call(list);
    };
    connect.post();
  }

  static getSimilarPosts(
      BuildContext context, String category, ListPostCallback? callback) async {
    Connector connect =
        Connector(context, "get_similar_posts", APIs.GET_SIMILAR_POSTS);
    connect.loaderText = "Fetching Posts";
    connect.body = {"post_category": category};
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      var dataList = body["data"] as List;
      List<PostModel> list =
          dataList.map((e) => PostModel.fromJson(e)).toList();
      callback?.call(list);
    };
    connect.post();
  }

  static getAllPosts(BuildContext context, ListPostCallback? callback) async {
    var user = await Constants.getUser();

    Connector connect = Connector(context, "get_all_posts", APIs.GET_ALL_POSTS);
    connect.loaderText = "Fetching Posts";
    connect.body = {"Uid": user["uid"]};
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      var dataList = body["data"] as List;
      List<PostModel> list =
          dataList.map((e) => PostModel.fromJson(e)).toList();
      callback?.call(list);
    };
    connect.post();
  }

  static getComments(BuildContext context, String postId,
      ListCommentCallback? callback) async {
    Connector connect = Connector(context, "comments", APIs.GET_COMMENTS);
    connect.loader = false;
    connect.body = {"postid": postId};
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      var dataList = body["data"] as List;
      List<CommentModel> list =
          dataList.map((e) => CommentModel.fromJson(e)).toList();
      callback?.call(list);
    };
    connect.post();
  }

  static getLikes(
      BuildContext context, String postId, ListLikeCallback? callback) async {
    Connector connect = Connector(context, "likes", APIs.GET_LIKES);
    connect.loader = false;
    connect.body = {"postid": postId};
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      var dataList = body["data"] as List;
      List<LikeModel> list =
          dataList.map((e) => LikeModel.fromJson(e)).toList();
      callback?.call(list);
    };
    connect.post();
  }

  static getLikeCounts(
      BuildContext context, ListCountCallback? callback) async {
    var user = await Constants.getUser();

    Connector connect = Connector(context, "like_counts", APIs.GET_LIKE_COUNTS);
    connect.body = {"uid": user["uid"]};
    connect.loader = false;
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      var dataList = body["result"] as List;
      List<CountModel> list =
          dataList.map((e) => CountModel.fromJson(e)).toList();
      callback?.call(list);
    };
    connect.post();
  }

  static getCommentCounts(
      BuildContext context, ListCountCallback? callback) async {
    var user = await Constants.getUser();

    Connector connect =
        Connector(context, "comment_counts", APIs.GET_COMMENT_COUNTS);
    connect.body = {"uid": user["uid"]};
    connect.loader = false;
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      var dataList = body["result"] as List;
      List<CountModel> list =
          dataList.map((e) => CountModel.fromJson(e)).toList();
      callback?.call(list);
    };
    connect.post();
  }

  static deletePost(
      BuildContext context, String postId, RepoCallback? callback) async {
    Connector connect = Connector(context, "delete_post", APIs.DELETE_POST);
    connect.loaderText = "Deleting Post";
    connect.body = {"postid": postId};
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      final success = body["response"];
      final message = body["message"];
      callback?.call(success == 1, message);
    };
    connect.post();
  }

  static insertComment(BuildContext context, String userId, String postId,
      String text, RepoCallback? callback) async {
    var user = await Constants.getUser();

    Connector connect =
        Connector(context, "insert_comment", APIs.INSERT_COMMENT);
    connect.loaderText = "Posting Comment";
    connect.body = {
      "postid": postId,
      "uid": user["uid"],
      "to_uid": userId,
      "uname": user["uname"],
      "comments": text
    };
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      final success = body["response"];
      final message = body["message"];
      callback?.call(success == 1, message);
    };
    connect.post();
  }

  static insertLike(BuildContext context, String userId, String postId, bool isLike,
      RepoCallback? callback) async {
    var user = await Constants.getUser();

    Connector connect = Connector(context, "insert_like", APIs.INSERT_LIKE);
    connect.loaderText = "Liking Post";
    connect.body = {
      "postid": postId,
      "uid": user["uid"],
      "to_uid": userId,
      "uname": user["uname"],
      "L_Type": isLike ? "like" : "dislike"
    };
    connect.callback = (statusCode, response) {
      Map<String, dynamic> body = jsonDecode(response);
      final success = body["response"];
      final message = body["message"];
      callback?.call(success == 1, message);
    };
    connect.post();
  }
}
