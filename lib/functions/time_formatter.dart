String getFormattedTime(DateTime dateTime) {
  String time = '';
  time += '${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12}:';
  time += '${dateTime.minute} ${dateTime.hour > 12 ? "PM" : "AM"}   ';
  time += '${dateTime.day}/';
  time += '${dateTime.month}/';
  time += '${dateTime.year}';
  return time;
}
