import 'package:emoji_flag_converter/emoji_flag_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/httpRepository/api_service.dart';
import 'package:task2/model/country.dart';
import 'package:task2/model/error_type.dart';
import 'package:task2/model/user.dart';
import 'package:task2/pages/error.dart';
import 'package:task2/pages/list_view.dart';
import 'package:task2/repository/database_repository.dart';
import 'package:task2/username/user_name.dart';
import 'package:task2/widgets/back.dart';
import 'package:task2/widgets/custom_button.dart';
import 'package:task2/widgets/titleTxt.dart';

import '../notifiers/country_change_value_notifier.dart';
import '../repository/validation_repository.dart';
import 'bloc/mobile_number_bloc.dart';
import 'bloc/mobile_number_event.dart';
import 'bloc/mobile_number_state.dart';

class MobileNumberOrEmail extends StatefulWidget {
  const MobileNumberOrEmail({required this.user, Key? key}) : super(key: key);
  final User user;

  @override
  State<MobileNumberOrEmail> createState() => _MobileNumberOrEmailState();
}

class _MobileNumberOrEmailState extends State<MobileNumberOrEmail> {
  final _validationRepository = ValidationRepository();
  final apiServiceRepository = ApiServiceRepository();
  final _databaseRepository = DatabaseRepository();

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController inputEmail = TextEditingController();
  bool isVisible = false;
  Country? _country;
  late MobileOrEmailBloc _numberbloc;
  final CountryChangeValueNotifier _countryChangeValueNotifier =
      CountryChangeValueNotifier();
  // CountryChangeNotifier get _countryChangeNotifier =>
  //     Provider.of<CountryChangeNotifier>(context, listen: false);

  @override
  void initState() {
    _numberbloc = MobileOrEmailBloc(
        _validationRepository, apiServiceRepository, _databaseRepository);
    _numberbloc.add(InitialLoadEvent());
    _countryChangeValueNotifier.addListener(_onChange);
    // _countryChangeNotifier.addListener(_onChange);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _numberbloc,
      child: BlocListener<MobileOrEmailBloc, MobileOrEmailState>(
        listener: listener,
        child: BlocBuilder<MobileOrEmailBloc, MobileOrEmailState>(
          builder: (context, state) {
            return _render(state);
            //   ValueListenableBuilder(
            // valueListenable: emailValidationNotifier,
            // builder: (context, value, child) {
            //   return _render(state);
            // },
            // );
          },
        ),
      ),
    );
  }

  Widget _render(MobileOrEmailState state) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const MyBackButton(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TitleTxt(
                    inputTitle: isVisible
                        ? "What's Your Phone Number?"
                        : "What's Your Email?",
                  ),
                  _renderTextChange(),
                  Visibility(
                    visible: isVisible,
                    child: Column(
                      children: <Widget>[
                        _renderItnlPhoneNumber(state),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !isVisible,
                    child: Column(
                      children: <Widget>[
                        _renderEmailForm(state),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomContinueButton(
            isValid: _buttonIsActive(state),
            onPressed: () async {
              state is MobileNumberInvalidState ||
                      state is EmailInvalidState &&
                          state.errorType == ErrorType.useddata
                  ? await _renderShowAlertDialog(context)
                  : {
                      _numberbloc.add(
                        SetDatesEvent(
                            email: inputEmail.text,
                            number: '${_country?.e164_cc}${phoneNumber.text}',
                            user: widget.user),
                      ),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserName(
                            user: widget.user,
                          ),
                        ),
                      )
                    };
            },
            textLabel: 'Continue',
          )
        ],
      ),
    );
  }

  Widget _renderItnlPhoneNumber(MobileOrEmailState state) {
    final country = _country;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
      child: TextFormField(
        onChanged: (value) {
          country != null
              ? {
                  _numberbloc.add(MobileNumberValidationEvent(
                      country: country,
                      number: value,
                      fullNumber: '${country.e164_cc}${phoneNumber.text}')),
                  setState(() {
                    if (phoneNumber.text.length >
                        country.example.split('').length) {
                      phoneNumber.clear();
                    }
                  })
                }
              : null;
        },
        keyboardType: TextInputType.number,
        controller: phoneNumber,
        decoration: InputDecoration(
          labelText: 'MOBILE NUMBER',
          errorText: state is MobileNumberValidState ||
                  (state is MobileNumberInvalidState &&
                      state.errorType == ErrorType.useddata)
              ? null
              : country != null
                  ? 'Must be ${country.example.count} numbers  ${phoneNumber.text.length}/${country.example.count}'
                  : '',
          hintText: country != null ? country.example : '',
          prefixIcon: _flagsChengeButton(),
        ),
      ),
    );
  }

  Widget _flagsChengeButton() {
    final country = _country;
    if (country == null) {
      return const CircularProgressIndicator();
    }
    return InkWell(
      hoverColor: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(EmojiConverter.fromAlpha2CountryCode(country.iso2_cc)),
            Text(' + ${country.e164_cc}'),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context1) => CountryList(
              countryChangeValueNotifier: _countryChangeValueNotifier,
              list: _numberbloc.dbAllCountries,

              // ChangeNotifierProvider.value(
              //   value: _countryChangeNotifier,
              //   child: CountryList(
              //     list: _numberbloc.dbAllCountries,

              // finishSelection: (Country country) {
              //   setState(() {
              //     mycount = country;
              //   });
              // }
            ),
          ),
        );

        // _numberbloc.add(NavigateAndDispleySelectionEvent(context: context));
      },
    );
  }

  Widget _renderTextChange() {
    return TextButton(
      onPressed: () {
        setState(() {
          isVisible = !isVisible;
        });
      },
      child: Text(
        isVisible ? 'Sign up with email instead' : 'Sign up with phone instead',
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }

  Widget _renderEmailForm(MobileOrEmailState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 100),
      child: TextFormField(
        controller: inputEmail,
        onChanged: (value) {
          _numberbloc.add(EmailValidationEvent(email: value));
        },
        decoration: InputDecoration(
          errorText:
              //  (emailValidationNotifier.value) ? null : 'error',
              (state is EmailInvalidState &&
                      state.errorType == ErrorType.format)
                  ? 'not correct email'
                  : null,
          labelText: 'Enter Email',
        ),
      ),
    );
  }

  Future _renderShowAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text('OK'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog? alert = AlertDialog(
        title: const Text('Error!!!'),
        content: Text(!isVisible
            ? 'Email is already in use.'
            : 'Phone Number is already in use'),
        actions: [
          okButton,
        ]);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _onChange() {
    _country = _countryChangeValueNotifier.value;
    setState(() {});
  }

  bool _buttonIsActive(MobileOrEmailState state) {
    if (state is EmailValidState ||
        state is MobileNumberValidState ||
        (state is MobileNumberInvalidState &&
            state.errorType == ErrorType.useddata) ||
        (state is EmailInvalidState && state.errorType == ErrorType.useddata)) {
      return true;
    }
    return false;
  }
}

extension _StringAddition on String {
  int get count {
    return split('').length;
  }
}

extension _BlocListener on _MobileNumberOrEmailState {
  void listener(BuildContext context, MobileOrEmailState state) {
    if (state is InitialLoadState) {
      _country = state.filteredcountry;
    }
    if (state is ErrorPageState) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ErrorPage(
                  errorCode: state.responseCode,
                  errorText: 'Error!!!',
                )),
      );
    }
  }
}
