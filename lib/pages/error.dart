import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import 'home.dart';

class ErrorPage extends StatefulWidget {
  final int errorCode;
  final String errorText;
  const ErrorPage({required this.errorCode, required this.errorText, Key? key})
      : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return _render();
  }

  Widget _render() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text('Error!!!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${widget.errorCode}  ${widget.errorText}'),
            CustomContinueButton(
                isValid: true,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHome(),
                      ));
                },
                textLabel: 'OK')
          ],
        ),
      ),
    );
  }
}
