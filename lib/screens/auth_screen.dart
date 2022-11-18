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
  // Switch between login and signup
  int login = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Authentifiez vous !"),
        ),
        body: Center(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 100.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        login = 0;
                      });
                    },
                    style:
                        ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    child: const Text('login'),
                  ),
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
              ],
            ),
            // Render Login widget or Signup widget 
            login == 0 ? const LoginForm() : const SignupForm(),
          ],
        )));
  }
}
