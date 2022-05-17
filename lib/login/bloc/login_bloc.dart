import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/httpRepository/api_service.dart';
import 'package:task2/login/bloc/login_event.dart';
import 'package:task2/login/bloc/login_state.dart';
import 'package:task2/repository/validation_repository.dart';

import '../../repository/database_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final DatabaseRepository databaseRepository;
  final ApiServiceRepository apiServiceRepository;
  final ValidationRepository validationRepository;
  LoginBloc(this.validationRepository, this.databaseRepository,
      this.apiServiceRepository)
      : super(InitialState()) {
    on<UserNameCheckEvent>(_mapUsernameEventToState);
    on<PasswordCheckEvent>(_mapPasswordEventToState);
    on<LoginCheckEvent>(_mapLoginEventToState);
    on<ButtonValidCheckEvent>(_mapButtonValidEventToState);
  }

  Future<void> _mapButtonValidEventToState(
      ButtonValidCheckEvent event, Emitter<LoginState> emit) async {
    final username = event.username;
    final password = event.password;

    if (validationRepository.buttonValidation(username, password)) {
      emit(ButtonIsValidState());
    }
  }

  Future<void> _mapUsernameEventToState(
      UserNameCheckEvent event, Emitter<LoginState> emit) async {
    final username = event.username;
    validationRepository.notEmptyValidation(username)
        ? emit(UserNameVallidState())
        : emit(UserNameInValidState());
  }

  Future<void> _mapPasswordEventToState(
      PasswordCheckEvent event, Emitter<LoginState> emit) async {
    final password = event.password;
    validationRepository.passwordValidation(password)
        ? emit(PasswordValidState())
        : emit(PasswordInValidState());
  }

  Future<void> _mapLoginEventToState(
      LoginCheckEvent event, Emitter<LoginState> emit) async {
    final username = event.username;
    final password = event.password;
    // Map<String, dynamic>? userMap;
    final res = await apiServiceRepository.login(username, password);
    // User? apiUser;
    // User? user;
    if (res.statusCode == 200) {
      // userMap = jsonDecode(res.body);
      // if (userMap != null) {
      // apiUser = User.fromJson(userMap['user']);
      // user = await databaseRepository.getUserByEmail(apiUser.getEmail);
      // print(user?.getEmail);
      emit(LoginSuccessState());
      // } else {
      //   emit(LoginErrorState());
      // }
    } else {
      String errorText = jsonDecode(res.body)['error'];
      emit(LogErrorPageState(errorCode: res.statusCode, errorText: errorText));
    }
    // user != null
    //     ? emit(LoginSuccessState(user: user, token: token))
    //     : emit(LoginErrorState());
  }
}
