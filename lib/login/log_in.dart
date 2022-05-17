import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/httpRepository/api_service.dart';
import 'package:task2/localization/app_localization.dart';
import 'package:task2/login/bloc/login_bloc.dart';
import 'package:task2/login/bloc/login_event.dart';
import 'package:task2/login/bloc/login_state.dart';
import 'package:task2/pages/error.dart';
import 'package:task2/userpage/user_page.dart';
import 'package:task2/widgets/back.dart';
import 'package:task2/widgets/custom_button.dart';
import 'package:task2/widgets/titleTxt.dart';
import '../repository/database_repository.dart';
import '../repository/validation_repository.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final validationRepository = ValidationRepository();
  final databaseRepository = DatabaseRepository();
  final apiServiceRepository = ApiServiceRepository();
  bool passwordVisibility = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  late LoginBloc _loginbloc;
  bool passwordValidation = false;
  bool emailValidation = false;

  @override
  void initState() {
    _loginbloc = LoginBloc(
        validationRepository, databaseRepository, apiServiceRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => _loginbloc),
      child: BlocListener<LoginBloc, LoginState>(
        listener: listener,
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return _render(state);
          },
        ),
      ),
    );
  }

  Widget _render(LoginState state) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        const MyBackButton(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TitleTxt(
                    inputTitle:
                        '${AppLocalizations.of(context)!.translate('login title')}'),
                _loginForm(state),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                      '${AppLocalizations.of(context)!.translate('forgot')}'),
                ),
              ],
            ),
          ),
        ),
        CustomContinueButton(
            isValid: state is ButtonIsValidState,
            onPressed: () async {
              const CircularProgressIndicator();
              _loginbloc.add(LoginCheckEvent(
                  username: emailController.text,
                  password: passwordController.text));
            },
            textLabel: '${AppLocalizations.of(context)!.translate('login')}'),
      ],
    ));
  }

  Widget _loginForm(LoginState state) {
    return Column(
      children: [
        _renderTextFormEmail(state),
        _renderTextFormPassword(state),
      ],
    );
  }

  Widget _renderTextFormEmail(LoginState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
      child: TextFormField(
        onChanged: (value) {
          _loginbloc
            ..add(UserNameCheckEvent(username: value))
            ..add(ButtonValidCheckEvent(
                username: emailController.text,
                password: passwordController.text));
        },
        controller: emailController,
        decoration: InputDecoration(
          errorText: emailValidation
              ? '${AppLocalizations.of(context)!.translate('username errortext')}'
              : null,
          labelText:
              '${AppLocalizations.of(context)!.translate('username labeltext')}',
        ),
      ),
    );
  }

  Widget _renderTextFormPassword(LoginState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        onChanged: (value) {
          _loginbloc
            ..add(PasswordCheckEvent(password: value))
            ..add(ButtonValidCheckEvent(
                username: emailController.text,
                password: passwordController.text));
        },
        obscureText: !passwordVisibility,
        controller: passwordController,
        decoration: InputDecoration(
          labelText:
              '${AppLocalizations.of(context)!.translate('password labeltext')}',
          errorText: passwordValidation
              ? '${AppLocalizations.of(context)!.translate('password errortext')}'
              : null,
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisibility ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                passwordVisibility = !passwordVisibility;
              });
            },
          ),
        ),
      ),
    );
  }

  void _pushToUserPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UserrPage(),
        ));
  }
}

extension _BlocListener on _LogInState {
  void listener(BuildContext context, LoginState state) {
    if (state is LoginSuccessState) {
      _pushToUserPage();
    }
    if (state is PasswordValidState) {
      passwordValidation = false;
    }
    if (state is PasswordInValidState) {
      passwordValidation = true;
    }
    if (state is UserNameVallidState) {
      emailValidation = false;
    }
    if (state is UserNameInValidState) {
      emailValidation = true;
    }
    if (state is LogErrorPageState) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ErrorPage(
                errorCode: state.errorCode, errorText: state.errorText),
          ));
    }
  }
}
