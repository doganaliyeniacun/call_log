import 'dart:async';

import 'package:flutter/services.dart';

/// main call_log plugin class
class CallLog {
  static const MethodChannel _channel = const MethodChannel('sk.fourq.call_log');

  /// Get all call history log entries. Permissions are handled automatically
  static Future<Iterable<CallLogEntry>> get() async {
    final Iterable<dynamic> result = await _channel.invokeMethod('get', null);
    return result?.map((dynamic m) => CallLogEntry.fromMap(m));
  }

  /// Query call history log entries
  /// dateFrom: unix timestamp. precision in millis
  /// dateTo: unix timestamp. precision in millis
  /// durationFrom: minimal call length in seconds
  /// durationTo: minimal call length in seconds
  /// name: call participant name (present only if in contacts)
  /// number: call participant phone number
  /// type: value from [CallType] enum
  static Future<Iterable<CallLogEntry>> query({
    int dateFrom,
    int dateTo,
    int durationFrom,
    int durationTo,
    String name,
    String number,
    CallType type,
    String numbertype,
    String numberlabel,
    String cachedNumberType,
    String cachedNumberLabel,
    String cachedMatchedNumber,
    String phoneAccountId,
  }) async {
    final Map<String, String> params = <String, String>{
      'dateFrom': dateFrom?.toString(),
      'dateTo': dateTo?.toString(),
      'durationFrom': durationFrom?.toString(),
      'durationTo': durationTo?.toString(),
      'name': name,
      'number': number,
      'type': type?.index == null ? null : (type.index + 1).toString(),
      'cachedNumberType': cachedNumberType,
      'cachedNumberLabel': cachedNumberLabel,
      'cachedMatchedNumber': cachedMatchedNumber,
      'phoneAccountId': phoneAccountId,
    };
    final Iterable<dynamic> records = await _channel.invokeMethod('query', params);
    return records?.map((dynamic m) => CallLogEntry.fromMap(m));
  }
}

/// PODO for one call log entry
class CallLogEntry {
  /// constructor
  CallLogEntry({
    this.name,
    this.number,
    this.formattedNumber,
    this.callType,
    this.duration,
    this.timestamp,
    this.cachedNumberType,
    this.cachedNumberLabel,
    this.simDisplayName,
    this.phoneAccountId,
  });

  /// constructor creating object from provided map
  CallLogEntry.fromMap(Map<dynamic, dynamic> m) {
    name = m['name'];
    number = m['number'];
    formattedNumber = m['formattedNumber'];
    callType = m['callType'] < 1 || m['callType'] > 8
        ? CallType.unknown
        : CallType.values[m['callType'] - 1];
    duration = m['duration'];
    timestamp = m['timestamp'];
    cachedNumberType = m['cachedNumberType'];
    cachedNumberLabel = m['cachedNumberLabel'];
    cachedMatchedNumber = m['cachedMatchedNumber'];
    simDisplayName = m['simDisplayName'];
    phoneAccountId = m['phoneAccountId'];
  }

  /// contact name
  String name;

  /// contact number
  String number;

  /// formatted number based on phone locales
  String formattedNumber;

  /// type of call entry. see CallType
  CallType callType;

  /// duration in seconds
  int duration;

  /// unix timestamp of call start
  int timestamp;

  /// todo comment
  int cachedNumberType;

  /// todo comment
  String cachedNumberLabel;

  /// todo comment
  String cachedMatchedNumber;

  /// SIM display name
  String simDisplayName;

  /// PHONE account id
  String phoneAccountId;
}

/// All possible call types
enum CallType {
  /// incoming call
  incoming,

  /// outgoing call
  outgoing,

  /// missed incoming call
  missed,

  /// voicemail call
  voiceMail,

  /// rejected incoming call
  rejected,

  /// blocked incoming call
  blocked,

  /// todo comment
  answeredExternally,

  /// unknown type of call
  unknown,
}
