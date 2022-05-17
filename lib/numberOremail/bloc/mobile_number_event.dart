import 'package:task2/model/country.dart';

import '../../model/user.dart';

abstract class MobileNumberEvent {}

class InitialLoadEvent extends MobileNumberEvent {}

class MobileNumberValidationEvent extends MobileNumberEvent {
  MobileNumberValidationEvent(
      {required this.country, required this.number, required this.fullNumber});
  final String fullNumber;
  final String number;
  final Country country;
}

class EmailValidationEvent extends MobileNumberEvent {
  EmailValidationEvent({required this.email});
  final String email;
}

class SetDatesEvent extends MobileNumberEvent {
  SetDatesEvent(
      {required this.email, required this.number, required this.user});
  final String email;
  final String number;
  final User user;
}
