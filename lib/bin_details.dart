import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bin.dart';
import 'maps_page.dart';

class BinDetailsRoute extends StatefulWidget {
  static String tag = 'bin-detail-page';

  @override
  _BinDetailsRouteState createState() => _BinDetailsRouteState();
}

class _BinDetailsRouteState extends State<BinDetailsRoute> {
  @override
  Widget build(BuildContext context) {
    final Bin bin = ModalRoute.of(context).settings.arguments;
    List<Bin> bins = [bin];

    final _appBar = AppBar(
      elevation: 0,
      leading: FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.white,)),
      title: Text(
        bin.binId,
        style: TextStyle(color: Colors.white),
      ),
//      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      centerTitle: true,
    );

    return Scaffold(
      appBar: _appBar,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: Column(
        children: <Widget>[
          BinMap(bins: bins, height: 200.0, width: MediaQuery.of(context).size.width,),

        ],
      ),
    );
  }
}
