import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthcare2050/constants/constants.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {

  final Completer<GoogleMapController> _controller = Completer();


  Future<Position> _getUserCurrentLocation() async {


    await Geolocator.requestPermission().then((value) {

    }).onError((error, stackTrace){
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();

  }


  final List<Marker> _markers =  <Marker>[];

  static const CameraPosition _kGooglePlex =  CameraPosition(
    //target: LatLng(33.6844, 73.0479),
    
    target: LatLng(20.3388, 85.7983),
    zoom: 14,
  );


  List<Marker> list =  [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(20.3388, 85.7983),
      infoWindow: InfoWindow(
          title: 'IIG Technology'
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
     // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.fromAssetImage(configuration, tar),
     
      
    ),

  ];

  late BitmapDescriptor customIcon,targetIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
    
    setCustomMarker();

    // BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(size: Size(48, 48)), 'assets/my_icon.png')
    //     .then((onValue) {
    //   targetIcon = onValue;
    // });

   
    _markers.addAll(list);
  }

  void setCustomMarker() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/images/gpsuser.png');
  }

 

 



  @override
  Widget build(BuildContext context) {

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
        ),
      ),

      
      floatingActionButton: DraggableFab(
        child: FloatingActionButton(
          elevation: 10,
          backgroundColor: themColor,
          onPressed: ()async {
            _getUserCurrentLocation().then((value) async {
              _markers.add(
                  Marker(
                    markerId: const MarkerId('SomeId'),
                    position: LatLng(value.latitude ,value.longitude),
                    infoWindow: const InfoWindow(
                        title: 'My Current Position'
                    ),
                    icon: customIcon
                  ),
              );
      
              final GoogleMapController controller = await _controller.future;
              CameraPosition _kGooglePlex =  CameraPosition(
                target: LatLng(value.latitude ,value.longitude),
                zoom: 14,
              );
              controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
              setState(() {
      
              });
            });
          },
          child: Icon(Icons.person,color: Colors.white,),
        ),
      ),
    );
  }


}
