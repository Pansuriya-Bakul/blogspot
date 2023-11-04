import 'package:blog/controllers/vc_create_post.dart';
import 'package:blog/controllers/vc_friends_list.dart';
import 'package:blog/controllers/vc_home.dart';
import 'package:blog/controllers/vc_notification_list.dart';
import 'package:blog/controllers/vc_profile.dart';
import 'package:blog/helper/tools.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/router/routes.dart';
import 'package:flutter/material.dart';

class DashboardVC extends StatefulWidget {
  const DashboardVC({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DashboardVC();
  }
}

class _DashboardVC extends State<DashboardVC> with WidgetsBindingObserver {
  int fragmentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(onCreate);
    WidgetsBinding.instance?.addObserver(this);
  }

  onCreate(_) {}

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            backgroundColor: Colors.indigo,
            body: SafeArea(child: body()),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: UI.boxDecoration(
                  Colors.black, Colors.transparent, Colors.transparent, 15.0),
              child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  currentIndex: fragmentIndex,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white.withOpacity(0.5),
                  iconSize: 30.0,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  onTap: (index) {
                    if (index == 2) {
                      Navigator.pushNamed(context, Routes.CREATE_POST)
                          .then((value) {
                        setStateIfMounted(() {});
                      });
                      return;
                    }
                    setStateIfMounted(() {
                      fragmentIndex = index;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        activeIcon: Icon(Icons.home),
                        label: "Home"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.people_outline),
                        activeIcon: Icon(Icons.people),
                        label: "Friends"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.add_circle_outline),
                        activeIcon: Icon(Icons.add_circle),
                        label: "Add Post"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.notifications_outlined),
                        activeIcon: Icon(Icons.notifications),
                        label: "Notifications"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.account_circle_outlined),
                        activeIcon: Icon(Icons.account_circle),
                        label: "Profile")
                  ]),
            )));
  }

  Widget body() {
    if (fragmentIndex == 0) {
      return const HomeVC();
    } else if (fragmentIndex == 1) {
      return const FriendListVC();
    } else if (fragmentIndex == 2) {
      return const CreatePostVC();
    } else if (fragmentIndex == 3) {
      return const NotificationListVC();
    } else if (fragmentIndex == 4) {
      return const ProfileVC();
    }
    return Container();
  }
}
