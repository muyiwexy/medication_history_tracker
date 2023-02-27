class UserFields {
  static const String id = "\$id";
  static const String medicationname = "medicationname";
  static const String userID = "userID";
  static const String dosages = "dosages";
  static const String isInjection = "isInjection";
  static const String isTablet = "isTablet";
  static const String isSyrup = "isSyrup";
  static const String date = "date";
  static const String check = "check";
}

class Medications {
  String? id;
  String? medicationname;
  String? userID;
  int? dosages;
  bool? isInjection;
  bool? isTablet;
  bool? isSyrup;
  bool? check;

  Medications({
    required this.id,
    required this.medicationname,
    required this.userID,
    required this.dosages,
    required this.isInjection,
    required this.isTablet,
    required this.isSyrup,
    required this.check,
  });

  Medications.fromJson(Map<String, dynamic> json) {
    id = json[UserFields.id];
    medicationname = json[UserFields.medicationname];
    userID = json[UserFields.userID];
    dosages = json[UserFields.dosages];
    isInjection = json[UserFields.isInjection];
    isTablet = json[UserFields.isTablet];
    isSyrup = json[UserFields.isSyrup];
    check = json[UserFields.check];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[UserFields.id] = id;
    data[UserFields.medicationname] = medicationname;
    data[UserFields.userID] = userID;
    data[UserFields.dosages] = dosages;
    data[UserFields.isInjection] = isInjection;
    data[UserFields.isTablet] = isTablet;
    data[UserFields.isSyrup] = isSyrup;
    data[UserFields.check] = check;
    return data;
  }
}
