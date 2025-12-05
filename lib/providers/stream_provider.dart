// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:employee_attendance/core/constant/text.dart';
// import 'package:flutter/material.dart';

// class AbsentProvider extends ChangeNotifier {
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//   String _message = "";
//   String get message => _message;
//   // final firestore = FirebaseFirestore.instance;

//   void setMessage(String value) {
//     _message = value;
//     notifyListeners();
//   }

//   void setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> addAbsent(
//     BuildContext context, {
//     required String userID,
//     required DateTime dateTime,
//     required String latitude,
//     required String longitude,
//     required String description,
//     required String address,
//   }) async {
//     setLoading(true);

//     try {
//       await _firestore.collection('attendances').add({
//         "user_id": userID,
//         "datetime": dateTime,
//         "latitude": latitude,
//         "longitude": longitude,
//         "description": description,
//         "address": address,
//       });

//       setLoading(false);
//       _message = "Berhasil checkin";
//     } catch (e) {
//       setLoading(false);
//       _message = "Server Error!";
//       print("Error: $e");
//     }
//   }

//   Future<void> changeActiveEmployee(
//     BuildContext context, {
//     required String userID,
//     required bool isActive,
//   }) async {
//     setLoading(true);

//     try {
//       await _firestore.collection('users').doc(userID).update({
//         "is_active": isActive,
//       });

//       setLoading(false);
//       _message = "Sukses";
//     } catch (e) {
//       setLoading(false);
//       _message = "Server Error!";
//       print("Error: $e");
//     }
//   }

//   Future<void> changeRole(
//     BuildContext context, {
//     required String userID,
//     required String role,
//   }) async {
//     setLoading(true);

//     try {
//       print("INI YA ID NYA");
//       print(userID);

//       await _firestore.collection('users').doc(userID).update({"role": role});

//       setLoading(false);
//       print("gatau");
//       setMessage("Sukses mengubah role");
//     } catch (e) {
//       setLoading(false);
//       setMessage("Server error");
//       print("Error: $e");
//     }
//   }

//   Stream<List<Map<String, dynamic>>> getAttendances() {
//     return _firestore
//         .collection('attendances')
//         .orderBy('datetime', descending: true)
//         .limit(5)
//         .snapshots()
//         .asyncMap((attendanceSnapshot) async {
//           final futures =
//               attendanceSnapshot.docs.map((doc) async {
//                 final data = doc.data();
//                 final userId = data['user_id'] as String;

//                 final userDoc =
//                     await _firestore.collection('users').doc(userId).get();
//                 final userData = userDoc.data();

//                 return {
//                   "attendanceId": doc.id,
//                   "datetime": data['datetime'],
//                   "latitude": data['latitude'],
//                   "description": data['description'],
//                   "longitude": data['longitude'],
//                   "address": data['address'],
//                   "user": userData,
//                 };
//               }).toList();

//           return await Future.wait(futures);
//         });
//   }

//   Stream<List<Map<String, dynamic>>> getAllAttendances() {
//     return _firestore
//         .collection('attendances')
//         .orderBy('datetime', descending: true)
//         .snapshots()
//         .asyncMap((attendanceSnapshot) async {
//           final futures =
//               attendanceSnapshot.docs.map((doc) async {
//                 final data = doc.data();
//                 final userId = data['user_id'] as String;

//                 final userDoc =
//                     await _firestore.collection('users').doc(userId).get();
//                 final userData = userDoc.data();

//                 return {
//                   "attendanceId": doc.id,
//                   "datetime": data['datetime'],
//                   "latitude": data['latitude'],
//                   "description": data['description'],
//                   "longitude": data['longitude'],
//                   "address": data['address'],
//                   "user": userData,
//                 };
//               }).toList();

//           return await Future.wait(futures);
//         });
//   }

//   Stream<List<Map<String, dynamic>>> getAllUsers() {
//     return _firestore
//         .collection('users')
//         .where('role', whereIn: [textEmployee, textAdmin])
//         .snapshots()
//         .map((snapshot) {
//           return snapshot.docs.map((doc) {
//             final data = doc.data();

//             return {
//               "doc_id": doc.id,
//               "name": data['name'],
//               "email": data['email'],
//             };
//           }).toList();
//         });
//   }

//   Stream<List<Map<String, dynamic>>> getAttendancesByUserId(String userId) {
//     return _firestore
//         .collection('attendances')
//         .where('user_id', isEqualTo: userId)
//         .orderBy('datetime', descending: true)
//         .snapshots()
//         .map((snapshot) {
//           return snapshot.docs.map((doc) {
//             final data = doc.data();

//             return {
//               "attendanceId": doc.id,
//               "datetime": data['datetime'],
//               "latitude": data['latitude'],
//               "longitude": data['longitude'],
//               "address": data['address'],
//               "description": data['description'],
//               "user_id": data['user_id'],
//             };
//           }).toList();
//         });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance/core/constant/text.dart';
import 'package:flutter/material.dart';

class AbsentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _message = "";
  String get message => _message;

  void setMessage(String value) {
    _message = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ====================================================
  // 🟦 CACHES
  // ====================================================
  List<Map<String, dynamic>> _cachedUsers = [];
  List<Map<String, dynamic>> get cachedUsers => _cachedUsers;

  List<Map<String, dynamic>> _cachedAttendances = [];
  List<Map<String, dynamic>> get cachedAttendances => _cachedAttendances;

  final Map<String, List<Map<String, dynamic>>> _cachedAttendancesByUser = {};
  Map<String, List<Map<String, dynamic>>> get cachedAttendancesByUser =>
      _cachedAttendancesByUser;

  Future<void> addAbsent(
    BuildContext context, {
    required String userID,
    required DateTime dateTime,
    required String latitude,
    required String longitude,
    required String description,
    required String address,
  }) async {
    setLoading(true);

    try {
      await _firestore.collection('attendances').add({
        "user_id": userID,
        "datetime": dateTime,
        "latitude": latitude,
        "longitude": longitude,
        "description": description,
        "address": address,
      });

      setLoading(false);
      _message = "Berhasil checkin";
    } catch (e) {
      setLoading(false);
      _message = "Server Error!";
      print("Error: $e");
    }
  }

  Future<void> changeActiveEmployee(
    BuildContext context, {
    required String userID,
    required bool isActive,
  }) async {
    setLoading(true);

    try {
      await _firestore.collection('users').doc(userID).update({
        "is_active": isActive,
      });

      setLoading(false);
      _message = "Sukses";
    } catch (e) {
      setLoading(false);
      _message = "Server Error!";
      print("Error: $e");
    }
  }

  Future<void> changeRole(
    BuildContext context, {
    required String userID,
    required String role,
  }) async {
    setLoading(true);

    try {
      await _firestore.collection('users').doc(userID).update({"role": role});
      setLoading(false);
      setMessage("Sukses mengubah role");
    } catch (e) {
      setLoading(false);
      setMessage("Server error");
      print("Error: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getAllUsers({required bool isAll}) {
    List getUser = [];
    if (isAll) {
      getUser = [textEmployee, textAdmin];
    } else {
      getUser = [textEmployee];
    }
    return _firestore
        .collection('users')
        .where('role', whereIn: getUser)
        .snapshots()
        .asyncMap((snapshot) async {
          final List<Map<String, dynamic>> result = [];

          for (final doc in snapshot.docs) {
            Map<String, dynamic>? data;

            // 1. Ambil dari cache dulu
            try {
              final cacheSnap = await _firestore
                  .collection('users')
                  .doc(doc.id)
                  .get(const GetOptions(source: Source.cache));

              data = cacheSnap.data();
            } catch (_) {}

            // 2. Jika cache kosong → ambil server
            if (data == null) {
              try {
                final serverSnap = await _firestore
                    .collection('users')
                    .doc(doc.id)
                    .get(const GetOptions(source: Source.server));

                data = serverSnap.data();
              } catch (_) {
                data = null;
              }
            }

            // ❌ Jika user null → SKIP
            if (data == null) continue;

            // ❌ Kalau field penting hilang → SKIP
            if (data['name'] == null || data['email'] == null) continue;

            // ✅ Tambahkan user valid
            result.add({
              "doc_id": doc.id,
              "name": data['name'],
              "email": data['email'],
              "is_active": data['is_active'],
              "role": data['role'],
            });
          }

          _cachedUsers = result;
          return result;
        });
  }

  Stream<List<Map<String, dynamic>>> getAllAttendances() {
    return _firestore
        .collection('attendances')
        .orderBy('datetime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final List<Map<String, dynamic>> result = [];

          for (final doc in snapshot.docs) {
            final data = doc.data();
            final userId = data['user_id'];

            Map<String, dynamic>? userData;

            try {
              final cacheSnap = await _firestore
                  .collection('users')
                  .doc(userId)
                  .get(const GetOptions(source: Source.cache));

              userData = cacheSnap.data();
            } catch (_) {}

            if (userData == null) {
              try {
                final serverSnap = await _firestore
                    .collection('users')
                    .doc(userId)
                    .get(const GetOptions(source: Source.server));

                userData = serverSnap.data();
              } catch (_) {
                userData = null;
              }
            }

            if (userData == null) continue;

            result.add({
              "attendanceId": doc.id,
              "datetime": data['datetime'],
              "latitude": data['latitude'],
              "longitude": data['longitude'],
              "address": data['address'],
              "description": data['description'],
              "user_id": userId,
              "user": userData,
            });
          }

          return result;
        });
  }

  Stream<List<Map<String, dynamic>>> getAttendancesByUserId(String userId) {
    return _firestore
        .collection('attendances')
        .where('user_id', isEqualTo: userId)
        .orderBy('datetime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final List<Map<String, dynamic>> result = [];

          for (final doc in snapshot.docs) {
            final data = doc.data();
            final userId = data['user_id'];

            Map<String, dynamic>? userData;

            try {
              final cacheSnap = await _firestore
                  .collection('users')
                  .doc(userId)
                  .get(const GetOptions(source: Source.cache));

              userData = cacheSnap.data();
            } catch (_) {}

            if (userData == null) {
              try {
                final serverSnap = await _firestore
                    .collection('users')
                    .doc(userId)
                    .get(const GetOptions(source: Source.server));

                userData = serverSnap.data();
              } catch (_) {
                userData = null;
              }
            }

            if (userData == null) continue;

            result.add({
              "attendanceId": doc.id,
              "datetime": data['datetime'],
              "latitude": data['latitude'],
              "longitude": data['longitude'],
              "address": data['address'],
              "description": data['description'],
              "user_id": userId,
              "user": userData,
            });
          }

          return result;
        });
  }
}
