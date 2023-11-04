import 'package:blog/components/text_field_custom.dart';
import 'package:blog/dialogs/dialog_logout.dart';
import 'package:blog/helper/apis.dart';
import 'package:blog/helper/constants.dart';
import 'package:blog/helper/tools.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/repositories/repo_auth.dart';
import 'package:blog/router/restart.dart';
import 'package:blog/router/routes.dart';
import 'package:flutter/material.dart';

class ProfileVC extends StatefulWidget {
  const ProfileVC({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileVC();
  }
}

class _ProfileVC extends State<ProfileVC> with WidgetsBindingObserver {
  Map<String, dynamic> user = {};
  bool isNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(onCreate);
    WidgetsBinding.instance?.addObserver(this);
    getProfile();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  void onCreate(_) async {
    var user = await Constants.getUser();
    setStateIfMounted(() {
      this.user = user;
      isNotificationEnabled = user["Is_Notify"] == "1";
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
        child: Scaffold(backgroundColor: Colors.transparent, body: body()));
  }

  Widget body() {
    return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            imageProfile(),
            const SizedBox(height: 15.0),
            Text("${user["uname"]}, ${user["age"]} Years",
                style: UI.textStyleBold(Colors.white, 18.0),
                textAlign: TextAlign.center),
            const SizedBox(height: 5.0),
            Text("${user["email"]}",
                style: UI.textStyleNormal(Colors.white, 15.0),
                textAlign: TextAlign.center),
            const SizedBox(height: 30.0),
            menu()
          ],
        ));
  }

  Widget imageProfile() {
    Widget placeHolder = Container(
      height: 120,
      width: 120,
      padding: const EdgeInsets.all(10.0),
      child: Image.asset("assets/images/ph_user.png", color: Colors.black),
      decoration: UI.circleDecoration(
          Colors.white, Colors.transparent, Colors.transparent),
    );

    String profileImage = "";
    if (user.isNotEmpty) {
      profileImage = user["uphoto"] ?? "";
    }
    if (profileImage.isNotEmpty) {
      placeHolder = ClipOval(
        child: Image.network(APIs.IMAGE_PATH_URL + profileImage,
            errorBuilder: (context, error, stackTrace) {
          return placeHolder;
        }, width: 120, height: 120, fit: BoxFit.fill),
      );
    }

    return Center(
      child: placeHolder,
    );
  }

  Widget menu() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: UI.boxDecoration(
          Colors.white, Colors.black, Colors.transparent, 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          btnEditProfile(),
          const Divider(color: Colors.grey, height: 2),
          btnMyPosts(),
          const Divider(color: Colors.grey, height: 2),
          btnEmergency(),
          const Divider(color: Colors.grey, height: 2),
          btnNotifications(),
          const Divider(color: Colors.grey, height: 2),
          btnLogout()
        ],
      ),
    );
  }

  Widget btnEditProfile() {
    return InkWell(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                const Icon(Icons.edit, color: Colors.black54),
                const SizedBox(width: 15.0),
                Text("Edit Profile",
                    style: UI.textStyleNormal(Colors.black54, 15.0),
                    textAlign: TextAlign.start)
              ],
            )),
        onTap: () {
          Navigator.pushNamed(context, Routes.EDIT_PROFILE).then((value) {
            getProfile();
          });
        });
  }

  Widget btnMyPosts() {
    return InkWell(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                const Icon(Icons.view_list, color: Colors.black54),
                const SizedBox(width: 15.0),
                Text("My Posts",
                    style: UI.textStyleNormal(Colors.black54, 15.0),
                    textAlign: TextAlign.start)
              ],
            )),
        onTap: () {
          Navigator.pushNamed(context, Routes.MY_POSTS).then((value) {
            getProfile();
          });
        });
  }

  Widget btnEmergency() {
    return InkWell(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                const Icon(Icons.emergency, color: Colors.black54),
                const SizedBox(width: 15.0),
                Text("Emergency",
                    style: UI.textStyleNormal(Colors.black54, 15.0),
                    textAlign: TextAlign.start)
              ],
            )),
        onTap: () {
          Navigator.pushNamed(context, Routes.EMERGENCY).then((value) {
            getProfile();
          });
        });
  }

  Widget btnNotifications() {
    return InkWell(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                const Icon(Icons.notifications, color: Colors.black54),
                const SizedBox(width: 15.0),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Enable Notifications",
                        style: UI.textStyleNormal(Colors.black54, 15.0),
                        textAlign: TextAlign.start),
                    const SizedBox(height: 2.5),
                    Text(
                        "Notification will help to improve your user experience better.",
                        style: UI.textStyleNormal(Colors.red, 10.0),
                        textAlign: TextAlign.start)
                  ],
                )),
                Switch(
                    value: isNotificationEnabled,
                    activeColor: Colors.indigo,
                    onChanged: (value) {
                      setStateIfMounted(() {
                        toggleNotification(value);
                      });
                    })
              ],
            )),
        onTap: () {
          setStateIfMounted(() {
            isNotificationEnabled = !isNotificationEnabled;
          });
        });
  }

  Widget btnLogout() {
    return InkWell(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                const Icon(Icons.power_settings_new, color: Colors.black54),
                const SizedBox(width: 15.0),
                Text("Logout",
                    style: UI.textStyleNormal(Colors.black54, 15.0),
                    textAlign: TextAlign.start)
              ],
            )),
        onTap: logout);
  }

  logout() {
    LogoutDialog.show(context, () {
      Constants.clear();
      RestartWidget.restartApp(context);
    });
  }

  toggleNotification(bool isEnable) {
    RepoAuth.toggleNotification(context, isEnable, (isSuccess, message) {
      setStateIfMounted(() {
        if (isSuccess) {
          user["Is_Notify"] = isEnable ? "1" : "0";
          Constants.setUser(user);
          isNotificationEnabled = isEnable;
        }
      });
    });
  }

  getProfile() {
    RepoAuth.getProfile(context, (isSuccess, message) {
      onCreate(null);
    });
  }
}
