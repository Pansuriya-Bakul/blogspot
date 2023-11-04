import 'package:blog/cells/cell_notification.dart';
import 'package:blog/components/text_field_custom.dart';
import 'package:blog/helper/tools.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/models/model_notification.dart';
import 'package:blog/repositories/repo_auth.dart';
import 'package:flutter/material.dart';

class NotificationListVC extends StatefulWidget {
  const NotificationListVC({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NotificationListVC();
  }
}

class _NotificationListVC extends State<NotificationListVC>
    with WidgetsBindingObserver {
  List<NotificationModel> list = [];

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
    getNotificationList();
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
                title: Text("Notifications",
                    style: UI.textStyleBold(Colors.white, 15.0))),
            backgroundColor: Colors.transparent,
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
            return NotificationCell(model: list[index]);
          },
          itemCount: list.length);
    }

    return RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.black,
        onRefresh: () async {
          getNotificationList();
        },
        child: childContainer);
  }

  getNotificationList() {
    RepoAuth.getNotifications(context, (list) {
      setStateIfMounted(() {
        this.list = list;
      });
    });
  }
}
