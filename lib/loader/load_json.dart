// ignore_for_file: import_of_legacy_library_into_null_safe, library_prefixes

import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'package:http/http.dart';
import '../model/country.dart';

class ItemManager {
  late List<Country> countries;

  final String postsURL = 'https://parentstree-server.herokuapp.com/countries';

  Future<List<Country>> getPosts() async {
    Response? res = await get(Uri.parse(postsURL));
    if (res.statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(res.body);
      var temp = jsonMap['countries'];

      var list = temp
          .map<Country>(
            (dynamic item) => Country.fromJson(item),
          )
          .toList();

      // List<dynamic> body = jsonDecode(res.body);
      // var posts = body
      //     .map(
      //       (dynamic item) => MyCountries.fromJson(item),
      //     )
      //     .toList();
      return list;
    } else {
      throw 'Unable to retrieve posts.';
    }
  }

  Future<void> loadItems() async {
    // countries = await readJsonData();
    countries = await getPosts();
  }

  Future<List<Country>> readJsonData() async {
    final jsondata = await rootBundle.rootBundle
        .loadString('assets/loadjson/country-codes.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => Country.fromJson(e)).toList();
  }

  List<Country> get getCountries => countries;
}
