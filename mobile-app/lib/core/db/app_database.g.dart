// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PropertiesTableTable extends PropertiesTable
    with TableInfo<$PropertiesTableTable, PropertiesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PropertiesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _surfaceMeta = const VerificationMeta(
    'surface',
  );
  @override
  late final GeneratedColumn<int> surface = GeneratedColumn<int>(
    'surface',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propertyTypeMeta = const VerificationMeta(
    'propertyType',
  );
  @override
  late final GeneratedColumn<String> propertyType = GeneratedColumn<String>(
    'property_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _agentNameMeta = const VerificationMeta(
    'agentName',
  );
  @override
  late final GeneratedColumn<String> agentName = GeneratedColumn<String>(
    'agent_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _agentAgencyMeta = const VerificationMeta(
    'agentAgency',
  );
  @override
  late final GeneratedColumn<String> agentAgency = GeneratedColumn<String>(
    'agent_agency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _agentPhoneMeta = const VerificationMeta(
    'agentPhone',
  );
  @override
  late final GeneratedColumn<String> agentPhone = GeneratedColumn<String>(
    'agent_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactIdMeta = const VerificationMeta(
    'contactId',
  );
  @override
  late final GeneratedColumn<String> contactId = GeneratedColumn<String>(
    'contact_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _saleUrgencyMeta = const VerificationMeta(
    'saleUrgency',
  );
  @override
  late final GeneratedColumn<String> saleUrgency = GeneratedColumn<String>(
    'sale_urgency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    address,
    surface,
    price,
    propertyType,
    agentName,
    agentAgency,
    agentPhone,
    contactId,
    saleUrgency,
    notes,
    syncStatus,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'properties_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PropertiesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('surface')) {
      context.handle(
        _surfaceMeta,
        surface.isAcceptableOrUnknown(data['surface']!, _surfaceMeta),
      );
    } else if (isInserting) {
      context.missing(_surfaceMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('property_type')) {
      context.handle(
        _propertyTypeMeta,
        propertyType.isAcceptableOrUnknown(
          data['property_type']!,
          _propertyTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_propertyTypeMeta);
    }
    if (data.containsKey('agent_name')) {
      context.handle(
        _agentNameMeta,
        agentName.isAcceptableOrUnknown(data['agent_name']!, _agentNameMeta),
      );
    }
    if (data.containsKey('agent_agency')) {
      context.handle(
        _agentAgencyMeta,
        agentAgency.isAcceptableOrUnknown(
          data['agent_agency']!,
          _agentAgencyMeta,
        ),
      );
    }
    if (data.containsKey('agent_phone')) {
      context.handle(
        _agentPhoneMeta,
        agentPhone.isAcceptableOrUnknown(data['agent_phone']!, _agentPhoneMeta),
      );
    }
    if (data.containsKey('contact_id')) {
      context.handle(
        _contactIdMeta,
        contactId.isAcceptableOrUnknown(data['contact_id']!, _contactIdMeta),
      );
    }
    if (data.containsKey('sale_urgency')) {
      context.handle(
        _saleUrgencyMeta,
        saleUrgency.isAcceptableOrUnknown(
          data['sale_urgency']!,
          _saleUrgencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saleUrgencyMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PropertiesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PropertiesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      surface: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surface'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      )!,
      propertyType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}property_type'],
      )!,
      agentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}agent_name'],
      ),
      agentAgency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}agent_agency'],
      ),
      agentPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}agent_phone'],
      ),
      contactId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_id'],
      ),
      saleUrgency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_urgency'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $PropertiesTableTable createAlias(String alias) {
    return $PropertiesTableTable(attachedDatabase, alias);
  }
}

