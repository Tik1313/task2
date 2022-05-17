// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';

@immutable
class CustomContinueButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String textLabel;
  bool isValid = false;
  CustomContinueButton({
    required this.isValid,
    required this.onPressed,
    required this.textLabel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: isValid ? onPressed : null,
        child: Text(textLabel),
      ),
    );
  }
}
