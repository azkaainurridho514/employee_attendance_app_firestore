class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'karyawan' atau 'owner'
  final String? password; // hanya digunakan untuk register/login

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.password,
  });

  // Convert Firestore document to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'karyawan',
      password: json['password'], // simpan password di model kalau perlu
    );
  }

  // Convert UserModel to Map<String, dynamic> untuk Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      if (password != null) 'password': password,
    };
  }
}
