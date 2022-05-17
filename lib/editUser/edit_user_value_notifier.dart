import 'package:flutter/cupertino.dart';

import '../model/user.dart';

class EditUserValueNotifier extends ValueNotifier<User?> {
  EditUserValueNotifier({User? value}) : super(value);

  void selectUser(User user) {
    value = user;
    notifyListeners();
  }
}
