import 'package:flutter/material.dart';

class BottomTabNavigator extends StatefulWidget {
  BottomTabNavigator({Key key, this.extContext}) : super(key: key);
  final BuildContext extContext;

  @override
  _BottomTabNavState createState() => _BottomTabNavState();
}

class _BottomTabNavState extends State<BottomTabNavigator> {
  int _selectedIndex = 0;
  List<String> _routes = ['/users', '/userDetails'];

  void _navigateTo(int index) {
    Navigator.of(widget.extContext).pushNamed(_routes[index]);
    // Navigator.of(context).settings.name
    setState(() {
      _selectedIndex =  index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile")
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _navigateTo,
      ),
    );
  }
}