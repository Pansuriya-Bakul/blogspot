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

class LoginVC extends StatefulWidget {
  const LoginVC({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginVC();
  }
}

class _LoginVC extends State<LoginVC> with WidgetsBindingObserver {
  String? errorEmail;
  var tfEmailController = TextEditingController();
  var focusEmail = FocusNode();

  String? errorPassword;
  var tfPasswordController = TextEditingController();
  var focusPassword = FocusNode();

  var hidePassword = true;

  final iconEmailAddress =
      const Icon(Icons.alternate_email, color: Colors.white, size: 16.0);
  final iconLock =
      const Icon(Icons.lock_outline, color: Colors.white, size: 16.0);
  final iconVisibility =
      const Icon(Icons.visibility_outlined, color: Colors.white, size: 16.0);
  final iconNonVisibility = const Icon(Icons.visibility_off_outlined,
      color: Colors.white, size: 16.0);

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
          return false;
        },
        child: Scaffold(
            backgroundColor: Colors.indigo, body: SafeArea(child: body())));
  }

  Widget body() {
    return Container(padding: const EdgeInsets.all(30.0), child: formFields());
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
            Container(
              child: tfPassword(),
              margin: const EdgeInsets.all(10.0),
            ),
            const SizedBox(height: 20.0),
            btnLogin(),
            const SizedBox(height: 5.0),
            Align(
              child: btnForgotPassword(),
              alignment: Alignment.centerRight,
            ),
            const SizedBox(height: 30.0),
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Text("OR",
                  style: UI.textStyleNormal(Colors.white, 15.0),
                  textAlign: TextAlign.center),
              decoration: UI.circleDecoration(Colors.white.withOpacity(0.1),
                  Colors.transparent, Colors.transparent),
            ),
            const SizedBox(height: 45.0),
            btnRegister()
          ],
        ),
        physics: const ClampingScrollPhysics());
  }

  Widget logo() {
    Widget placeHolder = SizedBox(
      width: 120,
      height: 120,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset("assets/images/ph_user.png", color: Colors.black),
        decoration: UI.circleDecoration(
            Colors.white, Colors.transparent, Colors.transparent),
      ),
    );

    return Center(
      child: placeHolder,
    );
  }

  Widget tfEmail() {
    return CustomTextField(
        restorationId: "tfEmail",
        textInputAction: TextInputAction.next,
        controller: tfEmailController,
        showCursor: true,
        hintText: "Email Address",
        focusNode: focusEmail,
        keyboardType: TextInputType.emailAddress,
        prefixIcon: iconEmailAddress,
        errorText: errorEmail,
        onFieldSubmitted: (value) {
          CustomTextField.nextFocus(context, focusPassword);
        },
        onValueChanged: (value) {
          if (value.isNotEmpty && errorEmail != null) {
            setStateIfMounted(() {
              errorEmail = null;
            });
          }
        });
  }

  Widget tfPassword() {
    return CustomTextField(
        restorationId: "tfPassword",
        textInputAction: TextInputAction.done,
        controller: tfPasswordController,
        showCursor: true,
        hintText: "Password",
        hideText: hidePassword,
        focusNode: focusPassword,
        keyboardType: TextInputType.text,
        prefixIcon: iconLock,
        suffixIcon: IconButton(
            onPressed: () {
              setStateIfMounted(() {
                hidePassword = !hidePassword;
              });
            },
            icon: hidePassword ? iconVisibility : iconNonVisibility),
        errorText: errorPassword,
        onFieldSubmitted: (value) {
          CustomTextField.dismissFocus(context);
        },
        onValueChanged: (value) {
          if (value.isNotEmpty && errorPassword != null) {
            setStateIfMounted(() {
              errorPassword = null;
            });
          }
        });
  }

  Widget btnLogin() {
    return CustomButton(
        text: "Login".toUpperCase(),
        onPressed: () {
          login();
        });
  }

  Widget btnRegister() {
    return CustomButton(
      text: "Don't have an Account? Click here",
      onPressed: () {
        Navigator.pushNamed(context, Routes.REGISTER);
      },
      textColor: Colors.black,
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
    );
  }

  TextButton btnForgotPassword() {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.FORGOT_PASSWORD);
        },
        child: Text("Forgot Password?",
            style: UI.textStyleNormal(Colors.white, 12.0)));
  }

  login() {
    var email = tfEmailController.text.trim();
    var emailValidation = Validations.validateEmail(email);

    var password = tfPasswordController.text.trim();
    var passwordValidation = Validations.validatePassword(password);

    var isValid = emailValidation == null && passwordValidation == null;

    if (!isValid) {
      setStateIfMounted(() {
        errorEmail = emailValidation;
        errorPassword = passwordValidation;
      });
      return;
    }

    RepoAuth.login(context, email, password, (isSuccess, message) {
      if (isSuccess) {
        Toast.snackBarSuccess(context: context, message: message);
        Navigator.pushNamed(context, Routes.DASHBOARD);
      } else {
        Toast.snackBarError(context: context, message: message);
      }
    });
  }
}
