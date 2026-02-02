import 'package:flutter/material.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';

String formatPropertyType(PropertyType type) {
  return switch (type) {
    PropertyType.appartement => 'Appartement',
    PropertyType.maison => 'Maison',
    PropertyType.terrain => 'Terrain',
    PropertyType.immeuble => 'Immeuble',
    PropertyType.commercial => 'Commercial',
  };
}

String formatSaleUrgency(SaleUrgency urgency) {
  return switch (urgency) {
    SaleUrgency.notSpecified => 'Non spécifié',
    SaleUrgency.low => 'Faible',
    SaleUrgency.medium => 'Moyenne',
    SaleUrgency.high => 'Élevée',
  };
}

Color saleUrgencyColor(SaleUrgency urgency) {
  return switch (urgency) {
    SaleUrgency.notSpecified => Colors.grey,
    SaleUrgency.low => Colors.green,
    SaleUrgency.medium => Colors.orange,
    SaleUrgency.high => Colors.red,
  };
}
