import 'package:blog/components/button_custom.dart';
import 'package:blog/components/text_field_custom.dart';
import 'package:blog/helper/constants.dart';
import 'package:blog/helper/toast.dart';
import 'package:blog/helper/tools.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/helper/validations.dart';
import 'package:blog/repositories/repo_auth.dart';
import 'package:blog/router/routes.dart';
import 'package:flutter/material.dart';

class ForgotPasswordVC extends StatefulWidget {
  const ForgotPasswordVC({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordVC();
  }
}

class _ForgotPasswordVC extends State<ForgotPasswordVC>
    with WidgetsBindingObserver {
  String? errorEmail;
  var tfEmailController = TextEditingController();
  var focusEmail = FocusNode();

  final iconEmailAddress =
      const Icon(Icons.alternate_email, color: Colors.white, size: 16.0);

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
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
            backgroundColor: Colors.indigo,
            appBar: AppBar(
              title: Text("Forgot Password?",
                  style: UI.textStyleBold(Colors.white, 15.0)),
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: true,
              elevation: 0.0,
              centerTitle: true,
            ),
            body: SafeArea(child: body())));
  }

  Widget body() {
    return Padding(padding: const EdgeInsets.all(30.0), child: formFields());
  }

  Widget formFields() {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 50.0),
                child: logo()),
            Container(
              child: tfEmail(),
              margin: const EdgeInsets.all(10.0),
            ),
            const Divider(color: Colors.white, height: 2),
            const SizedBox(height: 20.0),
            btnSubmit(),
          ],
        ),
        physics: const ClampingScrollPhysics());
  }

  Widget logo() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: UI.circleDecoration(
          Colors.white, Colors.transparent, Colors.transparent),
      child: const Icon(Icons.all_inclusive, color: Colors.indigo, size: 80.0),
    );
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

  Widget btnSubmit() {
    return CustomButton(
        text: "Submit".toUpperCase(),
        onPressed: forgotPassword);
  }

  checkAuth() async {
    Map<String, dynamic> json = await Constants.getUser();
    if (json.isEmpty) {
      Navigator.pushNamed(context, Routes.LOGIN);
      return;
    }
  }

  forgotPassword() {
    var email = tfEmailController.text.trim();
    var emailValidation = Validations.validateEmail(email);
    var isValid = emailValidation == null;

    if (!isValid) {
      setStateIfMounted(() {
        errorEmail = emailValidation;
      });
      return;
    }

    RepoAuth.forgotPassword(context, email, (isSuccess, message) {
      if (isSuccess) {
        Toast.snackBarSuccess(context: context, message: message);
        Navigator.pop(context);
      } else {
        Toast.snackBarError(context: context, message: message);
      }
    });
  }
}
