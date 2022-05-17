import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/repository/validation_repository.dart';
import 'package:task2/signup/bloc/sign_up_event.dart';
import 'package:task2/signup/bloc/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final ValidationRepository validationRepository;
  SignUpBloc(this.validationRepository) : super(SignUpInitialState()) {
    on<FirstNameValidationEvent>(_mapFirstNameValidEventToState);
    on<LastNameValidationEvent>(_mapLastNameValidEventToState);
    on<ButtonValidationEvent>(_mapButtonValidEventToState);
  }

  Future<void> _mapFirstNameValidEventToState(
      FirstNameValidationEvent event, Emitter<SignUpState> emit) async {
    final firstName = event.firstName;
    validationRepository.notEmptyValidation(firstName)
        ? emit(FirstNameValidState())
        : emit(FirstNameInvalidState());
  }

  Future<void> _mapLastNameValidEventToState(
      LastNameValidationEvent event, Emitter<SignUpState> emit) async {
    final lastName = event.lastName;
    validationRepository.notEmptyValidation(lastName)
        ? emit(LastNameValidState())
        : emit(LastNameInvalidState());
  }

  Future<void> _mapButtonValidEventToState(
      ButtonValidationEvent event, Emitter<SignUpState> emit) async {
    final firstName = event.firstName;
    final lastName = event.lastName;

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      emit(ButtonIsValidState());
    }
  }
}
