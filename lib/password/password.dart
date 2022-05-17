import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/pages/error.dart';
import 'package:task2/password/bloc/password_state.dart';
import 'package:task2/repository/database_repository.dart';
import 'package:task2/userpage/user_page.dart';

import '../httpRepository/api_service.dart';
import '../model/user.dart';
import '../repository/validation_repository.dart';
import '../widgets/back.dart';
import '../widgets/custom_button.dart';
import '../widgets/titleTxt.dart';
import 'bloc/password_bloc.dart';
import 'bloc/password_event.dart';

@immutable
class Password extends StatefulWidget {
  final User users;

  const Password({
    required this.users,
    Key? key,
  }) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final validationRepository = ValidationRepository();
  final apiServiceRepository = ApiServiceRepository();
  final databaseRepository = DatabaseRepository();
  var passwordInput = TextEditingController();
  var passVis = false;
  var isObs = true;
  late PasswordBloc _bloc;

  @override
  void initState() {
    _bloc = PasswordBloc(
        validationRepository, apiServiceRepository, databaseRepository);
    // _getData();
    super.initState();
  }

  // void _getData() async {
  // _userModel = (await ApiService().getUsers())!;
  // Future.delayed(const Duration(seconds: 1)).then(
  // (value) => setState(() {}),
  // );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => _bloc),
      child: BlocListener<PasswordBloc, PasswordState>(
          listener: listener,
          child: BlocBuilder<PasswordBloc, PasswordState>(
            builder: (context, state) {
              return _render(state);
            },
          )),
    );
  }

  Widget _render(PasswordState state) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const MyBackButton(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const TitleTxt(inputTitle: 'Set a password'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 100),
                    child: SizedBox(
                      width: 210,
                      child: Center(
                        child: Text(
                          'Your password should be at least 8  characters',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  _renderPasswordForm(state),
                ],
              ),
            ),
          ),
          CustomContinueButton(
            isValid: state is PasswordValidState,
            onPressed: () async {
              widget.users.setPassword = passwordInput.text;
              _bloc.add(CreateNewUserEvent(user: widget.users));

              // Navigator.push(
              // context,
              // MaterialPageRoute(
              // builder: (context) => const MyHome(),
              // ),
              // );
            },
            textLabel: 'Continue',
          )
        ],
      ),
    );
  }

  Widget _renderPasswordForm(PasswordState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 100),
      child: TextFormField(
        onChanged: (value) {
          _bloc.add(PasswordValidationEvent(password: value));
        },
        controller: passwordInput,
        obscureText: isObs,
        decoration: InputDecoration(
          suffixIcon: passwordInput.text.isEmpty
              ? null
              : TextButton(
                  child: passVis ? const Text('HYDE') : const Text('SHOW'),
                  onPressed: () {
                    setState(() {
                      isObs = !isObs;
                      passVis = !passVis;
                    });
                  },
                ),
          errorText: state is PasswordInvalidState
              ? 'password should be more than 8 characters!'
              : null,
          labelText: 'PASSWORD',
        ),
      ),
    );
  }
}

extension _BlocListener on _PasswordState {
  void listener(BuildContext context, PasswordState state) {
    if (state is UserIsCreatedState) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UserrPage(),
        ),
      );
    }
    if (state is UserNotCreatedState) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ErrorPage(
            errorCode: state.responseCode,
            errorText: 'Error!!',
          ),
        ),
      );
    }
  }
}
