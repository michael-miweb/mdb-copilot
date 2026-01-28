import 'package:equatable/equatable.dart';

class InvitationModel extends Equatable {
  const InvitationModel({
    required this.id,
    required this.ownerId,
    required this.email,
    required this.role,
    this.token,
    this.expiresAt,
    this.acceptedAt,
    this.createdAt,
    this.status,
  });

  factory InvitationModel.fromJson(Map<String, dynamic> json) {
    return InvitationModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as int,
      email: json['email'] as String,
      role: json['role'] as String,
      token: json['token'] as String?,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      acceptedAt: json['accepted_at'] != null
          ? DateTime.parse(json['accepted_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      status: json['status'] as String?,
    );
  }

  final String id;
  final int ownerId;
  final String email;
  final String role;
  final String? token;
  final DateTime? expiresAt;
  final DateTime? acceptedAt;
  final DateTime? createdAt;
  final String? status;

  @override
  List<Object?> get props => [
        id,
        ownerId,
        email,
        role,
        token,
        expiresAt,
        acceptedAt,
        createdAt,
        status,
      ];
}
