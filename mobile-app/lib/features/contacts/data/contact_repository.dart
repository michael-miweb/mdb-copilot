import 'package:mdb_copilot/features/contacts/data/contact_exception.dart';
import 'package:mdb_copilot/features/contacts/data/contact_local_source.dart';
import 'package:mdb_copilot/features/contacts/data/contact_remote_source.dart';
import 'package:mdb_copilot/features/contacts/data/models/contact_model.dart';
import 'package:uuid/uuid.dart';

class ContactRepository {
  const ContactRepository({
    required ContactLocalSource localSource,
    required ContactRemoteSource remoteSource,
  })  : _localSource = localSource,
        _remoteSource = remoteSource;

  final ContactLocalSource _localSource;
  final ContactRemoteSource _remoteSource;

  static const _uuid = Uuid();

  Future<List<ContactModel>> getContacts() async {
    try {
      final remoteContacts = await _remoteSource.fetchAll();
      for (final contact in remoteContacts) {
        final local = await _localSource.getById(contact.id);
        if (local == null) {
          await _localSource
              .insert(contact.copyWith(syncStatus: 'synced'));
        } else {
          await _localSource
              .update(contact.copyWith(syncStatus: 'synced'));
        }
      }
      return remoteContacts;
    } on ContactException {
      return _localSource.getAll();
    }
  }

  Future<List<ContactModel>> getContactsByType(
    ContactType type,
  ) async {
    try {
      final remoteContacts =
          await _remoteSource.fetchAll(type: type.toApiString());
      return remoteContacts;
    } on ContactException {
      return _localSource.getByType(type.toApiString());
    }
  }

  Future<ContactModel> createContact(ContactModel contact) async {
    final now = DateTime.now();
    final newContact = contact.copyWith(
      id: _uuid.v4(),
      syncStatus: 'pending',
      createdAt: now,
      updatedAt: now,
    );

    await _localSource.insert(newContact);

    try {
      final synced = await _remoteSource.create(newContact);
      await _localSource.update(synced.copyWith(syncStatus: 'synced'));
      return synced.copyWith(syncStatus: 'synced');
    } on ContactException {
      return newContact;
    }
  }

  Future<void> updateContact(ContactModel contact) async {
    final updated = contact.copyWith(
      updatedAt: DateTime.now(),
      syncStatus: 'pending',
    );
    await _localSource.update(updated);

    try {
      await _remoteSource.update(updated.id, updated);
      await _localSource.update(updated.copyWith(syncStatus: 'synced'));
    } on ContactException {
      // Will sync later
    }
  }

  Future<void> deleteContact(String id) async {
    await _localSource.delete(id);

    try {
      await _remoteSource.delete(id);
    } on ContactException {
      // Will sync later
    }
  }

  Future<ContactModel?> getContactById(String id) async {
    final local = await _localSource.getById(id);
    if (local != null) return local;

    try {
      final remote = await _remoteSource.fetchById(id);
      await _localSource.insert(remote.copyWith(syncStatus: 'synced'));
      return remote;
    } on ContactException {
      return null;
    }
  }

  Stream<List<ContactModel>> watchContacts() {
    return _localSource.watchAll();
  }
}
