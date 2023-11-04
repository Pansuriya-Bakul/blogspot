import 'package:blog/components/button_custom.dart';
import 'package:blog/components/loader.dart';
import 'package:blog/components/text_field_custom.dart';
import 'package:blog/helper/constants.dart';
import 'package:blog/helper/toast.dart';
import 'package:blog/helper/tools.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/helper/validations.dart';
import 'package:blog/repositories/repo_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';

class CreatePostVC extends StatefulWidget {
  const CreatePostVC({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreatePostVC();
  }
}

class _CreatePostVC extends State<CreatePostVC> with WidgetsBindingObserver {
  String? errorTitle;
  var tfTitleController = TextEditingController();
  var focusTitle = FocusNode();

  String? errorDescription;
  var tfDescriptionController = TextEditingController();
  var focusDescription = FocusNode();

  HtmlEditorController tfEditorController = HtmlEditorController();

  String photo = "";
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(onCreate);
  }

  onCreate(_) {}

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(
          title:
              Text("Create Post", style: UI.textStyleBold(Colors.white, 15.0)),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          elevation: 0.0,
          centerTitle: true,
        ),
        body: SafeArea(child: formFields()));
  }

  Widget formFields() {
    return ListView(
      children: [
        Container(
          child: tfTitle(),
          margin: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        ),
        const Divider(color: Colors.white, height: 2),
        InkWell(
          child: Container(
            child: Row(
              children: [
                Expanded(
                    child: Text(
                        photo.isEmpty
                            ? "Select Photo From Gallery"
                            : "Photo Selected:\n$photo",
                        textAlign: TextAlign.start,
                        style: UI.textStyleNormal(Colors.white, 15.0))),
                Visibility(
                    child: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
                    visible: photo.isEmpty),
                Visibility(
                    child: InkWell(
                      child: const Icon(Icons.clear, color: Colors.white),
                      onTap: clearImage,
                    ),
                    visible: photo.isNotEmpty),
              ],
            ),
            padding: const EdgeInsets.all(15.0),
            margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
            decoration: UI.boxDecoration(Colors.white.withOpacity(0.25),
                Colors.transparent, Colors.transparent, 5.0),
          ),
          onTap: openImagePicker,
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
            child: tfCategory()),
        Padding(
          child: tfEditor(),
          padding: const EdgeInsets.all(15.0),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
            child: btnPost())
      ],
    );
  }

  Widget tfTitle() {
    return CustomTextField(
        restorationId: "tfTitle",
        textInputAction: TextInputAction.next,
        controller: tfTitleController,
        showCursor: true,
        hintText: "Add Title",
        textSize: 20.0,
        focusNode: focusTitle,
        keyboardType: TextInputType.text,
        errorText: errorTitle,
        maxLength: 100,
        onFieldSubmitted: (value) {
          CustomTextField.nextFocus(context, focusDescription);
        },
        onValueChanged: (value) {
          if (value.isNotEmpty && errorTitle != null) {
            setStateIfMounted(() {
              errorTitle = null;
            });
          }
        });
  }

  Widget tfCategory() {
    return Tags(
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
    );
  }

  Widget tfDescription() {
    return CustomTextField(
        restorationId: "tfDescription",
        textInputAction: TextInputAction.newline,
        controller: tfDescriptionController,
        showCursor: true,
        hintText: "Description",
        hintColor: Colors.white,
        focusNode: focusDescription,
        maxLines: 8,
        keyboardType: TextInputType.multiline,
        errorText: errorDescription,
        maxLength: 300,
        onFieldSubmitted: (value) {
          CustomTextField.dismissFocus(context);
        },
        onValueChanged: (value) {
          if (value.isNotEmpty && errorDescription != null) {
            setStateIfMounted(() {
              errorDescription = null;
            });
          }
        });
  }

  Widget tfEditor() {
    return HtmlEditor(
      controller: tfEditorController,
      htmlEditorOptions: const HtmlEditorOptions(
          inputType: HtmlInputType.text,
          characterLimit: 300,
          adjustHeightForKeyboard: true,
          darkMode: false,
          hint: "Description",
          autoAdjustHeight: true),
      otherOptions: const OtherOptions(
        height: 300,
      ),
      htmlToolbarOptions: const HtmlToolbarOptions(
          renderBorder: true, toolbarType: ToolbarType.nativeScrollable),
    );
  }

  clearImage() {
    setStateIfMounted(() {
      photo = "";
    });
  }

  openImagePicker() async {
    var request = await Permission.storage.request();
    if (!request.isGranted) {
      openAppSettings();
      return;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        allowCompression: true,
        dialogTitle: "Pick Photo");

    setStateIfMounted(() {
      photo = result?.paths.first ?? "";
    });
  }

  Widget btnPost() {
    return CustomButton(
        text: "Post".toUpperCase(), onPressed: checkLocationPermission);
  }

  checkLocationPermission() async {
    bool isLocation = await Permission.locationWhenInUse.isGranted;
    if (!isLocation) {
      var requestStatus = await Permission.locationWhenInUse.request();
      if (requestStatus.isPermanentlyDenied) {
        Toast.snackBarError(
            context: context, message: "Change permission from settings.");
        return;
      }
    } else {
      createPost();
    }
  }

  createPost() async {
    var title = tfTitleController.text;
    var description = await tfEditorController.getText();

    var titleValidation = Validations.validateText(title);
    var descriptionValidation = Validations.validateText(description);

    var isValid = titleValidation == null &&
        descriptionValidation == null &&
        selectedCategory != null;

    if (!isValid) {
      if (selectedCategory == null) {
        Toast.snackBarError(
            context: context, message: "Select any one category.");
      } else if (errorDescription == null) {
        Toast.snackBarError(
            context: context, message: "Please enter description.");
      } else {
        setStateIfMounted(() {
          errorTitle = titleValidation;
        });
      }
      return;
    }

    Loader.show(context, text: "Fetching Current Location");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    Loader.dismiss(context);

    RepoPost.createPost(context, photo, title, description, selectedCategory!,
        position.latitude, position.longitude, (isSuccess, message) {
      if (isSuccess) {
        Toast.snackBarSuccess(context: context, message: message);
        Navigator.pop(context);
      } else {
        Toast.snackBarError(context: context, message: message);
      }
    });
  }
}
