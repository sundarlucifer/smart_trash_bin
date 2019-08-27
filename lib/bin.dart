import 'package:cloud_firestore/cloud_firestore.dart';

class Bin{

  String binId;
  var coLevel;
  var fillLevel;
  bool isFire;
  bool isTilt;
  GeoPoint location;

  Bin(DocumentSnapshot snapshot){
    binId = snapshot['bin_id'];
    coLevel = snapshot['co_level'];
    fillLevel = snapshot['fill_level'];
    isFire = snapshot['is_fire'];
    isTilt = snapshot['is_tilt'];
    location = snapshot['location'];
  }

}