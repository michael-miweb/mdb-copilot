import 'package:flutter_test/flutter_test.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';
import 'package:mdb_copilot/features/properties/data/property_exception.dart';
import 'package:mdb_copilot/features/properties/data/property_local_source.dart';
import 'package:mdb_copilot/features/properties/data/property_remote_source.dart';
import 'package:mdb_copilot/features/properties/data/property_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockPropertyLocalSource extends Mock implements PropertyLocalSource {}

class MockPropertyRemoteSource extends Mock implements PropertyRemoteSource {}

class FakePropertyModel extends Fake implements PropertyModel {}

void main() {
  late MockPropertyLocalSource mockLocal;
  late MockPropertyRemoteSource mockRemote;
  late PropertyRepository repository;

  setUpAll(() {
    registerFallbackValue(FakePropertyModel());
  });

  setUp(() {
    mockLocal = MockPropertyLocalSource();
    mockRemote = MockPropertyRemoteSource();
    repository = PropertyRepository(
      localSource: mockLocal,
      remoteSource: mockRemote,
    );
  });

  final now = DateTime(2026);
  final testProperty = PropertyModel(
    id: '',
    userId: '1',
    address: '12 rue de la Paix',
    surface: 85,
    price: 35000000,
    propertyType: PropertyType.appartement,
    createdAt: now,
    updatedAt: now,
  );

  final savedProperty = PropertyModel(
    id: 'uuid-123',
    userId: '1',
    address: '12 rue de la Paix',
    surface: 85,
    price: 35000000,
    propertyType: PropertyType.appartement,
    syncStatus: 'synced',
    createdAt: now,
    updatedAt: now,
  );

  group('createProperty', () {
    test('inserts locally and syncs to remote on success', () async {
      when(() => mockLocal.insert(any())).thenAnswer((_) async {});
      when(() => mockRemote.create(any()))
          .thenAnswer((_) async => savedProperty);
      when(() => mockLocal.update(any())).thenAnswer((_) async {});

      final result = await repository.createProperty(testProperty);

      expect(result.address, '12 rue de la Paix');
      expect(result.syncStatus, 'synced');
      verify(() => mockLocal.insert(any())).called(1);
      verify(() => mockRemote.create(any())).called(1);
      verify(() => mockLocal.update(any())).called(1);
    });

    test('inserts locally and keeps pending when remote fails', () async {
      when(() => mockLocal.insert(any())).thenAnswer((_) async {});
      when(() => mockRemote.create(any())).thenThrow(
        const PropertyNetworkException(),
      );

      final result = await repository.createProperty(testProperty);

      expect(result.syncStatus, 'pending');
      verify(() => mockLocal.insert(any())).called(1);
      verify(() => mockRemote.create(any())).called(1);
      verifyNever(() => mockLocal.update(any()));
    });

    test('generates UUID v4 for new property', () async {
      when(() => mockLocal.insert(any())).thenAnswer((_) async {});
      when(() => mockRemote.create(any()))
          .thenAnswer((_) async => savedProperty);
      when(() => mockLocal.update(any())).thenAnswer((_) async {});

      await repository.createProperty(testProperty);

      final captured =
          verify(() => mockLocal.insert(captureAny())).captured.single
              as PropertyModel;
      expect(captured.id, isNotEmpty);
      expect(captured.id, isNot(''));
    });
  });

  group('getProperties', () {
    test('returns remote properties on success', () async {
      when(() => mockRemote.fetchAll())
          .thenAnswer((_) async => [savedProperty]);
      when(() => mockLocal.getById(any())).thenAnswer((_) async => null);
      when(() => mockLocal.insert(any())).thenAnswer((_) async {});

      final result = await repository.getProperties();

      expect(result, hasLength(1));
      verify(() => mockRemote.fetchAll()).called(1);
      verify(() => mockLocal.insert(any())).called(1);
    });

    test('falls back to local when remote fails', () async {
      when(() => mockRemote.fetchAll()).thenThrow(
        const PropertyNetworkException(),
      );
      when(() => mockLocal.getAll())
          .thenAnswer((_) async => [savedProperty]);

      final result = await repository.getProperties();

      expect(result, hasLength(1));
      verify(() => mockLocal.getAll()).called(1);
    });
  });

  group('getPropertyById', () {
    test('returns local property when found', () async {
      when(() => mockLocal.getById('uuid-123'))
          .thenAnswer((_) async => savedProperty);

      final result = await repository.getPropertyById('uuid-123');

      expect(result, savedProperty);
      verify(() => mockLocal.getById('uuid-123')).called(1);
      verifyNever(() => mockRemote.fetchById(any()));
    });

    test('fetches remote when local is null', () async {
      when(() => mockLocal.getById('uuid-123'))
          .thenAnswer((_) async => null);
      when(() => mockRemote.fetchById('uuid-123'))
          .thenAnswer((_) async => savedProperty);
      when(() => mockLocal.insert(any())).thenAnswer((_) async {});

      final result = await repository.getPropertyById('uuid-123');

      expect(result, savedProperty);
      verify(() => mockRemote.fetchById('uuid-123')).called(1);
      verify(() => mockLocal.insert(any())).called(1);
    });

    test('returns null when local and remote fail', () async {
      when(() => mockLocal.getById('missing'))
          .thenAnswer((_) async => null);
      when(() => mockRemote.fetchById('missing'))
          .thenThrow(const PropertyNotFoundException());

      final result = await repository.getPropertyById('missing');

      expect(result, isNull);
    });
  });

  group('updateProperty', () {
    test('updates locally and syncs to remote on success', () async {
      when(() => mockLocal.update(any())).thenAnswer((_) async {});
      when(() => mockRemote.update(any(), any()))
          .thenAnswer((_) async => savedProperty);

      final before = DateTime.now();
      await repository.updateProperty(savedProperty);

      final captured =
          verify(() => mockLocal.update(captureAny())).captured;
      expect(captured, hasLength(2));
      final firstUpdate = captured.first as PropertyModel;
      expect(firstUpdate.syncStatus, 'pending');
      expect(
        firstUpdate.updatedAt.isAfter(before) ||
            firstUpdate.updatedAt.isAtSameMomentAs(before),
        isTrue,
      );
      verify(() => mockRemote.update(any(), any())).called(1);
    });

    test('updates locally and keeps pending when remote fails',
        () async {
      when(() => mockLocal.update(any())).thenAnswer((_) async {});
      when(() => mockRemote.update(any(), any()))
          .thenThrow(const PropertyNetworkException());

      await repository.updateProperty(savedProperty);

      verify(() => mockLocal.update(any())).called(1);
      verify(() => mockRemote.update(any(), any())).called(1);
    });
  });

  group('deleteProperty', () {
    test('deletes locally and syncs to remote on success', () async {
      when(() => mockLocal.delete(any())).thenAnswer((_) async {});
      when(() => mockRemote.delete(any())).thenAnswer((_) async {});

      await repository.deleteProperty('uuid-123');

      verify(() => mockLocal.delete('uuid-123')).called(1);
      verify(() => mockRemote.delete('uuid-123')).called(1);
    });

    test('deletes locally even when remote fails', () async {
      when(() => mockLocal.delete(any())).thenAnswer((_) async {});
      when(() => mockRemote.delete(any()))
          .thenThrow(const PropertyNetworkException());

      await repository.deleteProperty('uuid-123');

      verify(() => mockLocal.delete('uuid-123')).called(1);
      verify(() => mockRemote.delete('uuid-123')).called(1);
    });
  });
}
