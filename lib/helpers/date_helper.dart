import 'package:intl/intl.dart';

class DateHelper {
  static String getDayMonthYearDateText(DateTime date) =>
      DateFormat('dd.MM.yyyy').format(date);
}
