import 'package:intl/intl.dart';
const RS = "₹";

String getDisplayNumber(dynamic number,{required bool isBooking, bool showSymbol=true,bool compact=true}){

  if(isBooking)
  {
    return formatBookingNumber(number,compact: compact);
  }
  else
    return formatPrice(number,compact: compact,showSymbol: showSymbol);

}

String formatPrice(dynamic price,
    {bool compact = false, bool showSymbol = true}) {
  if (price == "--") return price;
  final String currency = showSymbol ? '$RS' : '';
  try {
    if (compact) {
      final n = price is String ? double.parse(price) : price;
      return "${NumberFormat.compactCurrency(symbol: currency, locale: getlocale(n)).format(n)}";
    }

    var value = removeDecimal(price is double ? price : double.parse(price));
    return "$RS $value";
  } catch (e) {
    print("Price ERROR: $e");
    return "$RS $price";
  }
}


String formatBookingNumber(dynamic number, {bool compact = true}) {
  print(number);
  if (number is int) {
    return '$number';
  }
  final n = number is String ? double.parse(number) : number;

  var numberFormat = NumberFormat.compact(locale: getlocale(n))
    ..minimumFractionDigits = 0
    ..maximumFractionDigits = 00;

  return numberFormat.format(n);
}

String removeDecimal(double value) {
  final numberFormat = NumberFormat();
  numberFormat.minimumFractionDigits = 0;
  numberFormat.maximumFractionDigits = 2;
  return numberFormat.format(value);
}

String getlocale(double number) {
  if (number <= 100000)
    return 'en_US';
  else
    return 'en_IN';
}
