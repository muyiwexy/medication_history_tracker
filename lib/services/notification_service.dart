import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:medication_history_tracker/Authenticate/reminder_provider.dart';
import 'package:medication_history_tracker/models/remindermodel.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //NotificationService a singleton object
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = '123';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  final AndroidNotificationDetails _androidNotificationDetails =
      const AndroidNotificationDetails(
    'channel ID',
    'channel name',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  Future<void> showNotifications(String medname, String viewid) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      "Take Your Medication\nMedication Name: $medname",
      "Medication Dosage: $viewid",
      NotificationDetails(android: _androidNotificationDetails),
    );
    print("Scheduled notification for reminder with ID $viewid");
  }

  Future<void> scheduleNotifications(
      BuildContext context, List<ReminderModel> reminders) async {
    // Initialize the time zone database
    tz.initializeTimeZones();

    for (var i = 0; i < reminders.length; i++) {
      var reminder = reminders[i];
      // Convert the reminder's scheduled time to the local time zone
      DateTime dateTime = DateFormat("MM/dd/yyyy H:mm").parse(reminder.date!);
      int secondsDifference = dateTime.difference(DateTime.now()).inSeconds;
      print(secondsDifference);
      if (secondsDifference < 0) {
        reminders.removeAt(i);
        i--;
        continue;
      }
      // Schedule a notification for the reminder
      flutterLocalNotificationsPlugin.zonedSchedule(
          0, // Use the reminder's ID as the notification ID
          "Take Your Medication\nMedication Name: ${reminder.medicationname}",
          "Medication Dosage: ${reminder.date}",
          tz.TZDateTime.now(tz.local).add(Duration(seconds: secondsDifference)),
          NotificationDetails(android: _androidNotificationDetails),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);

      // Print a message to the console indicating that the notification was scheduled
      print("Scheduled notification for reminder with ID ${reminder.id}");
      // int mainindex = reminders.indexWhere((timerer) => timerer.id == reminder.id);
      // reminders.removeAt(mainindex);
      // int index = reminders.indexWhere((timerer) => timerer.id == reminder.id);
      // print("this is ${index+1}");
      // var reminderid = reminder.id!;
      ReminderProvider state3 =
          Provider.of<ReminderProvider>(context, listen: false);
      await state3.updateisTrack(reminder.id.toString());
    }
  }

  Future<void> cancelNotifications(String id) async {
    await flutterLocalNotificationsPlugin.cancel(int.parse(id));
    print("object done");
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

Future selectNotification(String payload) async {
  //handle your logic here
}
