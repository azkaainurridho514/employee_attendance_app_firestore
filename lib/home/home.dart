// import 'package:cherry_toast/cherry_toast.dart';
// import 'package:cherry_toast/resources/arrays.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:employee_attendance/auth/login.dart';
// import 'package:employee_attendance/core/constant/widget.dart';
// import 'package:employee_attendance/home/detail.dart';
// import 'package:employee_attendance/home/list_absent.dart';
// import 'package:employee_attendance/home/users.dart';
// import 'package:employee_attendance/providers/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../core/colors/colors.dart';
// import '../core/constant/text.dart';
// import '../models/user_model.dart';
// import '../providers/stream_provider.dart';
// import 'absent.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late Stream<List<Map<String, dynamic>>> attendanceStream;
//   late Stream<List<Map<String, dynamic>>> attendanceByIdStream;

//   @override
//   void initState() {
//     super.initState();

//     final provider = Provider.of<AbsentProvider>(context, listen: false);
//     final auth = Provider.of<AuthProvider>(context, listen: false);

//     attendanceStream = provider.getAllAttendances();
//     attendanceByIdStream = provider.getAttendancesByUserId(auth.user!.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var user = context.read<AuthProvider>().user;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: MyColors.primary,
//         title: Consumer<AuthProvider>(
//           builder: (context, prov, _) {
//             return textRandom(
//               text:
//                   "Hallo, ${prov.user == null ? "Silahkan login ulang" : context.read<AuthProvider>().user!.name}",
//               size: 14,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             );
//           },
//         ),
//         actions: [_btnLogout()],
//       ),
//       body: SingleChildScrollView(
//         child: Column(children: [_buildHeader(), _buildListActivity(user)]),
//       ),
//     );
//   }

//   Widget _buildEmployeeActivity() {
//     return Padding(
//       padding: EdgeInsets.only(right: 15, left: 15, top: 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           textRandom(
//             text: "Aktifitas karyawan",
//             size: 13,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//           GestureDetector(
//             onTap:
//                 () => Navigator.of(
//                   context,
//                 ).push(MaterialPageRoute(builder: (context) => ListAbsent())),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: MyColors.button,
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//               child: textRandom(text: "Lihat", size: 10, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCardActivity({
//     required String name,
//     required dynamic date,
//     required String longitude,
//     required String latitude,
//     required String address,
//     required String desc,
//   }) {
//     return Container(
//       width: MediaQuery.sizeOf(context).width,
//       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(5)),
//         color: MyColors.primary,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 5,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               spacing: 3,
//               children: [
//                 textRandom(
//                   text: name,
//                   fontWeight: FontWeight.bold,
//                   size: 15,
//                   color: Colors.white,
//                 ),
//                 textRandom(
//                   text: formatDateTime((date as Timestamp).toDate()),
//                   size: 11,
//                   textAlign: TextAlign.left,
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 5,
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: GestureDetector(
//                 onTap:
//                     () => Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder:
//                             (context) => Detail(
//                               address: address,
//                               desc: desc,
//                               name: name,
//                               date: date,
//                               longitude: longitude,
//                               latitude: latitude,
//                             ),
//                       ),
//                     ),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(100),
//                     color: MyColors.green,
//                   ),
//                   child: textRandom(
//                     text: "Detail",
//                     size: 9,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _dataNotFound() {
//     return Center(
//       child: textRandom(text: "Tidak ada data", size: 10, color: Colors.black),
//     );
//   }

//   Widget _buildCardEmployee(dynamic date) {
//     return Container(
//       width: MediaQuery.sizeOf(context).width,
//       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(5)),
//         color: MyColors.primary,
//       ),
//       child: textRandom(
//         text: formatDateTime((date as Timestamp).toDate()),
//         fontWeight: FontWeight.bold,
//         size: 14,
//         textAlign: TextAlign.center,
//         color: Colors.white,
//       ),
//     );
//   }

//   Widget _btnLogout() {
//     return GestureDetector(
//       onTap: () {
//         context.read<AuthProvider>().logout();
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => LoginPage()),
//           (route) => false,
//         );
//       },
//       child: Container(
//         margin: EdgeInsets.only(right: 15),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(100),
//           color: MyColors.red,
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         child: textRandom(text: "Logout", size: 10, color: Colors.white),
//       ),
//     );
//   }

