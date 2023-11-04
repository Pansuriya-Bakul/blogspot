import 'package:blog/components/button_custom.dart';
import 'package:blog/helper/apis.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/models/model_user.dart';
import 'package:flutter/material.dart';

class FriendCell extends StatelessWidget {
  final UserModel? model;

  final bool? isMe;
  final bool? isFollowed;
  final VoidCallback? onFollow;
  final VoidCallback? onUnfollow;

  const FriendCell(
      {Key? key,
      this.model,
      this.isFollowed,
      this.onFollow,
      this.onUnfollow,
      this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
      decoration: UI.boxDecoration(
          Colors.black, Colors.black, Colors.transparent, 10.0),
      child: view(context),
    );
  }

  Widget view(BuildContext context) {
    var isFollowed = this.isFollowed ?? false;
    List<Widget> children = [
      imageProfile(),
      const SizedBox(width: 15.0),
      Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${model?.uname}, ${model?.age} Years",
              style: UI.textStyleBold(Colors.white, 18.0),
              textAlign: TextAlign.start),
          const SizedBox(height: 5),
          Text("${model?.email}",
              style: UI.textStyleNormal(Colors.white, 12.0),
              textAlign: TextAlign.start),
        ],
      )),
    ];

    var isMe = this.isMe ?? false;
    if (!isMe) {
      if (isFollowed) {
        children.add(btnFollowing());
      } else {
        children.add(btnFollow());
      }
    }

    return Row(
      children: children,
    );
  }

  Widget imageProfile() {
    Widget placeHolder = SizedBox(
      width: 50,
      height: 50,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: Image.asset("assets/images/ph_user.png", color: Colors.black),
        decoration: UI.circleDecoration(
            Colors.white, Colors.transparent, Colors.transparent),
      ),
    );

    var profileImage = model?.uphoto ?? "";
    if (profileImage.isNotEmpty) {
      placeHolder = ClipOval(
        child: Image.network(APIs.IMAGE_PATH_URL + profileImage,
            errorBuilder: (context, error, stackTrace) {
          return placeHolder;
        }, width: 50, height: 50, fit: BoxFit.fill),
      );
    }

    return Center(
      child: placeHolder,
    );
  }

  Widget btnFollow() {
    return CustomButton(
        text: "Follow".toUpperCase(),
        textSize: 10.0,
        onPressed: onFollow,
        backgroundColor: Colors.red,
        padding: const EdgeInsets.all(5.0));
  }

  Widget btnFollowing() {
    return CustomButton(
        text: "Following".toUpperCase(),
        textSize: 10.0,
        onPressed: onUnfollow,
        backgroundColor: Colors.green,
        padding: const EdgeInsets.all(5.0));
  }
}
