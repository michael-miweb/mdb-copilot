import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdb_copilot/core/utils/enum_formatter.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';

void main() {
  group('formatPropertyType', () {
    test('formats all property types', () {
      expect(formatPropertyType(PropertyType.appartement), 'Appartement');
      expect(formatPropertyType(PropertyType.maison), 'Maison');
      expect(formatPropertyType(PropertyType.terrain), 'Terrain');
      expect(formatPropertyType(PropertyType.immeuble), 'Immeuble');
      expect(formatPropertyType(PropertyType.commercial), 'Commercial');
    });
  });

  group('formatSaleUrgency', () {
    test('formats all urgency levels', () {
      expect(formatSaleUrgency(SaleUrgency.notSpecified), 'Non spécifié');
      expect(formatSaleUrgency(SaleUrgency.low), 'Faible');
      expect(formatSaleUrgency(SaleUrgency.medium), 'Moyenne');
      expect(formatSaleUrgency(SaleUrgency.high), 'Élevée');
    });
  });

  group('saleUrgencyColor', () {
    test('returns correct colors', () {
      expect(saleUrgencyColor(SaleUrgency.notSpecified), Colors.grey);
      expect(saleUrgencyColor(SaleUrgency.low), Colors.green);
      expect(saleUrgencyColor(SaleUrgency.medium), Colors.orange);
      expect(saleUrgencyColor(SaleUrgency.high), Colors.red);
    });
  });
}
