import 'package:mdb_copilot/features/properties/data/models/property_model.dart';
import 'package:mdb_copilot/features/properties/data/property_exception.dart';
import 'package:mdb_copilot/features/properties/data/property_local_source.dart';
import 'package:mdb_copilot/features/properties/data/property_remote_source.dart';
import 'package:uuid/uuid.dart';

class PropertyRepository {
  const PropertyRepository({
    required PropertyLocalSource localSource,
    required PropertyRemoteSource remoteSource,
  })  : _localSource = localSource,
        _remoteSource = remoteSource;

  final PropertyLocalSource _localSource;
  final PropertyRemoteSource _remoteSource;

  static const _uuid = Uuid();

  Future<List<PropertyModel>> getProperties() async {
    try {
      final remoteProperties = await _remoteSource.fetchAll();
      // Sync remote data to local for offline access
      for (final property in remoteProperties) {
        final local = await _localSource.getById(property.id);
        if (local == null) {
          await _localSource.insert(property.copyWith(syncStatus: 'synced'));
        } else {
          await _localSource.update(property.copyWith(syncStatus: 'synced'));
        }
      }
      return remoteProperties;
    } on PropertyException {
      return _localSource.getAll();
    }
  }

  Future<PropertyModel> createProperty(PropertyModel property) async {
    final now = DateTime.now();
    final newProperty = property.copyWith(
      id: _uuid.v4(),
      syncStatus: 'pending',
      createdAt: now,
      updatedAt: now,
    );

    await _localSource.insert(newProperty);

    try {
      final synced = await _remoteSource.create(newProperty);
      await _localSource.update(synced.copyWith(syncStatus: 'synced'));
      return synced.copyWith(syncStatus: 'synced');
    } on PropertyException {
      return newProperty;
    }
  }

  Future<void> updateProperty(PropertyModel property) async {
    final updated = property.copyWith(
      updatedAt: DateTime.now(),
      syncStatus: 'pending',
    );
    await _localSource.update(updated);

    try {
      await _remoteSource.update(updated.id, updated);
      await _localSource.update(updated.copyWith(syncStatus: 'synced'));
    } on PropertyException {
      // Will sync later
    }
  }

  Future<void> deleteProperty(String id) async {
    await _localSource.delete(id);

    try {
      await _remoteSource.delete(id);
    } on PropertyException {
      // Will sync later
    }
  }

  Future<PropertyModel?> getPropertyById(String id) async {
    final local = await _localSource.getById(id);
    if (local != null) return local;

    try {
      final remote = await _remoteSource.fetchById(id);
      await _localSource.insert(remote.copyWith(syncStatus: 'synced'));
      return remote;
    } on PropertyException {
      return null;
    }
  }

  Stream<List<PropertyModel>> watchProperties() {
    return _localSource.watchAll();
  }
}
