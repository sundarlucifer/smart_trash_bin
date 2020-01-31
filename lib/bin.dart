import 'package:cloud_firestore/cloud_firestore.dart';

class Bin{

  String binId;
  bool isGas;
  var fillLevel;
  bool isFire;
  String isTilt;
  GeoPoint location;

  Bin(DocumentSnapshot snapshot){
    binId = snapshot['bin_id'];
    isGas = snapshot['co_level'];
    fillLevel = snapshot['fill_level'];
    isFire = snapshot['is_fire'];
    isTilt = snapshot['is_tilt'];
    location = snapshot['location'];
  }

}