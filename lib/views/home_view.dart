import '../imports.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late MqttController _mqttController;

  EdgeInsets? _screenInsets;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  String selectedDuration = "0.0 hrs",
      selectedDistance = "0.0 kms",
      selectedName = "None";

  LatLng? myLocation;
  List<Marker> markers = [];
  List<Marker> busMarkers = [];
  Polyline? polyline;
  Location? selectedLocation;

  late GoogleMapController controller;
  final Completer<GoogleMapController> mapCompleter = Completer();
  CameraPosition position = CameraPosition(
    target: stations.last.coordinates,
    zoom: 14.0,
  );

  Future locationAccess() async {
    bool _checkPosition = await PermissionHandler.checkPositionService();
    if (_checkPosition) {
      try {
        Position _locate = await Locator.getPosition();

        myLocation = LatLng(_locate.latitude, _locate.longitude);
        controller.moveCamera(
          CameraUpdate.newLatLng(myLocation!),
        );

        if (myLocation != null) {
          markers.add(Marker(
            markerId: const MarkerId("_mine_"),
            position: myLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
            infoWindow: const InfoWindow(
              title: "Your Location",
            ),
          ));

          setState(() {});
        }
      } catch (e) {
        return;
      }
    }

    return;
  }

  void getBuses() async {
    Map _map = await ApiServices.getBusLocations();
    if (_map['status'] == "OK") {
      for (Map _map in _map['data']) {
        markers.add(Marker(
          markerId: MarkerId("_bus_${_map['id']}"),
          position: LatLng(
            double.tryParse(_map['lat']) ?? 0,
            double.tryParse(_map['lng']) ?? 0,
          ),
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(
                bundle: const AssetImage('assets/images/bus.png').bundle,
              ),
              "_bus_${_map['id']}"),
          infoWindow: InfoWindow(
            title: "Speed: ${_map['speed']}",
          ),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading.value = true;

    mapCompleter.future.then((_controller) async {
      controller = _controller;
      await locationAccess();
      getBuses();
      isLoading.value = false;

    });
  
    _mqttController = MqttController();
    _mqttController.connect();
  }

  @override
  Widget build(BuildContext context) {
    _mqttController.data();
    _screenInsets = MediaQuery.of(context).viewPadding;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: position,
            markers: {
              ...markers,
              ...busMarkers,
            },
            polylines: {
              if (polyline != null) polyline!,
            },
            onMapCreated: (controller) {
              mapCompleter.complete(controller);
              var _id = 1;
              for (Location _station in stations) {
                markers.add(Marker(
                  markerId: MarkerId("${_id++}"),
                  position: _station.coordinates,
                  infoWindow: InfoWindow(
                    title: _station.title,
                    snippet: _station.description,
                  ),
                ));
              }

              setState(() {});
            },
            zoomControlsEnabled: false,
            onCameraMove: (CameraPosition _position) {
              position = _position;
            },
          ),
          CustomBottomSheet(
            title: selectedDuration,
            subtitle: selectedDistance,
            description: selectedName,
            screenInsets: _screenInsets!,
            action: () {
              _mqttController.subscribe();
              _mqttController.data();
            },
            locate: () {
              if (selectedLocation != null) {
                controller.moveCamera(
                  CameraUpdate.newLatLng(selectedLocation!.coordinates),
                );
              }
            },
          ),
          Positioned(
            top: _screenInsets!.top,
            left: 0,
            right: 0,
            bottom: _screenInsets!.bottom,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchableDropdown(
                onChanged: (Location _location) async {
                  if (myLocation == null) {
                  } else {
                    isLoading.value = true;
                    Map _response = await ApiServices.getDirection(
                      myLocation!,
                      _location.coordinates,
                    );

                    if (_response['status'] == "OK") {
                      isLoading.value = false;
                      Direction _direction = _response["data"] as Direction;
                      controller.animateCamera(
                        CameraUpdate.newLatLngBounds(_direction.bounds, 50),
                      );

                      polyline = Polyline(
                        polylineId: const PolylineId("polyline_now"),
                        width: 3,
                        color: ColorTheme.primary,
                        points: _direction.polyLines.map((e) {
                          return LatLng(e.latitude, e.longitude);
                        }).toList(),
                      );

                      selectedName = _location.title;
                      selectedDistance = "${Utils.kmConvertor(
                        _direction.totalDistance.toInt(),
                      )} kms";
                      selectedDuration = "${Utils.hourConvertor(
                        _direction.totalDuration.toInt(),
                      )} hrs";
                      selectedLocation = _location;

                      setState(() {});
                    } else {
                      isLoading.value = false;
                      Display.prompt(
                        context,
                        title: "Error Occured",
                        message: _response['message'] ?? "",
                      );
                    }
                  }
                },
                items: [
                  ...stations.map((e) {
                    LatLng _latlng = e.coordinates;
                    return SearchDropdownItem(
                      title: e.title,
                      subtitle: "${_latlng.latitude.toStringAsFixed(
                        10,
                      )}, ${_latlng.longitude.toStringAsFixed(
                        10,
                      )}",
                      value: e,
                    );
                  }),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, _value, child) {
              if (myLocation == null && !_value) {
                return child!;
              }

              return const SizedBox();
            },
            child: Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Material(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 32.0,
                        ),
                        child: Text(
                          "This app needs your location to function properly, Please enable app to access your GPS location!!!!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.blueGrey[300],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          isLoading.value = true;
                          Future.delayed(
                            const Duration(seconds: 2),
                          ).then((value) async {
                            await locationAccess();
                            isLoading.value = false;
                          });
                        },
                        color: ColorTheme.secondary,
                        icon: const Icon(Icons.gps_fixed),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, value, child) {
              if (value) {
                return child!;
              } else {
                return const SizedBox();
              }
            },
            child: Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Material(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Material(
                    color: ColorTheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const SizedBox(
                      width: 120,
                      height: 120,
                      child: Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              ColorTheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void _showProfile() async {
  //   String _name = await Storage.get("name");
  //   String _index = await Storage.get("index");

  //   Display.show(
  //     context,
  //     child: Center(
  //       child: Stack(
  //         children: [
  //           Card(
  //             clipBehavior: Clip.hardEdge,
  //             margin: const EdgeInsets.all(8.0),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10.0),
  //             ),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Material(
  //                     color: ColorTheme.secondary,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10.0),
  //                     ),
  //                     child: const SizedBox(
  //                       width: 80,
  //                       height: 80,
  //                       child: Center(
  //                         child: Icon(
  //                           Icons.person,
  //                           size: 40,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(height: 12.0),
  //                       _tile(
  //                         label: "Name",
  //                         text: _name,
  //                       ),
  //                       const SizedBox(height: 4.0),
  //                       Row(
  //                         children: [
  //                           Expanded(
  //                             child: Column(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               mainAxisSize: MainAxisSize.min,
  //                               children: [
  //                                 _tile(
  //                                   label: "Index",
  //                                   text: _index,
  //                                 ),
  //                                 const SizedBox(height: 12.0),
  //                               ],
  //                             ),
  //                           ),
  //                           IconButton(
  //                             onPressed: () async {
  //                               Navigator.pop(context);
  //                               isLoading.value = true;

  //                               Future.delayed(
  //                                 const Duration(seconds: 3),
  //                               ).then((value) async {
  //                                 await Storage.clear();

  //                                 isLoading.value = false;

  //                                 Navigator.pushReplacement(
  //                                   context,
  //                                   MaterialPageRoute(builder: (context) {
  //                                     return const IntroView();
  //                                   }),
  //                                 );
  //                               });
  //                             },
  //                             color: ColorTheme.primary,
  //                             icon: const Icon(Icons.logout),
  //                           )
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //           Positioned(
  //             top: 0,
  //             right: 0,
  //             child: InkResponse(
  //               onTap: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Card(
  //                 shape: const CircleBorder(),
  //                 margin: EdgeInsets.zero,
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(3.0),
  //                   child: Icon(
  //                     Icons.close,
  //                     size: 20,
  //                     color: Colors.blueGrey.withOpacity(
  //                       0.6,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Column _tile({
    String label = "",
    String text = "",
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.blueGrey.withOpacity(0.7),
            fontSize: 12.0,
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            color: ColorTheme.secondary,
          ),
        ),
      ],
    );
  }
}
