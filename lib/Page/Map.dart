import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GetPoints extends StatefulWidget {
  const GetPoints({Key? key}) : super(key: key);

  @override
  State<GetPoints> createState() => _GetPointsState();
}

class _GetPointsState extends State<GetPoints> {

  late LocationData currentPosition;
  late GoogleMapController mapController;
  Location location = Location();
  LatLng initialcameraposition = LatLng(37.421998333333335, -122.084);

  late Marker marker;
  List<Marker> markers = <Marker>[];

  String myLocation = "no";
  late BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Getting Location Point"),
          actions: [
            Row(
              children: <Widget>[
                IconButton(
                    icon: const Icon(Icons.save),
                  onPressed: (){
                      Navigator.pop(
                        context,
                        initialcameraposition
                      );
                      print("Sava ${initialcameraposition.longitude} : ${initialcameraposition.latitude}");
                  },
                )
              ],
            )
          ],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: initialcameraposition,
            zoom: 5,
          ),
          markers: Set<Marker>.of(markers),
          mapType: MapType.normal,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: getLoc,
            label: Text("Me"),
          icon: Icon(Icons.near_me),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    print("oncreated ${initialcameraposition.longitude} : ${initialcameraposition.latitude}");
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: initialcameraposition, zoom: 12)
      )
    );
  }

  void getLoc()async {
    myLocation = "yes";
    print("myLocation: $myLocation");
    bool _serviceEnable;
    PermissionStatus _permissionGranted;

    _serviceEnable = await location.serviceEnabled();
    if(!_serviceEnable){
      _serviceEnable = await location.requestService();
      if(!_serviceEnable){
        return ;
      }
    }

    _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted == await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }

    currentPosition = await location.getLocation();
    double? latitude = currentPosition.latitude;
    double? longitude = currentPosition.longitude;

    location.onLocationChanged.listen((LocationData currentPosition) {

      setState((){
        print("Current ${currentPosition.latitude} : ${currentPosition.longitude}");
        initialcameraposition = LatLng(latitude!, longitude!);
        mapController.moveCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));

        setMarkers();
      });
    });
  }

  creatMarker(context){
    if( myLocation == "yes"){
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(24,24)), "images/Alps-Switzerland.jpg")
      .then((icon){
        setState((){
          customIcon = icon;
        });
      });
    }
  }

  setMarkers(){
    creatMarker(context);
    markers.add(
      Marker(
          markerId: MarkerId("Home"),
        position: initialcameraposition,
        icon: customIcon,
        infoWindow: InfoWindow(
          title: myLocation
        )
      )
    );
    setState((){});
  }
}
