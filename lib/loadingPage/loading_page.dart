import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/httpRepository/api_service.dart';
import 'package:task2/loadingPage/bloc/loading_page_bloc.dart';
import 'package:task2/pages/home.dart';
import 'package:task2/userpage/user_page.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final apiServiceRepository = ApiServiceRepository();
  final double _width = Random().nextInt(300).toDouble();
  final double _height = Random().nextInt(300).toDouble();
  late LoadingPageBloc _bloc;

  @override
  void initState() {
    _bloc = LoadingPageBloc(apiServiceRepository);
    _bloc.add(LogedInOrNotCheckEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener<LoadingPageBloc, LoadingPageState>(
        listener: (context, state) {
          if (state is LogedInState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserrPage(),
              ),
            );
          }
          if (state is NotLogedInState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHome(),
              ),
            );
          }
        },
        child: BlocBuilder<LoadingPageBloc, LoadingPageState>(
          builder: (context, state) => _render(),
        ),
      ),
    );
  }

  Widget _render() {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(254, 252, 0, 1),
      body: Center(
        child: AnimatedContainer(
          width: _width,
          height: _height,
          duration: const Duration(seconds: 5),
          child: Image.asset(
            'assets/images/log.png',
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}
