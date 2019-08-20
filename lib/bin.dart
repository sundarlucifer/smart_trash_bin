import 'package:cloud_firestore/cloud_firestore.dart';

class Bin{

  var coLevel;
  var fillLevel;
  bool fireStatus;
  GeoPoint location;

  Bin(DocumentSnapshot snapshot){
    coLevel = snapshot['co_level'];
    fillLevel = snapshot['fill_level'];
    fireStatus = snapshot['fire_status'];
    location = snapshot['location'];
  }

}