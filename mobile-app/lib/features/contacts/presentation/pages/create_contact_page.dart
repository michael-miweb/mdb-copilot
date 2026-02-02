import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_state.dart';
import 'package:mdb_copilot/features/contacts/data/models/contact_model.dart';
import 'package:mdb_copilot/features/contacts/presentation/cubit/contact_cubit.dart';
import 'package:mdb_copilot/features/contacts/presentation/cubit/contact_state.dart';
import 'package:mdb_copilot/features/contacts/presentation/widgets/contact_form_fields.dart';
import 'package:uuid/uuid.dart';

class CreateContactPage extends StatefulWidget {
  const CreateContactPage({super.key});

  @override
  State<CreateContactPage> createState() => _CreateContactPageState();
}

class _CreateContactPageState extends State<CreateContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  ContactType _contactType = ContactType.autre;

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

    final authState = context.read<AuthCubit>().state;
    final userId = authState is AuthAuthenticated
        ? authState.user.id.toString()
        : '';
    final now = DateTime.now();
    final contact = ContactModel(
      id: const Uuid().v4(),
      userId: userId,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      company: _companyController.text.trim().isEmpty
          ? null
          : _companyController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      contactType: _contactType,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: now,
      updatedAt: now,
    );

    unawaited(context.read<ContactCubit>().createContact(contact));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactCubit, ContactState>(
      listener: (context, state) {
        if (state is ContactCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contact cr\u00e9\u00e9.')),
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
          title: const Text('Nouveau contact'),
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
                              : const Text('Cr\u00e9er le contact'),
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
