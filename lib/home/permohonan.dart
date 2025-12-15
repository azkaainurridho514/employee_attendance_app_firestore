import 'package:employee_attendance/core/constant/text.dart';
import 'package:employee_attendance/core/constant/widget.dart';
import 'package:employee_attendance/core/widgets/buttons.dart';
import 'package:employee_attendance/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/colors/colors.dart';
import '../providers/stream_provider.dart';

class PermohonanPage extends StatefulWidget {
  final String from;
  const PermohonanPage({super.key, required this.from});

  @override
  State<PermohonanPage> createState() => _PermohonanPageState();
}

class _PermohonanPageState extends State<PermohonanPage> {
  final TextEditingController descController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  DateTime? selectedDate;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void dispose() {
    dateController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    descController.dispose();
    super.dispose();
  }

  void setSingleDate(DateTime date) {
    selectedDate = date;
    dateController.text = formatDateOnly(date);
    startDate = null;
    endDate = null;
    startDateController.clear();
    endDateController.clear();
  }

  void setDateRange(DateTimeRange range) {
    startDate = range.start;
    endDate = range.end;

    startDateController.text = formatDateOnly(range.start);
    endDateController.text = formatDateOnly(range.end);
    selectedDate = null;
    dateController.clear();
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
          text: widget.from,
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
            const SizedBox(height: 20),
            widget.from != textSakit
                ? const SizedBox()
                : Container(
                  margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      suffixIcon: const Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: MyColors.border,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: MyColors.border,
                          width: 1,
                        ),
                      ),
                    ),
                    onTap: () {
                      pickSingleDate(context);
                    },
                  ),
                ),

            widget.from == textSakit
                ? const SizedBox()
                : Container(
                  margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: TextField(
                    controller: startDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                          size: 20,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          pickDateRange(context);
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: MyColors.border,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: MyColors.border,
                          width: 1,
                        ),
                      ),
                    ),
                    onTap: () {
                      pickDateRange(context);
                    },
                  ),
                ),
            widget.from == textSakit
                ? const SizedBox()
                : Container(
                  margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: TextField(
                    controller: endDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      suffixIcon: const Icon(
                        Icons.event_outlined,
                        size: 20,
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: MyColors.border,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: MyColors.border,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
            Container(
              margin: EdgeInsets.only(top: 10, right: 20, left: 20),
              child: TextField(
                controller: descController,
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),

                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: MyColors.border, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: MyColors.border, width: 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 20),
        child: Consumer<RequestProvider>(
          builder: (context, prov, _) {
            if (prov.message.isNotEmpty && prov.isLoading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ToastHelper.showSuccess(
                  context: context,
                  title: "Berhasil ajukan ${widget.from}",
                );
                context.read<RequestProvider>().setMessage("");
                context.read<RequestProvider>().setLoading(false);
                Navigator.of(context).pop();
              });
            }
            return button(
              context,
              text: prov.isLoading ? "Loading..." : "Ajukan ${widget.from}",
              onTap: () {
                if (widget.from == textSakit) {
                  if (dateController.text.isEmpty) {
                    ToastHelper.showWarning(
                      context: context,
                      title: widget.from,
                    );
                    return;
                  }
                } else {
                  if (startDateController.text.isEmpty ||
                      endDateController.text.isEmpty) {
                    ToastHelper.showWarning(
                      context: context,
                      title: widget.from,
                    );
                    return;
                  }
                }
                prov.addRequest(
                  context,
                  userID: context.read<AuthProvider>().user!.id,
                  dateTime: DateTime.now(),
                  date: selectedDate,
                  startDate: startDate,
                  endDate: endDate,
                  description: descController.text,
                  type: widget.from,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> pickSingleDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: MyColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setSingleDate(picked);
    }
  }

  Future<void> pickDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: MyColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setDateRange(picked);
    }
  }
}
