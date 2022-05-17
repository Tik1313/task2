import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task2/httpRepository/constants.dart';

import '../model/user.dart';

class ApiServiceRepository {
  Future<Response> checkConnection() async {
    Uri? url = Uri.parse('${ApiConstants.baseUrl}/checkConnection');
    final res = await http.get(url);
    return res;
  }

  Future<Response> checkEmail(String email) async {
    final body = jsonEncode({'email': email});
    Map<String, String>? headers = {'Content-Type': 'application/json'};
    Uri? url = Uri.parse('${ApiConstants.baseUrl}/check/email');
    final res = await http.post(url, headers: headers, body: body);
    return res;
  }

  Future<http.Response> checkName(String username) async {
    final body = jsonEncode({'name': username});
    Map<String, String>? headers = {'Content-Type': 'application/json'};

    Uri? url = Uri.parse('${ApiConstants.baseUrl}/check/name');
    final res = await http.post(url, headers: headers, body: body);

    return res;
  }

  Future<http.Response> checkPhone(String phone) async {
    final body = jsonEncode({'phone': phone});
    Map<String, String>? headers = {'Content-Type': 'application/json'};
    Uri? url = Uri.parse('${ApiConstants.baseUrl}/check/phone');

    final res = await http.post(url, headers: headers, body: body);
    return res;
  }

  Future<Response> signUp(User user) async {
    Uri? signUpUrl = Uri.parse('${ApiConstants.baseUrl}/addUser');
    Map<String, String>? headers = {'Content-Type': 'application/json'};
    final tokenPref = await SharedPreferences.getInstance();

    final body = jsonEncode({
      'firstName': user.getName,
      'lastName': user.getSurName,
      'password': user.getPassword,
      'email': user.getEmail,
      'phone': user.getPhone,
      'name': user.getUserName,
      'birthDate': user.getBDay
    });

    final res = await http.post(signUpUrl, headers: headers, body: body);
    if (res.statusCode == 200) {
      String token = jsonDecode(res.body)['createdTokenForUser'];
      tokenPref.setString('token', token);
    }
    return res;
  }

  Future<Response> login(String login, String password) async {
    final tokenPref = await SharedPreferences.getInstance();

    Uri? loginUrl = Uri.parse('${ApiConstants.baseUrl}/signin');
    Map<String, String>? headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'login': login, 'password': password});

    final res = await http.post(loginUrl, headers: headers, body: body);
    if (res.statusCode == 200) {
      String token = jsonDecode(res.body)['createdTokenForUser'];
      tokenPref.setString('token', token);
    }
    return res;
  }

  Future<List<User>> getUserList() async {
    Uri? userUrl = Uri.parse('${ApiConstants.baseUrl}/allUsers');
    List<User>? users = [];
    final res = await http.get(userUrl);

    if (res.statusCode == 200) {
      Map<String, dynamic> userMap = jsonDecode(res.body);
      var temp = userMap['users'];

      users = temp
          .map<User>(
            (dynamic item) => User.fromJson(item),
          )
          .toList();
    }
    return users!;
  }

  Future<User?> getMyProfile() async {
    final tokenPref = await SharedPreferences.getInstance();
    final token = tokenPref.getString('token');
    Uri? myProfileUri = Uri.parse('${ApiConstants.baseUrl}/me');
    Map<String, String>? headers = {'token': token!};
    User? user;
    final res = await http.get(myProfileUri, headers: headers);
    if (res.statusCode == 200) {
      user = User.fromJson(jsonDecode(res.body)['user']);
    }
    return user;
  }

  Future<Response> updateUser(User user) async {
    final tokenPref = await SharedPreferences.getInstance();
    final token = tokenPref.getString('token');
    Uri? updateUserUrl = Uri.parse('${ApiConstants.baseUrl}/editAccount');
    Map<String, String>? headers = {
      'token': token!,
      'Content-Type': 'application/json'
    };
    final body = jsonEncode({
      'firstName': user.getName,
      'password': user.getPassword,
      'email': user.getEmail,
      'lastName': user.getSurName,
      'phone': user.getPhone,
      'name': user.getUserName,
      'birthDate': user.getBDay
    });

    final res = await http.post(updateUserUrl, headers: headers, body: body);

    return res;
  }

  Future<bool> deleteUser() async {
    final tokenPref = await SharedPreferences.getInstance();
    final token = tokenPref.getString('token');
    Uri? userUrl = Uri.parse('${ApiConstants.baseUrl}/delete/user');
    Map<String, String>? headers = {'token': token!};
    final res = await http.delete(userUrl, headers: headers);
    bool? b;
    if (res.statusCode == 200) {
      b = true;
      tokenPref.remove('token');
    } else {
      b = false;
    }
    return b;
  }
}
