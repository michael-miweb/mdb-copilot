import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:mdb_copilot/core/db/app_database.dart';

enum ContactType {
  agentImmobilier,
  artisan,
  notaire,
  courtier,
  autre;

  String toApiString() {
    return switch (this) {
      ContactType.agentImmobilier => 'agent_immobilier',
      ContactType.artisan => 'artisan',
      ContactType.notaire => 'notaire',
      ContactType.courtier => 'courtier',
      ContactType.autre => 'autre',
    };
  }

  static ContactType fromApiString(String value) {
    return switch (value) {
      'agent_immobilier' => ContactType.agentImmobilier,
      'artisan' => ContactType.artisan,
      'notaire' => ContactType.notaire,
      'courtier' => ContactType.courtier,
      _ => ContactType.autre,
    };
  }
}

class ContactModel extends Equatable {
  const ContactModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.contactType,
    required this.createdAt,
    required this.updatedAt,
    this.company,
    this.phone,
    this.email,
    this.notes,
    this.syncStatus = 'pending',
    this.deletedAt,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String,
      userId: json['user_id'].toString(),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      company: json['company'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      contactType:
          ContactType.fromApiString(json['contact_type'] as String),
      notes: json['notes'] as String?,
      syncStatus: 'synced',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
    );
  }

  factory ContactModel.fromDrift(ContactsTableData data) {
    return ContactModel(
      id: data.id,
      userId: data.userId,
      firstName: data.firstName,
      lastName: data.lastName,
      company: data.company,
      phone: data.phone,
      email: data.email,
      contactType: ContactType.fromApiString(data.contactType),
      notes: data.notes,
      syncStatus: data.syncStatus,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      deletedAt: data.deletedAt,
    );
  }

  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String? company;
  final String? phone;
  final String? email;
  final ContactType contactType;
  final String? notes;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'company': company,
      'phone': phone,
      'email': email,
      'contact_type': contactType.toApiString(),
      'notes': notes,
    };
  }

  ContactsTableCompanion toCompanion() {
    return ContactsTableCompanion.insert(
      id: id,
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      company: Value(company),
      phone: Value(phone),
      email: Value(email),
      contactType: contactType.toApiString(),
      notes: Value(notes),
      syncStatus: syncStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: Value(deletedAt),
    );
  }

  ContactModel copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? lastName,
    String? Function()? company,
    String? Function()? phone,
    String? Function()? email,
    ContactType? contactType,
    String? Function()? notes,
    String? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? Function()? deletedAt,
  }) {
    return ContactModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      company: company != null ? company() : this.company,
      phone: phone != null ? phone() : this.phone,
      email: email != null ? email() : this.email,
      contactType: contactType ?? this.contactType,
      notes: notes != null ? notes() : this.notes,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt != null ? deletedAt() : this.deletedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        firstName,
        lastName,
        company,
        phone,
        email,
        contactType,
        notes,
        syncStatus,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
