import 'package:flutter/material.dart';
import 'package:go_router_poc/models/company.dart';
import 'package:go_router_poc/models/user.dart';

extension TimeOfDayExtension on TimeOfDay {
  Map<String, dynamic> toMap() {
    return {
      'hour': hour,
      'minute': minute,
    };
  }

  String get label {
    final minute = this.minute.toString().padLeft(2, '0');
    final hour = this.hour.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String get labelAmPm {
    final minute = this.minute.toString().padLeft(2, '0');

    final hourInt = this.hour < 12 ? this.hour : this.hour - 12;

    final hour = hourInt.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String get amPM {
    final text = '$labelAmPm ';

    if (hour < 12) {
      return '${text}am';
    } else {
      return '${text}pm';
    }
  }
}

TimeOfDay timeOfDayFromMap(Map<String, dynamic> map) {
  return TimeOfDay(
    hour: map['hour'] as int,
    minute: map['minute'] as int,
  );
}

TimeOfDay? timeOfDayFromString(String time) {
  try {
    final List<String> parts;
    if (time.contains(':')) {
      parts = time.split(':');
    } else {
      final values = time.split('');
      parts = [
        values[0] + values[1],
        values[2] + values[3],
      ];
    }
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(
      hour: hour,
      minute: minute,
    );
  } catch (e) {
    return null;
  }
}

extension UserExtension on User? {
  bool get isCommonUser => this is CommonUser;
  bool get isCompany => this is Company;
  bool get isAnalyst => this is Analyst;
  bool get isAdmin => this is Admin;
  bool get isAdminAnalystOrCompany => isAdmin || isAnalyst || isCompany;
}
