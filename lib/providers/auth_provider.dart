import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constant/text.dart';
import '../core/constant/widget.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _message = "";
  String get message => _message;

  UserModel? _user;
  UserModel? get user => _user;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void setMessage(String value) {
    _message = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loginUser(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    setLoading(true);
    logout();
    try {
      final prefs = await SharedPreferences.getInstance();
      var querySnapshot;
      if (email.isEmpty || password.isEmpty) {
        setLoading(false);
        setMessage("Semua field harus di isi!");
        return;
      }
      querySnapshot =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .where('password', isEqualTo: password)
              .where('is_active', isEqualTo: true)
              .get();

      if (querySnapshot.docs.isEmpty) {
        setLoading(false);
        setMessage("Credential salah / akun belum aktif");
        return;
      }

      final doc = querySnapshot.docs.first;
      _user = UserModel.fromJson(doc.data(), doc.id);

      await prefs.setString('userId', _user!.id);
      await prefs.setString('userName', _user!.name);
      await prefs.setString('userEmail', _user!.email);
      await prefs.setString('userRole', _user!.role);
      await saveUserToLocal(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        role: _user!.role,
      );
      setLoading(false);
      setMessage("Berhasil login");
    } catch (e) {
      setLoading(false);
      setMessage("Server Error!");
      print("Error : $e");
    }
  }

  Future<void> registerUser(
    BuildContext context, {
    required String username,
    required String email,
    required String password,
  }) async {
    setLoading(true);

    try {
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        setLoading(false);
        setMessage("Semua field harus di isi!");
        return;
      }
      await _firestore.collection('users').add({
        "name": username,
        "email": email,
        "password": password,
        "role": textKaryawan,
        "is_active": true,
        "createdAt": FieldValue.serverTimestamp(),
      });

      setLoading(false);
      _message = "Berhasil register";
    } catch (e) {
      setLoading(false);
      _message = "Server Error!";
      print("Error: $e");
    }
  }

  Future<void> saveUserToLocal({
    required String id,
    required String name,
    required String email,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', id);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    await prefs.setString('userRole', role);
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  Future<void> loadUserFromLocal() async {
    setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId');
    if (id != null) {
      _user = UserModel(
        id: id,
        name: prefs.getString('userName') ?? '',
        email: prefs.getString('userEmail') ?? '',
        role: prefs.getString('userRole') ?? 'karyawan',
      );
      setLoading(false);
      setMessage("login");
      notifyListeners();
    } else {
      setLoading(false);
    }
  }
}
