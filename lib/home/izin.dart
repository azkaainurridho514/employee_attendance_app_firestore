import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance/core/constant/text.dart';
import 'package:employee_attendance/providers/stream_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/colors/colors.dart';
import '../core/constant/widget.dart';

class IzinPage extends StatefulWidget {
  final String from;
  const IzinPage({super.key, required this.from});

  @override
  State<IzinPage> createState() => _IzinPageState();
}

class _IzinPageState extends State<IzinPage> {
  late Stream<List<Map<String, dynamic>>> getRequests;
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<RequestProvider>(context, listen: false);
    getRequests = provider.getRequestByType(widget.from);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: textRandom(
          text: "List ${widget.from}",
          size: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: MyColors.primary,
      ),
      backgroundColor: MyColors.bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: getRequests,
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
                final requestsss = snapshot.data!;
                return Container(
                  width: MediaQuery.sizeOf(context).width,
                  margin: EdgeInsets.all(15),
                  child:
                      requestsss.isEmpty
                          ? _dataNotFound()
                          : Column(
                            spacing: 5,
                            children: List.generate(requestsss.length, (i) {
                              final att = requestsss[i];
                              final user = att['user'];
                              return _buildCardActivity(
                                id: att['doc_id'] ?? "",
                                name: user['name'] ?? "",
                                email: user['email'] ?? "",
                                date: att["date"] ?? "",
                                desc: att["description"] ?? "",
                                endDate: att["end_date"] ?? "",
                                startDate: att["start_date"] ?? "",
                                type: att["type"] ?? "",
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
    required String email,
    required String name,
    required String id,
    required String type,
    required dynamic date,
    required dynamic startDate,
    required dynamic endDate,
    required String desc,
  }) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: MyColors.primary,
      ),
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textRandom(
            text: name,
            size: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          type == textSakit
              ? Row(
                children: [
                  Expanded(
                    child: textRandom(
                      text: "Tanggal",
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: textRandom(
                      text: formatDateOnly((date as Timestamp).toDate()),
                      textAlign: TextAlign.end,
                      size: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
              : textRandom(
                text:
                    "${formatDateOnly((startDate as Timestamp).toDate())} - ${formatDateOnly((endDate as Timestamp).toDate())}",
                size: 11,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),

          desc.isNotEmpty
              ? textRandom(
                text: desc,
                size: 12,
                maxLine: 10,
                color: Colors.white,
              )
              : const SizedBox(),
        ],
      ),
    );
  }
}
