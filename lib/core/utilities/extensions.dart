import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

extension Date on DateTime {
  String? toTimeFormat() {
    initializeDateFormatting();
    try {
      return DateFormat.Hm('id').format(this);
    } catch (e) {
      return null;
    }
  }

  String? toIndonesiaDateFormat() {
    initializeDateFormatting();
    try {
      return DateFormat.yMMMMd('id').format(this);
    } catch (e) {
      return null;
    }
  }

  int getDurationBetween(DateTime datetime) {
    Duration difference = this.difference(datetime);
    return difference.inMinutes;
  }

  String? toIndonesianDayName() {
    initializeDateFormatting();
    try {
      return DateFormat.EEEE('id').format(this);
    } catch (e) {
      return null;
    }
  }
}
