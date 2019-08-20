import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bin.dart';

class BinDetailsRoute extends StatefulWidget {
  static String tag = 'bin-detail-page';

  @override
  _BinDetailsRouteState createState() => _BinDetailsRouteState();
}

class _BinDetailsRouteState extends State<BinDetailsRoute>{
  @override
  Widget build(BuildContext context) {
    final Bin bin = ModalRoute.of(context).settings.arguments;

    final _appBar = AppBar(
      leading: FlatButton(onPressed: ()=> Navigator.pop(context), child: Icon(Icons.arrow_back)),
    );

    return Scaffold(
      appBar: _appBar,
      body: Column(
        children: <Widget>[
          Text(bin.location.latitude.toString())
        ],
      ),
    );
  }
}