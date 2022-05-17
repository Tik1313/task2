import 'package:flutter/cupertino.dart';

import '../repository/validation_repository.dart';

class EmailValidationNotifier extends ValueNotifier<bool> {
  EmailValidationNotifier(bool value) : super(value);
  final validationRapository = ValidationRepository();

  void validationChack(String email) {
    value = validationRapository.emailValidation(email);
  }
}
