import '../../model/user.dart';

abstract class UserPageEvent {}

class UserDatesChangeEvent extends UserPageEvent {
  String name;
  String surname;
  String username;
  String password;
  String email;
  User logedInUser;
  UserDatesChangeEvent({
    required this.name,
    required this.surname,
    required this.username,
    required this.password,
    required this.email,
    required this.logedInUser,
  });
}

class DeleteUserEvent extends UserPageEvent {}

class GetUserEvent extends UserPageEvent {}

class LogOutEvent extends UserPageEvent {}
