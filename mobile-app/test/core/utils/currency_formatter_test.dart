import 'package:flutter_test/flutter_test.dart';
import 'package:mdb_copilot/core/utils/currency_formatter.dart';

void main() {
  test('formats price in cents to euros with FR locale', () {
    final result = formatPrice(150000);
    // intl FR: "1\u202f500,00 €" (narrow no-break space)
    expect(result, contains('500'));
    expect(result, contains('€'));
    expect(result, contains(',00'));
  });

  test('formats zero price', () {
    final result = formatPrice(0);
    expect(result, contains('0'));
    expect(result, contains(',00'));
    expect(result, contains('€'));
  });

  test('formats large price', () {
    final result = formatPrice(35000000);
    expect(result, contains('000'));
    expect(result, contains(',00'));
    expect(result, contains('€'));
  });

  test('formats price with cents', () {
    final result = formatPrice(12345);
    expect(result, contains('123'));
    expect(result, contains(',45'));
    expect(result, contains('€'));
  });
}
