import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';
import '../notifiers/country_change_notifier.dart';
import '../numberOremail/mobile_number_or_email.dart';
import '../repository/database_repository.dart';
import '../repository/validation_repository.dart';
import '../widgets/back.dart';
import '../widgets/custom_button.dart';
import '../widgets/titleTxt.dart';
import 'bloc/birthday_bloc.dart';
import 'bloc/birthday_event.dart';
import 'bloc/birthday_state.dart';

class BirthDay extends StatefulWidget {
  final User user;

  const BirthDay({required this.user, Key? key}) : super(key: key);

  @override
  State<BirthDay> createState() => _BirthDayState();
}

class _BirthDayState extends State<BirthDay> {
  final validationRepository = ValidationRepository();
  final databaseRepository = DatabaseRepository();
  DateTime selectedDate = DateTime.now();
  TextEditingController dateinput = TextEditingController();
  String? errorText;
  late BirthDayBloc _birthdaybloc;
  bool isActive = false;

  @override
  void initState() {
    _birthdaybloc = BirthDayBloc(validationRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _birthdaybloc,
      child: BlocListener<BirthDayBloc, BirthDayState>(
        listener: (context, state) {
          if (state is BirthDayValidState) {
            isActive = true;
          } else {
            isActive = false;
          }
        },
        child: BlocBuilder<BirthDayBloc, BirthDayState>(
          builder: (context, state) {
            return _render(state);
          },
        ),
      ),
    );
  }

  Widget _render(BirthDayState state) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const MyBackButton(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const TitleTxt(inputTitle: "When's Your Birthday?"),
                  _renderTextForm(state),
                ],
              ),
            ),
          ),
          CustomContinueButton(
            isValid: isActive,
            onPressed: () {
              widget.user.setBDay = selectedDate;
              // databaseRepository.getItems();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => CountryChangeNotifier(),
                      child: MobileNumberOrEmail(
                        user: widget.user,
                      ),
                    ),
                  ));
            },
            textLabel: 'Continue',
          ),
          _renderDatePicker(state),
        ],
      ),
    );
  }

  Widget _renderTextForm(BirthDayState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 100),
      child: TextFormField(
        controller: dateinput,
        decoration: InputDecoration(
          icon: const Icon(Icons.calendar_today),
          errorText:
              state is BirthDayInvalidState ? 'cant be small than 16' : null,
          labelText: 'Enter date',
        ),
        readOnly: true,
      ),
    );
  }

  Widget _renderDatePicker(BirthDayState state) {
    return Container(
      height: MediaQuery.of(context).copyWith().size.height * 0.25,
      color: Colors.white,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (value) {
          if (value != selectedDate) {
            setState(() {
              var formattedDate = DateFormat('dd-MM-yyyy').format(value);
              _birthdaybloc.add(BirthDayValidationEvent(selectedDate: value));

              dateinput.text = formattedDate;
              selectedDate = value;
            });
          }
        },
        initialDateTime: DateTime.now(),
        minimumYear: 1900,
        maximumDate: DateTime.now(),
      ),
    );
  }
}
