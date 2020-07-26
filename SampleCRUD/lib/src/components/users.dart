import 'dart:convert';

import 'package:SampleCRUD/src/config/flag.dart';
import 'package:SampleCRUD/src/config/requests.dart';
import 'package:SampleCRUD/src/config/sharedPref.dart';
import 'package:SampleCRUD/src/config/toast.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  UsersPage({Key key}) : super(key: key);

  @override
  _MyUsersState createState() => _MyUsersState();
}

class _MyUsersState extends State<UsersPage> {
  var _users = [];

  void _fetchData() async {
    Flags.setLoading(true);
    final userid = MyPreferences.getSingle('userid');
    var response = await HTTPReqs.getAllUsers({'userid': userid});
    final res = json.decode(response.body).cast<Map<String, dynamic>>();
    if(res.message != null) {
      CRUDToasts.showToast(res.message);
    }
    if(response.statusCode == 200) {
      setState(() {
        _users = res.users;
      });
    }
    Flags.setLoading(false);
  }

  _navDetails(int userid) {
    Navigator.of(context).pushNamed('/userDetails', arguments: {"userid": userid});
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
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];

          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Image.network(user.profpic),
                ),
                Text(user.name),
                Text(user.username),
              ],
            ),
          );
        },
      ),
    );
  }
}