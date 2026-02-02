import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/features/contacts/data/models/contact_model.dart';
import 'package:mdb_copilot/features/contacts/presentation/cubit/contact_cubit.dart';
import 'package:mdb_copilot/features/contacts/presentation/cubit/contact_state.dart';
import 'package:mdb_copilot/features/contacts/presentation/widgets/contact_form_fields.dart';

class EditContactPage extends StatefulWidget {
  const EditContactPage({required this.contact, super.key});

  final ContactModel contact;

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _companyController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _notesController;
  late ContactType _contactType;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.contact.firstName);
    _lastNameController =
        TextEditingController(text: widget.contact.lastName);
    _companyController =
        TextEditingController(text: widget.contact.company ?? '');
    _phoneController =
        TextEditingController(text: widget.contact.phone ?? '');
    _emailController =
        TextEditingController(text: widget.contact.email ?? '');
    _notesController =
        TextEditingController(text: widget.contact.notes ?? '');
    _contactType = widget.contact.contactType;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final updated = widget.contact.copyWith(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      company: () => _companyController.text.trim().isEmpty
          ? null
          : _companyController.text.trim(),
      phone: () => _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      email: () => _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      contactType: _contactType,
      notes: () => _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      updatedAt: DateTime.now(),
      syncStatus: 'pending',
    );

    unawaited(context.read<ContactCubit>().updateContact(updated));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactCubit, ContactState>(
      listener: (context, state) {
        if (state is ContactUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contact mis \u00e0 jour.'),
            ),
          );
          context.pop();
        } else if (state is ContactError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Modifier le contact'),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ContactFormFields(
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      companyController: _companyController,
                      phoneController: _phoneController,
                      emailController: _emailController,
                      notesController: _notesController,
                      contactType: _contactType,
                      onContactTypeChanged: (type) {
                        if (type != null) {
                          setState(() => _contactType = type);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<ContactCubit, ContactState>(
                      builder: (context, state) {
                        return FilledButton(
                          onPressed:
                              state is ContactLoading ? null : _onSubmit,
                          child: state is ContactLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Enregistrer'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
