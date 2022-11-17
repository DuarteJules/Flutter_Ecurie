import 'package:flutter/material.dart';

import '../providers/navigation_bar.dart';
import '../widgets/login_form.dart';
import '../widgets/signup_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int login = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("test"),
        ),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  login = 0;
                });
              },
              style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
              child: const Text('login'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  login = 1;
                });
              },
              style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
              child: const Text('signup'),
            ),
            login == 0 ? const LoginForm() : const SignupForm(),
          ],
        ))
        );
  }
}
