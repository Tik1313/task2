// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:intl/intl.dart';

List<User> userModelFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromMap(x)));

String userModelToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  // late int id;
  late String _name;
  late String _surName;
  late String _userName;
  late String _email;
  late String _password;
  late var _phone;
  late var _bDay;

  set setName(String name) {
    _name = name;
  }

  set setSurName(String surName) {
    _surName = surName;
  }

  set setUserName(String userName) {
    _userName = userName;
  }

  set setEmail(String email) {
    _email = email;
  }

  set setPassword(String password) {
    _password = password;
  }

  set setPhone(var phone) {
    _phone = phone;
  }

  set setBDay(DateTime bDay) {
    _bDay = DateFormat('dd MMMM yyyy').format(bDay);
  }

  String get getName => _name;
  String get getSurName => _surName;
  String get getUserName => _userName;
  String get getEmail => _email;
  String get getPassword => _password;
  String get getPhone => _phone;
  String get getBDay => _bDay;
  // DateTime get getBDay => _bDay;
  // String get getApiBday => DateFormat('dd MM yyyy').format(_bDay);
  // int get getId => id;
  // User({
  //   this._name,
  //   this._surName,
  //   this._bDay,
  //   this._email,
  //   this._password,
  //   this._phone,
  //   this._userName,
  // });

  User.fromJson(Map<String, dynamic> json)
      : _name = json['firstName'],
        _userName = json['name'],
        _email = json['email'],
        _bDay = json['birthDate'],
        _phone = json['phone'],
        _surName = json['lastName'],
        _password = json['password'];

  User.fromMap(Map<String, dynamic> res)
      : _name = res['name'],
        _bDay = res['bDay'],
        _surName = res['surname'],
        _email = res['email'],
        _password = res['password'],
        _phone = res['phone'],
        _userName = res['username'];

  Map<String, Object?> toMap() {
    return {
      'name': _name,
      'bDay': _bDay,
      'surname': _surName,
      'email': _email,
      'password': _password,
      'phone': _phone,
      'username': _userName
    };
  }

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'name': _name,
        'username': _userName,
        'email': _email,
        'bday': _bDay,
        'phone': _phone,
        'surname': _surName,
        'password': _password,
      };

  String toStringg() {
    return 'name: $_name  surname: $_surName username: $_userName email: $_email phone: $_phone birthDay: $_bDay password: $_password';
  }

  User();
}
