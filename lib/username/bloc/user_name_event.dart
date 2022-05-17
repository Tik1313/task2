abstract class UsernameEvent {}

class UsernameValidationEvent extends UsernameEvent {
  UsernameValidationEvent({required this.username});
  final String username;
}

class UsernameUsedCheckEvent extends UsernameEvent {
  UsernameUsedCheckEvent({required this.username});
  final String username;
}
