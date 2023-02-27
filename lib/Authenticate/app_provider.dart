import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:medication_history_tracker/constants/app_constants.dart';
import 'package:medication_history_tracker/models/medicationhistory.dart';

class AppProvider extends ChangeNotifier {
  Client client = Client();
  late Databases _databases;
  late bool _isloading;
  List<Medications>? _meditem;

  bool get isloading => _isloading;
  List<Medications>? get meditem => _meditem;

  AppProvider() {
    _isloading = true;
    initializeclass();
  }

  initializeclass() {
    client
      ..setEndpoint(Appconstants.endpoint)
      ..setProject(Appconstants.projectid);
    _databases = Databases(client);
    _isloading = false;
  }

  loadMedication(String userid) async {
    try {
      final response = await _databases.listDocuments(
          collectionId: Appconstants.collectionID,
          databaseId: Appconstants.dbID,
          queries: [
            // Query.orderAsc('date'),
            Query.equal('userID', [userid])
          ]);
      _meditem = response.documents
          .map((meditem) => Medications.fromJson(meditem.data))
          .toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  addMedication(String medicationname, String userID, int dosages, bool isInjection,
      bool isTablet, bool isSyrup) async {
    try {
      final response = await _databases.createDocument(
        collectionId: Appconstants.collectionID,
        data: {
          'id': '',
          'medicationname': medicationname,
          'userID': userID,
          'dosages': dosages,
          'isInjection': isInjection,
          'isTablet': isTablet,
          'isSyrup': isSyrup,
          'check':false,
          'isTrack':false
        },
        databaseId: Appconstants.dbID,
        documentId: 'unique()',
      );
      final String documentId = response.$id;
      // print(documentId);
      // update the ID of the medication.
      await _databases.updateDocument(
          databaseId: Appconstants.dbID,
          collectionId: Appconstants.collectionID,
          documentId: documentId,
          data: {'id': documentId});
      if (response.$id.isNotEmpty) {
        _isloading = false;
      }

      notifyListeners();
    } catch (e) {
      _isloading = false;
      notifyListeners();
      print(e);
    }
  }

  // updateReminder(String documentId, bool isTrack, int scheduledinterval,
  //     String date) async {
  //   try {
  //     await _databases.updateDocument(
  //         databaseId: Appconstants.dbID,
  //         collectionId: Appconstants.collectionID,
  //         documentId: documentId,
  //         data: {
  //           'isTrack': isTrack,
  //           'dosages': scheduledinterval,
  //           'date': date,
  //         });
  //     print("done!");
  //     notifyListeners();
  //   } catch (e) {
  //     _isloading = false;
  //     notifyListeners();
  //     print(e);
  //   }
  // }

  setIsTrack(
    String documentId,
    bool isTrack,
  ) async {
    try {
      await _databases.updateDocument(
          databaseId: Appconstants.dbID,
          collectionId: Appconstants.collectionID,
          documentId: documentId,
          data: {
            'isTrack': isTrack,
          });
      print("done!");
      notifyListeners();
    } catch (e) {
      _isloading = false;
      notifyListeners();
      print(e);
    }
  }

  // Future<void> deleteReminder(String id) async {
  //   try {
  //     // await _databases.deleteDocument(
  //     //   collectionId: Appconstants.collectionID,
  //     //   documentId: id,
  //     //   databaseId: Appconstants.dbID,
  //     // );
  //     _meditem!.removeWhere((element) => element == id);
  //     // _meditem?.removeAt(index);
  //     print(_meditem![0].id);
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
