import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance/core/colors/colors.dart';
import 'package:employee_attendance/home/detail.dart';
import 'package:employee_attendance/providers/stream_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constant/widget.dart';

class ListAbsent extends StatefulWidget {
  const ListAbsent({super.key});

  @override
  State<ListAbsent> createState() => _ListAbsentState();
}

class _ListAbsentState extends State<ListAbsent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: MyColors.primary,
        title: textRandom(
          text: "List Absensi",
          size: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: MyColors.bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: context.watch<AbsentProvider>().getAllAttendances(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: textRandom(
                      text: "Terjadi kesalahan",
                      size: 10,
                      color: Colors.black,
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: MyColors.primary),
                  );
                }

                final attendances = snapshot.data!;

                return Container(
                  width: MediaQuery.sizeOf(context).width,
                  margin: EdgeInsets.all(15),
                  child:
                      attendances.isEmpty
                          ? _dataNotFound()
                          : Column(
                            spacing: 5,
                            children: List.generate(attendances.length, (i) {
                              final att = attendances[i];
                              final user = att['user'];
                              return _buildCardActivity(
                                address: att['address'] ?? "",
                                desc: att['description'] ?? "",
                                date: att['datetime'] ?? "",
                                name: user?['name'] ?? 'User tidak ditemukan',
                                latitude: att['latitude'] ?? "",
                                longitude: att['longitude'] ?? "",
                              );
                            }),
                          ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataNotFound() {
    return Center(
      child: textRandom(text: "Tidak ada data", size: 10, color: Colors.black),
    );
  }

  Widget _buildCardActivity({
    required String address,
    required String desc,
    required String name,
    required dynamic date,
    required String longitude,
    required String latitude,
  }) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: MyColors.primary,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                textRandom(
                  text: name,
                  fontWeight: FontWeight.bold,
                  size: 15,
                  color: Colors.white,
                ),
                textRandom(
                  text: formatDateTime((date as Timestamp).toDate()),
                  size: 11,
                  textAlign: TextAlign.left,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => Detail(
                              address: address,
                              desc: desc,
                              name: name,
                              date: date,
                              longitude: longitude,
                              latitude: latitude,
                            ),
                      ),
                    ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: MyColors.green,
                  ),
                  child: textRandom(
                    text: "Detail",
                    size: 9,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
