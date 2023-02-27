import 'dart:async';
import 'dart:js';
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medication_history_tracker/Authenticate/app_provider.dart';
import 'package:medication_history_tracker/Authenticate/reminder_provider.dart';
import 'package:medication_history_tracker/Authenticate/user_reg_provider.dart';
import 'package:medication_history_tracker/pages/user_home.dart';
import 'package:medication_history_tracker/pages/user_login.dart';
import 'package:medication_history_tracker/routers/routerclass.dart';
import 'package:medication_history_tracker/services/notification_service.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserRegProvider(),
        lazy: false,
      ),
      ChangeNotifierProvider(
        create: (context) => AppProvider(),
        lazy: false,
      ),
      ChangeNotifierProvider(
        create: (context) => ReminderProvider(),
        lazy: false,
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: const TextTheme(
                subtitle1: TextStyle(color: Colors.pinkAccent))),
        onGenerateRoute: RouteGenerator.generateRoute,
        // initialRoute: '/page1',
        home: Consumer<UserRegProvider>(
          builder: (context, state, child) {
            if (state.isloggedin == true) {
              return const Home();
            } else {
              return const Login();
            }
          },
        )
        // CountdownTimerPage()
        );
  }
}

// class CountdownTimerPage extends StatefulWidget {
//   const CountdownTimerPage({Key? key}) : super(key: key);

//   @override
//   _CountdownTimerPageState createState() => _CountdownTimerPageState();
// }

// class _CountdownTimerPageState extends State<CountdownTimerPage> {
//   final TextEditingController _secondsController = TextEditingController();
//   final List<TimerModel> _timers = [];
//   final List<TimerModels> _timerers = [
//     TimerModels(id: 0, countdown: "02/25/2023 16:12", isRunning: true),
//     TimerModels(id: 1, countdown: "02/28/2023 16:12", isRunning: true)
//   ];
//   int _counter = 0;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();

//     // Define the startCountdown function in JavaScript
//     js.context['startCountdown'] = (int seconds, Function callback) {
//       int count = seconds;
//       _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//         if (count >= 0) {
//           callback(count);
//           count--;
//         }
//       });
//     };
//   }

//   @override
//   void dispose() {
//     _secondsController.dispose();
//     super.dispose();
//   }

// void _addTimer() {
//   for (var i = 0; i < _timerers.length; i++) {
//     var telltime = _timerers[i];
//     DateTime dateTime = DateFormat("MM/dd/yyyy H:mm").parse(telltime.countdown);
//     int secondsDifference = DateTime.now().difference(dateTime).inSeconds;
//     if (secondsDifference < 0) {
//       _timerers.removeAt(i);
//       i--;
//       continue;
//     }
//     int seconds = secondsDifference ?? 0;
//     TimerModel newTimer = TimerModel(
//         id: telltime.id, countdown: seconds, isRunning: telltime.isRunning);
//     setState(() {
//       _timers.add(newTimer);
//     });
//     js.context.callMethod('startCountdown', [
//       seconds,
//       allowInterop((seconds) => _updateCountdown(newTimer.id, seconds))
//     ]);
//   }
// }


//   void _updateCountdown(int id, int seconds) {
//     if (_timers.isEmpty) {
//       _timer!.cancel();
//       return;
//     }
//     int index = _timers.indexWhere((timer) => timer.id == id);
//     // if (index == -1) {
//     //   print("Timer with ID $id not found");
//     //   return;
//     // }
//     TimerModel updatedTimer = _timers[index].copyWith(countdown: seconds);
//     setState(() {
//       _timers[index] = updatedTimer;
//       print("${updatedTimer.id}: ${updatedTimer.countdown}");
//     });
//     if (seconds == 0) {
//       print("hello");
//       _onCountdownEnd(updatedTimer.id);
//     }
//   }

