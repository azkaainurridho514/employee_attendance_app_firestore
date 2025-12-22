class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? password;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'karyawan',
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      if (password != null) 'password': password,
    };
  }
}
