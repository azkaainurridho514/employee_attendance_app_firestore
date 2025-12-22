import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

Widget textRandom({
  required String text,
  Color? color,
  required double size,
  TextAlign textAlign = TextAlign.left,
  int maxLine = 2,
  FontWeight fontWeight = FontWeight.w400,
  double? height,
  double? spacing,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return Text(
    text,
    style: GoogleFonts.inter(
      height: height,
      color: color,
      fontWeight: fontWeight,
      fontSize: size,
      letterSpacing: spacing,
      fontStyle: fontStyle,
    ),
    softWrap: true,
    overflow: TextOverflow.ellipsis,
    maxLines: maxLine,
    textAlign: textAlign,
  );
}

class ToastHelper {
  static void showSuccess({
    required BuildContext context,
    required String title,
    String? description,
    CherryToastVariant variant = CherryToastVariant.success,
    Duration duration = const Duration(seconds: 3),
    bool dismissible = true,
  }) {
    CherryToast.success(
      title: Text(title),
      description: description != null ? Text(description) : null,
      toastDuration: duration,
      animationDuration: const Duration(milliseconds: 500),
      toastPosition: Position.top,
      animationType: AnimationType.fromTop,
    ).show(context);
  }

  static void showError({
    required BuildContext context,
    required String title,
    String? description,
    CherryToastVariant variant = CherryToastVariant.error,
    Duration duration = const Duration(seconds: 3),
    bool dismissible = true,
  }) {
    CherryToast.error(
      title: Text(title),
      description: description != null ? Text(description) : null,
      toastDuration: duration,
      animationDuration: const Duration(milliseconds: 500),
      toastPosition: Position.top,
      animationType: AnimationType.fromTop,
    ).show(context);
  }

  static void showWarning({
    required BuildContext context,
    required String title,
    String? description,
    CherryToastVariant variant = CherryToastVariant.warning,
    Duration duration = const Duration(seconds: 3),
    bool dismissible = true,
  }) {
    CherryToast.warning(
      title: Text(title),
      description: description != null ? Text(description) : null,
      toastDuration: duration,
      animationDuration: const Duration(milliseconds: 500),
      toastPosition: Position.top,
      animationType: AnimationType.fromTop,
    ).show(context);
  }

  static void showInfo({
    required BuildContext context,
    required String title,
    String? description,
    CherryToastVariant variant = CherryToastVariant.info,
    Duration duration = const Duration(seconds: 3),
    bool dismissible = true,
  }) {
    CherryToast.info(
      title: Text(title),
      description: description != null ? Text(description) : null,
      toastDuration: duration,
      animationDuration: const Duration(milliseconds: 500),
      toastPosition: Position.top,
      animationType: AnimationType.fromTop,
    ).show(context);
  }
}

enum CherryToastVariant { success, error, warning, info }

String formatToNameFile(DateTime dateTime) {
  final DateFormat formatter = DateFormat('dd_MMMM_yyyy_HH_mm');
  return formatter.format(dateTime);
}

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('dd MMMM yyyy, HH:mm');
  return formatter.format(dateTime);
}

String formatddDDMMMYYYY(DateTime dateTime) {
  final DateFormat formatter = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
  return formatter.format(dateTime);
}

String formatDateOnly(DateTime dateTime) {
  final DateFormat formatter = DateFormat('dd MMMM yyyy', 'id_ID');
  return formatter.format(dateTime);
}

String formatHourOnly(DateTime dateTime) {
  final DateFormat formatter = DateFormat('HH:mm');
  return formatter.format(dateTime);
}

String formatHourMinuteOnly(DateTime dateTime) {
  final DateFormat formatter = DateFormat('HH:mm:ss');
  return formatter.format(dateTime);
}

String formatHourMinuteTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('HH:mm a');
  return formatter.format(dateTime);
}

DateTime? parseFirestoreDate(dynamic value) {
  if (value == null) return null;

  if (value is Timestamp) {
    return value.toDate();
  }

  if (value is String) {
    return DateTime.tryParse(value);
  }

  return null;
}

bool isLate({required int sesi, required DateTime dateTime}) {
  // batas waktu per sesi (dalam menit)
  final Map<int, int> batasSesi = {
    1: 5 * 60 + 30, // 05:30
    2: 6 * 60 + 30, // 06:30
  };
  print(sesi);
  if (!batasSesi.containsKey(sesi)) {
    print("Sesi tidak valid");
    return false;
  }

  // waktu sekarang dalam menit
  final int nowInMinutes = dateTime.hour * 60 + dateTime.minute;

  // batas sesi dalam menit
  final int batasInMinutes = batasSesi[sesi]!;

  final bool terlambat = nowInMinutes > batasInMinutes;

  print(
    terlambat
        ? "Terlambat! Melewati batas sesi $sesi"
        : "Tepat waktu untuk sesi $sesi",
  );

  return terlambat;
}

Duration getDurasiTerlambat(int sesi, Timestamp absenTimestamp) {
  DateTime absenTime = absenTimestamp.toDate();
  DateTime batasWaktu;

  if (sesi == 1) {
    batasWaktu = DateTime(
      absenTime.year,
      absenTime.month,
      absenTime.day,
      5,
      30,
    );
  } else {
    batasWaktu = DateTime(
      absenTime.year,
      absenTime.month,
      absenTime.day,
      6,
      30,
    );
  }

  if (absenTime.isAfter(batasWaktu)) {
    return absenTime.difference(batasWaktu);
  }

  return Duration.zero;
}

String formatDurasiTerlambat(Duration durasi) {
  if (durasi.inMinutes == 0) return "Tepat waktu";

  int jam = durasi.inHours;
  int menit = durasi.inMinutes.remainder(60);

  if (jam > 0) {
    return "Terlambat $jam jam $menit menit";
  } else {
    return "Terlambat $menit menit";
  }
}

String truncateString(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  }
  return '${text.substring(0, maxLength)}...';
}
