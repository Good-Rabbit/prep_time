String getFormattedTime(DateTime dateTime) {
  String time = '';
  time += '${dateTime.hour % 12 == 0 ? 12 : (dateTime.hour % 12 < 10 ? "0${dateTime.hour % 12}":"${dateTime.hour % 12}")}:';
  time += '${dateTime.minute < 10 ? "0${dateTime.minute}":"${dateTime.minute}"} ${dateTime.hour > 12 ? "PM" : "AM"}   ';
  time += '${dateTime.day < 10 ? "0${dateTime.day}":"${dateTime.day}"}/';
  time += '${dateTime.month < 10 ? "0${dateTime.month}":"${dateTime.month}"}/';
  time += '${dateTime.year}';
  return time;
}
