import 'package:task2/model/country.dart';
import 'package:task2/model/error_type.dart';

abstract class MobileOrEmailState {}

class MobileOrEMailInitialState extends MobileOrEmailState {}

class MobileNumberValidState extends MobileOrEmailState {}

class MobileNumberInvalidState extends MobileOrEmailState {
  MobileNumberInvalidState({required this.errorType});
  ErrorType errorType;
}

class EmailValidState extends MobileOrEmailState {}

class EmailInvalidState extends MobileOrEmailState {
  EmailInvalidState({required this.errorType});
  ErrorType errorType;
}

class InitialLoadState extends MobileOrEmailState {
  InitialLoadState({required this.filteredcountry});
  Country filteredcountry;
}

class NavigateAndDispleySelectedState extends MobileOrEmailState {
  // NavigateAndDispleySelectedState({required this.selectedC});
  // Country selectedC;
}

class ErrorPageState extends MobileOrEmailState {
  ErrorPageState({required this.responseCode});
  final int responseCode;
}
