abstract class PasswordState {
  // bool isvalid = false;
}

class PasswordInitialState extends PasswordState {}

class PasswordValidState extends PasswordState {}

class PasswordInvalidState extends PasswordState {}

class UserIsCreatedState extends PasswordState {}

class UserNotCreatedState extends PasswordState {
  UserNotCreatedState({required this.responseCode});
  final int responseCode;
}
