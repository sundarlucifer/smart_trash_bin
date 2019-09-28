import 'package:flutter/material.dart';
import 'navigation_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'auth.dart';
import 'bin.dart';

class MapsRoute extends StatefulWidget {
  static String tag = 'maps-page';

  @override
  _MapsRouteState createState() => _MapsRouteState();
}

class _MapsRouteState extends State<MapsRoute> {
  List<Bin> bins = [];

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      title: Text('Bin Map'),
      centerTitle: true,
    );


    authService.getBinsForMap().then((QuerySnapshot binsList){
      print(binsList.documents.length);

      binsList.documents.forEach((document){
        Bin myBin = new Bin(document);
        bool found = false;
        for(Bin bin in bins){
          if(bin.binId == myBin.binId)
            found = true;
        }
        if(!found){
          setState(() {
            bins.add(myBin);
          });
          print('${document.documentID} added to map');
        }
      });
    });

    print('Creating scaffold');

    return Scaffold(
      //Custom drawer from navigation_menu.dart
      drawer: MyDrawer(),
      appBar: _appBar,
      body: Center(
        child: BinMap(
            bins: bins,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}

class BinMap extends StatefulWidget {
  final List<Bin> bins;
  double height;
  double width;

  BinMap({
    @required this.bins,
    @required this.height,
    @required this.width,
  }) : assert(bins != null);

  @override
  _BinMapState createState() => _BinMapState();
}

class _BinMapState extends State<BinMap> {
  List<Marker> binMarkers = [];

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    for (Bin bin in widget.bins) {
      binMarkers.add(Marker(
          markerId: MarkerId(bin.binId),
          draggable: false,
          position: LatLng(bin.location.latitude, bin.location.longitude)));
    }

    if(widget.bins.length == 0)
      return Text('No bins found at the moment');

    return Container(
      height: widget.height,
      width: widget.width,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _target(),
          zoom: _zoom(),
        ),
        markers: binMarkers.toSet() ?? null,
      ),
    );
  }

  double _zoom() => widget.bins.length>1 ? 2 : 8;

  _target() => widget.bins.length>1 ? LatLng(28.7041, 77.1025) : LatLng(widget.bins.first.location.latitude, widget.bins.first.location.longitude);
}
