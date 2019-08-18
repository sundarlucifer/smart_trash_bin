import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'navigation_menu.dart';

class BinListRoute extends StatefulWidget{
  static String tag='bin-list-page';

  @override
  _BinListRouteState createState() => _BinListRouteState();
}

class _BinListRouteState extends State<BinListRoute>{
  @override
  Widget build(BuildContext context) {

    final _appBar = AppBar(
      title: Text('Bin List'),
      centerTitle: true,
    );

    return Scaffold(
      //Custom drawer from navigation_menu.dart
      drawer: MyDrawer(),
      appBar: _appBar,
      body: BinList(),
    );
  }

}

class BinList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    return StreamBuilder<QuerySnapshot>(
//      stream: Firestore.instance.collection('bins').snapshots(),
//      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//        if (snapshot.hasError)
//          return new Text('Error: ${snapshot.error}');
//        switch (snapshot.connectionState) {
//          case ConnectionState.waiting: return new Text('Loading...');
//          default:
//            return new ListView(
//              children: snapshot.data.documents.map((DocumentSnapshot document) {
//                return new Bin(document: document,);
//              }).toList(),
//            );
//        }
//      },
//    );
  return Container(child: Text('Bin List'),);
  }
}

//class Bin extends StatelessWidget{
//  final DocumentSnapshot document;
//
//  const Bin({
//    Key key,
//    @required this.document,
//  })  : assert(document!=null),
//        super(key : key);
//
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Card(
//      elevation: 5,
//      child: Container(
//        height: 100.0,
//        child: Row(
//          children: <Widget>[
//            Container(
//              height: 100.0,
//              width: 70.0,
//              decoration: BoxDecoration(
//                  borderRadius: BorderRadius.only(
//                      bottomLeft: Radius.circular(5),
//                      topLeft: Radius.circular(5)
//                  ),
//                  image: DecorationImage(
//                      fit: BoxFit.cover,
//                      image: NetworkImage("https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png")
//                  )
//              ),
//            ),
//            Container(
//              height: 100,
//              child: Padding(
//                padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text(
//                      document['fill_level'].toString(),
//                    ),
//                    Padding(
//                      padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
//                      child: Container(
//                        width: 30,
//                        decoration: BoxDecoration(
//                            border: Border.all(color: Colors.teal),
//                            borderRadius: BorderRadius.all(Radius.circular(10))
//                        ),
//                        child: Text("3D",textAlign: TextAlign.center,),
//                      ),
//                    ),
//                    Padding(
//                      padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
//                      child: Container(
//                        width: 260,
//                        child: Text("His genius finally recognized by his idol Chester",style: TextStyle(
//                            fontSize: 15,
//                            color: Color.fromARGB(255, 48, 48, 54)
//                        ),),
//
//
//                      ),
//                    )
//                  ],
//                ),
//              ),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//}

