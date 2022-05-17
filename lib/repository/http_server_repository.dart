// import 'package:http/http.dart';
// import 'package:task2/httpRepository/api_service.dart';

// import '../model/user.dart';

// class HttpServerRepository {
 

 
//   Future<List<User>> getUsers() async {
//     List<User>? users = await ApiService().getUserList();
//     return users;
//   }

//   Future<Response> login(String username, String password) async {
//     return await ApiService().login(username, password);
//   }

//   Future<Response> emailCheck(String email) async {
//     return await ApiService().checkEmail(email);
//   }

//   Future<Response> phoneCheck(String phone) async {
//     return await ApiService().checkPhone(phone);
//   }

//   Future<Response> usernameCheck(String username) async {
//     return await ApiService().checkName(username);
//   }

//   Future<bool> deleteUser(String token) async {
//     return await ApiService().deleteUser(token);
//   }

//   Future<Response> updateUser(User user, String token) async {
//     return await ApiService().updateUser(user, token);
//   }
// }
