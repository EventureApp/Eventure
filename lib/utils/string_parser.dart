String parseDateForEvents(DateTime date) {
  return '${date.day}.${date.month}.${date.year}, ${date.hour}:${_parseMinute(date.minute)}';
}

String _parseMinute(int minute) {
  return minute < 10 ? '0$minute' : '$minute';
}

String capitalizeString(String s) {
  return '${s[0].toUpperCase()}${s.substring(1)}';
}
