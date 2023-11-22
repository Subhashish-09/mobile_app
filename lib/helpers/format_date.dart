import 'package:intl/intl.dart';

String convertTimestampToReadableText(String timestamp) {
  return DateFormat('MMMM d, yyyy hh:mm a').format(DateTime.parse(timestamp));
}
