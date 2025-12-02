import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
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

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('dd MMMM yyyy, HH:mm');
  return formatter.format(dateTime);
}

String formatDateOnly(DateTime dateTime) {
  final DateFormat formatter = DateFormat('dd MMMM yyyy');
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
