import 'package:flutter_test/flutter_test.dart';
import 'package:mdb_copilot/features/contacts/data/contact_exception.dart';
import 'package:mdb_copilot/features/contacts/data/contact_local_source.dart';
import 'package:mdb_copilot/features/contacts/data/contact_remote_source.dart';
import 'package:mdb_copilot/features/contacts/data/contact_repository.dart';
import 'package:mdb_copilot/features/contacts/data/models/contact_model.dart';
import 'package:mocktail/mocktail.dart';

class MockContactLocalSource extends Mock implements ContactLocalSource {}

class MockContactRemoteSource extends Mock implements ContactRemoteSource {}

class FakeContactModel extends Fake implements ContactModel {}

void main() {
  late MockContactLocalSource mockLocal;
  late MockContactRemoteSource mockRemote;
  late ContactRepository repository;

  setUpAll(() {
    registerFallbackValue(FakeContactModel());
  });

  setUp(() {
    mockLocal = MockContactLocalSource();
    mockRemote = MockContactRemoteSource();
    repository = ContactRepository(
      localSource: mockLocal,
      remoteSource: mockRemote,
    );
  });

  final now = DateTime(2026);
  final testContact = ContactModel(
    id: '',
    userId: '1',
    firstName: 'Jean',
    lastName: 'Dupont',
    contactType: ContactType.agentImmobilier,
    createdAt: now,
    updatedAt: now,
  );

  final savedContact = ContactModel(
    id: 'uuid-c1',
    userId: '1',
    firstName: 'Jean',
    lastName: 'Dupont',
    contactType: ContactType.agentImmobilier,
    syncStatus: 'synced',
    createdAt: now,
    updatedAt: now,
  );

  group('createContact', () {
    test('inserts locally and syncs to remote on success', () async {
      when(() => mockLocal.insert(any())).thenAnswer((_) async {});
      when(() => mockRemote.create(any()))
          .thenAnswer((_) async => savedContact);
      when(() => mockLocal.update(any())).thenAnswer((_) async {});

      final result = await repository.createContact(testContact);

      expect(result.firstName, 'Jean');
      expect(result.syncStatus, 'synced');
      verify(() => mockLocal.insert(any())).called(1);
      verify(() => mockRemote.create(any())).called(1);
      verify(() => mockLocal.update(any())).called(1);
    });

    test('inserts locally and keeps pending when remote fails', () async {
      when(() => mockLocal.insert(any())).thenAnswer((_) async {});
      when(() => mockRemote.create(any()))
          .thenThrow(const ContactNetworkException());

      final result = await repository.createContact(testContact);

      expect(result.syncStatus, 'pending');
      verify(() => mockLocal.insert(any())).called(1);
      verify(() => mockRemote.create(any())).called(1);
      verifyNever(() => mockLocal.update(any()));
    });

    test('generates UUID v4 for new contact', () async {
      when(() => mockLocal.insert(any())).thenAnswer((_) async {});
      when(() => mockRemote.create(any()))
          .thenAnswer((_) async => savedContact);
      when(() => mockLocal.update(any())).thenAnswer((_) async {});

      await repository.createContact(testContact);

      final captured =
          verify(() => mockLocal.insert(captureAny())).captured.single
              as ContactModel;
      expect(captured.id, isNotEmpty);
      expect(captured.id, isNot(''));
    });
  });

  group('getContacts', () {
    test('returns remote contacts on success', () async {
      when(() => mockRemote.fetchAll())
          .thenAnswer((_) async => [savedContact]);
      when(() => mockLocal.getById(any())).thenAnswer((_) async => null);
      when(() => mockLocal.insert(any())).thenAnswer((_) async {});

      final result = await repository.getContacts();

      expect(result, hasLength(1));
      verify(() => mockRemote.fetchAll()).called(1);
      verify(() => mockLocal.insert(any())).called(1);
    });

    test('falls back to local when remote fails', () async {
      when(() => mockRemote.fetchAll())
          .thenThrow(const ContactNetworkException());
      when(() => mockLocal.getAll())
          .thenAnswer((_) async => [savedContact]);

      final result = await repository.getContacts();

      expect(result, hasLength(1));
      verify(() => mockLocal.getAll()).called(1);
    });
  });

  group('getContactsByType', () {
    test('returns remote contacts filtered by type', () async {
      when(() => mockRemote.fetchAll(type: any(named: 'type')))
          .thenAnswer((_) async => [savedContact]);

      final result =
          await repository.getContactsByType(ContactType.agentImmobilier);

      expect(result, hasLength(1));
      verify(
        () => mockRemote.fetchAll(type: 'agent_immobilier'),
      ).called(1);
    });

    test('falls back to local by type when remote fails', () async {
      when(() => mockRemote.fetchAll(type: any(named: 'type')))
          .thenThrow(const ContactNetworkException());
      when(() => mockLocal.getByType(any()))
          .thenAnswer((_) async => [savedContact]);

      final result =
          await repository.getContactsByType(ContactType.agentImmobilier);

      expect(result, hasLength(1));
      verify(() => mockLocal.getByType('agent_immobilier')).called(1);
    });
  });

  group('getContactById', () {
    test('returns local contact when found', () async {
      when(() => mockLocal.getById('uuid-c1'))
          .thenAnswer((_) async => savedContact);

      final result = await repository.getContactById('uuid-c1');

      expect(result, savedContact);
      verify(() => mockLocal.getById('uuid-c1')).called(1);
      verifyNever(() => mockRemote.fetchById(any()));
    });

    test('fetches remote when local is null', () async {
      when(() => mockLocal.getById('uuid-c1'))
          .thenAnswer((_) async => null);
      when(() => mockRemote.fetchById('uuid-c1'))
          .thenAnswer((_) async => savedContact);
      when(() => mockLocal.insert(any())).thenAnswer((_) async {});

      final result = await repository.getContactById('uuid-c1');

      expect(result, savedContact);
      verify(() => mockRemote.fetchById('uuid-c1')).called(1);
      verify(() => mockLocal.insert(any())).called(1);
    });

    test('returns null when local and remote fail', () async {
      when(() => mockLocal.getById('missing'))
          .thenAnswer((_) async => null);
      when(() => mockRemote.fetchById('missing'))
          .thenThrow(const ContactNotFoundException());

      final result = await repository.getContactById('missing');

      expect(result, isNull);
    });
  });

  group('updateContact', () {
    test('updates locally and syncs to remote on success', () async {
      when(() => mockLocal.update(any())).thenAnswer((_) async {});
      when(() => mockRemote.update(any(), any()))
          .thenAnswer((_) async => savedContact);

      await repository.updateContact(savedContact);

      verify(() => mockLocal.update(any())).called(2);
      verify(() => mockRemote.update(any(), any())).called(1);
    });

    test('updates locally and keeps pending when remote fails', () async {
      when(() => mockLocal.update(any())).thenAnswer((_) async {});
      when(() => mockRemote.update(any(), any()))
          .thenThrow(const ContactNetworkException());

      await repository.updateContact(savedContact);

      verify(() => mockLocal.update(any())).called(1);
      verify(() => mockRemote.update(any(), any())).called(1);
    });
  });

  group('deleteContact', () {
    test('deletes locally and syncs to remote on success', () async {
      when(() => mockLocal.delete(any())).thenAnswer((_) async {});
      when(() => mockRemote.delete(any())).thenAnswer((_) async {});

      await repository.deleteContact('uuid-c1');

      verify(() => mockLocal.delete('uuid-c1')).called(1);
      verify(() => mockRemote.delete('uuid-c1')).called(1);
    });

    test('deletes locally even when remote fails', () async {
      when(() => mockLocal.delete(any())).thenAnswer((_) async {});
      when(() => mockRemote.delete(any()))
          .thenThrow(const ContactNetworkException());

      await repository.deleteContact('uuid-c1');

      verify(() => mockLocal.delete('uuid-c1')).called(1);
      verify(() => mockRemote.delete('uuid-c1')).called(1);
    });
  });
}
