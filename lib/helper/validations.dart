import 'package:email_validator/email_validator.dart';
import 'package:flutter_pw_validator/Utilities/Validator.dart';

class Validations {
  static String cannotBeEmpty = "This is a required field, cannot be empty.";

  static String? validateText(String name) {
    if (name.isEmpty) {
      return cannotBeEmpty;
    }
    return null;
  }

  static String? validatePassword(String password,
      {minLength = 6, uppercaseCount = 1, numericCount = 1, specialCount = 1}) {
    if (password.isEmpty) {
      return cannotBeEmpty;
    }
    Validator validator = Validator();
    if (!validator.hasMinLength(password, minLength)) {
      return "Password must be at least $minLength characters.";
    }
    // if (!validator.hasMinUppercase(password, uppercaseCount)){
    //   return "Password must contain at least $uppercaseCount uppercase character.";
    // }
    // if (!validator.hasMinNumericChar(password, numericCount)){
    //   return "Password must contain at least $numericCount numeric character.";
    // }
    // if (!validator.hasMinSpecialChar(password, specialCount)){
    //   return "Password must contain at least $specialCount special character.";
    // }
    return null;
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return cannotBeEmpty;
    }
    if (!EmailValidator.validate(email)) {
      return "Email address is invalid.";
    }
    return null;
  }

  static String? validatePhone(String number) {
    if (number.isEmpty) {
      return cannotBeEmpty;
    }
    Validator validator = Validator();
    if (!validator.hasMinNumericChar(number, 10)) {
      return "Phone number must contain only 10 digits.";
    }
    return null;
  }

  static String? validateID(int id) {
    if (id == 0) {
      return cannotBeEmpty;
    }
    return null;
  }
}
