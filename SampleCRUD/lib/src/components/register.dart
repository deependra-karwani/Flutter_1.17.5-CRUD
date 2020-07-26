import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:SampleCRUD/src/config/RegEx.dart';
import 'package:SampleCRUD/src/config/flag.dart';
import 'package:SampleCRUD/src/config/requests.dart';
import 'package:SampleCRUD/src/config/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<RegisterPage> {
  PickedFile _profPic;
  final ImagePicker _picker = ImagePicker();
  bool _gotImage = false;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final usernameController = TextEditingController();
  final passController = TextEditingController();
  final confPassController = TextEditingController();

  @override
  void dispose() {
    _clearFields();
    super.dispose();
  }

  void _clearFields() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    usernameController.dispose();
    passController.dispose();
    confPassController.dispose();
  }

  void _uploadImage() async {
    try {
      final pickedFile = await _picker.getImage(
        source: ImageSource.gallery
      );
      setState(() {
        _profPic = pickedFile;
        _gotImage = true;
      });
    } catch(e) {
      if(_gotImage == true) {
        setState(() {
          _gotImage = false;
        });
      }
    }
  }

  void _submit() async {
    Flags.setLoading(true);
    try {
      FormData fd = FormData.fromMap({
        'name': nameController.text,
        'mobile': mobileController.text,
        'email': emailController.text,
        'username': usernameController.text,
        'password': passController.text,
        'prof': _profPic,
      });
      final response = await HTTPReqs.register(fd);
      if(response.statusCode == 200) {
        emailController.dispose();
        passController.dispose();
        confPassController.dispose();
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
          "Register",
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
            Image(
              image: _gotImage ? _profPic : AssetImage('lib/assets/noImage.png'),
              height: 180,
              width: MediaQuery.of(context).size.width * 0.65,
              fit: BoxFit.contain,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter your name"
              ),
              validator: (value) {
                return Regs.nameRE.hasMatch(value) ? "Please enter your name" : null;
              },
              controller: nameController,
            ),
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
                hintText: "Enter your mobile number"
              ),
              validator: (value) {
                return Regs.mobileRE.hasMatch(value) ? "Please enter a valid mobile number" : null;
              },
              controller: mobileController,
              keyboardType: TextInputType.phone,
            ),TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter your username"
              ),
              validator: (value) {
                return Regs.emailRE.hasMatch(value) ? "Please enter a valid username" : null;
              },
              controller: usernameController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter your Password"
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