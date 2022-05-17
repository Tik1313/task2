import '../../model/error_type.dart';

abstract class UsernameState {}

class UsernameInitialState extends UsernameState {}

class UsernameValidState extends UsernameState {}

class UsernameInvalidState extends UsernameState {
  UsernameInvalidState({required this.errorType});
  ErrorType errorType;
}

class ErrorPageState extends UsernameState {
  ErrorPageState({required this.responseCode});
  final int responseCode;
}
