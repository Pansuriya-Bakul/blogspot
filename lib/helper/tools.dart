import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Tools {
  static String formatDate(DateTime dt, String format) {
    DateFormat formatter = DateFormat(format);
    return formatter.format(dt);
  }

  static DateTime formatDateFromString(String dt, String format) {
    DateFormat formatter = DateFormat(format);
    return formatter.parse(dt, false);
  }

  static String formatDateString(
      String dt, String fromFormat, String toFormat) {
    var date = formatDateFromString(dt, fromFormat);
    return formatDate(date, toFormat);
  }

  static String formatDateFromMilliseconds(int milliseconds, String format) {
    var dt = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return formatDate(dt, format);
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension StateExtension on State {
  setStateIfMounted(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}

class MapUtils {
  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw "Could not open google map.";
    }
  }
}
