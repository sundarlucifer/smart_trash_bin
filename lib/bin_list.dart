import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navigation_menu.dart';
import 'auth.dart';

class BinListRoute extends StatefulWidget{
  static String tag='bin-list-page';

  @override
  _BinListRouteState createState() => _BinListRouteState();
}

class _BinListRouteState extends State<BinListRoute>{
  @override
  Widget build(BuildContext context) {

    final _appBar = AppBar(
      elevation: 0.1,
      title: Text('Bin List', style: TextStyle(color: Colors.white),),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      centerTitle: true,
    );

    return Scaffold(
      //Custom drawer from navigation_menu.dart
      drawer: MyDrawer(),
      appBar: _appBar,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: BinList(),
    );
  }

}

class BinList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: authService.getBins(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new Bin(document: document,);
              }).toList(),
            );
        }
      },
    );
  }
}

class Bin extends StatelessWidget{
  final DocumentSnapshot document;

  const Bin({
    Key key,
    @required this.document,
  })  : assert(document!=null),
        super(key : key);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(document),
      ),
    );
  }

  ListTile makeListTile(DocumentSnapshot document) => ListTile(
    contentPadding:
    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Icon(Icons.autorenew, color: Colors.white),
    ),
    title: Text(
      document['location'].toString(),
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),


    subtitle: Column(
      children: <Widget>[
        FlatButton(
            child: Container(
              // tag: 'hero',
              child: LinearProgressIndicator(
                  backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                  value: document['fill_level'],
                  valueColor: AlwaysStoppedAnimation(Colors.green)),
            )),
        FlatButton(
          child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(document['co_level'].toString(),
                  style: TextStyle(color: Colors.white))),
        ),
        FlatButton(
          child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(document['fire_status'].toString(),
                  style: TextStyle(color: Colors.white))),
        )
      ],
    ),
    trailing:
    Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
  );
}

