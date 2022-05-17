import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/validation_repository.dart';
import 'birthday_event.dart';
import 'birthday_state.dart';

class BirthDayBloc extends Bloc<BirthDayEvent, BirthDayState> {
  final ValidationRepository validationRepository;
  BirthDayBloc(this.validationRepository) : super(BirthDayInitialState()) {
    on<BirthDayValidationEvent>(_mapBirthDayValidEventToState);
  }

  Future<void> _mapBirthDayValidEventToState(
      BirthDayValidationEvent event, Emitter<BirthDayState> emit) async {
    final selectedDate = event.selectedDate;
    validationRepository.birthDayValidation(selectedDate)
        ? emit(BirthDayValidState())
        : emit(BirthDayInvalidState());
  }
}
