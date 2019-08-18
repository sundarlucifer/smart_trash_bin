import 'package:flutter/material.dart';
import 'navigation_menu.dart';

class MapsRoute extends StatefulWidget{
  static String tag = 'maps-page';

  @override
  _MapsRouteState createState() => _MapsRouteState();
}

class _MapsRouteState extends State<MapsRoute>{
  @override
  Widget build(BuildContext context) {

    final _appBar = AppBar(
      title: Text('Bin Map'),
      centerTitle: true,
    );

    return Scaffold(
      //Custom drawer from navigation_menu.dart
      drawer: MyDrawer(),
      appBar: _appBar,
      body: Container(child: Text('Maps page'),),
    );
  }

}