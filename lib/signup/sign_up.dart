import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/signup/bloc/sign_up_bloc.dart';
import 'package:task2/signup/bloc/sign_up_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../birthday/birthday.dart';
import '../localization/app_localization.dart';
import '../model/user.dart';
import '../repository/validation_repository.dart';
import '../widgets/back.dart';
import '../widgets/custom_button.dart';
import '../widgets/titleTxt.dart';
import 'bloc/sign_up_event.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final validationRepository = ValidationRepository();
  User user = User();
  TextEditingController fNameTxt = TextEditingController();
  TextEditingController lNameTxt = TextEditingController();
  late SignUpBloc _signupbloc;

  @override
  void initState() {
    _signupbloc = SignUpBloc(validationRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => _signupbloc,
      child: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {},
        child: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) {
            return _render(state);
          },
        ),
      ),
    ));
  }

  Widget _render(SignUpState state) {
    return Column(
      children: <Widget>[
        const MyBackButton(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TitleTxt(
                  inputTitle:
                      '${AppLocalizations.of(context)!.translate('login title')}',
                ),
                _loginForm(state),
              ],
            ),
          ),
        ),
        CustomContinueButton(
          isValid: state is ButtonIsValidState,
          onPressed: () async {
            // await apiService.checkEmail(fNameTxt.text);

            user
              ..setName = fNameTxt.text
              ..setSurName = lNameTxt.text;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BirthDay(user: user)));
          },
          textLabel: '${AppLocalizations.of(context)!.translate('sign up')}',
        )
      ],
    );
  }

  Widget _loginForm(SignUpState state) {
    return Column(
      children: [
        _renderTextFirstName(state),
        _renderTextLastName(state),
        _renderUnderText(),
      ],
    );
  }

  Widget _renderTextFirstName(SignUpState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 35),
      child: TextFormField(
        onChanged: (value) {
          _signupbloc
            ..add(FirstNameValidationEvent(firstName: value))
            ..add(ButtonValidationEvent(
                firstName: fNameTxt.text, lastName: lNameTxt.text));
        },
        controller: fNameTxt,
        decoration: InputDecoration(
          errorText: state is FirstNameInvalidState
              ? '${AppLocalizations.of(context)!.translate('username errortext')}'
              : null,
          labelText: '${AppLocalizations.of(context)!.translate('first name')}',
        ),
      ),
    );
  }

  Widget _renderTextLastName(SignUpState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 25),
      child: TextFormField(
        onChanged: (value) {
          _signupbloc
            ..add(LastNameValidationEvent(lastName: value))
            ..add(ButtonValidationEvent(
                firstName: fNameTxt.text, lastName: lNameTxt.text));
        },
        controller: lNameTxt,
        decoration: InputDecoration(
          errorText: state is LastNameInvalidState
              ? '${AppLocalizations.of(context)!.translate('username errortext')}'
              : null,
          labelText: '${AppLocalizations.of(context)!.translate('last name')}',
        ),
        // hintText: 'Password',
      ),
    );
  }

  Widget _renderUnderText() {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            style: const TextStyle(
              color: Colors.black,
            ),
            text: '${AppLocalizations.of(context)!.translate('text1')}'
            // 'By tapping Sign Up & Accept, you acknowledge \nthat you have read the',
            ),
        // _renderLinkText(),
        TextSpan(
          text: '${AppLocalizations.of(context)!.translate('text2')}',
          // 'Privacy Policy',
          style: const TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              var url =
                  'https://androidride.com/flutter-hyperlink-text/#example_1';
              await launch(url);
              //  if (await canLaunch(url)) {
              //     await launch(url);
              //   } else {
              //     throw 'Could not launch $url';
              //   }
            },
        ),
        TextSpan(
          style: const TextStyle(
            color: Colors.black,
          ),
          text: '${AppLocalizations.of(context)!.translate('text3')}',
          // ' and agree \nto the ',
        ),
        TextSpan(
          text: '${AppLocalizations.of(context)!.translate('text4')}',
          // 'Terms of Service ',
          style: const TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              var url =
                  'https://androidride.com/flutter-hyperlink-text/#example_1';
              await launch(url);
            },
        ),
      ]),
    );
  }
}
