import 'package:equatable/equatable.dart';
import 'package:mdb_copilot/features/contacts/data/models/contact_model.dart';

sealed class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

class ContactInitial extends ContactState {
  const ContactInitial();
}

class ContactLoading extends ContactState {
  const ContactLoading();
}

class ContactLoaded extends ContactState {
  const ContactLoaded(this.contacts);

  final List<ContactModel> contacts;

  @override
  List<Object?> get props => [contacts];
}

class ContactError extends ContactState {
  const ContactError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ContactCreated extends ContactState {
  const ContactCreated(this.contact);

  final ContactModel contact;

  @override
  List<Object?> get props => [contact];
}

class ContactDetailLoaded extends ContactState {
  const ContactDetailLoaded(this.contact);

  final ContactModel contact;

  @override
  List<Object?> get props => [contact];
}

class ContactUpdated extends ContactState {
  const ContactUpdated(this.contact);

  final ContactModel contact;

  @override
  List<Object?> get props => [contact];
}

class ContactDeleted extends ContactState {
  const ContactDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