//   void _onCountdownEnd(int id) {
//     int mainindex = _timerers.indexWhere((timerer) => timerer.id == id);
//     // print(mainindex);
//     int index = _timers.indexWhere((timer) => timer.id == id);
//     setState(() {
//       _timers.removeAt(index);
//       _timerers.removeAt(mainindex);
//     });
//     if (_timers.isEmpty) {
//       _timer!.cancel();
//       print("done");
//       return;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Countdown Timer'),
//         ),
//         body: Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).pushNamed('/RegisterMedication');
//                     },
//                     child: Text("data")),
//                 Expanded(
//                   flex: 20,
//                   child: ElevatedButton(
//                     onPressed: () => showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: Text("data"),
//                           content: Container(
//                             width: MediaQuery.of(context).size.width,
//                             height: MediaQuery.of(context).size.height,
//                             child: Column(
//                               children: [
//                                 TextField(
//                                   controller: _secondsController,
//                                   keyboardType: TextInputType.number,
//                                   decoration: InputDecoration(
//                                     hintText: 'Enter seconds',
//                                     border: OutlineInputBorder(),
//                                   ),
//                                 ),
//                                 SizedBox(height: 16),
//                               ],
//                             ),
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 _addTimer();
//                                 Navigator.pop(context);
//                               },
//                               child: Text("Done"),
//                             )
//                           ],
//                         );
//                       },
//                     ),
//                     child: Text("Add Timer"),
//                   ),
//                 ),
//                 Expanded(
//                     flex: 80,
//                     child: Row(
//                       children: [
//                         Expanded(
//                             flex: 50,
//                             child: Container(
//                               color: Colors.red,
//                               child:
//                                   _timers.isEmpty // Check if the list is empty
//                                       ? Center(
//                                           child: Text('No timers found.'),
//                                         )
//                                       : ListView.builder(
//                                           itemCount: _timers.length,
//                                           itemBuilder: (context, index) {
//                                             final timer = _timers[index];
//                                             return ListTile(
//                                               title: Text('Timer ${timer.id}'),
//                                               subtitle: Text(
//                                                   '${timer.countdown} seconds left'),
//                                               trailing: IconButton(
//                                                 icon: Icon(Icons.delete),
//                                                 onPressed: () =>
//                                                     _onCountdownEnd(timer.id),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                             )),
//                         Expanded(
//                             flex: 50,
//                             child: Container(
//                               color: Colors.green,
//                             ))
//                       ],
//                     )),
//               ],
//             )));
//   }
// }

// class TimerModels {
//   final int id;
//   final String countdown;
//   final bool isRunning;

//   TimerModels({
//     required this.id,
//     required this.countdown,
//     required this.isRunning,
//   });
// }

// class TimerModel {
//   final int id;
//   final int countdown;
//   final bool isRunning;

//   TimerModel({
//     required this.id,
//     required this.countdown,
//     required this.isRunning,
//   });

//   TimerModel copyWith({
//     int? countdown,
//     bool? isRunning,
//   }) {
//     return TimerModel(
//       id: this.id,
//       countdown: countdown ?? this.countdown,
//       isRunning: isRunning ?? this.isRunning,
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Reminder App',
//       home: ReminderScreen(),
//     );
//   }
// }

// class ReminderScreen extends StatefulWidget {
//   @override
//   _ReminderScreenState createState() => _ReminderScreenState();
// }

// class _ReminderScreenState extends State<ReminderScreen> {
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//   TextEditingController reminderController = TextEditingController();
//   DateTime selectedDateTime = DateTime.now();
//   bool switchValue = false;

//   @override
//   void initState() {
//     super.initState();
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     var android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initSettings = InitializationSettings(android: android);
//     flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//     );
//   }

//   Future onSelectNotification(String payload) async {
//     debugPrint("payload: $payload");
//   }

//   Future<void> scheduleNotification(
//       String message, DateTime reminderTime, bool isRecurring) async {
//     var androidDetails = AndroidNotificationDetails(
//         'channel_id', 'channel_name',
//         importance: Importance.high);
//     // var iosDetails = IOSNotificationDetails();
//     var platformDetails = NotificationDetails(android: androidDetails);
//     if (isRecurring) {
//       await flutterLocalNotificationsPlugin.periodicallyShow(
//           0, 'Reminder', message, RepeatInterval.everyMinute, platformDetails,
//           androidAllowWhileIdle: true);
//     } else {
//       await flutterLocalNotificationsPlugin.schedule(
//           0, 'Reminder', message, reminderTime, platformDetails,
//           androidAllowWhileIdle: true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reminder App'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: reminderController,
//               decoration: InputDecoration(
//                 labelText: 'Reminder Message',
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Text('Reminder Time:'),
//             SizedBox(height: 8.0),
//             RaisedButton(
//               onPressed: () async {
//                 DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: selectedDateTime,
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime(2100));
//                 if (picked != null) {
//                   TimeOfDay? time = await showTimePicker(
//                       context: context, initialTime: TimeOfDay.now());
//                   if (time != null) {
//                     setState(() {
//                       selectedDateTime = DateTime(picked.year, picked.month,
//                           picked.day, time.hour, time.minute);
//                     });
//                   }
//                 }
//               },
//               child: Text(
//                   '${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year} ${selectedDateTime.hour}:${selectedDateTime.minute}'),
//             ),
//             SizedBox(height: 16.0),
//             Row(
//               children: [
//                 Text('Recurring?'),
//                 SizedBox(width: 16.0),
//                 Switch(
//                   value: switchValue,
//                   onChanged: (bool value) {
//                     setState(() {
//                       switchValue = value;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             RaisedButton(
//               onPressed: () {
//                 String message = reminderController.text;
//                 DateTime reminderTime = selectedDateTime;
//                 bool isRecurring = switchValue;
//                 scheduleNotification(message, reminderTime, isRecurring);
//               },
//               child: Text('Set Reminder'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
