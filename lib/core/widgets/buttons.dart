import 'package:employee_attendance/core/constant/widget.dart';
import 'package:flutter/material.dart';

import '../colors/colors.dart';

Widget button(
  BuildContext context, {
  required String text,
  required VoidCallback onTap,
}) {
  return IntrinsicWidth(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyColors.primary,
        ),
        child: textRandom(
          text: text,
          size: 14,
          color: Colors.white,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
