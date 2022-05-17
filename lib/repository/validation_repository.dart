import 'package:email_validator/email_validator.dart';
import 'package:task2/model/country.dart';

class ValidationRepository {
  bool birthDayValidation(DateTime selectedDate) {
    DateTime? nowDate = DateTime.now();

    if (nowDate.difference(selectedDate).inDays > 5844) {
      return true;
    } else {
      return false;
    }
  }

  bool usernameValidation(String username) {
    if (username.length >= 5) {
      return true;
    } else {
      return false;
    }
  }

  bool passwordValidation(String password) {
    if (password.length >= 8) {
      return true;
    } else {
      return false;
    }
  }

  bool buttonValidation(String username, String password) {
    if (username.isNotEmpty && password.length >= 8) {
      return true;
    }
    return false;
  }

  bool numberValidation(Country country, String number) {
    if (number.isNotEmpty &&
        number.length >= 5 &&
        number.length == country.example.split('').length) {
      return true;
    } else {
      return false;
    }
  }

  bool emailValidation(var email) {
    if (EmailValidator.validate(email)) {
      return true;
    } else {
      return false;
    }
  }

  bool notEmptyValidation(String word) {
    if (word.isNotEmpty) {
      return true;
    }
    return false;
  }
}
