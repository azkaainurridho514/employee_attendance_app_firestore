import 'package:employee_attendance/core/colors/colors.dart';
import 'package:employee_attendance/core/constant/text.dart';
import 'package:employee_attendance/providers/auth_provider.dart';
import 'package:employee_attendance/providers/stream_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constant/widget.dart';

import '../providers/download_attendance_provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late Stream<List<Map<String, dynamic>>> getUsers;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AbsentProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    getUsers = provider.getAllUsers(isAll: auth.user!.role == textOwner);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: MyColors.primary,
        title: textRandom(
          text: "List Users",
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
              stream: getUsers,
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
                                id: att['doc_id'] ?? "",
                                name: att['name'] ?? "",
                                email: att['email'] ?? "",
                                isActive: att['is_active'] ?? false,
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
    required bool isActive,
  }) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: MyColors.primary,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              spacing: 3,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textRandom(
                  text: name,
                  size: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textRandom(
                  text: email,
                  size: 12,
                  textAlign: TextAlign.right,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          context.read<AuthProvider>().user!.role == textAdmin
              ? Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap:
                        () => showChangeEmployeeSheet(
                          context,
                          isActive: isActive,
                          id: id,
                          name: name,
                        ),
                    child: Icon(
                      Icons.edit_note_rounded,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              : context.read<AuthProvider>().user!.role == textOwner
              ? Expanded(
                child: Wrap(
                  spacing: 5,
                  alignment: WrapAlignment.end,
                  children: [
                    GestureDetector(
                      onTap:
                          () =>
                              showChangeRoleSheet(context, id: id, name: name),
                      child: Icon(
                        Icons.edit_note_rounded,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          () => showDownloadAttendanceSheet(
                            context,
                            id: id,
                            name: name,
                          ),
                      child: Icon(
                        Icons.downloading_rounded,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
              : const SizedBox(),
        ],
      ),
    );
  }

  void showDownloadAttendanceSheet(
    BuildContext context, {
    required String id,
    required String name,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DownloadAttendanceBottomSheet(id: id, name: name);
      },
    );
  }

  void showChangeRoleSheet(
    BuildContext context, {
    required String id,
    required String name,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ChangeRoleBottomSheet(id: id, name: name);
      },
    );
  }

  void showChangeEmployeeSheet(
    BuildContext context, {
    required bool isActive,
    required String id,
    required String name,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ChangeActiveEmployeeBottomSheet(
          isActive: isActive,
          id: id,
          name: name,
        );
      },
    );
  }
}

class ChangeActiveEmployeeBottomSheet extends StatefulWidget {
  final String id;
  final String name;
  final bool isActive;
  const ChangeActiveEmployeeBottomSheet({
    super.key,
    required this.id,
    required this.name,
    required this.isActive,
  });

  @override
  State<ChangeActiveEmployeeBottomSheet> createState() =>
      _ChangeActiveEmployeeBottomSheetState();
}

class _ChangeActiveEmployeeBottomSheetState
    extends State<ChangeActiveEmployeeBottomSheet> {
  bool? selectedType;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedType = widget.isActive;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Center(
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: textRandom(
                      text: "Aktif",
                      size: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    selected: selectedType == true,
                    onSelected: (_) {
                      setState(() => selectedType = true);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: textRandom(
                      text: "Tidak Aktif",
                      size: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    selected: selectedType == false,
                    onSelected: (_) {
                      setState(() => selectedType = false);
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          SafeArea(
            child: Consumer<AbsentProvider>(
              builder: (context, prov, _) {
                if (!prov.isLoading && prov.message.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ToastHelper.showSuccess(
                      context: context,
                      title: prov.message,
                    );
                    context.read<AbsentProvider>().setMessage("");
                    Navigator.pop(context);
                  });
                }
                return SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      if (selectedType != null) {
                        Navigator.pop(context);
                        prov.changeActiveEmployee(
                          context,
                          userID: widget.id,
                          isActive: selectedType!,
                        );
                      }
                    },
                    child: Container(
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
                                text: "Ubah",
                                textAlign: TextAlign.center,
                                color: Colors.white,
                                size: 16,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class ChangeRoleBottomSheet extends StatefulWidget {
  final String id;
  final String name;
  const ChangeRoleBottomSheet({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  State<ChangeRoleBottomSheet> createState() => _ChangeRoleBottomSheetState();
}

class _ChangeRoleBottomSheetState extends State<ChangeRoleBottomSheet> {
  String selectedType = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          textRandom(text: "Ubah role", size: 18, fontWeight: FontWeight.bold),
          const SizedBox(height: 15),
          textRandom(text: "Pilih Role", size: 14, fontWeight: FontWeight.w600),
          const SizedBox(height: 10),

          Center(
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: textRandom(
                      text: textKaryawan,
                      size: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    selected: selectedType == textKaryawan,
                    onSelected: (_) {
                      setState(() => selectedType = textKaryawan);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: textRandom(
                      text: textAdmin,
                      size: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    selected: selectedType == textAdmin,
                    onSelected: (_) {
                      setState(() => selectedType = textAdmin);
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Consumer<AbsentProvider>(
                builder: (context, prov, child) {
                  if (!prov.isLoading && prov.message.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ToastHelper.showSuccess(
                        context: context,
                        title: prov.message,
                      );
                      context.read<AbsentProvider>().setLoading(false);
                      context.read<AbsentProvider>().setMessage("");
                      Navigator.pop(context);
                    });
                  }
                  return GestureDetector(
                    onTap: () {
                      context.read<AbsentProvider>().setLoading(false);
                      prov.changeRole(
                        context,
                        userID: widget.id,
                        role: selectedType,
                      );
                    },
                    child: Container(
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
                                text: "Ubah",
                                textAlign: TextAlign.center,
                                color: Colors.white,
                                size: 16,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class DownloadAttendanceBottomSheet extends StatefulWidget {
  final String id;
  final String name;
  const DownloadAttendanceBottomSheet({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  State<DownloadAttendanceBottomSheet> createState() =>
      _DownloadAttendanceBottomSheetState();
}

class _DownloadAttendanceBottomSheetState
    extends State<DownloadAttendanceBottomSheet> {
  AttendanceRange selectedType = AttendanceRange.today;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          textRandom(
            text: "Download Absensi",
            size: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 15),
          textRandom(
            text: "Pilih Periode",
            size: 14,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 10),

          Center(
            child: Wrap(
              spacing: 5,
              children: [
                ChoiceChip(
                  label: textRandom(
                    text: "1 Day",
                    size: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  selected: selectedType == AttendanceRange.today,
                  onSelected: (_) {
                    setState(() => selectedType = AttendanceRange.today);
                  },
                ),
                ChoiceChip(
                  label: textRandom(
                    text: "1 Week",
                    size: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  selected: selectedType == AttendanceRange.week,
                  onSelected: (_) {
                    setState(() => selectedType = AttendanceRange.week);
                  },
                ),
                ChoiceChip(
                  label: textRandom(
                    text: "1 Month",
                    size: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  selected: selectedType == AttendanceRange.month,
                  onSelected: (_) {
                    setState(() => selectedType = AttendanceRange.month);
                  },
                ),
                ChoiceChip(
                  label: textRandom(
                    text: "All",
                    size: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  selected: selectedType == AttendanceRange.all,
                  onSelected: (_) {
                    setState(() => selectedType = AttendanceRange.all);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () async {
                  try {
                    final path = await context
                        .read<DownloadAttendanceProvider>()
                        .downloadAttendanceExcel(
                          userID: widget.id,
                          employeeName: widget.name,
                          range: selectedType,
                        );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Berhasil diunduh: $path"),
                        duration: Duration(seconds: 5),
                      ),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $e"),
                        duration: Duration(seconds: 5),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: MyColors.primary,
                  ),
                  child: textRandom(
                    text: "Download",
                    textAlign: TextAlign.center,
                    color: Colors.white,
                    size: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
