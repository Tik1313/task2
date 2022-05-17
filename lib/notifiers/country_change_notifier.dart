import 'package:flutter/cupertino.dart';

import '../model/country.dart';

class CountryChangeNotifier extends ChangeNotifier {
  Country? country;

  void selectCountry(Country selected) {
    country = selected;
    notifyListeners();
  }
}
