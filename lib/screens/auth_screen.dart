import 'package:flutter/material.dart';

import '../widgets/login_form.dart';
import '../widgets/signup_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({ Key? key }) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
       body: const LoginForm()
      //  body: const SignupForm()
    );
  }
}