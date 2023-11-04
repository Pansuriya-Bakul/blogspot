import 'package:blog/components/button_custom.dart';
import 'package:blog/controllers/vc_photo_viewer.dart';
import 'package:blog/helper/tools.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/models/model_count.dart';
import 'package:blog/models/model_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_html/flutter_html.dart';

class BlogCell extends StatelessWidget {
  final PostModel model;
  final VoidCallback? onDelete;
  final CountModel? modelCountComment;
  final CountModel? modelCountLike;
  final VoidCallback? onCategory;
  final VoidCallback? onDetails;
  final VoidCallback? onLike;

  const BlogCell(
      {Key? key,
      required this.model,
      this.onDetails,
      this.onDelete,
      this.modelCountComment,
      this.modelCountLike,
      this.onCategory,
      this.onLike})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
        decoration: UI.boxDecoration(
            Colors.black, Colors.black, Colors.transparent, 10.0),
        child: view(context),
      ),
      onTap: onDetails,
    );
  }

  Widget view(BuildContext context) {
    var postDate = DateTime.parse(model.pdate ?? "");
    var latitude = double.tryParse(model.latitude ?? "0") ?? 0;
    var longitude = double.tryParse(model.longitude ?? "0") ?? 0;

    var commentCount = modelCountComment?.count ?? 0;
    var isCommented = modelCountComment?.commented ?? false;

    var likeCount = modelCountLike?.count ?? 0;
    var isLiked = modelCountLike?.liked ?? false;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            imageProfile(),
            const SizedBox(width: 10.0),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(model.ptitle ?? "",
                      style: UI.textStyleBold(Colors.white, 18.0),
                      textAlign: TextAlign.start),
                  const SizedBox(height: 2.5),
                  Text("Posted By ${model.uname ?? "Unknown"}",
                      style: UI.textStyleNormal(Colors.white, 12.0),
                      textAlign: TextAlign.start)
                ])),
            IconButton(
                onPressed: share,
                icon: const Icon(Icons.share_outlined),
                color: Colors.white),
            Visibility(
                child: IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete),
                    color: Colors.red),
                visible: onDelete != null)
          ],
        ),
        const SizedBox(height: 10),
        Container(
          child: Html(data: model.pdetails ?? "", shrinkWrap: true),
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          decoration: UI.boxDecoration(
              Colors.white, Colors.transparent, Colors.transparent, 5.0),
        ),
        const SizedBox(height: 5),
        Visibility(
            child: Align(
              child: btnSeePhoto(context),
              alignment: Alignment.centerLeft,
            ),
            visible: model.pimage?.isNotEmpty ?? false),
        const SizedBox(height: 10),
        Text("Posted On ${Tools.formatDate(postDate, "dd MMMM, yyyy")}",
            style: UI.textStyleNormal(Colors.white, 10.0),
            textAlign: TextAlign.end),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Icon(
                          isLiked
                              ? Icons.favorite_outlined
                              : Icons.favorite_outline,
                          color: isLiked ? Colors.red : Colors.white),
                      onTap: onLike,
                    ),
                    const SizedBox(height: 2.5),
                    Text("$likeCount",
                        style: UI.textStyleNormal(Colors.white, 15.0))
                  ],
                )),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                        isCommented
                            ? Icons.chat_rounded
                            : Icons.chat_bubble_outline,
                        color: isCommented ? Colors.red : Colors.white),
                    const SizedBox(height: 2.5),
                    Text("$commentCount",
                        style: UI.textStyleNormal(Colors.white, 15.0))
                  ],
                )),
            const Spacer(),
            IconButton(
                onPressed: () {
                  MapUtils.openMap(latitude, longitude);
                },
                icon: const Icon(Icons.location_on_outlined,
                    color: Colors.white)),
            IconButton(
                onPressed: onCategory,
                icon: const Icon(Icons.compare),
                color: Colors.white)
          ],
        ),
      ],
    );
  }

  Widget imageProfile() {
    Widget placeHolder = Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(5),
      child: Image.asset("assets/images/ph_user.png", color: Colors.black),
      decoration: UI.circleDecoration(
          Colors.white, Colors.transparent, Colors.transparent),
    );

    var profileImage = "";
    if (profileImage.isNotEmpty) {
      placeHolder = ClipOval(
        child: Image.network(profileImage,
            errorBuilder: (context, error, stackTrace) {
          return placeHolder;
        }, width: 40, height: 40, fit: BoxFit.fill),
      );
    }

    return Center(
      child: placeHolder,
    );
  }

  Widget btnSeePhoto(BuildContext context) {
    return CustomButton(
        text: "See Photo".toUpperCase(),
        textSize: 10.0,
        onPressed: () {
          PhotoViewerVC.show(context, model.pimage ?? "");
        },
        backgroundColor: Colors.green,
        padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0));
  }

  share() {
    FlutterShare.share(
        title: model.ptitle ?? "",
        text: "${model.ptitle}\n\n${model.pdetails}",
        linkUrl: model.pimage);
  }
}
