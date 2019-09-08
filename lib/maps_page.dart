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

    StreamBuilder(
      stream: authService.getBins(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        print('stream builder');
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
    switch (snapshot.connectionState) {
    case ConnectionState.waiting:
    return new Text('Loading...');
    default:
    snapshot.data.documents.map((DocumentSnapshot document) {
    bins.add(new Bin(document));
    });
        };
        if (snapshot.hasData) {
          print('bin found');
          snapshot.data.documents
              .map((DocumentSnapshot document) => bins.add(new Bin(document)));
        } else
          print('no bins');
        return null;
      },
    );

    return Scaffold(
      //Custom drawer from navigation_menu.dart
      drawer: MyDrawer(),
      appBar: _appBar,
      body: Center(
        child: BinMap(
            bins: bins,
            height: 300,
            width: 300),
      ),
    );
  }
}

class BinMap extends StatelessWidget {
  final List<Bin> bins;
  double height;
  double width;
  List<Marker> binMarkers = [];
  GoogleMapController mapController;

  BinMap({
    @required this.bins,
    @required this.height,
    @required this.width,
  }) : assert(bins != null);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    for (Bin bin in bins) {
      print(bin.binId);
      binMarkers.add(Marker(
          markerId: MarkerId(bin.binId),
          draggable: false,
          position: LatLng(bin.location.latitude, bin.location.longitude)));
    }

    if(bins.length == 0)
      return Text('No bins found at the moment');

    return Container(
      height: height,
      width: width,
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

  double _zoom() => bins.length>1 ? 2 : 8;

  _target() => bins.length>1 ? LatLng(28.7041, 77.1025) : LatLng(bins.first.location.latitude, bins.first.location.longitude);
}
