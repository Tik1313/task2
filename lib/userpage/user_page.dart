import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/editUser/edid_user.dart';
import 'package:task2/httpRepository/api_service.dart';
import 'package:task2/pages/error.dart';

import '../model/user.dart';
import '../pages/home.dart';
import '../repository/database_repository.dart';
import '../repository/validation_repository.dart';
import '../widgets/custom_button.dart';
import 'bloc/user_page_bloc.dart';
import 'bloc/user_page_event.dart';
import 'bloc/user_page_state.dart';

@immutable
class UserrPage extends StatefulWidget {
  const UserrPage({
    Key? key,
  }) : super(key: key);

  @override
  State<UserrPage> createState() => _UserrPageState();
}

class _UserrPageState extends State<UserrPage> {
  final databaseRepository = DatabaseRepository();
  final validtaionRepository = ValidationRepository();
  final apiServiceRepository = ApiServiceRepository();
  bool isV = true;
  TextEditingController name = TextEditingController();
  TextEditingController surName = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  User? user;
  String? errorEmail;
  String? errorUsername;

  late UserPageBloc _userPageBloc;

  @override
  void initState() {
    _userPageBloc = UserPageBloc(
        databaseRepository, validtaionRepository, apiServiceRepository);
    _userPageBloc.add(GetUserEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _userPageBloc,
      child: BlocListener<UserPageBloc, UserPageState>(
        listener: listener,
        child: BlocBuilder<UserPageBloc, UserPageState>(
          builder: (context, state) {
            return _render(state);
          },
        ),
      ),
    );
  }

  Widget _render(UserPageState state) {
    return user == null
        ? const Padding(
            padding: EdgeInsets.symmetric(horizontal: 150, vertical: 330),
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          )
        : Drawer(
            child: ListView(children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  // color: Colors.amber[100],
                  image: DecorationImage(
                      // fit: BoxFit.scaleDown,
                      alignment: Alignment.topRight,
                      image: AssetImage('assets/images/userImage2.jpg'))),
              child: Text(
                '${user?.getName}\n\n ${user?.getSurName}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ),
            isV ? _renderUserPage(state) : _editingWidget(state),
          ]));
  }

  Widget _renderUserPage(UserPageState state) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(children: [
        ListTile(
          leading: const Icon(Icons.verified_user),
          title: const Text('Profile'),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EdidUser(
                  user: user!,
                  onFinishSave: () {
                    setState(() {});
                  },
                ),
              ),
            ),
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () => {
            errorUsername = '',
            errorEmail = '',
            setState(() {
              isV = !isV;
            })
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever_outlined),
          title: const Text('Delete Account'),
          onTap: () async {
            await _renderShowAlertDialog(context, 'delete');
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: () async {
            await _renderShowAlertDialog(context, '');
          },
        ),
      ]),
    );
  }

  Widget _editingWidget(UserPageState state) {
    return
        // Expanded(
        //   child: SingleChildScrollView(
        //       child: Column(children: <Widget>[

        Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SafeArea(
              child: Container(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      isV = !isV;
                    });
                  },
                ),
              ),
            ),
            CustomContinueButton(
                isValid: true,
                onPressed: () async {
                  _userPageBloc.add(UserDatesChangeEvent(
                    name: name.text,
                    surname: surName.text,
                    username: userName.text,
                    password: password.text,
                    email: email.text,
                    logedInUser: user!,
                  ));
                  // _wait();

                  name.text = '';
                  surName.text = '';
                  userName.text = '';
                  email.text = '';
                  password.text = '';
                },
                textLabel: 'Save')
          ],
        ),
        TextField(
          controller: name,
          decoration:
              InputDecoration(hintText: '${user?.getName} -  write new name'),
        ),
        TextField(
          controller: surName,
          decoration: InputDecoration(
              hintText: '${user?.getSurName} -  write new surname'),
        ),
        TextField(
          controller: userName,
          decoration: InputDecoration(
              errorText: errorUsername,
              hintText: '${user?.getUserName} -  write new username'),
        ),
        TextField(
          controller: email,
          decoration: InputDecoration(
              errorText: errorEmail,
              hintText: '${user?.getEmail} -  write new email'),
        ),
        TextField(
          controller: password,
          decoration: InputDecoration(
              hintText: '${user?.getPassword} -  write new password'),
        ),
      ]),
    );

    // ])),
  }

  Future _renderShowAlertDialog(BuildContext context, String s) {
    Widget okButton = TextButton(
      child: const Text('YES'),
      onPressed: () {
        s == 'delete'
            ? {
                _userPageBloc.add(DeleteUserEvent()),
                _renderShowAlertDialogOK(context)
              }
            : {
                _userPageBloc.add(LogOutEvent()),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHome(),
                  ),
                )
              };
      },
    );
    Widget noButton = TextButton(
      child: const Text('NO'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog? alert = AlertDialog(
        title: const Text('Attention!!!'),
        content: s == 'delete'
            ? const Text('are you sure, you want to delete your account??')
            : const Text('You want to Log Out?'),
        actions: [
          okButton,
          noButton,
        ]);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future _renderShowAlertDialogOK(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text('Ok'),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHome(),
            ));
      },
    );

    AlertDialog? alert = AlertDialog(
        title: const Text('Error!!!'),
        content: const Text('Your Account is deleted!!!'),
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

extension _BlocListener on _UserrPageState {
  void listener(BuildContext context, UserPageState state) {
    if (state is UserPageEmailInvalidState) {
      errorEmail = 'Email is Incorrect!!';
      // await _renderShowAlertDialog(context);
    }
    if (state is UserLoadedState) {
      user = state.user;
    }
    if (state is UserPageEmailIsAlreadyState) {
      errorEmail = state.emailState;
      errorUsername = state.usernameState;
    }
    if (state is UserPageUserNameInvalidState) {
      errorUsername = 'Username is Incorrect!!';
    }
    if (state is UserDatesChengeCompleteState) {
      {
        isV = !isV;
      }

      //   errorUsername = false;
      //   errorEmail = false;
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
