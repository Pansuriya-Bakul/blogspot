import 'package:blog/cells/cell_friend.dart';
import 'package:blog/components/text_field_custom.dart';
import 'package:blog/components/text_field_search.dart';
import 'package:blog/helper/constants.dart';
import 'package:blog/helper/toast.dart';
import 'package:blog/helper/tools.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/models/model_follow.dart';
import 'package:blog/models/model_user.dart';
import 'package:blog/repositories/repo_follow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendListVC extends StatefulWidget {
  const FriendListVC({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FriendListVC();
  }
}

class _FriendListVC extends State<FriendListVC> with WidgetsBindingObserver {
  String keywords = "";
  String? errorSearch;
  var tfSearchController = TextEditingController();
  var focusSearch = FocusNode();

  final iconSearch = const Icon(Icons.search, color: Colors.white, size: 20.0);

  String userId = "";

  int selectedSegment = 0;

  List<FollowModel> listFollowers = [];
  List<UserModel> listFilter = [];
  List<UserModel> list = [];

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
    Constants.getUser().then((value) {
      userId = value["uid"];
      getFriendList();
    });
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
                automaticallyImplyLeading: false,
                title: Text("People",
                    style: UI.textStyleBold(Colors.white, 15.0))),
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Container(
                  child: tfSearch(),
                  margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                ),
                Expanded(child: listing())
              ],
            )));
  }

  Widget segmentControl() {
    return CupertinoSlidingSegmentedControl<int>(
        groupValue: selectedSegment,
        children: {0: buildSegment("Followings"), 1: buildSegment("Followers")},
        backgroundColor: Colors.white.withOpacity(0.5),
        onValueChanged: (value) {
          setStateIfMounted(() {
            selectedSegment = value ?? 0;
          });
        });
  }

  Widget buildSegment(String text) {
    return Text(text, style: UI.textStyleNormal(Colors.black, 12.0));
  }

  Widget tfSearch() {
    return SearchTextField(
        text: keywords,
        onChanged: (value) {
          keywords = value;
          filter();
        },
        onFieldSubmitted: (value) {
          CustomTextField.dismissFocus(context);
        },
        hintText: "Who are you looking for?");
  }

  Widget listing() {
    Widget childContainer;
    if (listFilter.isEmpty) {
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
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            var model = listFilter[index];
            var isFollowed = listFollowers.where((element) {
              return model.uid == element.personid;
            }).isNotEmpty;

            return FriendCell(
                model: model,
                isMe: model.uid == userId,
                isFollowed: isFollowed,
                onFollow: () {
                  insertFollower(model);
                },
                onUnfollow: () {
                  deleteFollower(model);
                });
          },
          itemCount: listFilter.length);
    }

    return RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.black,
        onRefresh: () async {
          getFriendList();
        },
        child: childContainer);
  }

  filter() {
    setStateIfMounted(() {
      if (keywords.isEmpty) {
        listFilter = list;
      } else {
        listFilter = list.where((element) {
          var name = element.uname ?? "";
          var email = element.email ?? "";
          return name.contains(keywords) || email.contains(keywords);
        }).toList();
      }
    });
  }

  getFriendList() {
    RepoFollow.getAllUsers(context, (list) {
      this.list = list;
      filter();
      getFollowers();
    });
  }

  getFollowers() {
    RepoFollow.getMyFollowers(context, (list) {
      setStateIfMounted(() {
        listFollowers = list;
      });
    });
  }

  insertFollower(UserModel model) {
    var userId = model.uid ?? "";
    var userName = model.uname ?? "";
    RepoFollow.insertFollow(context, userId, userName, (isSuccess, message) {
      if (isSuccess) {
        Toast.snackBarSuccess(context: context, message: message);
        getFollowers();
      } else {
        Toast.snackBarError(context: context, message: message);
      }
    });
  }

  deleteFollower(UserModel model) {
    var userId = model.uid ?? "";
    RepoFollow.deleteFollow(context, userId, (isSuccess, message) {
      if (isSuccess) {
        Toast.snackBarSuccess(context: context, message: message);
        getFollowers();
      } else {
        Toast.snackBarError(context: context, message: message);
      }
    });
  }
}
