import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';
import 'package:mdb_copilot/features/properties/data/property_repository.dart';
import 'package:mdb_copilot/features/properties/presentation/cubit/property_cubit.dart';
import 'package:mdb_copilot/features/properties/presentation/cubit/property_state.dart';
import 'package:mocktail/mocktail.dart';

class MockPropertyRepository extends Mock implements PropertyRepository {}

class FakePropertyModel extends Fake implements PropertyModel {}

void main() {
  late MockPropertyRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakePropertyModel());
  });

  setUp(() {
    mockRepository = MockPropertyRepository();
  });

  final now = DateTime(2026);
  final testProperty = PropertyModel(
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
    blocTest<PropertyCubit, PropertyState>(
      'emits [PropertyLoading, PropertyCreated] on success',
      build: () {
        when(() => mockRepository.createProperty(any()))
            .thenAnswer((_) async => testProperty);
        return PropertyCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.createProperty(testProperty),
      expect: () => [
        const PropertyLoading(),
        PropertyCreated(testProperty),
      ],
    );

    blocTest<PropertyCubit, PropertyState>(
      'emits [PropertyLoading, PropertyError] on failure',
      build: () {
        when(() => mockRepository.createProperty(any()))
            .thenThrow(Exception('Network error'));
        return PropertyCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.createProperty(testProperty),
      expect: () => [
        const PropertyLoading(),
        isA<PropertyError>(),
      ],
    );
  });

  group('loadProperties', () {
    blocTest<PropertyCubit, PropertyState>(
      'emits [PropertyLoading, PropertyLoaded] on success',
      build: () {
        when(() => mockRepository.getProperties())
            .thenAnswer((_) async => [testProperty]);
        return PropertyCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.loadProperties(),
      expect: () => [
        const PropertyLoading(),
        PropertyLoaded([testProperty]),
      ],
    );

    blocTest<PropertyCubit, PropertyState>(
      'emits [PropertyLoading, PropertyError] on failure',
      build: () {
        when(() => mockRepository.getProperties())
            .thenThrow(Exception('Error'));
        return PropertyCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.loadProperties(),
      expect: () => [
        const PropertyLoading(),
        isA<PropertyError>(),
      ],
    );
  });

  group('loadPropertyById', () {
    blocTest<PropertyCubit, PropertyState>(
      'emits [PropertyLoading, PropertyDetailLoaded] on success',
      build: () {
        when(() => mockRepository.getPropertyById('uuid-123'))
            .thenAnswer((_) async => testProperty);
        return PropertyCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.loadPropertyById('uuid-123'),
      expect: () => [
        const PropertyLoading(),
        PropertyDetailLoaded(testProperty),
      ],
    );

    blocTest<PropertyCubit, PropertyState>(
      'emits [PropertyLoading, PropertyError] when not found',
      build: () {
        when(() => mockRepository.getPropertyById('missing'))
            .thenAnswer((_) async => null);
        return PropertyCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.loadPropertyById('missing'),
      expect: () => [
        const PropertyLoading(),
        isA<PropertyError>(),
      ],
    );
  });

  group('updateProperty', () {
    blocTest<PropertyCubit, PropertyState>(
      'emits [PropertyLoading, PropertyUpdated] on success',
      build: () {
        when(() => mockRepository.updateProperty(any()))
            .thenAnswer((_) async {});
        return PropertyCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.updateProperty(testProperty),
      expect: () => [
        const PropertyLoading(),
        PropertyUpdated(testProperty),
      ],
    );

    blocTest<PropertyCubit, PropertyState>(
      'emits [PropertyLoading, PropertyError] on failure',
      build: () {
        when(() => mockRepository.updateProperty(any()))
            .thenThrow(Exception('Network error'));
        return PropertyCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.updateProperty(testProperty),
      expect: () => [
        const PropertyLoading(),
        isA<PropertyError>(),
      ],
    );
  });

  group('deleteProperty', () {
    blocTest<PropertyCubit, PropertyState>(
      'emits [PropertyLoading, PropertyDeleted] on success',
      build: () {
        when(() => mockRepository.deleteProperty(any()))
            .thenAnswer((_) async {});
        return PropertyCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.deleteProperty('uuid-123'),
      expect: () => [
        const PropertyLoading(),
        const PropertyDeleted('uuid-123'),
      ],
    );

    blocTest<PropertyCubit, PropertyState>(
      'emits [PropertyLoading, PropertyError] on failure',
      build: () {
        when(() => mockRepository.deleteProperty(any()))
            .thenThrow(Exception('Error'));
        return PropertyCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.deleteProperty('uuid-123'),
      expect: () => [
        const PropertyLoading(),
        isA<PropertyError>(),
      ],
    );
  });
}
