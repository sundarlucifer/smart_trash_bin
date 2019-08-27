import 'package:flutter/material.dart';
import 'navigation_menu.dart';
import 'auth.dart';

class ProfileRoute extends StatefulWidget{
  static String tag = 'profile-page';

  @override
  _ProfileRouteState createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(),
      body: null,
    );
  }
}