String dateToString(DateTime date) {
  String year = date.year.toString();
  String month = date.month.toString();
  String day = date.day.toString();
  return '$year-$month-$day';
}

DateTime stringToDate(String date) {
  return DateTime.parse(date);
}

String generateEntry(int cycleLength, DateTime cycleStartDate, DateTime entryDate) {
  return '${cycleLength.toString()} ${dateToString(cycleStartDate)} ${dateToString(entryDate)}';
}

(int, String, String) seperateEntry(String entry) {
  List separated = entry.split(' ');
  return (separated[0].toInt(), separated[1], separated[2]);
}
