import 'package:core/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtil {
  final DateTime time;

  TimeUtil(this.time);

  String timeAgo(BuildContext context) {
    Duration diff;
    if (time.isUtc) {
      diff = DateTime.now().toUtc().difference(time);
    } else {
      diff = DateTime.now().difference(time);
    }
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()}${S.of(context).time_years_ago}";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()}${S.of(context).time_months_ago}";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()}${S.of(context).time_weeks_ago}";
    if (diff.inDays > 0) return "${diff.inDays} ${S.of(context).time_days_ago}";
    if (diff.inHours > 0)
      return "${diff.inHours}${S.of(context).time_hours_ago}";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes}${S.of(context).time_minutes_ago}";
    if (diff.inSeconds > 0)
      return "${diff.inSeconds}${S.of(context).time_seconds_ago}";
    return S.of(context).time_just_now;
  }

  String getPreciseTime() {
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss E');
    return formatter.format(time.toLocal());
  }
}
