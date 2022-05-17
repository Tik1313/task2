import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/httpRepository/api_service.dart';
import 'package:task2/model/user.dart';
import 'package:task2/password/bloc/password_event.dart';
import 'package:task2/password/bloc/password_state.dart';
import 'package:task2/repository/database_repository.dart';
import 'package:task2/repository/validation_repository.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final ValidationRepository validationRepository;
  final ApiServiceRepository apiServiceRepository;
  final DatabaseRepository databaseRepository;
  PasswordBloc(this.validationRepository, this.apiServiceRepository,
      this.databaseRepository)
      : super(PasswordInitialState()) {
    on<PasswordValidationEvent>(_mapEventToState);
    on<CreateNewUserEvent>(_mapCreateUserEventToState);
  }

  Future<void> _mapEventToState(
      PasswordValidationEvent event, Emitter<PasswordState> emit) async {
    final password = event.password;
    validationRepository.passwordValidation(password)
        ? emit(PasswordValidState())
        : emit(PasswordInvalidState());
  }

  Future<void> _mapCreateUserEventToState(
      CreateNewUserEvent event, Emitter<PasswordState> emit) async {
    final user = event.user;

    // try {
    // final res = await httpServerRepository.addUser(user);
    // } catch (ee) {

    // }
    // User? createdUser;
    final res = await apiServiceRepository.signUp(user);
    // try{
    // databaseRepository.addItem(user);
    //   emit(UserIsCreatedState());
    // }catch(notUser){
    //   emit(UserNotCreatedState(responseCode: res.statusCode));

    // }
    if (res.statusCode == 200) {
      User? user = User.fromJson((jsonDecode(res.body))['user']);
      databaseRepository.addItem(user);
      emit(UserIsCreatedState());
    } else {
      emit(UserNotCreatedState(responseCode: res.statusCode));
    }
  }
}

  // Stream mapEventToState(PasswordEvent event) async* {
  // if (event is PasswordValidationEvent) {
  // final password = event.password;
  // yield PasswordValid();
  // }
  // }
