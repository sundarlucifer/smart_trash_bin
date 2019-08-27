import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navigation_menu.dart';
import 'auth.dart';
import 'bin_details.dart';
import 'bin.dart';

class BinListRoute extends StatefulWidget {
  static String tag = 'bin-list-page';

  @override
  _BinListRouteState createState() => _BinListRouteState();
}

class _BinListRouteState extends State<BinListRoute> {
  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      elevation: 5,
      title: Text(
        'Bin List',
        style: TextStyle(color: Colors.white),
      ),
//      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
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
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                snapshot.data.documents.map((DocumentSnapshot document) {
                  return CustomCard(
                    document: document,
                  );
                }).toList(),
            );
        }
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  final DocumentSnapshot document;

  const CustomCard({
    Key key,
    @required this.document,
  })  : assert(document != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {

    Bin bin = new Bin(document);

    return FlatButton(
      onPressed: (){
        Navigator.pushNamed(
          context,
          BinDetailsRoute.tag,
          arguments: bin,
        );
      },
      child: Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: makeListTile(bin),
        ),
      ),
    );
  }

  ListTile makeListTile(Bin bin) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Icon(Icons.restore_from_trash, color: Colors.white, size: 35.0,),
        title: Text(
          'Bin ID : ${bin.binId}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          children: <Widget>[
            FlatButton(
                child: Container(
              child: LinearProgressIndicator(
                  backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                  value: bin.fillLevel,
                  valueColor: AlwaysStoppedAnimation(Colors.green)),
            )),
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      );
}
