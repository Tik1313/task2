import '../../model/user.dart';

abstract class UserPageState {}

class UserPageInitialState extends UserPageState {}

class UserDatesChengeCompleteState extends UserPageState {}

class UserDatesNotChangedState extends UserPageState {
  // UserDatesNotChangedState({required this.errordata});
  // final ErrorData errordata;
}

class UserPagePasswordInvalidState extends UserPageState {}

class UserPageEmailInvalidState extends UserPageState {}

class UserPageEmailIsAlreadyState extends UserPageState {
  UserPageEmailIsAlreadyState(
      {required this.emailState, required this.usernameState});
  final String emailState;
  final String usernameState;
}

class UserPageUserNameInvalidState extends UserPageState {}

class UserPageDeletedState extends UserPageState {}

class ErrorPageState extends UserPageState {
  ErrorPageState({required this.responseCode});
  final int responseCode;
}

class UserLoadedState extends UserPageState {
  UserLoadedState({required this.user});
  final User user;
}
