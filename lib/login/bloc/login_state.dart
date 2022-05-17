abstract class LoginState {}

class InitialState extends LoginState {}

class UserNameVallidState extends LoginState {}

class UserNameInValidState extends LoginState {}

class PasswordValidState extends LoginState {}

class PasswordInValidState extends LoginState {}

class ButtonIsValidState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LogErrorPageState extends LoginState {
  LogErrorPageState({required this.errorCode, required this.errorText});
  final int errorCode;
  final String errorText;
}
