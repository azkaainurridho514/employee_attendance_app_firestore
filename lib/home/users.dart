import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance/core/colors/colors.dart';
import 'package:employee_attendance/home/detail.dart';
import 'package:employee_attendance/providers/stream_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constant/widget.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
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
              stream: context.watch<AbsentProvider>().getAllUsers(),
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
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: CircularProgressIndicator(color: MyColors.primary),
                    ),
                  );
                }

                final users = snapshot.data!;

                return Container(
                  width: MediaQuery.sizeOf(context).width,
                  margin: EdgeInsets.all(15),
                  child:
                      users.isEmpty
                          ? _dataNotFound()
                          : Column(
                            spacing: 5,
                            children: List.generate(users.length, (i) {
                              final att = users[i];
                              return _buildCardActivity(
                                name: att['name'] ?? "",
                                email: att['email'] ?? "",
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

  Widget _buildCardActivity({required String email, required String name}) {
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
            child: textRandom(
              text: name,
              size: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: textRandom(
              text: email,
              size: 12,
              textAlign: TextAlign.right,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
