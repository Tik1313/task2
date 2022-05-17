abstract class SignUpEvent {}

class FirstNameValidationEvent extends SignUpEvent {
  FirstNameValidationEvent({required this.firstName});
  final String firstName;
}

class LastNameValidationEvent extends SignUpEvent {
  LastNameValidationEvent({required this.lastName});
  final String lastName;
}

class ButtonValidationEvent extends SignUpEvent {
  ButtonValidationEvent({required this.firstName, required this.lastName});
  final String firstName;
  final String lastName;
}
