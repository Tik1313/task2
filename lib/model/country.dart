// ignore_for_file: file_names, non_constant_identifier_names

class Country {
  late String e164_cc;
  late String iso2_cc;
  late int e164_sc;
  late bool geographic;
  late int level;
  late String name;
  late String example;
  late String display_name;
  late String full_example_with_plus_sign;
  late String display_name_no_e164_cc;
  late String e164_key;

  Country(
      this.e164_cc,
      this.iso2_cc,
      this.e164_sc,
      this.geographic,
      this.level,
      this.name,
      this.example,
      this.display_name,
      this.full_example_with_plus_sign,
      this.display_name_no_e164_cc,
      this.e164_key);

  Country.fromMap(Map<String, dynamic> count) {
    final bool geographicint;
    if (count['geographic'] == 1) {
      geographicint = true;
    } else {
      geographicint = false;
    }

    name = count['name'];
    display_name = count['display_name'];
    iso2_cc = count['iso2_cc'];
    e164_sc = count['e164_sc'];
    geographic = geographicint;
    level = count['level'];
    example = count['example'];
    full_example_with_plus_sign = count['full_example_with_plus_sign'];
    display_name_no_e164_cc = count['display_name_no_e164_cc'];
    e164_key = count['e164_key'];
    e164_cc = count['e164_cc'];
  }

  Country.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    display_name = json['display_name'];
    iso2_cc = json['iso2_cc'];
    e164_sc = json['e164_sc'];
    geographic = json['geographic'];
    level = json['level'];
    example = json['example'];
    full_example_with_plus_sign = json['full_example_with_plus_sign'];
    display_name_no_e164_cc = json['display_name_no_e164_cc'];
    e164_key = json['e164_key'];
    e164_cc = json['e164_cc'];
  }
}
