import 'package:blog/components/button_custom.dart';
import 'package:blog/components/text_field_custom.dart';
import 'package:blog/helper/toast.dart';
import 'package:blog/helper/tools.dart';
import 'package:blog/helper/ui.dart';
import 'package:blog/helper/validations.dart';
import 'package:blog/repositories/repo_auth.dart';
import 'package:flutter/material.dart';

class RegisterVC extends StatefulWidget {
  const RegisterVC({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterVC();
  }
}

class _RegisterVC extends State<RegisterVC> with WidgetsBindingObserver {
  String? errorName;
  var tfNameController = TextEditingController();
  var focusName = FocusNode();

  String? errorAge;
  var tfAgeController = TextEditingController();
  var focusAge = FocusNode();

  String? errorEmail;
  var tfEmailController = TextEditingController();
  var focusEmail = FocusNode();

  String? errorPhone;
  var tfPhoneController = TextEditingController();
  var focusPhone = FocusNode();

  String? errorPassword;
  var tfPasswordController = TextEditingController();
  var focusPassword = FocusNode();

  var hidePassword = true;

  final iconFullName =
      const Icon(Icons.person, color: Colors.white, size: 16.0);
  final iconAge =
      const Icon(Icons.accessibility, color: Colors.white, size: 16.0);
  final iconEmailAddress =
      const Icon(Icons.alternate_email, color: Colors.white, size: 16.0);
  final iconPhone = const Icon(Icons.phone, color: Colors.white, size: 16.0);
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
    return Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(
          title:
              Text("Registration", style: UI.textStyleBold(Colors.white, 15.0)),
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
            logo(),
            const SizedBox(height: 15.0),
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
            const Divider(color: Colors.white, height: 2),
            Container(
              child: tfPhone(),
              margin: const EdgeInsets.all(10.0),
            ),
            const Divider(color: Colors.white, height: 2),
            Container(
              child: tfPassword(),
              margin: const EdgeInsets.all(10.0),
            ),
            const SizedBox(height: 20.0),
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
        textInputAction: TextInputAction.next,
        controller: tfEmailController,
        showCursor: true,
        hintText: "Email Address",
        focusNode: focusEmail,
        keyboardType: TextInputType.emailAddress,
        prefixIcon: iconEmailAddress,
        errorText: errorEmail,
        onFieldSubmitted: (value) {
          CustomTextField.nextFocus(context, focusPhone);
        },
        onValueChanged: (value) {
          if (value.isNotEmpty && errorEmail != null) {
            setStateIfMounted(() {
              errorEmail = null;
            });
          }
        });
  }

  Widget tfPhone() {
    return CustomTextField(
        restorationId: "tfPhone",
        textInputAction: TextInputAction.next,
        controller: tfPhoneController,
        showCursor: true,
        hintText: "Phone",
        focusNode: focusPhone,
        keyboardType: TextInputType.phone,
        prefixIcon: iconPhone,
        errorText: errorPhone,
        onFieldSubmitted: (value) {
          CustomTextField.nextFocus(context, focusPassword);
        },
        onValueChanged: (value) {
          if (value.isNotEmpty && errorPhone != null) {
            setStateIfMounted(() {
              errorPhone = null;
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

  Widget btnRegister() {
    return CustomButton(
        text: "Register".toUpperCase(),
        onPressed: () {
          register();
        });
  }

  register() {
    var name = tfNameController.text.trim();
    var nameValidation = Validations.validateText(name);

    var age = tfAgeController.text.trim();
    var ageValidation = Validations.validateText(age);

    var email = tfEmailController.text.trim();
    var emailValidation = Validations.validateEmail(email);

    var phone = tfPhoneController.text.trim();
    var phoneValidation = Validations.validatePhone(phone);

    var password = tfPasswordController.text.trim();
    var passwordValidation = Validations.validatePassword(password);

    var isValid = nameValidation == null &&
        ageValidation == null &&
        emailValidation == null &&
        phoneValidation == null &&
        passwordValidation == null;

    if (!isValid) {
      setStateIfMounted(() {
        errorName = nameValidation;
        errorAge = ageValidation;
        errorEmail = emailValidation;
        errorPhone = phoneValidation;
        errorPassword = passwordValidation;
      });
      return;
    }

    RepoAuth.register(context, name, email, phone, age, password,
        (isSuccess, message) {
      if (isSuccess) {
        Toast.snackBarSuccess(context: context, message: message);
        Navigator.pop(context);
      } else {
        Toast.snackBarError(context: context, message: message);
      }
    });
  }
}
