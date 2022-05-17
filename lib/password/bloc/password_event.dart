import '../../model/user.dart';

abstract class PasswordEvent {}

class PasswordValidationEvent extends PasswordEvent {
  PasswordValidationEvent({required this.password});
  final String password;
}

class CreateNewUserEvent extends PasswordEvent {
  CreateNewUserEvent({required this.user});
  final User user;
}
