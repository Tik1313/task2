import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task2/httpRepository/api_service.dart';

part 'loading_page_event.dart';
part 'loading_page_state.dart';

class LoadingPageBloc extends Bloc<LoadingPageEvent, LoadingPageState> {
  final ApiServiceRepository apiServiceRepository;

  LoadingPageBloc(this.apiServiceRepository) : super(FirstscreenInitial()) {
    on<LogedInOrNotCheckEvent>(_mapLoginCheckEventToState);
  }

  Future<void> _mapLoginCheckEventToState(
      LoadingPageEvent event, Emitter<LoadingPageState> emit) async {
    final tokenPref = await SharedPreferences.getInstance();
    if (tokenPref.getString('token') == null) {
      emit(NotLogedInState());
    } else {
      emit(LogedInState());
    }
  }
}
