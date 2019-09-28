import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'bin_list.dart';
import 'maps_page.dart';
import 'profile_page.dart';
import 'auth.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDraweState createState() => _MyDraweState();
}

class _MyDraweState extends State<MyDrawer> {
  String _userName ;
  String _userMail;
  Widget _userPhoto = Image.asset('assets/icons/user.png');

  @override
  void initState() {
    authService.getUser().then((user){
      setState(() {
        _userName = user.displayName;
        _userMail = user.email;
        _userPhoto = Image.network(user.photoUrl);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(_userName ?? 'loading..'),
            accountEmail: Text(_userMail ?? 'loading..'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child:  _userPhoto,
            ),
          ),
          ListTile(
            title: Text('Bins'),
            leading: Icon(Icons.keyboard_backspace),
            onTap: () => Navigator.pushReplacementNamed(context, BinListRoute.tag),
          ),
          ListTile(
            title: Text('Map'),
            leading: Icon(Icons.keyboard_backspace),
            onTap: () => Navigator.pushReplacementNamed(context, MapsRoute.tag),
          ),
          ListTile(
            title: Text('Profile'),
            leading: Icon(Icons.keyboard_backspace),
            onTap: () => Navigator.pushReplacementNamed(context, ProfileRoute.tag),
          ),
          ListTile(
            title: Text('Sign Out'),
            leading: Icon(Icons.keyboard_backspace),
            onTap: () {
              authService.signOut();
              Navigator.pushReplacementNamed(context, LoginRoute.tag);
            }
          ),
        ],
      ),
    );
  }
}
