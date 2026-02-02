import 'package:flutter/material.dart';
import 'package:mdb_copilot/features/contacts/data/models/contact_model.dart';

const Map<ContactType, String> contactTypeLabels = {
  ContactType.agentImmobilier: 'Agent immobilier',
  ContactType.artisan: 'Artisan',
  ContactType.notaire: 'Notaire',
  ContactType.courtier: 'Courtier',
  ContactType.autre: 'Autre',
};

const Map<ContactType, Color> contactTypeColors = {
  ContactType.agentImmobilier: Colors.blue,
  ContactType.artisan: Colors.orange,
  ContactType.notaire: Colors.purple,
  ContactType.courtier: Colors.teal,
  ContactType.autre: Colors.grey,
};
