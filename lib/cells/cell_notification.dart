import 'package:blog/helper/tools.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/models/model_notification.dart';
import 'package:flutter/material.dart';

class NotificationCell extends StatelessWidget {
  final NotificationModel model;

  const NotificationCell({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
      decoration: UI.boxDecoration(
          Colors.black, Colors.black, Colors.transparent, 10.0),
      child: view(context),
    );
  }

  Widget view(BuildContext context) {
    var notificationDate = DateTime.parse(model.ndate ?? "");

    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("${model.ntitle}",
                style: UI.textStyleBold(Colors.white, 18.0),
                textAlign: TextAlign.start),
            const SizedBox(height: 7.5),
            Text("${model.ndetails}",
                style: UI.textStyleNormal(Colors.white, 15.0),
                textAlign: TextAlign.start),
            const SizedBox(height: 5),
            Align(
              child: Text(Tools.formatDate(notificationDate, "dd MMMM, yyyy"),
                  style: UI.textStyleNormal(Colors.white, 10.0),
                  textAlign: TextAlign.end),
              alignment: Alignment.centerRight,
            ),
          ],
        ),
        margin: const EdgeInsets.all(15.0));
  }
}
