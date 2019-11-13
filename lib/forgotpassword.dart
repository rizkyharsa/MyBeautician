import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  final String email,radius,name,credit;

 const ForgotPassword({Key key,this.email,this.radius,this.name,this.credit}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Forgot Password'),
        ),
        body: Center(
          child: Container(
            child: Text(''),
          ),
        ),
      ),
    );
  }
}
