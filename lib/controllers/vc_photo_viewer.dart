import 'package:blog/helper/apis.dart';
import 'package:blog/helper/ui.dart';
import 'package:flutter/material.dart';

class PhotoViewerVC extends StatefulWidget {
  final String photo;

  const PhotoViewerVC({Key? key, required this.photo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PhotoViewerVC();
  }

  static show(BuildContext context, String photo) {
    showDialog(
        context: context,
        useSafeArea: true,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PhotoViewerVC(photo: photo);
        });
  }
}

class _PhotoViewerVC extends State<PhotoViewerVC> with WidgetsBindingObserver {
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
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.8),
            appBar: AppBar(
              title: Text("View Photo",
                  style: UI.textStyleBold(Colors.white, 15.0)),
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: true,
              elevation: 0.0,
              centerTitle: true,
            ),
            body: SafeArea(child: imageView())));
  }

  Widget imageView() {
    Widget placeHolder = Container(
      child: Image.asset("assets/images/ph_user.png", color: Colors.black),
      decoration: UI.circleDecoration(
          Colors.white, Colors.transparent, Colors.transparent),
    );

    if (widget.photo.isNotEmpty) {
      placeHolder = Image.network(APIs.IMAGE_PATH_URL + widget.photo,
          errorBuilder: (context, error, stackTrace) {
        return placeHolder;
      }, fit: BoxFit.fill);
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: placeHolder,
      ),
    );
  }
}
