import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/httpRepository/api_service.dart';
import 'package:task2/model/error_type.dart';
import 'package:task2/numberOremail/bloc/mobile_number_event.dart';
import 'package:task2/numberOremail/bloc/mobile_number_state.dart';
import 'package:task2/repository/database_repository.dart';
import 'package:task2/repository/validation_repository.dart';

import '../../loader/load_json.dart';
import '../../model/country.dart';

class MobileOrEmailBloc extends Bloc<MobileNumberEvent, MobileOrEmailState> {
  final _itemManager = ItemManager();
  final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
  List<Country> get _allCountries => _itemManager.countries;
  List<Country> _dbAllCountries = [];

  List<Country> get dbAllCountries => _dbAllCountries;

  Country? mycount;
  final ValidationRepository validationRepository;
  final ApiServiceRepository apiServiceRepository;
  final DatabaseRepository databaseRepository;
  MobileOrEmailBloc(this.validationRepository, this.apiServiceRepository,
      this.databaseRepository)
      : super(MobileOrEMailInitialState()) {
    on<MobileNumberValidationEvent>(_mapMobileNumberValideEvenetToState);
    on<EmailValidationEvent>(_mapEmailValidEventToState);
    on<SetDatesEvent>(_mapSetDatesEventToState);
    on<InitialLoadEvent>(_initialLoad);
  }

  Future<void> _mapMobileNumberValideEvenetToState(
      MobileNumberValidationEvent event,
      Emitter<MobileOrEmailState> emit) async {
    final country = event.country;
    final number = event.number;
    final fullNumber = event.fullNumber;
    final res = await apiServiceRepository.checkPhone(fullNumber);

    validationRepository.numberValidation(country, number)
        ? {
            if (res.statusCode == 200)
              {emit(MobileNumberValidState())}
            else if (res.statusCode == 500)
              {emit(MobileNumberInvalidState(errorType: ErrorType.useddata))}
            else
              {
                {emit(ErrorPageState(responseCode: res.statusCode))}
              }
          }
        : emit(MobileNumberInvalidState(errorType: ErrorType.format));
  }

  Future<void> _mapEmailValidEventToState(
      EmailValidationEvent event, Emitter<MobileOrEmailState> emit) async {
    final email = event.email;
    final res = await apiServiceRepository.checkEmail(email);
    validationRepository.emailValidation(email)
        ? {
            if (res.statusCode == 200)
              {emit(EmailValidState())}
            else if (res.statusCode == 500)
              {emit(EmailInvalidState(errorType: ErrorType.useddata))}
            else
              {emit(ErrorPageState(responseCode: res.statusCode))}
          }
        : emit(EmailInvalidState(errorType: ErrorType.format));
  }

  Future<void> _initialLoad(
      InitialLoadEvent event, Emitter<MobileOrEmailState> emit) async {
    _dbAllCountries = await databaseRepository.getCounties();
    if (_dbAllCountries.isEmpty) {
      await _itemManager.loadItems();
      await databaseRepository.addCountry(_allCountries);
    }
    var isoCountryCode = systemLocales.last.countryCode;
    final filtered =
        _dbAllCountries.where((i) => i.iso2_cc == isoCountryCode).toList();
    if (filtered.isNotEmpty) {
      mycount = filtered.first;
      emit(InitialLoadState(filteredcountry: mycount!));
    }
  }

  Future<void> _mapSetDatesEventToState(
      SetDatesEvent event, Emitter<MobileOrEmailState> emit) async {
    final email = event.email;
    final number = event.number;
    final user = event.user;
    if (email.isEmpty && number.isNotEmpty) {
      user
        ..setPhone = number
        ..setEmail = '';
    } else if (email.isNotEmpty) {
      user
        ..setEmail = email
        ..setPhone = '';
    }
  }
}