class PropertiesTableData extends DataClass
    implements Insertable<PropertiesTableData> {
  final String id;
  final String userId;
  final String address;
  final int surface;
  final int price;
  final String propertyType;
  final String? agentName;
  final String? agentAgency;
  final String? agentPhone;
  final String? contactId;
  final String saleUrgency;
  final String? notes;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const PropertiesTableData({
    required this.id,
    required this.userId,
    required this.address,
    required this.surface,
    required this.price,
    required this.propertyType,
    this.agentName,
    this.agentAgency,
    this.agentPhone,
    this.contactId,
    required this.saleUrgency,
    this.notes,
    required this.syncStatus,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['address'] = Variable<String>(address);
    map['surface'] = Variable<int>(surface);
    map['price'] = Variable<int>(price);
    map['property_type'] = Variable<String>(propertyType);
    if (!nullToAbsent || agentName != null) {
      map['agent_name'] = Variable<String>(agentName);
    }
    if (!nullToAbsent || agentAgency != null) {
      map['agent_agency'] = Variable<String>(agentAgency);
    }
    if (!nullToAbsent || agentPhone != null) {
      map['agent_phone'] = Variable<String>(agentPhone);
    }
    if (!nullToAbsent || contactId != null) {
      map['contact_id'] = Variable<String>(contactId);
    }
    map['sale_urgency'] = Variable<String>(saleUrgency);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PropertiesTableCompanion toCompanion(bool nullToAbsent) {
    return PropertiesTableCompanion(
      id: Value(id),
      userId: Value(userId),
      address: Value(address),
      surface: Value(surface),
      price: Value(price),
      propertyType: Value(propertyType),
      agentName: agentName == null && nullToAbsent
          ? const Value.absent()
          : Value(agentName),
      agentAgency: agentAgency == null && nullToAbsent
          ? const Value.absent()
          : Value(agentAgency),
      agentPhone: agentPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(agentPhone),
      contactId: contactId == null && nullToAbsent
          ? const Value.absent()
          : Value(contactId),
      saleUrgency: Value(saleUrgency),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory PropertiesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PropertiesTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      address: serializer.fromJson<String>(json['address']),
      surface: serializer.fromJson<int>(json['surface']),
      price: serializer.fromJson<int>(json['price']),
      propertyType: serializer.fromJson<String>(json['propertyType']),
      agentName: serializer.fromJson<String?>(json['agentName']),
      agentAgency: serializer.fromJson<String?>(json['agentAgency']),
      agentPhone: serializer.fromJson<String?>(json['agentPhone']),
      contactId: serializer.fromJson<String?>(json['contactId']),
      saleUrgency: serializer.fromJson<String>(json['saleUrgency']),
      notes: serializer.fromJson<String?>(json['notes']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'address': serializer.toJson<String>(address),
      'surface': serializer.toJson<int>(surface),
      'price': serializer.toJson<int>(price),
      'propertyType': serializer.toJson<String>(propertyType),
      'agentName': serializer.toJson<String?>(agentName),
      'agentAgency': serializer.toJson<String?>(agentAgency),
      'agentPhone': serializer.toJson<String?>(agentPhone),
      'contactId': serializer.toJson<String?>(contactId),
      'saleUrgency': serializer.toJson<String>(saleUrgency),
      'notes': serializer.toJson<String?>(notes),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  PropertiesTableData copyWith({
    String? id,
    String? userId,
    String? address,
    int? surface,
    int? price,
    String? propertyType,
    Value<String?> agentName = const Value.absent(),
    Value<String?> agentAgency = const Value.absent(),
    Value<String?> agentPhone = const Value.absent(),
    Value<String?> contactId = const Value.absent(),
    String? saleUrgency,
    Value<String?> notes = const Value.absent(),
    String? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => PropertiesTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    address: address ?? this.address,
    surface: surface ?? this.surface,
    price: price ?? this.price,
    propertyType: propertyType ?? this.propertyType,
    agentName: agentName.present ? agentName.value : this.agentName,
    agentAgency: agentAgency.present ? agentAgency.value : this.agentAgency,
    agentPhone: agentPhone.present ? agentPhone.value : this.agentPhone,
    contactId: contactId.present ? contactId.value : this.contactId,
    saleUrgency: saleUrgency ?? this.saleUrgency,
    notes: notes.present ? notes.value : this.notes,
    syncStatus: syncStatus ?? this.syncStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  PropertiesTableData copyWithCompanion(PropertiesTableCompanion data) {
    return PropertiesTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      address: data.address.present ? data.address.value : this.address,
      surface: data.surface.present ? data.surface.value : this.surface,
      price: data.price.present ? data.price.value : this.price,
      propertyType: data.propertyType.present
          ? data.propertyType.value
          : this.propertyType,
      agentName: data.agentName.present ? data.agentName.value : this.agentName,
      agentAgency: data.agentAgency.present
          ? data.agentAgency.value
          : this.agentAgency,
      agentPhone: data.agentPhone.present
          ? data.agentPhone.value
          : this.agentPhone,
      contactId: data.contactId.present ? data.contactId.value : this.contactId,
      saleUrgency: data.saleUrgency.present
          ? data.saleUrgency.value
          : this.saleUrgency,
      notes: data.notes.present ? data.notes.value : this.notes,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PropertiesTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('address: $address, ')
          ..write('surface: $surface, ')
          ..write('price: $price, ')
          ..write('propertyType: $propertyType, ')
          ..write('agentName: $agentName, ')
          ..write('agentAgency: $agentAgency, ')
          ..write('agentPhone: $agentPhone, ')
          ..write('contactId: $contactId, ')
          ..write('saleUrgency: $saleUrgency, ')
          ..write('notes: $notes, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    address,
    surface,
    price,
    propertyType,
    agentName,
    agentAgency,
    agentPhone,
    contactId,
    saleUrgency,
    notes,
    syncStatus,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PropertiesTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.address == this.address &&
          other.surface == this.surface &&
          other.price == this.price &&
          other.propertyType == this.propertyType &&
          other.agentName == this.agentName &&
          other.agentAgency == this.agentAgency &&
          other.agentPhone == this.agentPhone &&
          other.contactId == this.contactId &&
          other.saleUrgency == this.saleUrgency &&
          other.notes == this.notes &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class PropertiesTableCompanion extends UpdateCompanion<PropertiesTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> address;
  final Value<int> surface;
  final Value<int> price;
  final Value<String> propertyType;
  final Value<String?> agentName;
  final Value<String?> agentAgency;
  final Value<String?> agentPhone;
  final Value<String?> contactId;
  final Value<String> saleUrgency;
  final Value<String?> notes;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PropertiesTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.address = const Value.absent(),
    this.surface = const Value.absent(),
    this.price = const Value.absent(),
    this.propertyType = const Value.absent(),
    this.agentName = const Value.absent(),
    this.agentAgency = const Value.absent(),
    this.agentPhone = const Value.absent(),
    this.contactId = const Value.absent(),
    this.saleUrgency = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PropertiesTableCompanion.insert({
    required String id,
    required String userId,
    required String address,
    required int surface,
    required int price,
    required String propertyType,
    this.agentName = const Value.absent(),
    this.agentAgency = const Value.absent(),
    this.agentPhone = const Value.absent(),
    this.contactId = const Value.absent(),
    required String saleUrgency,
    this.notes = const Value.absent(),
    required String syncStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       address = Value(address),
       surface = Value(surface),
       price = Value(price),
       propertyType = Value(propertyType),
       saleUrgency = Value(saleUrgency),
       syncStatus = Value(syncStatus),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PropertiesTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? address,
    Expression<int>? surface,
    Expression<int>? price,
    Expression<String>? propertyType,
    Expression<String>? agentName,
    Expression<String>? agentAgency,
    Expression<String>? agentPhone,
    Expression<String>? contactId,
    Expression<String>? saleUrgency,
    Expression<String>? notes,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (address != null) 'address': address,
      if (surface != null) 'surface': surface,
      if (price != null) 'price': price,
      if (propertyType != null) 'property_type': propertyType,
      if (agentName != null) 'agent_name': agentName,
      if (agentAgency != null) 'agent_agency': agentAgency,
      if (agentPhone != null) 'agent_phone': agentPhone,
      if (contactId != null) 'contact_id': contactId,
      if (saleUrgency != null) 'sale_urgency': saleUrgency,
      if (notes != null) 'notes': notes,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PropertiesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? address,
    Value<int>? surface,
    Value<int>? price,
    Value<String>? propertyType,
    Value<String?>? agentName,
    Value<String?>? agentAgency,
    Value<String?>? agentPhone,
    Value<String?>? contactId,
    Value<String>? saleUrgency,
    Value<String?>? notes,
    Value<String>? syncStatus,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return PropertiesTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      surface: surface ?? this.surface,
      price: price ?? this.price,
      propertyType: propertyType ?? this.propertyType,
      agentName: agentName ?? this.agentName,
      agentAgency: agentAgency ?? this.agentAgency,
      agentPhone: agentPhone ?? this.agentPhone,
      contactId: contactId ?? this.contactId,
      saleUrgency: saleUrgency ?? this.saleUrgency,
      notes: notes ?? this.notes,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (surface.present) {
      map['surface'] = Variable<int>(surface.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (propertyType.present) {
      map['property_type'] = Variable<String>(propertyType.value);
    }
    if (agentName.present) {
      map['agent_name'] = Variable<String>(agentName.value);
    }
    if (agentAgency.present) {
      map['agent_agency'] = Variable<String>(agentAgency.value);
    }
    if (agentPhone.present) {
      map['agent_phone'] = Variable<String>(agentPhone.value);
    }
    if (contactId.present) {
      map['contact_id'] = Variable<String>(contactId.value);
    }
    if (saleUrgency.present) {
      map['sale_urgency'] = Variable<String>(saleUrgency.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PropertiesTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('address: $address, ')
          ..write('surface: $surface, ')
          ..write('price: $price, ')
          ..write('propertyType: $propertyType, ')
          ..write('agentName: $agentName, ')
          ..write('agentAgency: $agentAgency, ')
          ..write('agentPhone: $agentPhone, ')
          ..write('contactId: $contactId, ')
          ..write('saleUrgency: $saleUrgency, ')
          ..write('notes: $notes, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContactsTableTable extends ContactsTable
    with TableInfo<$ContactsTableTable, ContactsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactTypeMeta = const VerificationMeta(
    'contactType',
  );
  @override
  late final GeneratedColumn<String> contactType = GeneratedColumn<String>(
    'contact_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
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
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContactsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('contact_type')) {
      context.handle(
        _contactTypeMeta,
        contactType.isAcceptableOrUnknown(
          data['contact_type']!,
          _contactTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contactTypeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContactsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContactsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      contactType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_type'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ContactsTableTable createAlias(String alias) {
    return $ContactsTableTable(attachedDatabase, alias);
  }
}

class ContactsTableData extends DataClass
    implements Insertable<ContactsTableData> {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String? company;
  final String? phone;
  final String? email;
  final String contactType;
  final String? notes;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const ContactsTableData({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.company,
    this.phone,
    this.email,
    required this.contactType,
    this.notes,
    required this.syncStatus,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || company != null) {
      map['company'] = Variable<String>(company);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['contact_type'] = Variable<String>(contactType);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ContactsTableCompanion toCompanion(bool nullToAbsent) {
    return ContactsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      firstName: Value(firstName),
      lastName: Value(lastName),
      company: company == null && nullToAbsent
          ? const Value.absent()
          : Value(company),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      contactType: Value(contactType),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ContactsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContactsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      company: serializer.fromJson<String?>(json['company']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      contactType: serializer.fromJson<String>(json['contactType']),
      notes: serializer.fromJson<String?>(json['notes']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'company': serializer.toJson<String?>(company),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'contactType': serializer.toJson<String>(contactType),
      'notes': serializer.toJson<String?>(notes),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ContactsTableData copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? lastName,
    Value<String?> company = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    String? contactType,
    Value<String?> notes = const Value.absent(),
    String? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ContactsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    company: company.present ? company.value : this.company,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    contactType: contactType ?? this.contactType,
    notes: notes.present ? notes.value : this.notes,
    syncStatus: syncStatus ?? this.syncStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ContactsTableData copyWithCompanion(ContactsTableCompanion data) {
    return ContactsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      company: data.company.present ? data.company.value : this.company,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      contactType: data.contactType.present
          ? data.contactType.value
          : this.contactType,
      notes: data.notes.present ? data.notes.value : this.notes,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContactsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('company: $company, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('contactType: $contactType, ')
          ..write('notes: $notes, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
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
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContactsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.company == this.company &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.contactType == this.contactType &&
          other.notes == this.notes &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ContactsTableCompanion extends UpdateCompanion<ContactsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> company;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String> contactType;
  final Value<String?> notes;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ContactsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.company = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.contactType = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContactsTableCompanion.insert({
    required String id,
    required String userId,
    required String firstName,
    required String lastName,
    this.company = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    required String contactType,
    this.notes = const Value.absent(),
    required String syncStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       firstName = Value(firstName),
       lastName = Value(lastName),
       contactType = Value(contactType),
       syncStatus = Value(syncStatus),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ContactsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? company,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? contactType,
    Expression<String>? notes,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (company != null) 'company': company,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (contactType != null) 'contact_type': contactType,
      if (notes != null) 'notes': notes,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContactsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String?>? company,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String>? contactType,
    Value<String?>? notes,
    Value<String>? syncStatus,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ContactsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      company: company ?? this.company,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      contactType: contactType ?? this.contactType,
      notes: notes ?? this.notes,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (contactType.present) {
      map['contact_type'] = Variable<String>(contactType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('company: $company, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('contactType: $contactType, ')
          ..write('notes: $notes, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PropertiesTableTable propertiesTable = $PropertiesTableTable(
    this,
  );
  late final $ContactsTableTable contactsTable = $ContactsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    propertiesTable,
    contactsTable,
  ];
}

typedef $$PropertiesTableTableCreateCompanionBuilder =
    PropertiesTableCompanion Function({
      required String id,
      required String userId,
      required String address,
      required int surface,
      required int price,
      required String propertyType,
      Value<String?> agentName,
      Value<String?> agentAgency,
      Value<String?> agentPhone,
      Value<String?> contactId,
      required String saleUrgency,
      Value<String?> notes,
      required String syncStatus,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$PropertiesTableTableUpdateCompanionBuilder =
    PropertiesTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> address,
      Value<int> surface,
      Value<int> price,
      Value<String> propertyType,
      Value<String?> agentName,
      Value<String?> agentAgency,
      Value<String?> agentPhone,
      Value<String?> contactId,
      Value<String> saleUrgency,
      Value<String?> notes,
      Value<String> syncStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$PropertiesTableTableFilterComposer
    extends Composer<_$AppDatabase, $PropertiesTableTable> {
  $$PropertiesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surface => $composableBuilder(
    column: $table.surface,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get propertyType => $composableBuilder(
    column: $table.propertyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get agentName => $composableBuilder(
    column: $table.agentName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get agentAgency => $composableBuilder(
    column: $table.agentAgency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get agentPhone => $composableBuilder(
    column: $table.agentPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactId => $composableBuilder(
    column: $table.contactId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saleUrgency => $composableBuilder(
    column: $table.saleUrgency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PropertiesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PropertiesTableTable> {
  $$PropertiesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surface => $composableBuilder(
    column: $table.surface,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get propertyType => $composableBuilder(
    column: $table.propertyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get agentName => $composableBuilder(
    column: $table.agentName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get agentAgency => $composableBuilder(
    column: $table.agentAgency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get agentPhone => $composableBuilder(
    column: $table.agentPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactId => $composableBuilder(
    column: $table.contactId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleUrgency => $composableBuilder(
    column: $table.saleUrgency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PropertiesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PropertiesTableTable> {
  $$PropertiesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<int> get surface =>
      $composableBuilder(column: $table.surface, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get propertyType => $composableBuilder(
    column: $table.propertyType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get agentName =>
      $composableBuilder(column: $table.agentName, builder: (column) => column);

  GeneratedColumn<String> get agentAgency => $composableBuilder(
    column: $table.agentAgency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get agentPhone => $composableBuilder(
    column: $table.agentPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactId =>
      $composableBuilder(column: $table.contactId, builder: (column) => column);

  GeneratedColumn<String> get saleUrgency => $composableBuilder(
    column: $table.saleUrgency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$PropertiesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PropertiesTableTable,
          PropertiesTableData,
          $$PropertiesTableTableFilterComposer,
          $$PropertiesTableTableOrderingComposer,
          $$PropertiesTableTableAnnotationComposer,
          $$PropertiesTableTableCreateCompanionBuilder,
          $$PropertiesTableTableUpdateCompanionBuilder,
          (
            PropertiesTableData,
            BaseReferences<
              _$AppDatabase,
              $PropertiesTableTable,
              PropertiesTableData
            >,
          ),
          PropertiesTableData,
          PrefetchHooks Function()
        > {
  $$PropertiesTableTableTableManager(
    _$AppDatabase db,
    $PropertiesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PropertiesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PropertiesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PropertiesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<int> surface = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<String> propertyType = const Value.absent(),
                Value<String?> agentName = const Value.absent(),
                Value<String?> agentAgency = const Value.absent(),
                Value<String?> agentPhone = const Value.absent(),
                Value<String?> contactId = const Value.absent(),
                Value<String> saleUrgency = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PropertiesTableCompanion(
                id: id,
                userId: userId,
                address: address,
                surface: surface,
                price: price,
                propertyType: propertyType,
                agentName: agentName,
                agentAgency: agentAgency,
                agentPhone: agentPhone,
                contactId: contactId,
                saleUrgency: saleUrgency,
                notes: notes,
                syncStatus: syncStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String address,
                required int surface,
                required int price,
                required String propertyType,
                Value<String?> agentName = const Value.absent(),
                Value<String?> agentAgency = const Value.absent(),
                Value<String?> agentPhone = const Value.absent(),
                Value<String?> contactId = const Value.absent(),
                required String saleUrgency,
                Value<String?> notes = const Value.absent(),
                required String syncStatus,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PropertiesTableCompanion.insert(
                id: id,
                userId: userId,
                address: address,
                surface: surface,
                price: price,
                propertyType: propertyType,
                agentName: agentName,
                agentAgency: agentAgency,
                agentPhone: agentPhone,
                contactId: contactId,
                saleUrgency: saleUrgency,
                notes: notes,
                syncStatus: syncStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PropertiesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PropertiesTableTable,
      PropertiesTableData,
      $$PropertiesTableTableFilterComposer,
      $$PropertiesTableTableOrderingComposer,
      $$PropertiesTableTableAnnotationComposer,
      $$PropertiesTableTableCreateCompanionBuilder,
      $$PropertiesTableTableUpdateCompanionBuilder,
      (
        PropertiesTableData,
        BaseReferences<
          _$AppDatabase,
          $PropertiesTableTable,
          PropertiesTableData
        >,
      ),
      PropertiesTableData,
      PrefetchHooks Function()
    >;
typedef $$ContactsTableTableCreateCompanionBuilder =
    ContactsTableCompanion Function({
      required String id,
      required String userId,
      required String firstName,
      required String lastName,
      Value<String?> company,
      Value<String?> phone,
      Value<String?> email,
      required String contactType,
      Value<String?> notes,
      required String syncStatus,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ContactsTableTableUpdateCompanionBuilder =
    ContactsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> firstName,
      Value<String> lastName,
      Value<String?> company,
      Value<String?> phone,
      Value<String?> email,
      Value<String> contactType,
      Value<String?> notes,
      Value<String> syncStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$ContactsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ContactsTableTable> {
  $$ContactsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactType => $composableBuilder(
    column: $table.contactType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContactsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ContactsTableTable> {
  $$ContactsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactType => $composableBuilder(
    column: $table.contactType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContactsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContactsTableTable> {
  $$ContactsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get contactType => $composableBuilder(
    column: $table.contactType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$ContactsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContactsTableTable,
          ContactsTableData,
          $$ContactsTableTableFilterComposer,
          $$ContactsTableTableOrderingComposer,
          $$ContactsTableTableAnnotationComposer,
          $$ContactsTableTableCreateCompanionBuilder,
          $$ContactsTableTableUpdateCompanionBuilder,
          (
            ContactsTableData,
            BaseReferences<
              _$AppDatabase,
              $ContactsTableTable,
              ContactsTableData
            >,
          ),
          ContactsTableData,
          PrefetchHooks Function()
        > {
  $$ContactsTableTableTableManager(_$AppDatabase db, $ContactsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String> contactType = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContactsTableCompanion(
                id: id,
                userId: userId,
                firstName: firstName,
                lastName: lastName,
                company: company,
                phone: phone,
                email: email,
                contactType: contactType,
                notes: notes,
                syncStatus: syncStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String firstName,
                required String lastName,
                Value<String?> company = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                required String contactType,
                Value<String?> notes = const Value.absent(),
                required String syncStatus,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContactsTableCompanion.insert(
                id: id,
                userId: userId,
                firstName: firstName,
                lastName: lastName,
                company: company,
                phone: phone,
                email: email,
                contactType: contactType,
                notes: notes,
                syncStatus: syncStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContactsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContactsTableTable,
      ContactsTableData,
      $$ContactsTableTableFilterComposer,
      $$ContactsTableTableOrderingComposer,
      $$ContactsTableTableAnnotationComposer,
      $$ContactsTableTableCreateCompanionBuilder,
      $$ContactsTableTableUpdateCompanionBuilder,
      (
        ContactsTableData,
        BaseReferences<_$AppDatabase, $ContactsTableTable, ContactsTableData>,
      ),
      ContactsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PropertiesTableTableTableManager get propertiesTable =>
      $$PropertiesTableTableTableManager(_db, _db.propertiesTable);
  $$ContactsTableTableTableManager get contactsTable =>
      $$ContactsTableTableTableManager(_db, _db.contactsTable);
}
