import 'package:drift/drift.dart';
import 'package:mdb_copilot/core/db/app_database.dart';
import 'package:mdb_copilot/features/contacts/data/models/contact_model.dart';

class ContactLocalSource {
  const ContactLocalSource({required AppDatabase database})
      : _database = database;

  final AppDatabase _database;

  Future<List<ContactModel>> getAll() async {
    final rows = await (_database.select(_database.contactsTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.asc(t.lastName),
            (t) => OrderingTerm.asc(t.firstName),
          ]))
        .get();
    return rows.map(ContactModel.fromDrift).toList();
  }

  Future<List<ContactModel>> getByType(String contactType) async {
    final rows = await (_database.select(_database.contactsTable)
          ..where(
            (t) =>
                t.deletedAt.isNull() & t.contactType.equals(contactType),
          )
          ..orderBy([
            (t) => OrderingTerm.asc(t.lastName),
            (t) => OrderingTerm.asc(t.firstName),
          ]))
        .get();
    return rows.map(ContactModel.fromDrift).toList();
  }

  Future<ContactModel?> getById(String id) async {
    final row = await (_database.select(_database.contactsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? ContactModel.fromDrift(row) : null;
  }

  Future<void> insert(ContactModel contact) async {
    await _database
        .into(_database.contactsTable)
        .insert(contact.toCompanion());
  }

  Future<void> update(ContactModel contact) async {
    await (_database.update(_database.contactsTable)
          ..where((t) => t.id.equals(contact.id)))
        .write(contact.toCompanion());
  }

  Future<void> delete(String id) async {
    await (_database.update(_database.contactsTable)
          ..where((t) => t.id.equals(id)))
        .write(
      ContactsTableCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value('pending'),
      ),
    );
  }

  Stream<List<ContactModel>> watchAll() {
    return (_database.select(_database.contactsTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.asc(t.lastName),
            (t) => OrderingTerm.asc(t.firstName),
          ]))
        .watch()
        .map((rows) => rows.map(ContactModel.fromDrift).toList());
  }
}
