import 'package:drift/drift.dart';
import 'package:mdb_copilot/core/db/app_database.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';

class PropertyLocalSource {
  const PropertyLocalSource({required AppDatabase database})
      : _database = database;

  final AppDatabase _database;

  Future<List<PropertyModel>> getAll() async {
    final rows = await (_database.select(_database.propertiesTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .get();
    return rows.map(PropertyModel.fromDrift).toList();
  }

  Future<PropertyModel?> getById(String id) async {
    final row = await (_database.select(_database.propertiesTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? PropertyModel.fromDrift(row) : null;
  }

  Future<void> insert(PropertyModel property) async {
    await _database
        .into(_database.propertiesTable)
        .insert(property.toCompanion());
  }

  Future<void> update(PropertyModel property) async {
    await (_database.update(_database.propertiesTable)
          ..where((t) => t.id.equals(property.id)))
        .write(property.toCompanion());
  }

  Future<void> delete(String id) async {
    await (_database.update(_database.propertiesTable)
          ..where((t) => t.id.equals(id)))
        .write(
      PropertiesTableCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value('pending'),
      ),
    );
  }

  Stream<List<PropertyModel>> watchAll() {
    return (_database.select(_database.propertiesTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch()
        .map((rows) => rows.map(PropertyModel.fromDrift).toList());
  }
}
