abstract class LoginEvent {}

class UserNameCheckEvent extends LoginEvent {
  UserNameCheckEvent({required this.username});
  final String username;
}

class PasswordCheckEvent extends LoginEvent {
  PasswordCheckEvent({required this.password});
  final String password;
}

class ButtonValidCheckEvent extends LoginEvent {
  ButtonValidCheckEvent({required this.username, required this.password});
  final String username;
  final String password;
}

class LoginCheckEvent extends LoginEvent {
  LoginCheckEvent({required this.username, required this.password});
  final String username;
  final String password;
}
