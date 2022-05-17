part of 'edid_user_bloc.dart';

abstract class EdidUserEvent {}

class UserEditEvent extends EdidUserEvent {
  String name;
  String surname;
  String username;
  String password;
  String email;
  User logedInUser;
  UserEditEvent({
    required this.name,
    required this.surname,
    required this.username,
    required this.password,
    required this.email,
    required this.logedInUser,
  });
}
