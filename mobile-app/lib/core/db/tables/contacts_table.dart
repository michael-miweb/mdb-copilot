import 'package:drift/drift.dart';

class ContactsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get company => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get contactType => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get syncStatus => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
