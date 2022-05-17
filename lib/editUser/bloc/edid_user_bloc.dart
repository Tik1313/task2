import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:task2/httpRepository/api_service.dart';
import 'package:task2/model/user.dart';
import 'package:task2/repository/database_repository.dart';
import 'package:task2/repository/validation_repository.dart';

part 'edid_user_event.dart';
part 'edid_user_state.dart';

class EdidUserBloc extends Bloc<EdidUserEvent, EdidUserState> {
  final DatabaseRepository databaseRepository;
  final ValidationRepository validationRepository;
  final ApiServiceRepository apiServiceRepository;
  EdidUserBloc(this.databaseRepository, this.validationRepository,
      this.apiServiceRepository)
      : super(EdidUserInitialState()) {
    on<UserEditEvent>(_mapUserEditEventToState);
  }

  Future<void> _mapUserEditEventToState(
      UserEditEvent event, Emitter<EdidUserState> emit) async {
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
                    emit(EmailIsAlreadyState(
                        emailState: 'Email Already in Use', usernameState: ''))
                  }
                else
                  {emit(ErrorPageState(responseCode: emailRes.statusCode))}
              }
            else
              {emit(EmailInValidState())}
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
                    emit(UserNameIsAlreadyState(
                        usernameState: 'Username Already in Use',
                        emailState: ''))
                  }
                else
                  {emit(ErrorPageState(responseCode: usernameRes.statusCode))}
              }
            else
              {emit(UserNameInValidState())}
          }
        : null;
    password.isNotEmpty
        ? {
            if (validationRepository.passwordValidation(password))
              {
                logedInUser.setPassword = password,
              }
            else
              {emit(PasswordInValidState())}
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
      emit(EditingComplateState());
      var map = jsonDecode(res.body);
      var user = User.fromJson(map['user']);
      await databaseRepository.updateUser(user);
    }
  }
}
