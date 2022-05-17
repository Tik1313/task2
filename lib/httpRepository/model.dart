// import 'dart:convert';

// List<UserModel> userModelFromJson(String str) =>
//     List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

// String userModelToJson(List<UserModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class UserModel {
//   UserModel({
//     required this.id,
//     required this.name,
//     required this.username,
//     required this.email,
//     required this.bday,
//     required this.phone,
//     required this.password,
//     required this.surname,
//   });

//   int id;
//   String name;
//   String username;
//   String email;
//   String phone;
//   String surname;
//   String password;
//   String bday;

//   factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
//         id: json['id'],
//         name: json['name'],
//         username: json['username'],
//         email: json['email'],
//         bday: json['bday'],
//         phone: json['phone'],
//         surname: json['surname'],
//         password: json['password'],
//       );

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'username': username,
//         'email': email,
//         'bday': bday,
//         'phone': phone,
//         'surname': surname,
//         'password': password,
//       };
// }

// // class Address {
// //   Address({
// //     required this.street,
// //     required this.suite,
// //     required this.city,
// //     required this.zipcode,
// //     required this.geo,
// //   });

// //   String street;
// //   String suite;
// //   String city;
// //   String zipcode;
// //   Geo geo;

// //   factory Address.fromJson(Map<String, dynamic> json) => Address(
// //         street: json['street'],
// //         suite: json['suite'],
// //         city: json['city'],
// //         zipcode: json['zipcode'],
// //         geo: Geo.fromJson(json['geo']),
// //       );

// //   Map<String, dynamic> toJson() => {
// //         'street': street,
// //         'suite': suite,
// //         'city': city,
// //         'zipcode': zipcode,
// //         'geo': geo.toJson(),
// //       };
// // }
