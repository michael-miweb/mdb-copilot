import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mdb_copilot/features/contacts/data/contact_repository.dart';
import 'package:mdb_copilot/features/contacts/data/models/contact_model.dart';
import 'package:mdb_copilot/features/contacts/presentation/cubit/contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit({required ContactRepository repository})
      : _repository = repository,
        super(const ContactInitial());

  final ContactRepository _repository;
  StreamSubscription<List<ContactModel>>? _subscription;

  Future<void> loadContacts() async {
    emit(const ContactLoading());
    try {
      final contacts = await _repository.getContacts();
      emit(ContactLoaded(contacts));
    } on Exception catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  Future<void> loadContactsByType(ContactType type) async {
    emit(const ContactLoading());
    try {
      final contacts = await _repository.getContactsByType(type);
      emit(ContactLoaded(contacts));
    } on Exception catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  Future<void> createContact(ContactModel contact) async {
    emit(const ContactLoading());
    try {
      final created = await _repository.createContact(contact);
      emit(ContactCreated(created));
    } on Exception catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  Future<void> updateContact(ContactModel contact) async {
    emit(const ContactLoading());
    try {
      await _repository.updateContact(contact);
      emit(ContactUpdated(contact));
    } on Exception catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  Future<void> deleteContact(String id) async {
    emit(const ContactLoading());
    try {
      await _repository.deleteContact(id);
      emit(ContactDeleted(id));
    } on Exception catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  Future<void> loadContactById(String id) async {
    emit(const ContactLoading());
    try {
      final contact = await _repository.getContactById(id);
      if (contact != null) {
        emit(ContactDetailLoaded(contact));
      } else {
        emit(const ContactError('Contact introuvable.'));
      }
    } on Exception catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  void watchContacts() {
    unawaited(_subscription?.cancel());
    _subscription = _repository.watchContacts().listen(
      (contacts) => emit(ContactLoaded(contacts)),
      onError: (Object e) => emit(ContactError(e.toString())),
    );
  }

  @override
  Future<void> close() {
    unawaited(_subscription?.cancel());
    return super.close();
  }
}
