import 'package:blog/helper/tools.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/models/model_comment.dart';
import 'package:flutter/material.dart';

class CommentCell extends StatelessWidget {
  final CommentModel model;

  const CommentCell({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var commentDate = DateTime.parse(model.cdate ?? "");

    return Container(
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
      decoration: UI.boxDecoration(Colors.black.withOpacity(0.5),
          Colors.black.withOpacity(0.5), Colors.transparent, 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text((model.uname ?? "Unknown").toUpperCase(),
              style: UI.textStyleBold(Colors.white, 15.0),
              textAlign: TextAlign.start),
          const SizedBox(height: 2.5),
          Text("Comment: ${model.cdtls}",
              style: UI.textStyleNormal(Colors.white, 12.0),
              textAlign: TextAlign.start),
          const SizedBox(height: 5),
          Align(
            child: Text(Tools.formatDate(commentDate, "dd MMMM, yyyy"),
                style: UI.textStyleNormal(Colors.white, 10.0),
                textAlign: TextAlign.end),
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }

  Widget ivProfile() {
    Widget placeHolder = SizedBox(
      width: 35,
      height: 35,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: Image.asset("assets/images/ph_user.png", color: Colors.black),
        decoration: UI.circleDecoration(
            Colors.white, Colors.transparent, Colors.transparent),
      ),
    );

    var profileImage = "";
    if (profileImage.isNotEmpty) {
      placeHolder = ClipOval(
        child: Image.network(profileImage,
            errorBuilder: (context, error, stackTrace) {
          return placeHolder;
        }, width: 35, height: 35, fit: BoxFit.fill),
      );
    }

    return Center(
      child: placeHolder,
    );
  }
}
