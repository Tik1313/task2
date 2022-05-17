import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/httpRepository/api_service.dart';
import 'package:task2/pages/error.dart';

import '../model/error_type.dart';
import '../model/user.dart';
import '../password/password.dart';
import '../repository/validation_repository.dart';
import '../widgets/back.dart';
import '../widgets/custom_button.dart';
import '../widgets/titleTxt.dart';
import 'bloc/user_name_bloc.dart';
import 'bloc/user_name_event.dart';
import 'bloc/user_name_state.dart';

@immutable
class UserName extends StatefulWidget {
  final User user;

  const UserName({required this.user, Key? key}) : super(key: key);

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  final _validationRepository = ValidationRepository();
  final apiServiceRepository = ApiServiceRepository();

  var usernameInput = TextEditingController();

  late UsernameBloc _usernamebloc;

  @override
  void initState() {
    _usernamebloc = UsernameBloc(_validationRepository, apiServiceRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _usernamebloc,
      child: BlocListener<UsernameBloc, UsernameState>(
        listener: (context, state) {
          if (state is ErrorPageState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ErrorPage(
                        errorCode: state.responseCode,
                        errorText: 'Error!',
                      )),
            );
          }
        },
        child: BlocBuilder<UsernameBloc, UsernameState>(
          builder: (context, state) {
            return _render(state);
          },
        ),
      ),
    );
  }

  Widget _render(UsernameState state) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const MyBackButton(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const TitleTxt(inputTitle: 'Set a username'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 100),
                    child: SizedBox(
                      // width: 210,
                      child: Text(
                        'Your username is how friands add you on Snapchat',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  _renderEmailForm(state),
                ],
              ),
            ),
          ),
          CustomContinueButton(
            isValid: state is UsernameValidState ||
                (state is UsernameInvalidState &&
                    state.errorType == ErrorType.useddata),
            onPressed: () async {
              state is UsernameInvalidState &&
                      state.errorType == ErrorType.useddata
                  ? await _renderShowAlertDialog(context)
                  : {
                      widget.user.setUserName = usernameInput.text,
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Password(
                            users: widget.user,
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

  Widget _renderEmailForm(UsernameState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 100),
      child: TextFormField(
        onChanged: (value) {
          _usernamebloc.add(UsernameValidationEvent(username: value));
        },
        controller: usernameInput,
        decoration: InputDecoration(
          errorText: state is UsernameInvalidState &&
                  state.errorType == ErrorType.format
              ? 'username should be more than 5 characters!'
              : null,
          labelText: 'USERNAME',
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
    var alert = AlertDialog(
        title: const Text('Error!!!'),
        content: const Text('Username is already in use'),
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
}
