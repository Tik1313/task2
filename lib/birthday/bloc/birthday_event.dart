abstract class BirthDayEvent {}

class BirthDayValidationEvent extends BirthDayEvent {
  BirthDayValidationEvent({required this.selectedDate});
  // final List<int> selectedDate;
  DateTime selectedDate;
  // final List<int> nowDate;
}