//   Widget _buildStreamBuilderOwner() {
//     return StreamBuilder<List<Map<String, dynamic>>>(
//       stream: attendanceStream,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: textRandom(
//               text: "Terjadi kesalahan",
//               size: 10,
//               color: Colors.black,
//             ),
//           );
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(color: MyColors.primary),
//           );
//         }

//         final attendances = snapshot.data!;

//         return Container(
//           width: MediaQuery.sizeOf(context).width,
//           margin: EdgeInsets.all(15),
//           padding: EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             border: Border.all(color: MyColors.border, width: 1.0),
//           ),
//           child:
//               attendances.isEmpty
//                   ? _dataNotFound()
//                   : Column(
//                     spacing: 5,
//                     children: List.generate(attendances.length, (i) {
//                       final att = attendances[i];
//                       final user = att['user'];
//                       return _buildCardActivity(
//                         address: att['address'] ?? "",
//                         desc: att['description'] ?? "",
//                         date: att['datetime'] ?? "",
//                         name: user?['name'] ?? 'User tidak ditemukan',
//                         latitude: att['latitude'] ?? "",
//                         longitude: att['longitude'] ?? "",
//                       );
//                     }),
//                   ),
//         );
//       },
//     );
//   }

//   Widget _buildStreamBuilderEmployee(String id) {
//     return StreamBuilder<List<Map<String, dynamic>>>(
//       stream: attendanceByIdStream,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: textRandom(
//               text: "Terjadi kesalahan",
//               size: 10,
//               color: Colors.black,
//             ),
//           );
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(color: MyColors.primary),
//           );
//         }

//         final attendances = snapshot.data!;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 15, top: 20, bottom: 5),
//               child: textRandom(
//                 text: "Aktifitas Absensi",
//                 size: 14,
//                 textAlign: TextAlign.center,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Container(
//               width: MediaQuery.sizeOf(context).width,
//               margin: EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 5),
//               padding: EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 border: Border.all(color: MyColors.border, width: 1.0),
//               ),
//               child:
//                   attendances.isEmpty
//                       ? _dataNotFound()
//                       : Column(
//                         spacing: 5,
//                         children: List.generate(attendances.length, (i) {
//                           final att = attendances[i];
//                           return _buildCardEmployee(att['datetime'] ?? "");
//                         }),
//                       ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildListActivity(UserModel? user) {
//     return Column(
//       children: [
//         user == null
//             ? const SizedBox()
//             : user.role == textOwner
//             ? _buildEmployeeActivity()
//             : const SizedBox(),
//         user == null
//             ? Center(
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: _btnLogout(),
//               ),
//             )
//             : user.role == textOwner
//             ? _buildStreamBuilderOwner()
//             : _buildStreamBuilderEmployee(user.id),
//       ],
//     );
//   }

//   Stream<DateTime> timeStream() async* {
//     while (true) {
//       yield DateTime.now();
//       await Future.delayed(const Duration(seconds: 1));
//     }
//   }

//   Widget _buildHeader() {
//     return Container(
//       decoration: BoxDecoration(color: MyColors.primary),
//       padding: EdgeInsets.only(right: 15, left: 15, bottom: 15),
//       child: Column(
//         spacing: 5,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           textRandom(
//             text: "Apa kabar?, semoga harimu menyenangkan!",
//             size: 11,
//             textAlign: TextAlign.left,
//             color: Colors.white,
//             fontWeight: FontWeight.w400,
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//             decoration: BoxDecoration(
//               color: MyColors.bg,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: StreamBuilder(
//                     stream: timeStream(),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return textRandom(
//                           text: "-- -- ----",
//                           size: 13,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         );
//                       }

