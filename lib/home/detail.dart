import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../core/colors/colors.dart';
import '../core/constant/widget.dart';

class Detail extends StatefulWidget {
  final String name;
  final dynamic date;
  final String longitude;
  final String latitude;
  final String desc;
  final String address;
  final int sesi;
  const Detail({
    super.key,
    required this.name,
    required this.date,
    required this.longitude,
    required this.latitude,
    required this.desc,
    required this.address,
    required this.sesi,
  });

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: MyColors.primary,
        title: textRandom(
          text: "Detail",
          size: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: MyColors.bg,
      body: SingleChildScrollView(
        child: Column(
          spacing: 5,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).width * 0.7,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: MyColors.border, width: 1.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GoogleMap(
                  markers: _markers,
                  onMapCreated: (controller) {
                    setState(() {
                      mapController = controller;
                      _markers.add(
                        Marker(
                          markerId: const MarkerId("current_location"),
                          position: LatLng(
                            double.tryParse(widget.latitude) ?? 0,
                            double.tryParse(widget.longitude) ?? 0,
                          ),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed,
                          ),
                        ),
                      );
                    });
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      double.tryParse(widget.latitude) ?? 0,
                      double.tryParse(widget.longitude) ?? 0,
                    ),
                    zoom: 20.0,
                  ),
                  mapType: MapType.satellite,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  scrollGesturesEnabled: false,
                  zoomGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(right: 15, left: 15, top: 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: MyColors.border, width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  _buildList("Nama", widget.name),
                  _buildList(
                    "Tanggal Absen",
                    formatDateOnly((widget.date as Timestamp).toDate()),
                  ),
                  _buildList(
                    "Waktu",
                    formatHourOnly((widget.date as Timestamp).toDate()),
                  ),
                  _buildList("Latitude", widget.longitude),
                  _buildList("Longitude", widget.latitude),
                  _buildListStatus(widget.date),
                  isLate(dateTime: (widget.date).toDate(), sesi: widget.sesi)
                      ? textRandom(
                        text: formatDurasiTerlambat(
                          getDurasiTerlambat(widget.sesi, widget.date),
                        ),
                        size: 11,
                      )
                      : const SizedBox(),
                  _buildListColumn("Alamat", widget.address),
                  _buildListColumn("Deskripsi", widget.desc),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListStatus(date) {
    return Row(
      children: [
        Expanded(
          child: textRandom(
            text: "Status Absen",
            size: 13,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        Expanded(
          child: textRandom(
            text:
                isLate(dateTime: (widget.date).toDate(), sesi: widget.sesi)
                    ? "Terlambat"
                    : "Tepat Waktu",
            size: 13,
            textAlign: TextAlign.end,
            fontWeight: FontWeight.bold,
            color:
                isLate(dateTime: (widget.date).toDate(), sesi: widget.sesi)
                    ? MyColors.softRed
                    : MyColors.softGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildList(title, text) {
    return Row(
      children: [
        Expanded(
          child: textRandom(
            text: title,
            size: 13,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        Expanded(
          child: textRandom(
            text: text,
            size: 13,
            textAlign: TextAlign.end,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildListColumn(title, text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textRandom(
          text: title,
          size: 13,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        textRandom(
          text: text.isEmpty ? "-" : text,
          size: 11,
          fontWeight: FontWeight.bold,
          maxLine: 5,
          color: Colors.black,
        ),
      ],
    );
  }
}
