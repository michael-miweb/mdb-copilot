import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdb_copilot/features/contacts/data/contact_repository.dart';
import 'package:mdb_copilot/features/contacts/data/models/contact_model.dart';
import 'package:mdb_copilot/features/contacts/presentation/cubit/contact_cubit.dart';
import 'package:mdb_copilot/features/contacts/presentation/cubit/contact_state.dart';
import 'package:mocktail/mocktail.dart';

class MockContactRepository extends Mock implements ContactRepository {}

class FakeContactModel extends Fake implements ContactModel {}

void main() {
  late MockContactRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeContactModel());
    registerFallbackValue(ContactType.autre);
  });

  setUp(() {
    mockRepository = MockContactRepository();
  });

  final now = DateTime(2026);
  final testContact = ContactModel(
    id: 'uuid-c1',
    userId: '1',
    firstName: 'Jean',
    lastName: 'Dupont',
    company: 'Agence Immo',
    phone: '0601020304',
    email: 'jean@agence.fr',
    contactType: ContactType.agentImmobilier,
    syncStatus: 'synced',
    createdAt: now,
    updatedAt: now,
  );

  group('loadContacts', () {
    blocTest<ContactCubit, ContactState>(
      'emits [ContactLoading, ContactLoaded] on success',
      build: () {
        when(() => mockRepository.getContacts())
            .thenAnswer((_) async => [testContact]);
        return ContactCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.loadContacts(),
      expect: () => [
        const ContactLoading(),
        ContactLoaded([testContact]),
      ],
    );

    blocTest<ContactCubit, ContactState>(
      'emits [ContactLoading, ContactError] on failure',
      build: () {
        when(() => mockRepository.getContacts())
            .thenThrow(Exception('Error'));
        return ContactCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.loadContacts(),
      expect: () => [
        const ContactLoading(),
        isA<ContactError>(),
      ],
    );
  });

  group('loadContactsByType', () {
    blocTest<ContactCubit, ContactState>(
      'emits [ContactLoading, ContactLoaded] on success',
      build: () {
        when(() => mockRepository.getContactsByType(any()))
            .thenAnswer((_) async => [testContact]);
        return ContactCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.loadContactsByType(ContactType.agentImmobilier),
      expect: () => [
        const ContactLoading(),
        ContactLoaded([testContact]),
      ],
    );
  });

  group('createContact', () {
    blocTest<ContactCubit, ContactState>(
      'emits [ContactLoading, ContactCreated] on success',
      build: () {
        when(() => mockRepository.createContact(any()))
            .thenAnswer((_) async => testContact);
        return ContactCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.createContact(testContact),
      expect: () => [
        const ContactLoading(),
        ContactCreated(testContact),
      ],
    );

    blocTest<ContactCubit, ContactState>(
      'emits [ContactLoading, ContactError] on failure',
      build: () {
        when(() => mockRepository.createContact(any()))
            .thenThrow(Exception('Network error'));
        return ContactCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.createContact(testContact),
      expect: () => [
        const ContactLoading(),
        isA<ContactError>(),
      ],
    );
  });

  group('updateContact', () {
    blocTest<ContactCubit, ContactState>(
      'emits [ContactLoading, ContactUpdated] on success',
      build: () {
        when(() => mockRepository.updateContact(any()))
            .thenAnswer((_) async {});
        return ContactCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.updateContact(testContact),
      expect: () => [
        const ContactLoading(),
        ContactUpdated(testContact),
      ],
    );

    blocTest<ContactCubit, ContactState>(
      'emits [ContactLoading, ContactError] on failure',
      build: () {
        when(() => mockRepository.updateContact(any()))
            .thenThrow(Exception('Error'));
        return ContactCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.updateContact(testContact),
      expect: () => [
        const ContactLoading(),
        isA<ContactError>(),
      ],
    );
  });

  group('deleteContact', () {
    blocTest<ContactCubit, ContactState>(
      'emits [ContactLoading, ContactDeleted] on success',
      build: () {
        when(() => mockRepository.deleteContact(any()))
            .thenAnswer((_) async {});
        return ContactCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.deleteContact('uuid-c1'),
      expect: () => [
        const ContactLoading(),
        const ContactDeleted('uuid-c1'),
      ],
    );

    blocTest<ContactCubit, ContactState>(
      'emits [ContactLoading, ContactError] on failure',
      build: () {
        when(() => mockRepository.deleteContact(any()))
            .thenThrow(Exception('Error'));
        return ContactCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.deleteContact('uuid-c1'),
      expect: () => [
        const ContactLoading(),
        isA<ContactError>(),
      ],
    );
  });

  group('loadContactById', () {
    blocTest<ContactCubit, ContactState>(
      'emits [ContactLoading, ContactDetailLoaded] on success',
      build: () {
        when(() => mockRepository.getContactById('uuid-c1'))
            .thenAnswer((_) async => testContact);
        return ContactCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.loadContactById('uuid-c1'),
      expect: () => [
        const ContactLoading(),
        ContactDetailLoaded(testContact),
      ],
    );

    blocTest<ContactCubit, ContactState>(
      'emits [ContactLoading, ContactError] when not found',
      build: () {
        when(() => mockRepository.getContactById('missing'))
            .thenAnswer((_) async => null);
        return ContactCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.loadContactById('missing'),
      expect: () => [
        const ContactLoading(),
        isA<ContactError>(),
      ],
    );
  });
}