//                       final now = snapshot.data as DateTime;

//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           textRandom(
//                             text: formatDateOnly(now),
//                             size: 10,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textRandom(
//                             text: formatHourMinuteOnly(now),
//                             size: 10,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: Consumer<AuthProvider>(
//                     builder: (context, prov, _) {
//                       if (prov.user == null) {
//                         return const SizedBox();
//                       }
//                       return Row(
//                         spacing: 4,
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           prov.user!.role == textAdmin
//                               ? GestureDetector(
//                                 onTap: () {
//                                   Navigator.of(context).push(
//                                     MaterialPageRoute(
//                                       builder: (context) => AbsentPage(),
//                                     ),
//                                   );
//                                 },
//                                 child: Align(
//                                   alignment: Alignment.centerRight,
//                                   child: Container(
//                                     margin: EdgeInsets.symmetric(vertical: 1),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.all(
//                                         Radius.circular(100),
//                                       ),
//                                       color: MyColors.button,
//                                     ),
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: 10,
//                                       vertical: 5,
//                                     ),
//                                     child: textRandom(
//                                       text: "Absen",
//                                       size: 10,
//                                       color: Colors.white,
//                                       textAlign: TextAlign.center,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                               : const SizedBox(),
//                           GestureDetector(
//                             onTap: () {
//                               if (prov.user!.role == textKaryawan) {
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder: (context) => AbsentPage(),
//                                   ),
//                                 );
//                               } else if (prov.user!.role == textOwner ||
//                                   prov.user!.role == textAdmin) {
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder: (context) => UsersPage(),
//                                   ),
//                                 );
//                               }
//                             },
//                             child: Align(
//                               alignment: Alignment.centerRight,
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(vertical: 1),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(100),
//                                   ),
//                                   color: MyColors.button,
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 5,
//                                 ),
//                                 child: textRandom(
//                                   text:
//                                       prov.user!.role == textKaryawan
//                                           ? "Absen"
//                                           : "Users",
//                                   size: 10,
//                                   color: Colors.white,
//                                   textAlign: TextAlign.center,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance/core/assets/images.dart';
import 'package:employee_attendance/core/constant/text.dart';
import 'package:employee_attendance/core/constant/widget.dart';
import 'package:employee_attendance/home/izin.dart';
import 'package:employee_attendance/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../auth/login.dart';
import '../core/assets/icons.dart';
import '../core/colors/colors.dart';
import '../core/widgets/buttons.dart';
import '../providers/stream_provider.dart';
import 'absent.dart';
import 'permohonan.dart';
import 'users.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<List<Map<String, dynamic>>> attendanceStream;
  late Stream<List<Map<String, dynamic>>> attendanceByIdStream;

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<AbsentProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (context.read<AuthProvider>().user!.role == textOwner) {
      attendanceStream = provider.getAllAttendances();
    } else {
      attendanceByIdStream = provider.getAttendancesByUserId(auth.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primary,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Image.asset(MyIcons.logoPNG, width: 30),
        ),
        title: textRandom(
          maxLine: 1,
          text:
              "${context.read<AuthProvider>().user!.name} (${context.read<AuthProvider>().user!.role})",
          size: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: MyColors.secondary,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                context.read<AuthProvider>().logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
              child: SvgPicture.asset(MyIcons.icLogout),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            MyImages.bgSplashScreen,
            width: MediaQuery.sizeOf(context).width,
            height: 200,
            fit: BoxFit.fill,
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(right: 15, left: 15, top: 30),
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(right: 20, left: 20, top: 10),
                child: Column(
                  children: [
                    textRandom(
                      text: "Live Attendance",
                      size: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    StreamBuilder(
                      stream: timeStream(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return textRandom(
                            text: "-- -- ----",
                            size: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          );
                        }
                        final now = snapshot.data as DateTime;
                        return Column(
                          children: [
                            textRandom(
                              text: formatHourMinuteTime(now),
                              size: 30,
                              color: MyColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            textRandom(
                              text: formatddDDMMMYYYY(now),
                              size: 13,
                              color: MyColors.border,
                            ),
                          ],
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Divider(color: MyColors.border, thickness: 0.2),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        context.read<AuthProvider>().user!.role == textOwner
                            ? const SizedBox()
                            : Expanded(
                              child: button(
                                context,
                                text: "Absen",
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AbsentPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                        context.read<AuthProvider>().user!.role == textKaryawan
                            ? const SizedBox()
                            : Expanded(
                              child: button(
                                context,
                                text: "Users",
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => UsersPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Wrap(
                      spacing: 10,
                      children: [
                        SizedBox(
                          width: 80,
                          child: button(
                            context,
                            text: textIzin,
                            onTap: () => toPage(textIzin),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: button(
                            context,
                            text: textSakit,
                            onTap: () => toPage(textSakit),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: button(
                            context,
                            text: textCuti,
                            onTap: () => toPage(textCuti),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 10,
                                  ),
                                  child: Divider(
                                    color: MyColors.border,
                                    thickness: 0.2,
                                  ),
                                ),
                                Row(
                                  spacing: 5,
                                  children: [
                                    SvgPicture.asset(MyIcons.icHistory),
                                    textRandom(
                                      text: "Histori Absen",
                                      size: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        StreamBuilder<
                                          List<Map<String, dynamic>>
                                        >(
                                          stream:
                                              context
                                                          .read<AuthProvider>()
                                                          .user!
                                                          .role ==
                                                      textOwner
                                                  ? attendanceStream
                                                  : attendanceByIdStream,
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

                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      color: MyColors.primary,
                                                    ),
                                              );
                                            }

                                            final attendances = snapshot.data!;

                                            return attendances.isEmpty
                                                ? _dataNotFound()
                                                : Column(
                                                  spacing: 5,
                                                  children: List.generate(
                                                    attendances.length,
                                                    (i) {
                                                      final att =
                                                          attendances[i];
                                                      final user = att['user'];
                                                      return _buildCardActivity(
                                                        isLast:
                                                            i ==
                                                            attendances.length -
                                                                1,
                                                        address:
                                                            att['address'] ??
                                                            "",
                                                        desc:
                                                            att['description'] ??
                                                            "",
                                                        date:
                                                            att['datetime'] ??
                                                            "",
                                                        name:
                                                            user?['name'] ??
                                                            'User tidak ditemukan',
                                                        latitude:
                                                            att['latitude'] ??
                                                            "",
                                                        longitude:
                                                            att['longitude'] ??
                                                            "",
                                                      );
                                                    },
                                                  ),
                                                );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void toPage(String from) {
    if (context.read<AuthProvider>().user!.role == textOwner) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => IzinPage(from: from)));
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PermohonanPage(from: from)),
      );
    }
  }

  _buildCardActivity({
    required bool isLast,
    required String address,
    required String desc,
    required dynamic date,
    required String name,
    required String latitude,
    required String longitude,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: textRandom(
                text:
                    context.read<AuthProvider>().user!.role == textKaryawan
                        ? formatddDDMMMYYYY((date as Timestamp).toDate())
                        : "$name, ${formatDateOnly((date).toDate())}",
                size: 11,
                color: MyColors.border,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 5,
                children: [
                  SvgPicture.asset(
                    MyIcons.icTime,
                    color: Colors.black,
                    width: 17,
                  ),
                  textRandom(
                    text: formatHourOnly((date).toDate()),
                    size: 11,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ],
        ),
        isLast
            ? const SizedBox()
            : Divider(color: MyColors.border, thickness: 0.5),
      ],
    );
  }

  Widget _dataNotFound() {
    return Center(
      child: textRandom(text: "Tidak ada data", size: 10, color: Colors.black),
    );
  }

  Stream<DateTime> timeStream() async* {
    while (true) {
      yield DateTime.now();
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
