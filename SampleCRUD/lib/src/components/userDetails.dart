import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:SampleCRUD/src/config/RegEx.dart';
import 'package:SampleCRUD/src/config/flag.dart';
import 'package:SampleCRUD/src/config/requests.dart';
import 'package:SampleCRUD/src/config/sharedPref.dart';
import 'package:SampleCRUD/src/config/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatefulWidget {
  UserDetailsPage({Key key, this.userid}) : super(key : key);
  final String userid;

  @override
  _MyUserDetailsState createState() => _MyUserDetailsState();
}

class _MyUserDetailsState extends State<UserDetailsPage> {
  PickedFile _profPic;
  final ImagePicker _picker = ImagePicker();
  bool _gotImage = false;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final usernameController = TextEditingController();
  bool _isUser = false;

  _confirmLogout() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Are you sure you want to Logout?'),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {Navigator.pop(context);},
                          child: Text("No"),
                          color: Colors.blue,
                          textColor: Colors.white,
                        )
                      ),
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {Navigator.pop(context); _logout();},
                          child: Text("Yes"),
                          color: Colors.blue,
                          textColor: Colors.white,
                        )
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  void _logout() async {
    Flags.setLoading(true);
    final userid = MyPreferences.getSingle('userid');
    final response = await HTTPReqs.logout({"userid": userid});
    final res = json.decode(response.body).cast<Map<String, dynamic>>();
    CRUDToasts.showToast(res.message);
    if(response.statusCode == 200) {
      MyPreferences.removeAll();
      Navigator.of(context).pushReplacementNamed('/login');
    }
    Flags.setLoading(false);
  }

  _confirmDelProf() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Are you sure you want to Delete your Profile? This action is irreversible.'),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {Navigator.pop(context);},
                          child: Text("No"),
                          color: Colors.blue,
                          textColor: Colors.white,
                        )
                      ),
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {Navigator.pop(context); _delProf();},
                          child: Text("Yes"),
                          color: Colors.blue,
                          textColor: Colors.white,
                        )
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  void _delProf() async {
    Flags.setLoading(true);
    final userid = MyPreferences.getSingle('userid');
    final response = await HTTPReqs.logout({"userid": userid});
    final res = json.decode(response.body).cast<Map<String, dynamic>>();
    CRUDToasts.showToast(res.message);
    if(response.statusCode == 200) {
      MyPreferences.removeAll();
      Navigator.of(context).pushReplacementNamed('/register');
    }
    Flags.setLoading(false);
  }

  void _fetchData() async {
    Flags.setLoading(true);
    var userid = widget.userid;
    if(userid == null || userid == '') {
      userid = MyPreferences.getSingle('userid');
      _isUser = true;
    }
    final response = await HTTPReqs.getUserDetails({"userid": userid});
    final res = json.decode(response.body).cast<Map<String, dynamic>>();

    nameController.text = res.name;
    nameController.selection = TextSelection.fromPosition(TextPosition(offset: res.name.length));

    emailController.text = res.email;
    emailController.selection = TextSelection.fromPosition(TextPosition(offset: res.email.length));

    usernameController.text = res.username;
    usernameController.selection = TextSelection.fromPosition(TextPosition(offset: res.username.length));

    mobileController.text = res.mobile;
    mobileController.selection = TextSelection.fromPosition(TextPosition(offset: res.mobile.length));
    if(res.profpic != null) {
      setState(() {
        _profPic = res.profpic;
        _gotImage = true;
      });
    }
    Flags.setLoading(false);
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
    final userid = MyPreferences.getSingle('userid');
    FormData fd = FormData.fromMap({
      'name': nameController.text,
      'mobile': mobileController.text,
      'username': usernameController.text,
      'userid': userid,
      'prof': _profPic
    });
    final response = await HTTPReqs.updateProfile(fd);
    final res = json.decode(response.body).cast<Map<String, dynamic>>();
    CRUDToasts.showToast(res.message);
    Flags.setLoading(false);
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "Profile",
          style: new TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Column(
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
              readOnly: !_isUser,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter your email"
              ),
              controller: emailController,
              readOnly: true,
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
              readOnly: !_isUser,
            ),TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter your username"
              ),
              validator: (value) {
                return Regs.emailRE.hasMatch(value) ? "Please enter a valid username" : null;
              },
              controller: usernameController,
              readOnly: !_isUser,
            ),
            _isUser ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  if(_formKey.currentState.validate()) {
                    _submit();
                  }
                },
                child: Text('Submit'),
              ),
            ) : null
        ]
      ),
    );
  }
}