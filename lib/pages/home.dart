import 'package:flutter/material.dart';
import 'package:task2/signup/sign_up.dart';

import '../login/log_in.dart';

class MyHome extends StatefulWidget {
  const MyHome({
    Key? key,
  }) : super(key: key);
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    Widget homeBtn = Column(
      children: [
        _renderLoginButton(),
        _rednderSignUpButton(),
      ],
    );

    return Scaffold(
      backgroundColor: const Color.fromRGBO(254, 252, 0, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Image.asset(
            'assets/images/log.png',
            width: 100,
            height: 100,
          ),
          Container(
            child: homeBtn,
          )
        ],
      ),
    );
  }

  Widget _renderLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const LogIn()));
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
        ),
        child: const Text('Log In'),
      ),
    );
  }

  Widget _rednderSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const SignUp()));
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
        ),
        child: const Text('Sign Up'),
      ),
    );
  }
}
