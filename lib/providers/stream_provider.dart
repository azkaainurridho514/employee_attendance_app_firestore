import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance/core/constant/text.dart';
import 'package:flutter/material.dart';

class AbsentProvider extends ChangeNotifier {
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Stream<List<Map<String, dynamic>>> getAttendances() {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('attendances')
        .orderBy('datetime', descending: true)
        .limit(5)
        .snapshots()
        .asyncMap((attendanceSnapshot) async {
          final futures =
              attendanceSnapshot.docs.map((doc) async {
                final data = doc.data();
                final userId = data['user_id'] as String;

                final userDoc =
                    await firestore.collection('users').doc(userId).get();
                final userData = userDoc.data();

                return {
                  "attendanceId": doc.id,
                  "datetime": data['datetime'],
                  "latitude": data['latitude'],
                  "description": data['description'],
                  "longitude": data['longitude'],
                  "address": data['address'],
                  "user": userData,
                };
              }).toList();

          return await Future.wait(futures);
        });
  }

  Stream<List<Map<String, dynamic>>> getAllAttendances() {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('attendances')
        .orderBy('datetime', descending: true)
        .snapshots()
        .asyncMap((attendanceSnapshot) async {
          final futures =
              attendanceSnapshot.docs.map((doc) async {
                final data = doc.data();
                final userId = data['user_id'] as String;

                final userDoc =
                    await firestore.collection('users').doc(userId).get();
                final userData = userDoc.data();

                return {
                  "attendanceId": doc.id,
                  "datetime": data['datetime'],
                  "latitude": data['latitude'],
                  "description": data['description'],
                  "longitude": data['longitude'],
                  "address": data['address'],
                  "user": userData,
                };
              }).toList();

          return await Future.wait(futures);
        });
  }

  Stream<List<Map<String, dynamic>>> getAllUsers() {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('users')
        .where('role', isEqualTo: textEmployee)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();

            return {"name": data['name'], "email": data['email']};
          }).toList();
        });
  }

  Stream<List<Map<String, dynamic>>> getAttendancesByUserId(String userId) {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('attendances')
        .where('user_id', isEqualTo: userId)
        .orderBy('datetime', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();

            return {
              "attendanceId": doc.id,
              "datetime": data['datetime'],
              "latitude": data['latitude'],
              "longitude": data['longitude'],
              "address": data['address'],
              "description": data['description'],
              "user_id": data['user_id'],
            };
          }).toList();
        });
  }
}
