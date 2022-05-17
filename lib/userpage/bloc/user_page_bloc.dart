import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task2/httpRepository/api_service.dart';
import 'package:task2/userpage/bloc/user_page_event.dart';
import 'package:task2/userpage/bloc/user_page_state.dart';

import '../../model/user.dart';
import '../../repository/database_repository.dart';
import '../../repository/validation_repository.dart';

class UserPageBloc extends Bloc<UserPageEvent, UserPageState> {
  final DatabaseRepository databaseRepository;
  final ValidationRepository validationRepository;
  final ApiServiceRepository apiServiceRepository;
  UserPageBloc(this.databaseRepository, this.validationRepository,
      this.apiServiceRepository)
      : super(UserPageInitialState()) {
    on<UserDatesChangeEvent>(_mapUserDatesChangeEventToState);
    on<DeleteUserEvent>(_mapDeleteUserEventToState);
    on<GetUserEvent>(_mapGetUserEventToState);
    on<LogOutEvent>(_mapLogOutEvent);
  }

  Future<void> _mapLogOutEvent(
      LogOutEvent event, Emitter<UserPageState> emit) async {
    final tokenPref = await SharedPreferences.getInstance();
    tokenPref.remove('token');
  }

  Future<void> _mapUserDatesChangeEventToState(
      UserDatesChangeEvent event, Emitter<UserPageState> emit) async {
    final name = event.name;
    final surname = event.surname;
    final username = event.username;
    final password = event.password;
    final email = event.email;
    final logedInUser = event.logedInUser;
    Response emailRes;
    Response usernameRes;

    email.isNotEmpty
        ? {
            if (validationRepository.emailValidation(email))
              {
                emailRes = await apiServiceRepository.checkEmail(email),
                if (emailRes.statusCode == 200)
                  {
                    logedInUser.setEmail = email,
                  }
                else if (emailRes.statusCode == 500)
                  {
                    emit(UserPageEmailIsAlreadyState(
                        emailState: 'Email Already in Use', usernameState: ''))
                  }
                else
                  {emit(ErrorPageState(responseCode: emailRes.statusCode))}
              }
            else
              {emit(UserPageEmailInvalidState())}
          }
        : null;

    username.isNotEmpty
        ? {
            if (validationRepository.usernameValidation(username))
              {
                usernameRes = await apiServiceRepository.checkName(username),
                if (usernameRes.statusCode == 200)
                  {
                    logedInUser.setUserName = username,
                  }
                else if (usernameRes.statusCode == 500)
                  {
                    emit(UserPageEmailIsAlreadyState(
                        usernameState: 'Username Already in Use',
                        emailState: ''))
                  }
                else
                  {emit(ErrorPageState(responseCode: usernameRes.statusCode))}
              }
            else
              {emit(UserPageUserNameInvalidState())}
          }
        : null;
    password.isNotEmpty
        ? {
            if (validationRepository.passwordValidation(password))
              {
                logedInUser.setPassword = password,
              }
            else
              {emit(UserPagePasswordInvalidState())}
          }
        : null;

    name.isNotEmpty
        ? {
            logedInUser.setName = name,
          }
        : null;
    surname.isNotEmpty
        ? {
            logedInUser.setSurName = surname,
          }
        : null;

    final res = await apiServiceRepository.updateUser(logedInUser);
    if (res.statusCode == 200) {
      emit(UserDatesChengeCompleteState());
      var map = jsonDecode(res.body);
      var user = User.fromJson(map['user']);
      await databaseRepository.updateUser(user);
    }
  }

  Future<void> _mapGetUserEventToState(
      GetUserEvent event, Emitter<UserPageState> emit) async {
    final user = await apiServiceRepository.getMyProfile();
    await databaseRepository.updateUser(user!);
    final baseUser = await databaseRepository.getUserByEmail(user.getEmail);
    emit(UserLoadedState(user: baseUser!));
  }

  Future<void> _mapDeleteUserEventToState(
      DeleteUserEvent event, Emitter<UserPageState> emit) async {
    User? user;
    user = await apiServiceRepository.getMyProfile();
    if (user != null) {
      databaseRepository.delete(user.getEmail);
    }
    await apiServiceRepository.deleteUser();
  }
}
