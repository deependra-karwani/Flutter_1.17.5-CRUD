import 'dart:convert';

import 'package:SampleCRUD/src/config/RegEx.dart';
import 'package:SampleCRUD/src/config/flag.dart';
import 'package:SampleCRUD/src/config/requests.dart';
import 'package:SampleCRUD/src/config/toast.dart';
import 'package:flutter/material.dart';

class ForgotPage extends StatefulWidget {
  ForgotPage({Key key}) : super(key: key);

  @override
  _MyForgotState createState() => _MyForgotState();
}

class _MyForgotState extends State<ForgotPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confPassController = TextEditingController();

  @override
  void dispose() {
    _clearFields();
    super.dispose();
  }

  void _clearFields() {
    emailController.dispose();
    passController.dispose();
    confPassController.dispose();
  }

  void _submit() async {
    Flags.setLoading(true);
    try {
      final response = await HTTPReqs.forgotPassword({'email': emailController.text, 'password': passController.text});
      if(response.statusCode == 200) {
        _clearFields();
      }
      final res = json.decode(response.body).cast<Map<String, dynamic>>();
      CRUDToasts.showToast(res.message);
    } catch(e) {
      CRUDToasts.showToast("Unexpected Error has Occurred");
    }
    Flags.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "Forgot Password",
          style: new TextStyle(color: Colors.white),
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter your email"
              ),
              validator: (value) {
                return Regs.emailRE.hasMatch(value) ? "Please enter a valid email" : null;
              },
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter your new Password"
              ),
              validator: (value) {
                return Regs.passwordRE.hasMatch(value) ? "Please enter a valid password" : null;
              },
              controller: passController,
              obscureText: true,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Confirm your Password"
              ),
              validator: (value) {
                return value == "" ? "Password do not match" : null;
              },
              controller: confPassController,
              obscureText: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  if(_formKey.currentState.validate()) {
                    _submit();
                  }
                },
                child: Text('Submit'),
              ),
            )
          ],
        ),
      ),
    );
  }
}