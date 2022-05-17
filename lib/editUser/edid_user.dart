import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/editUser/bloc/edid_user_bloc.dart';
import 'package:task2/httpRepository/api_service.dart';
import 'package:task2/model/user.dart';
import 'package:task2/pages/error.dart';
import 'package:task2/repository/database_repository.dart';
import 'package:task2/repository/validation_repository.dart';
import 'package:task2/widgets/back.dart';
import 'package:task2/widgets/custom_button.dart';

class EdidUser extends StatefulWidget {
  const EdidUser({required this.user, this.onFinishSave, Key? key})
      : super(key: key);

  final User user;
  final VoidCallback? onFinishSave;

  @override
  State<EdidUser> createState() => _EdidUserState();
}

class _EdidUserState extends State<EdidUser> {
  final databaseRepository = DatabaseRepository();
  final validtaionRepository = ValidationRepository();
  final apiServiceRepository = ApiServiceRepository();
  TextEditingController name = TextEditingController();
  TextEditingController surName = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  late EdidUserBloc _edidUserBloc;

  String? errorEmail;
  String? errorUsername;

  @override
  void initState() {
    _edidUserBloc = EdidUserBloc(
        databaseRepository, validtaionRepository, apiServiceRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _edidUserBloc,
      child: BlocListener<EdidUserBloc, EdidUserState>(
        listener: listener,
        child: BlocBuilder<EdidUserBloc, EdidUserState>(
          builder: (context, state) {
            return _render();
          },
        ),
      ),
    );
  }

  Widget _render() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Column(children: <Widget>[
          const MyBackButton(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                        hintText: '${widget.user.getName} -  write new name'),
                  ),
                  TextField(
                    controller: surName,
                    decoration: InputDecoration(
                        hintText:
                            '${widget.user.getSurName} -  write new surname'),
                  ),
                  TextField(
                    controller: userName,
                    decoration: InputDecoration(
                        errorText: errorUsername,
                        hintText:
                            '${widget.user.getUserName} -  write new username'),
                  ),
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                        errorText: errorEmail,
                        hintText: '${widget.user.getEmail} -  write new email'),
                  ),
                  TextField(
                    controller: password,
                    decoration: InputDecoration(
                        hintText:
                            '${widget.user.getPassword} -  write new password'),
                  ),
                ],
              ),
            ),
          ),
          CustomContinueButton(
              isValid: true,
              onPressed: () {
                _edidUserBloc.add(UserEditEvent(
                  name: name.text,
                  surname: surName.text,
                  username: userName.text,
                  password: password.text,
                  email: email.text,
                  logedInUser: widget.user,
                ));
                // _wait();

                name.text = '';
                surName.text = '';
                userName.text = '';
                email.text = '';
                password.text = '';
              },
              textLabel: 'Save')
        ]),
      ),
    );
  }
}

extension _BlocListener on _EdidUserState {
  void listener(BuildContext context, EdidUserState state) {
    if (state is EmailInValidState) {
      errorEmail = 'Email is Incorrect!!';
      // await _renderShowAlertDialog(context);
    }
    // if (state is UserLoadedState) {
    //   user = state.user;
    // }
    if (state is EmailIsAlreadyState) {
      errorEmail = state.emailState;
      errorUsername = state.usernameState;
    }
    if (state is UserNameInValidState) {
      errorUsername = 'Username is Incorrect!!';
    }
    if (state is EditingComplateState) {
      widget.onFinishSave?.call();
      Navigator.pop(context);
    }
    if (state is ErrorPageState) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ErrorPage(
              errorCode: state.responseCode,
              errorText: 'Error',
            ),
          ));
    }
  }
}
