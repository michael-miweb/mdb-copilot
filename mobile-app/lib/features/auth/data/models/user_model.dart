import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.role = 'owner',
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      role: json['role'] as String? ?? 'owner',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final DateTime? createdAt;

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, firstName, lastName, email, role, createdAt];
}
