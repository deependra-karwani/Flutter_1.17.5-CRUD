import 'package:SampleCRUD/src/components/loader.dart';
import 'package:SampleCRUD/src/config/sharedPref.dart';
import 'package:flutter/material.dart';

import './src/config/toast.dart';
import './src/config/flag.dart';

import './src/components/loader.dart';
import './src/components/bottomTabNav.dart';

import './src/components/forgot.dart';
import './src/components/login.dart';
import './src/components/register.dart';
import './src/components/userDetails.dart';
import './src/components/users.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MyPreferences.initPref();
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          if(Flags.getLoading()) Loader(),
          Router(),
          if(MyPreferences.exists('token')) BottomTabNavigator(extContext: context),
        ],
      ),
    );
  }
}

class Router extends StatefulWidget {
  Router({Key key}) : super(key: key);

	@override
	_MyRouter createState() => _MyRouter();
}

class _MyRouter extends State<Router> {
  @override
  void initState() {
    super.initState();
    CRUDToasts.initToasts(context);
  }

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Sample CRUD',
			theme: ThemeData(
				primarySwatch: Colors.blue,
				visualDensity: VisualDensity.adaptivePlatformDensity,
			),
			home: LoginPage(),
			initialRoute: '/login',
			routes: {
				'/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/forgot': (context) => ForgotPage(),
        '/users': (context) => UsersPage(),
        '/userDetails': (context) => UserDetailsPage(),
			},
		);
	}
}