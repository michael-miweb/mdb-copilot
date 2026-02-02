import 'package:drift/drift.dart';

class PropertiesTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get address => text()();
  IntColumn get surface => integer()();
  IntColumn get price => integer()();
  TextColumn get propertyType => text()();
  TextColumn get agentName => text().nullable()();
  TextColumn get agentAgency => text().nullable()();
  TextColumn get agentPhone => text().nullable()();
  TextColumn get contactId => text().nullable()();
  TextColumn get saleUrgency => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get syncStatus => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
