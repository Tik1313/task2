import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/httpRepository/api_service.dart';
import 'package:task2/username/bloc/user_name_event.dart';
import 'package:task2/username/bloc/user_name_state.dart';

import '../../model/error_type.dart';
import '../../repository/validation_repository.dart';

class UsernameBloc extends Bloc<UsernameEvent, UsernameState> {
  final ValidationRepository validationRepository;
  final ApiServiceRepository apiServiceRepository;
  UsernameBloc(this.validationRepository, this.apiServiceRepository)
      : super(UsernameInitialState()) {
    on<UsernameValidationEvent>(_mapUsernameValidEventToState);
  }

  Future<void> _mapUsernameValidEventToState(
      UsernameValidationEvent event, Emitter<UsernameState> emit) async {
    final username = event.username;
    final res = await apiServiceRepository.checkName(username);
    validationRepository.usernameValidation(username)
        ? {
            if (res.statusCode == 200)
              {emit(UsernameValidState())}
            else if (res.statusCode == 500)
              {emit(UsernameInvalidState(errorType: ErrorType.useddata))}
            else
              {emit(ErrorPageState(responseCode: res.statusCode))}
          }
        : emit(UsernameInvalidState(errorType: ErrorType.format));
  }

  // Future<void> _usernameUsedCheckEventToState(
  //     UsernameUsedCheckEvent event, Emitter<UsernameState> emit) async {
  //   final username = event.username;
  //   if (await databaseRepository.getUserByUsername(username) != null) {
  //     emit(UsernameIsUsedState());
  //   } else {
  //     emit(UsernameIsNotUsedState());
  //   }
  // }
}
