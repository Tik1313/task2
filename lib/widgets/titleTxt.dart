// ignore_for_file: file_names
import 'package:flutter/material.dart';

@immutable
class TitleTxt extends StatelessWidget {
  final String inputTitle;
  const TitleTxt({
    required this.inputTitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      inputTitle,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
