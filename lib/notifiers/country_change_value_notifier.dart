import 'package:flutter/cupertino.dart';

import '../model/country.dart';

class CountryChangeValueNotifier extends ValueNotifier<Country?> {
  CountryChangeValueNotifier({Country? value}) : super(value);

  void selectedCountry(Country selected) {
    value = selected;
  }
}
