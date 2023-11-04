import 'package:blog/components/button_custom.dart';
import 'package:blog/components/text_field_custom.dart';
import 'package:blog/helper/apis.dart';
import 'package:blog/helper/constants.dart';
import 'package:blog/helper/toast.dart';
import 'package:blog/helper/tools.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/helper/validations.dart';
import 'package:blog/repositories/repo_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

class EditProfileVC extends StatefulWidget {
  const EditProfileVC({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditProfileVC();
  }
}

class _EditProfileVC extends State<EditProfileVC> with WidgetsBindingObserver {
  String? errorName;
  var tfNameController = TextEditingController();
  var focusName = FocusNode();

  String? errorAge;
  var tfAgeController = TextEditingController();
  var focusAge = FocusNode();

  String? errorEmail;
  var tfEmailController = TextEditingController();
  var focusEmail = FocusNode();

  String photo = "";

  final iconFullName =
      const Icon(Icons.person, color: Colors.white, size: 16.0);
  final iconAge =
      const Icon(Icons.accessibility, color: Colors.white, size: 16.0);
  final iconEmailAddress =
      const Icon(Icons.alternate_email, color: Colors.white, size: 16.0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(onCreate);
  }

  void onCreate(_) async {
    setupUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(
          title:
              Text("Edit Profile", style: UI.textStyleBold(Colors.white, 15.0)),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          elevation: 0.0,
          centerTitle: true,
        ),
        body: SafeArea(child: formFields()));
  }

  Widget formFields() {
    return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            imageProfile(),
            Container(
              child: tfName(),
              margin: const EdgeInsets.all(10.0),
            ),
            const Divider(color: Colors.white, height: 2),
            Container(
              child: tfAge(),
              margin: const EdgeInsets.all(10.0),
            ),
            const Divider(color: Colors.white, height: 2),
            Container(
              child: tfEmail(),
              margin: const EdgeInsets.all(10.0),
            ),
            const SizedBox(height: 20.0),
            btnUpdate()
          ],
        ),
        physics: const ClampingScrollPhysics());
  }

  Widget imageProfile() {
    Widget placeHolder = Container(
      width: 120,
      height: 120,
      padding: const EdgeInsets.all(10.0),
      child: Image.asset("assets/images/ph_user.png", color: Colors.black),
      decoration: UI.circleDecoration(
          Colors.white, Colors.transparent, Colors.transparent),
    );

    if (photo.isNotEmpty) {
      placeHolder = ClipOval(
        child: Image.network(APIs.IMAGE_PATH_URL + photo,
            errorBuilder: (context, error, stackTrace) {
          return placeHolder;
        }, width: 120, height: 120, fit: BoxFit.fill),
      );
    }

    List<Widget> children = [];
    children.add(placeHolder);
    children.add(
        Padding(padding: const EdgeInsets.all(15.0), child: btnChangePhoto()));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: children,
    );
  }

  Widget tfName() {
    return CustomTextField(
        restorationId: "tfName",
        textInputAction: TextInputAction.next,
        controller: tfNameController,
        showCursor: true,
        hintText: "Name",
        focusNode: focusName,
        keyboardType: TextInputType.text,
        prefixIcon: iconFullName,
        errorText: errorName,
        onFieldSubmitted: (value) {
          CustomTextField.nextFocus(context, focusAge);
        },
        onValueChanged: (value) {
          if (value.isNotEmpty && errorName != null) {
            setStateIfMounted(() {
              errorName = null;
            });
          }
        });
  }

  Widget tfAge() {
    return CustomTextField(
        restorationId: "tfAge",
        textInputAction: TextInputAction.next,
        controller: tfAgeController,
        showCursor: true,
        hintText: "Age",
        focusNode: focusAge,
        keyboardType: TextInputType.number,
        prefixIcon: iconAge,
        errorText: errorAge,
        onFieldSubmitted: (value) {
          CustomTextField.nextFocus(context, focusEmail);
        },
        onValueChanged: (value) {
          if (value.isNotEmpty && errorAge != null) {
            setStateIfMounted(() {
              errorAge = null;
            });
          }
        });
  }

  Widget tfEmail() {
    return CustomTextField(
        restorationId: "tfEmail",
        textInputAction: TextInputAction.done,
        controller: tfEmailController,
        showCursor: true,
        hintText: "Email Address",
        focusNode: focusEmail,
        keyboardType: TextInputType.emailAddress,
        prefixIcon: iconEmailAddress,
        errorText: errorEmail,
        onFieldSubmitted: (value) {
          CustomTextField.dismissFocus(context);
        },
        onValueChanged: (value) {
          if (value.isNotEmpty && errorEmail != null) {
            setStateIfMounted(() {
              errorEmail = null;
            });
          }
        });
  }

  Widget btnUpdate() {
    return CustomButton(
        text: "Update".toUpperCase(),
        onPressed: () {
          updateProfile();
        });
  }

  updateProfile() {
    var name = tfNameController.text.trim();
    var nameValidation = Validations.validateText(name);

    var age = tfAgeController.text.trim();
    var ageValidation = Validations.validateText(age);

    var email = tfEmailController.text.trim();
    var emailValidation = Validations.validateEmail(email);

    var isValid = nameValidation == null &&
        ageValidation == null &&
        emailValidation == null;

    if (!isValid) {
      setStateIfMounted(() {
        errorName = nameValidation;
        errorAge = ageValidation;
        errorEmail = emailValidation;
      });
      return;
    }
    RepoAuth.updateProfile(context, name, email, age, (isSuccess, message) {
      if (isSuccess) {
        Toast.snackBarSuccess(context: context, message: message);
        Navigator.pop(context);
      } else {
        Toast.snackBarError(context: context, message: message);
      }
    });
  }

  setupUser() async {
    var user = await Constants.getUser();
    setStateIfMounted(() {
      tfNameController.text = user["uname"];
      tfAgeController.text = user["age"];
      tfEmailController.text = user["email"];
      photo = user["uphoto"];
    });
  }

  // -------- PERMISSIONS

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

    var imagePath = result?.paths.first ?? "";
    if (imagePath.isNotEmpty) {
      uploadProfile(imagePath);
    }
  }

  uploadProfile(String imagePath) {
    RepoAuth.uploadProfile(context, imagePath, (isSuccess, message) {
      getProfile();
    });
  }

  getProfile() {
    RepoAuth.getProfile(context, (isSuccess, message) {
      setupUser();
    });
  }

  Widget btnChangePhoto() {
    return CustomButton(
        text: "Change Photo".toUpperCase(),
        textSize: 10.0,
        onPressed: openImagePicker,
        backgroundColor: Colors.green,
        padding: const EdgeInsets.all(10.0));
  }
}
