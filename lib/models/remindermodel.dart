class UserFields {
  static const String id = "id";
  static const String medicationname = "medicationname";
  static const String userID = "userID";
  static const String interval = "interval";
  static const String date = "date";
  static const String isTrack = "isTrack";
}

class ReminderModel {
  String? id;
  String? medicationname;
  String? userID;
  // int? interval;
  //   final int countdown;
//   final bool isRunning;
  String? date;
  bool? isTrack;

  ReminderModel({
    required this.id,
    required this.medicationname,
    required this.userID,
    // required this.interval,
    required this.date,
    required this.isTrack,
  });

  ReminderModel.fromJson(Map<String, dynamic> json) {
    id = json[UserFields.id];
    medicationname = json[UserFields.medicationname];
    userID = json[UserFields.userID];
    // interval = json[UserFields.interval];
    date = json[UserFields.date];
    isTrack = json[UserFields.isTrack];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[UserFields.id] = id;
    data[UserFields.medicationname] = medicationname;
    data[UserFields.userID] = userID;
    // data[UserFields.interval] = interval;
    data[UserFields.date] = date;
    data[UserFields.isTrack] = isTrack;
    return data;
  }
}
