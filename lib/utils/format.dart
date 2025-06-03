import 'package:intl/intl.dart';

class Format {
  static String currency(num value, { String pattern = "R\$ #,##0.00" }) {
    final f = NumberFormat(pattern, "pt_BR");
    return f.format(value);
  }

  static String percentage(num value) {
    final f = NumberFormat("#,##0.00", "pt_BR");
    return "${f.format(value)} %";
  }

  static String web3Address(String value) {
    return "${value.substring(0, 5)}...${value.substring(value.length - 4, value.length)}";
  }
}