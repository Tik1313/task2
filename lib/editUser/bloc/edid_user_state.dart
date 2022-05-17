part of 'edid_user_bloc.dart';

@immutable
abstract class EdidUserState {}

class EdidUserInitialState extends EdidUserState {}

class UserNameIsAlreadyState extends EdidUserState {
  UserNameIsAlreadyState(
      {required this.emailState, required this.usernameState});
  final String emailState;
  final String usernameState;
}

class ErrorPageState extends EdidUserState {
  ErrorPageState({required this.responseCode});
  final int responseCode;
}

class UserNameInValidState extends EdidUserState {}

class EmailIsAlreadyState extends EdidUserState {
  EmailIsAlreadyState({required this.emailState, required this.usernameState});
  final String emailState;
  final String usernameState;
}

class EmailInValidState extends EdidUserState {}

class PasswordInValidState extends EdidUserState {}

class EditingComplateState extends EdidUserState {}
