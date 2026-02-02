import 'package:intl/intl.dart';

final NumberFormat _currencyFormatter = NumberFormat.currency(
  locale: 'fr_FR',
  symbol: '€',
  decimalDigits: 2,
);

String formatPrice(int priceInCents) {
  final euros = priceInCents / 100;
  return _currencyFormatter.format(euros);
}
