import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:medication_history_tracker/constants/app_constants.dart';
import 'package:medication_history_tracker/models/remindermodel.dart';
import 'package:medication_history_tracker/services/notification_service.dart';

class ReminderProvider extends ChangeNotifier {
  Client client = Client();
  late Databases _databases;
  late bool _isloading;
  List<ReminderModel>? _reminderitemtrue;
  List<ReminderModel>? _reminderitem;

  bool get isloading => _isloading;
  List<ReminderModel>? get reminderitem => _reminderitem;
  List<ReminderModel>? get reminderitemtrue => _reminderitemtrue;

  ReminderProvider() {
    _isloading = true;
    initializeclass();
  }

  initializeclass() {
    client
      ..setEndpoint(Appconstants.endpoint)
      ..setProject(Appconstants.projectid);
    _databases = Databases(client);
  }

  loadReminders(String userid) async {
    try {
      final response = await _databases.listDocuments(
          collectionId: Appconstants.collectionID2,
          databaseId: Appconstants.dbID,
          queries: [
            Query.orderDesc('date'),
            Query.equal('userID', userid),
            Query.equal('isTrack', false)
          ]);
      _reminderitem = response.documents
          .map((reminder) => ReminderModel.fromJson(reminder.data))
          .toList();
      _isloading = false;
      // print("this is ${_reminderitem![0].date}");
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

    loadReminderstrue(String userid) async {
    try {
      final response = await _databases.listDocuments(
          collectionId: Appconstants.collectionID2,
          databaseId: Appconstants.dbID,
          queries: [
            Query.orderDesc('date'),
            Query.equal('userID', userid),
            Query.equal('isTrack', true)
          ]);
      _reminderitemtrue = response.documents
          .map((reminder) => ReminderModel.fromJson(reminder.data))
          .toList();
      _isloading = false;
      // print("this is ${_reminderitem![0].date}");
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  addReminder(
    String medname,
    String medid,
    String userid,
    String date,
  ) async {
    try {
      var response = await _databases.createDocument(
        collectionId: Appconstants.collectionID2,
        data: {
          'id': "",
          'medicationname': medname,
          'userID': userid,
          'date': date,
          'isTrack': false,
        },
        databaseId: Appconstants.dbID,
        documentId: ID.unique(),
      );
      final String documentId = response.$id;
      await _databases.updateDocument(
          databaseId: Appconstants.dbID,
          collectionId: Appconstants.collectionID2,
          documentId: documentId,
          data: {'id': documentId});
      print("done for adding");
      notifyListeners();
    } catch (e) {
      _isloading = false;
      if (e is AppwriteException) {
        _databases.updateDocument(
            collectionId: Appconstants.collectionID2,
            databaseId: Appconstants.dbID,
            documentId: medid,
            data: {
              'date': date,
            });
        print('done');
      } else {
        print('Unknown error: $e');
      }
      notifyListeners();
    }
  }

  updateisTrack(String medid) async {
    try {
      await _databases.updateDocument(
          databaseId: Appconstants.dbID,
          collectionId: Appconstants.collectionID2,
          documentId: medid,
          data: {'isTrack': true});
    } catch (e) {
      rethrow;
    }
  }

  void removeReminder(String documentID) async {
    try {
      final response = await _databases.deleteDocument(
          databaseId: Appconstants.dbID,
          collectionId: Appconstants.collectionID2,
          documentId: documentID);
      print('done');
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void removeReminderfromList(int index) async {
    try {
      _reminderitem!.removeAt(index);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

    void removeReminderfromListtrue(int index) async {
    try {
      _reminderitemtrue!.removeAt(index);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
