import 'package:blog/cells/cell_blog.dart';
import 'package:blog/components/text_field_custom.dart';
import 'package:blog/helper/toast.dart';
import 'package:blog/helper/tools.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/models/model_count.dart';
import 'package:blog/models/model_post.dart';
import 'package:blog/repositories/repo_post.dart';
import 'package:blog/router/routes.dart';
import 'package:flutter/material.dart';

class MyPostsVC extends StatefulWidget {
  const MyPostsVC({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyPostsVC();
  }
}

class _MyPostsVC extends State<MyPostsVC> with WidgetsBindingObserver {
  List<PostModel> list = [];
  List<CountModel> likes = [];
  List<CountModel> comments = [];

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
    getMyPosts();
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
                title: Text("My Posts",
                    style: UI.textStyleBold(Colors.white, 15.0))),
            backgroundColor: Colors.indigo,
            body: listing()));
  }

  Widget listing() {
    Widget childContainer;
    if (list.isEmpty) {
      childContainer = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.storage, size: 75.0, color: Colors.white),
          const SizedBox(height: 15.0),
          Text("No Data Available",
              style: UI.textStyleNormal(Colors.white, 18.0),
              textAlign: TextAlign.center)
        ],
      );
    } else {
      childContainer = ListView.builder(
          itemBuilder: (context, index) {
            var model = list[index];
            var modelCountLiked = isLiked(model.pid);
            var modelCountComment = isCommented(model.pid);
            var liked = modelCountLiked?.liked ?? false;

            return BlogCell(
                model: model,
                modelCountComment: modelCountComment,
                modelCountLike: modelCountLiked,
                onDetails: () {
                  openPostDetails(model);
                },
                onCategory: () {
                  openSimilarPosts(model);
                },
                onLike: () {
                  insertLike(model, !liked);
                });
          },
          itemCount: list.length);
    }

    return RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.black,
        onRefresh: () async {
          getMyPosts();
        },
        child: childContainer);
  }

  openPostDetails(PostModel model) {
    Navigator.pushNamed(context, Routes.POST_DETAILS, arguments: model)
        .then((value) {
      getMyPosts();
    });
  }

  openSimilarPosts(PostModel model) {
    String category = (model.postCategory ?? "").trim();
    if (category.isNotEmpty) {
      Navigator.pushNamed(context, Routes.SIMILAR_POSTS, arguments: category)
          .then((value) {
        getMyPosts();
      });
    }
  }

  CountModel? isLiked(String? postId) {
    var list = likes.where((element) {
      return element.postId == postId;
    });

    if (list.isNotEmpty) {
      return list.first;
    }
    return null;
  }

  CountModel? isCommented(String? postId) {
    var list = comments.where((element) {
      return element.postId == postId;
    });

    if (list.isNotEmpty) {
      return list.first;
    }
    return null;
  }

  getMyPosts() {
    RepoPost.getMyPosts(context, (list) {
      setStateIfMounted(() {
        this.list = list;
      });
      getLikeCounts();
      getCommentCounts();
    });
  }

  getLikeCounts() {
    RepoPost.getLikeCounts(context, (list) {
      setStateIfMounted(() {
        likes = list;
      });
    });
  }

  getCommentCounts() {
    RepoPost.getCommentCounts(context, (list) {
      setStateIfMounted(() {
        comments = list;
      });
    });
  }

  insertLike(PostModel model, bool isLiked) {
    String postId = model.pid ?? "";
    var userId = model.uid ?? "";
    RepoPost.insertLike(context, userId, postId, isLiked, (isSuccess, message) {
      if (isSuccess) {
        getLikeCounts();
      }
    });
  }
}
