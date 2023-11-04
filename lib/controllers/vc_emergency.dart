import 'package:blog/components/text_field_custom.dart';
import 'package:blog/helper/ui.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyVC extends StatefulWidget {
  const EmergencyVC({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EmergencyVC();
  }
}

class _EmergencyVC extends State<EmergencyVC> {
  List<String> list = ["Ambulance", "Fire", "Police", "National Emergency"];
  List<IconData> icons = [
    Icons.medical_services,
    Icons.local_fire_department,
    Icons.local_police,
    Icons.emergency
  ];
  List<String> callingNumbers = ["102", "101", "100", "112"];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                title: Text("Emergency",
                    style: UI.textStyleBold(Colors.white, 15.0))),
            backgroundColor: Colors.indigo,
            body: listing()));
  }

  Widget listing() {
    return ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
            margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
            decoration: UI.boxDecoration(
                Colors.white, Colors.black, Colors.transparent, 10.0),
            child: Row(
              children: [
                Icon(icons[index]),
                const SizedBox(width: 10.0),
                Expanded(
                    child: Text(list[index],
                        style: UI.textStyleBold(Colors.black, 20.0),
                        textAlign: TextAlign.start)),
                IconButton(
                    onPressed: () {
                      call(callingNumbers[index]);
                    },
                    icon: const Icon(Icons.call, color: Colors.green)),
              ],
            ),
          );
        },
        itemCount: list.length);
  }

  call(String phone) async {
    bool isCall = await Permission.phone.isGranted;
    if (!isCall) {
      Permission.phone.request();
      return;
    }

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    await launch(launchUri.toString());
  }
}
