import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:mdb_copilot/core/db/app_database.dart';

enum PropertyType {
  appartement,
  maison,
  terrain,
  immeuble,
  commercial;

  String toApiString() => name;

  static PropertyType fromApiString(String value) {
    return PropertyType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PropertyType.appartement,
    );
  }
}

enum SaleUrgency {
  notSpecified,
  low,
  medium,
  high;

  String toApiString() {
    return switch (this) {
      SaleUrgency.notSpecified => 'not_specified',
      SaleUrgency.low => 'low',
      SaleUrgency.medium => 'medium',
      SaleUrgency.high => 'high',
    };
  }

  static SaleUrgency fromApiString(String value) {
    return switch (value) {
      'not_specified' => SaleUrgency.notSpecified,
      'low' => SaleUrgency.low,
      'medium' => SaleUrgency.medium,
      'high' => SaleUrgency.high,
      _ => SaleUrgency.notSpecified,
    };
  }
}

class PropertyModel extends Equatable {
  const PropertyModel({
    required this.id,
    required this.userId,
    required this.address,
    required this.surface,
    required this.price,
    required this.propertyType,
    required this.createdAt,
    required this.updatedAt,
    this.agentName,
    this.agentAgency,
    this.agentPhone,
    this.saleUrgency = SaleUrgency.notSpecified,
    this.notes,
    this.syncStatus = 'pending',
    this.deletedAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      address: json['address'] as String,
      surface: json['surface'] as int,
      price: json['price'] as int,
      propertyType:
          PropertyType.fromApiString(json['property_type'] as String),
      agentName: json['agent_name'] as String?,
      agentAgency: json['agent_agency'] as String?,
      agentPhone: json['agent_phone'] as String?,
      saleUrgency: SaleUrgency.fromApiString(
        json['sale_urgency'] as String? ?? 'not_specified',
      ),
      notes: json['notes'] as String?,
      syncStatus: 'synced',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
    );
  }

  factory PropertyModel.fromDrift(PropertiesTableData data) {
    return PropertyModel(
      id: data.id,
      userId: data.userId,
      address: data.address,
      surface: data.surface,
      price: data.price,
      propertyType: PropertyType.fromApiString(data.propertyType),
      agentName: data.agentName,
      agentAgency: data.agentAgency,
      agentPhone: data.agentPhone,
      saleUrgency: SaleUrgency.fromApiString(data.saleUrgency),
      notes: data.notes,
      syncStatus: data.syncStatus,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      deletedAt: data.deletedAt,
    );
  }

  final String id;
  final String userId;
  final String address;
  final int surface;
  final int price;
  final PropertyType propertyType;
  final String? agentName;
  final String? agentAgency;
  final String? agentPhone;
  final SaleUrgency saleUrgency;
  final String? notes;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'address': address,
      'surface': surface,
      'price': price,
      'property_type': propertyType.toApiString(),
      'agent_name': agentName,
      'agent_agency': agentAgency,
      'agent_phone': agentPhone,
      'sale_urgency': saleUrgency.toApiString(),
      'notes': notes,
    };
  }

  PropertiesTableCompanion toCompanion() {
    return PropertiesTableCompanion.insert(
      id: id,
      userId: userId,
      address: address,
      surface: surface,
      price: price,
      propertyType: propertyType.toApiString(),
      agentName: Value(agentName),
      agentAgency: Value(agentAgency),
      agentPhone: Value(agentPhone),
      saleUrgency: saleUrgency.toApiString(),
      notes: Value(notes),
      syncStatus: syncStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: Value(deletedAt),
    );
  }

  PropertyModel copyWith({
    String? id,
    String? userId,
    String? address,
    int? surface,
    int? price,
    PropertyType? propertyType,
    String? Function()? agentName,
    String? Function()? agentAgency,
    String? Function()? agentPhone,
    SaleUrgency? saleUrgency,
    String? Function()? notes,
    String? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? Function()? deletedAt,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      surface: surface ?? this.surface,
      price: price ?? this.price,
      propertyType: propertyType ?? this.propertyType,
      agentName: agentName != null ? agentName() : this.agentName,
      agentAgency: agentAgency != null ? agentAgency() : this.agentAgency,
      agentPhone: agentPhone != null ? agentPhone() : this.agentPhone,
      saleUrgency: saleUrgency ?? this.saleUrgency,
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
        address,
        surface,
        price,
        propertyType,
        agentName,
        agentAgency,
        agentPhone,
        saleUrgency,
        notes,
        syncStatus,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
