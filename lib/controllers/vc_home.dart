import 'package:blog/cells/cell_blog.dart';
import 'package:blog/components/text_field_custom.dart';
import 'package:blog/helper/constants.dart';
import 'package:blog/helper/tools.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/models/model_count.dart';
import 'package:blog/models/model_post.dart';
import 'package:blog/repositories/repo_post.dart';
import 'package:blog/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class HomeVC extends StatefulWidget {
  const HomeVC({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeVC();
  }
}

class _HomeVC extends State<HomeVC> with WidgetsBindingObserver {
  final iconSearch = const Icon(Icons.search, color: Colors.white, size: 20.0);

  String? selectedCategory;

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
    getPosts();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      //onCreate(null);
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
                automaticallyImplyLeading: false,
                title:
                    Text("Home", style: UI.textStyleBold(Colors.white, 15.0))),
            backgroundColor: Colors.transparent,
            body: listing()));
  }

  Widget tfCategory() {
    return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Tags(
          itemCount: Constants.categories.length,
          itemBuilder: (int index) {
            var text = Constants.categories[index];
            return ItemTags(
                key: Key("$index"),
                title: text,
                onPressed: (value) {
                  selectedCategory = value.title;
                },
                textActiveColor: Colors.white,
                textColor: Colors.black,
                textStyle: UI.textStyleNormal(Colors.black, 15.0),
                combine: ItemTagsCombine.withTextAfter,
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                pressEnabled: true,
                highlightColor: Colors.black,
                activeColor: Colors.black,
                singleItem: true,
                index: index);
          },
          alignment: WrapAlignment.start,
          horizontalScroll: true,
        ));
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
          getPosts();
        },
        child: childContainer);
  }

  openPostDetails(PostModel model) {
    Navigator.pushNamed(context, Routes.POST_DETAILS, arguments: model)
        .then((value) {
      getPosts();
    });
  }

  openSimilarPosts(PostModel model) {
    String category = (model.postCategory ?? "").trim();
    if (category.isNotEmpty) {
      Navigator.pushNamed(context, Routes.SIMILAR_POSTS, arguments: category)
          .then((value) {
        getPosts();
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

  getPosts() {
    RepoPost.getAllPosts(context, (list) {
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
