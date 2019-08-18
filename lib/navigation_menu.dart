import 'package:flutter/material.dart';
import 'login_page.dart';
import 'bin_list.dart';
import 'maps_page.dart';
import 'auth.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDraweState createState() => _MyDraweState();
}

class _MyDraweState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Sundar Saravanan'),
            accountEmail: Text('sundarlucifer@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'S',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            title: Text('Bins'),
            leading: Icon(Icons.keyboard_backspace),
            onTap: () {
//              Navigator.of(context).pop();
//              Navigator.of(context).pushNamed(BinListRoute.tag);
            },
          ),
          ListTile(
            title: Text('Map'),
            leading: Icon(Icons.keyboard_backspace),
            onTap: () {
//              Navigator.of(context).pop();
//              Navigator.of(context).pushNamed(MapsRoute.tag);
            },
          ),
          ListTile(
            title: Text('Profile'),
            leading: Icon(Icons.keyboard_backspace),
            onTap: () {

            },
          ),
          ListTile(
            title: Text('Sign Out'),
            leading: Icon(Icons.keyboard_backspace),
            onTap: () {
              authService.signOut();
              while(Navigator.canPop(context))
                Navigator.pop(context);
            }
          ),
        ],
      ),
    );
  }
}
