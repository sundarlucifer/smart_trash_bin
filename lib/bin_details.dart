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
  //Bin bin;

  @override
  Widget build(BuildContext context) {
    Bin bin = ModalRoute.of(context).settings.arguments;

    final _appBar = AppBar(
      elevation: 0,
      leading: FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
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
          _showMap(bin),
          _showFillLevel(bin.fillLevel),
          _showGasLevel(bin.isGas),
          _showFire(bin.isFire),
          _showTilt(bin.isTilt),
        ],
      ),
    );
  }

  _showMap(Bin bin) {
    List<Bin> bins = [bin];
    return BinMap(
      bins: bins,
      height: 200.0,
      width: MediaQuery.of(context).size.width,
    );
  }

  _showFillLevel(_fillLevel) {
    var _color = _fillLevel >= 0.4 ? Colors.orange : Colors.green;
    if(_fillLevel >= 0.8) _color = Colors.red;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        width: 70,
        child: Text(
          'Fill level',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      title: Column(
        children: <Widget>[
          FlatButton(
            child: Container(
              child: LinearProgressIndicator(
                  backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                  value: _fillLevel,
                  valueColor: AlwaysStoppedAnimation(_color)),
            ),
          ),
        ],
      ),
      trailing: Text(
        '${_fillLevel * 100} %',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  _showGasLevel(_isGas) {
    final _color = _isGas ? Colors.red : Colors.green;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        width: 70,
        child: Text(
          'Toxic Gas',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      title: Column(
        children: <Widget>[
          FlatButton(
            child: Container(
              child: LinearProgressIndicator(
                  backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                  value: 1,
                  valueColor: AlwaysStoppedAnimation(_color)),
            ),
          ),
        ],
      ),
      trailing: Text(
        '${_isGas}',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  _showFire(bool _isFire) {
    final _color = _isFire ? Colors.red : Colors.green;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
          width: 70,
          child: Text(
            'Fire',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          )),
      title: Column(
        children: <Widget>[
          FlatButton(
            child: Container(
              child: LinearProgressIndicator(
                  backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                  value: 1,
                  valueColor: AlwaysStoppedAnimation(_color)),
            ),
          ),
        ],
      ),
      trailing: Text(
        '${_isFire}',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  _showTilt(String _isTilt) {
    final _color = _isTilt[0]=='W' ? Colors.red : Colors.green;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        width: 70,
        child: Text(
          'Tilt',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      title: Column(
        children: <Widget>[
          FlatButton(
            child: Container(
              child: Text(_isTilt, style: TextStyle(color: _color, fontSize: 15),)
          ),
          )
        ],
      ),
    );
  }
}
