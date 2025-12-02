import 'package:employee_attendance/providers/auth_provider.dart';
import 'package:employee_attendance/providers/stream_provider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../core/colors/colors.dart';
import '../core/constant/widget.dart';

class AbsentPage extends StatefulWidget {
  const AbsentPage({super.key});

  @override
  State<AbsentPage> createState() => _AbsentPageState();
}

class _AbsentPageState extends State<AbsentPage> {
  List<Marker> _markers = [];
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;

  LatLng? startLocation;
  void _currentLocation() async {
    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(startLocation!.latitude, startLocation!.longitude),
          zoom: 20.0,
        ),
      ),
    );
  }

  String longitude = "";
  String latitude = "";
  String? name;
  String? subLocality;
  String? locality;
  String? administrativeArea;
  String? postalCode;
  String? country;
  String? street;
  String? subadministrativearea;
  String location = "...";
  @override
  void initState() {
    getLocation();
    super.initState();
  }

  TextEditingController desc = TextEditingController();

  @override
  void dispose() {
    mapController!.dispose();
    desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: MyColors.primary,
        title: textRandom(
          text: "Absen",
          size: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: MyColors.bg,
      body: SingleChildScrollView(
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, right: 15, left: 15),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).width * 0.7,
              child:
                  startLocation == null
                      ? Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            color: MyColors.border,
                          ),
                        ),
                      )
                      : Stack(
                        children: [
                          GoogleMap(
                            padding: EdgeInsets.only(top: 30),
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                startLocation!.latitude,
                                startLocation!.longitude,
                              ),
                              zoom: 18.0,
                            ),
                            mapType: MapType.normal,
                            myLocationEnabled: false,
                            myLocationButtonEnabled: false,
                            onMapCreated: (controller) {
                              setState(() {
                                mapController = controller;
                              });
                            },
                            onCameraMove: (CameraPosition cameraPositiona) {
                              cameraPosition = cameraPositiona;
                            },
                            zoomControlsEnabled: false,
                            scrollGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                            tiltGesturesEnabled: false,
                            onCameraIdle: () async {
                              List<Placemark> placemarks =
                                  await placemarkFromCoordinates(
                                    cameraPosition!.target.latitude,
                                    cameraPosition!.target.longitude,
                                  );

                              try {
                                if (placemarks.isNotEmpty) {
                                  Placemark place = placemarks.first;
                                  setState(() {
                                    startLocation = LatLng(
                                      cameraPosition!.target.latitude,
                                      cameraPosition!.target.longitude,
                                    );

                                    name = placemarks.first.name;
                                    subLocality = placemarks.first.subLocality;
                                    locality = placemarks.first.locality;
                                    subadministrativearea =
                                        placemarks.first.subAdministrativeArea;
                                    administrativeArea =
                                        placemarks.first.administrativeArea;
                                    postalCode = placemarks.first.postalCode;
                                    country = placemarks.first.country;
                                    street = placemarks.first.street;
                                    location =
                                        "$street, $subLocality, $locality, $subadministrativearea, $administrativeArea, $country, $postalCode";
                                  });
                                }
                              } catch (e) {}
                            },
                          ),
                          Center(
                            child: Icon(
                              Icons.location_on,
                              size: 45,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, right: 15, left: 15),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              width: MediaQuery.sizeOf(context).width,
              // height: MediaQuery.sizeOf(context).width * 0.4,
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textRandom(
                        text: "Lokasi mu",
                        size: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      longitude.isEmpty || latitude.isEmpty
                          ? GestureDetector(
                            onTap: () => getLocation(),
                            child: Icon(Icons.refresh_rounded, size: 30),
                          )
                          : const SizedBox(),
                    ],
                  ),
                  textRandom(
                    text: location.isEmpty ? "-" : location,
                    size: 13,
                    fontWeight: FontWeight.w400,
                    maxLine: 5,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, right: 15, left: 15),
              child: TextField(
                controller: desc,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  labelStyle: TextStyle(fontSize: 14),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: MyColors.border, width: 1),
                  ),
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: MyColors.primary, width: 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: IntrinsicHeight(
          child: GestureDetector(
            onTap: () {
              if (longitude.isEmpty || latitude.isEmpty || location.isEmpty) {
                ToastHelper.showWarning(
                  context: context,
                  title: "Lokasimu belum di temukan!",
                );
                return;
              }
              context.read<AbsentProvider>().addAbsent(
                context,
                userID: context.read<AuthProvider>().user!.id.toString(),
                dateTime: DateTime.now(),
                latitude: latitude,
                longitude: longitude,
                description: desc.text,
                address: location,
              );
            },
            child: Consumer<AbsentProvider>(
              builder: (context, prov, _) {
                if (!prov.isLoading && prov.message.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ToastHelper.showSuccess(
                      context: context,
                      title: prov.message,
                    );
                    context.read<AbsentProvider>().setLoading(false);
                    context.read<AbsentProvider>().setMessage("");
                    Navigator.of(context).pop();
                  });
                }
                return Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: MyColors.primary,
                  ),
                  child:
                      prov.isLoading
                          ? Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: MyColors.border,
                              ),
                            ),
                          )
                          : textRandom(
                            text: "ABSEN",
                            size: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getLocation({bool isCurrentLocation = false}) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ToastHelper.showWarning(
          context: context,
          title: "Lokasi tidak di nyalakan",
          description: "Aktifkan GPS untuk melanjutkan.",
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ToastHelper.showWarning(
            context: context,
            title: "Izin lokasi ditolak",
            description: "Izinkan aplikasi mengakses lokasi.",
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ToastHelper.showWarning(
          context: context,
          title: "Izin lokasi ditolak permanen",
          description: "Aktifkan izin lokasi dari pengaturan.",
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        startLocation = LatLng(position.latitude, position.longitude);
        cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 10.0,
        );

        latitude = position.latitude.toString();
        longitude = position.longitude.toString();

        if (isCurrentLocation == true) {
          _currentLocation();
        }
      });
    } catch (e) {
      print("Error get location: $e");
      ToastHelper.showWarning(
        context: context,
        title: "Gagal mendapatkan lokasi",
        description: "$e",
      );
    }
  }
}
