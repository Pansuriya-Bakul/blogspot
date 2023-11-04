import 'package:blog/cells/cell_comment.dart';
import 'package:blog/components/button_custom.dart';
import 'package:blog/components/text_field_custom.dart';
import 'package:blog/controllers/vc_photo_viewer.dart';
import 'package:blog/helper/tools.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/models/model_comment.dart';
import 'package:blog/models/model_post.dart';
import 'package:blog/repositories/repo_post.dart';
import 'package:blog/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_html/flutter_html.dart';

class PostDetailsVC extends StatefulWidget {
  const PostDetailsVC({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PostDetailsVC();
  }
}

class _PostDetailsVC extends State<PostDetailsVC> with WidgetsBindingObserver {
  PostModel? model;

  List<CommentModel> listComment = [];
  var tfCommentController = TextEditingController();
  String? errorComment;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(onCreate);
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  void onCreate(_) {
    setStateIfMounted(() {
      model = ModalRoute.of(context)!.settings.arguments as PostModel;
    });
    getComments();
    getLikeCounts();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      onCreate(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          CustomTextField.dismissFocus(context);
        },
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                centerTitle: true,
                automaticallyImplyLeading: true,
                actions: [btnLike()],
                title: Text("Post Details",
                    style: UI.textStyleBold(Colors.white, 15.0))),
            backgroundColor: Colors.indigo,
            body: body()));
  }

  Widget? body() {
    if (model == null) {
      return null;
    }
    return Column(
      children: [
        Expanded(
            child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                child: view()),
            const Divider(color: Colors.white, height: 1),
            listComments()
          ],
        )),
        Padding(padding: const EdgeInsets.all(15.0), child: tfComment())
      ],
    );
  }

  Widget view() {
    var postDate = DateTime.parse(model?.pdate ?? "");

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            ivProfile(),
            const SizedBox(width: 15),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(model?.ptitle ?? "",
                      style: UI.textStyleBold(Colors.white, 20.0),
                      textAlign: TextAlign.start),
                  const SizedBox(height: 2.5),
                  Text("Posted By ${model?.uname ?? "Unknown"}",
                      style: UI.textStyleNormal(Colors.white, 12.0),
                      textAlign: TextAlign.start)
                ]))
          ],
        ),
        const SizedBox(height: 15),
        Container(
          child: Html(data: model?.pdetails ?? "", shrinkWrap: true),
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          decoration: UI.boxDecoration(
              Colors.white, Colors.transparent, Colors.transparent, 10.0),
        ),
        const SizedBox(height: 5),
        Visibility(
            child: Align(
              child: btnSeePhoto(),
              alignment: Alignment.centerLeft,
            ),
            visible: model?.pimage?.isNotEmpty ?? false),
        const SizedBox(height: 10),
        Text("Posted On ${Tools.formatDate(postDate, "dd MMMM, yyyy")}",
            style: UI.textStyleNormal(Colors.white, 10.0),
            textAlign: TextAlign.end),
      ],
    );
  }

  Widget listComments() {
    if (listComment.isEmpty) {
      return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text("No Comments",
              textAlign: TextAlign.center,
              style: UI.textStyle(textColor: Colors.white, fontSize: 15.0)));
    }

    return ListView.builder(
        padding: const EdgeInsets.only(top: 15.0),
        itemBuilder: (context, index) {
          return CommentCell(model: listComment[index]);
        },
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: listComment.length);
  }

  Widget ivProfile() {
    Widget placeHolder = SizedBox(
      width: 50,
      height: 50,
      child: Container(
        padding: const EdgeInsets.all(10.0),
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
        }, width: 50, height: 50, fit: BoxFit.fill),
      );
    }

    return Center(
      child: placeHolder,
    );
  }

  Widget tfComment() {
    var isTyping = tfCommentController.text.isNotEmpty;
    Widget suffixIcon = isTyping
        ? btnSend()
        : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [btnLocate(), btnSimilarPosts(), btnShare()]);

    Widget? prefixIcon = isTyping ? btnClear() : null;

    return TextField(
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.send,
      onSubmitted: (value) {
        //sendMessage();
      },
      maxLength: 40,
      maxLines: 1,
      controller: tfCommentController,
      style: UI.textStyleNormal(Colors.black, 12.0),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
          filled: true,
          fillColor: Colors.indigo[50],
          border: UI.borderStyle(Colors.transparent),
          enabledBorder: UI.borderStyle(Colors.transparent),
          focusedBorder: UI.borderStyle(Colors.grey[400]!),
          hintStyle: UI.textStyleNormal(Colors.grey, 12.0),
          hintText: "Enter your comment here",
          errorText: errorComment,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon),
      textCapitalization: TextCapitalization.none,
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      onChanged: (value) {
        setStateIfMounted(() {
          if (value.isNotEmpty && errorComment != null) {
            errorComment = null;
          }
        });
      },
    );
  }

  Widget btnClear() {
    return IconButton(
        onPressed: () {
          setStateIfMounted(() {
            tfCommentController.text = "";
          });
        },
        color: Colors.grey,
        icon: const Icon(Icons.clear));
  }

  Widget btnLike() {
    return InkWell(
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("$likeCount", style: UI.textStyleNormal(Colors.white, 15.0)),
              const SizedBox(width: 5),
              Icon(isLiked ? Icons.favorite_outlined : Icons.favorite_outline,
                  color: isLiked ? Colors.red : Colors.white)
            ],
          )),
      onTap: () {
        insertLike(!isLiked);
      },
    );
  }

  Widget btnSend() {
    return IconButton(
        onPressed: () {
          insertComment();
        },
        color: Colors.indigo,
        icon: const Icon(Icons.send));
  }

  Widget btnShare() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(6.0, 12.0, 12.0, 12.0),
        child: InkWell(
          child: const Icon(Icons.share_outlined, color: Colors.indigo),
          onTap: share,
        ));
  }

  Widget btnSimilarPosts() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(6.0, 12.0, 6.0, 12.0),
        child: InkWell(
          child: const Icon(Icons.compare, color: Colors.indigo),
          onTap: similarPosts,
        ));
  }

  Widget btnLocate() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(6.0, 12.0, 12.0, 12.0),
        child: InkWell(
          child: const Icon(Icons.location_on_outlined, color: Colors.indigo),
          onTap: share,
        ));
  }

  Widget btnSeePhoto() {
    return CustomButton(
        text: "See Photo".toUpperCase(),
        textSize: 10.0,
        onPressed: () {
          PhotoViewerVC.show(context, model?.pimage ?? "");
        },
        backgroundColor: Colors.green,
        padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0));
  }

  similarPosts() {
    String category = (model?.postCategory ?? "").trim();
    if (category.isNotEmpty) {
      Navigator.pushNamed(context, Routes.SIMILAR_POSTS, arguments: category);
    }
  }

  int likeCount = 0;
  bool isLiked = false;

  getComments() {
    var postId = model?.pid ?? "";
    RepoPost.getComments(context, postId, (list) {
      setStateIfMounted(() {
        listComment = list.reversed.toList();
      });
    });
  }

  insertComment() {
    var postId = model?.pid ?? "";
    var userId = model?.uid ?? "";
    RepoPost.insertComment(context, userId, postId, tfCommentController.text,
        (isSuccess, message) {
      if (isSuccess) {
        setStateIfMounted(() {
          tfCommentController.text = "";
        });
        getComments();
      }
    });
  }

  getLikeCounts() {
    RepoPost.getLikeCounts(context, (list) {
      var data = list.where((element) {
        return element.postId == model?.pid;
      });

      if (data.isNotEmpty) {
        setStateIfMounted(() {
          isLiked = data.first.liked ?? false;
          likeCount = data.first.count ?? 0;
        });
      }
    });
  }

  insertLike(bool isLike) {
    var postId = model?.pid ?? "";
    var userId = model?.uid ?? "";
    RepoPost.insertLike(context, userId, postId, isLike, (isSuccess, message) {
      if (isSuccess) {
        getLikeCounts();
      }
    });
  }

  share() {
    FlutterShare.share(
        title: model?.ptitle ?? "",
        text: "${model?.ptitle}\n\n${model?.pdetails}",
        linkUrl: model?.pimage);
  }
}
