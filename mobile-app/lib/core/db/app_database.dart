import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:mdb_copilot/core/db/tables/contacts_table.dart';
import 'package:mdb_copilot/core/db/tables/properties_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [PropertiesTable, ContactsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(contactsTable);
            await m.addColumn(propertiesTable, propertiesTable.contactId);
          }
          if (from < 3) {
            await m.addColumn(contactsTable, contactsTable.firstName);
            await m.addColumn(contactsTable, contactsTable.lastName);
            await customStatement(
              "UPDATE contacts_table SET last_name = name, first_name = ''",
            );
            await customStatement(
              'ALTER TABLE contacts_table DROP COLUMN name',
            );
          }
        },
      );
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'mdb_copilot',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
