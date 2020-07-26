import 'dart:convert';

import 'package:SampleCRUD/src/config/flag.dart';
import 'package:SampleCRUD/src/config/RegEx.dart';
import 'package:SampleCRUD/src/config/requests.dart';
import 'package:SampleCRUD/src/config/sharedPref.dart';
import 'package:SampleCRUD/src/config/toast.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    _clearFields();
    super.dispose();
  }

  void _clearFields() {
    usernameController.dispose();
    passController.dispose();
  }

  void _submit(context) async {
    Flags.setLoading(true);
    try {
      final response = await HTTPReqs.login({'username': usernameController.text, 'password': passController.text});
      final res = json.decode(response.body).cast<Map<String, dynamic>>();
      CRUDToasts.showToast(res.message);
      if(response.statusCode == 200) {
        _clearFields();
        MyPreferences.saveSingle('token', response.headers['token']);
        MyPreferences.saveSingle('userid', res.userid);
        Navigator.of(context).pushReplacementNamed('/users');
      }
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
          "Login",
          style: new TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter your Username"
              ),
              validator: (value) {
                return Regs.usernameRE.hasMatch(value) ? "Please enter your Username" : null;
              },
              controller: usernameController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter your Password"
              ),
              validator: (value) {
                return Regs.passwordRE.hasMatch(value) ? "Please enter your valid Password" : null;
              },
              controller: passController,
              obscureText: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  if(_formKey.currentState.validate()) {
                    _submit(context);
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