import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum AttendanceRange { today, week, month, all }

class DownloadAttendanceProvider extends ChangeNotifier {
  Future<String> downloadAttendanceExcel({
    required String userID,
    required String employeeName,
    required AttendanceRange range,
  }) async {
    try {
      final now = DateTime.now();
      late DateTime start;
      switch (range) {
        case AttendanceRange.today:
          start = DateTime(now.year, now.month, now.day);
          break;
        case AttendanceRange.week:
          start = now.subtract(Duration(days: 7));
          break;
        case AttendanceRange.month:
          start = now.subtract(Duration(days: 30));
        case AttendanceRange.all:
          start = DateTime(2000);
          break;
      }

      QuerySnapshot query;
      try {
        query =
            await FirebaseFirestore.instance
                .collection('attendances')
                .where('user_id', isEqualTo: userID)
                .where('datetime', isGreaterThanOrEqualTo: start)
                .orderBy('datetime', descending: false)
                .get();
      } catch (e) {
        throw Exception("Gagal mengambil data attendance: $e");
      }

      final attendances =
          query.docs.map((d) => d.data() as Map<String, dynamic>).toList();

      if (attendances.isEmpty) {
        throw Exception("Tidak ada data attendance pada range ini.");
      }

      final status = await Permission.storage.request();
      if (!status.isGranted) throw Exception("Izin penyimpanan ditolak.");

      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      sheet.appendRow(["No", "Nama", "Tanggal", "Alamat"]);

      final df = DateFormat('yyyy-MM-dd HH:mm:ss');

      for (int i = 0; i < attendances.length; i++) {
        final row = attendances[i];

        DateTime dt;
        final raw = row['datetime'];
        if (raw is Timestamp) {
          dt = raw.toDate();
        } else if (raw is DateTime) {
          dt = raw;
        } else {
          dt = DateTime.tryParse(raw?.toString() ?? '') ?? DateTime.now();
        }

        sheet.appendRow([
          (i + 1).toString(),
          employeeName,
          df.format(dt),
          row['address'] ?? '',
        ]);
      }

      final cleanFileName =
          "attendance_${range.name}".replaceAll(" ", "_").toLowerCase();
      final finalFileName =
          "${cleanFileName}_${DateTime.now().millisecondsSinceEpoch}.xlsx";

      Directory directory;
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory =
              await getExternalStorageDirectory() ??
              await getApplicationDocumentsDirectory();
        }
      }

      final path = "${directory.path}/$finalFileName";

      final bytes = excel.encode();
      if (bytes == null) throw Exception("Gagal encode file Excel.");

      final file = File(path);
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);

      return path;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
