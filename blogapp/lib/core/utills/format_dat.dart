import 'package:intl/intl.dart';

String formatdateBydMMMYYYY(DateTime dateTie) {
  return DateFormat('d MMM, yyyy').format(dateTie);
}
