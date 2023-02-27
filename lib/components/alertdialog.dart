// import 'dart:async';
// import 'dart:io';
// import 'dart:isolate';
// import 'dart:js' as js;
// import 'dart:js';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:medication_history_tracker/Authenticate/app_provider.dart';
// import 'package:medication_history_tracker/Authenticate/reminder_provider.dart';
// import 'package:medication_history_tracker/Authenticate/user_reg_provider.dart';
// import 'package:medication_history_tracker/components/spacers.dart';
// import 'package:medication_history_tracker/models/medicationhistory.dart';
// import 'package:medication_history_tracker/services/notification_service.dart';
// import 'package:provider/provider.dart';

// class AlertdialogBody extends StatefulWidget {
//   AlertdialogBody({required this.data, super.key});
//   late List<Medications> data;

//   @override
//   State<AlertdialogBody> createState() => _AlertdialogBodyState();
// }

// class _AlertdialogBodyState extends State<AlertdialogBody> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   // List<Medications>? data;
//   final intervalController = TextEditingController();
//   final dateinput = TextEditingController();
//   final NotificationService _notificationService = NotificationService();
//   double _interval = 0.0;
//   int _countdown = 0;
//   // Timer? timer;

//   @override
//   void initState() {
//     super.initState();
//     // UserRegProvider state1 = Provider.of(context, listen: false);
//     // AppProvider state2 = Provider.of(context, listen: false);
//     // state2.loadMedication(
//     //   state1.user!.id!,
//     // );
//     // data = state2.meditem;

//     // Define the startCountdown function in JavaScript
//     js.context['startCountdown'] = (int seconds, String medname, String viewid,
//         Function callback, Function onCountdownFinished) {
//       int count = seconds;
//       Timer.periodic(Duration(seconds: 1), (timer) {
//         if (count >= 0) {
//           callback(count);
//           count--;
//         } else {
//           timer.cancel();
//           onCountdownFinished(widget.data, medname, viewid);
//         }
//       });
//     };
//     print("initstate: $_countdown");
//     print("initstate: $widget.data");
//   }

//   @override
//   void dispose() {
//     dateinput.dispose();
//     super.dispose();
//   }

//   void _updateCountdown(int seconds) {
//     // if (mounted) {

//     // }
//     setState(() {
//       _countdown = seconds;
//       print("this is $_countdown");
//       // if (_countdown == 0) {
//       //   _onCountdownFinished();
//       // }
//     });
//   }

//   void onCountdownFinished(
//       List<Medications> data, String medname, String viewid) {
//     if (mounted) {
//       // Do something when the countdown finishes
//       _notificationService.showNotifications(medname, viewid);
//       print('Countdown finished! $data, $medname');
//     }
//   }

//   void _selectOption(int index) {
//     if (mounted) {
//       setState(() {
//         for (int i = 0; i < widget.data!.length; i++) {
//           if (i == index) {
//             widget.data![i].check = true;
//           } else {
//             widget.data![i].check = false;
//           }
//         }
//       });
//     }
//   }

//   bool get isAtLeastOneChecked =>
//       widget.data!.any((element) => element.check == true);
//   bool get isAtLeastOneCheckeds {
//     bool isAnyChecked = false;
//     bool isOtherChecked = false;

//     for (final element in widget.data!) {
//       if (element.check!) {
//         isAnyChecked = true;

//         if (element.isTrack == true) {
//           isOtherChecked = true;
//           break;
//         }
//       }
//     }

//     return isAnyChecked && isOtherChecked;
//   }

//   List? get selectedName {
//     final selectedOptions =
//         widget.data?.where((element) => element.check == true).toList() ?? [];
//     print("These are: ${selectedOptions[0].id}");
//     return selectedOptions;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("titlebody"),
//       content: alerdialogcontent(isAtLeastOneCheckeds),
//       actions: <Widget>[
//         TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               // if (mounted) {

//               // }
//             },
//             child: const Text(
//               "Close",
//               style: TextStyle(fontSize: 20),
//             )),
//         TextButton(
//             onPressed: isAtLeastOneChecked
//                 ? () {
//                     Navigator.of(context).pushNamed('/RegisterMedication');
//                   }
//                 : null,
//             child: const Text(
//               "Done",
//               style: TextStyle(fontSize: 20),
//             )),
//       ],
//     );
//   }

//   Widget alerdialogcontent(isAtLeastOneCheckeds) {
//     return SizedBox(
//       width: 500,
//       height: 500,
//       child: ListView.builder(
//         itemCount: widget.data!.length,
//         shrinkWrap: true,
//         itemBuilder: (context, index) {
//           return Column(
//             children: [
//               ListTile(
//                 title: Text(
//                     "${widget.data![index].medicationname ?? ''}(Dosage: ${widget.data![index].dosages})"),
//                 subtitle: Text(widget.data![index].id ?? ''),
//                 leading: Checkbox(
//                   value: widget.data![index].check,
//                   onChanged: (newvalue) {
//                     _selectOption(index);
//                     if (mounted) {
//                       setState(() {
//                         widget.data![index].check = newvalue!;
//                         // print("checking ${data![index].userID}");
//                       });
//                     }
//                   },
//                 ),
//               ),
//               widget.data![index].check == true
//                   ? trackerandupdate(
//                       context, widget.data, index, isAtLeastOneCheckeds)
//                   : const Text("")
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget trackerandupdate(
//       BuildContext context, data, index, isAtLeastOneCheckeds) {
//     return IntrinsicHeight(
//       child: Container(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             SizedBox(
//               child: SwitchListTile(
//                 title: const Text(
//                   'Track',
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 value: data![index].isTrack!,
//                 onChanged: (value) {
//                   if (mounted) {
//                     setState(() {
//                       data![index].isTrack = value;
//                     });
//                   }
//                 },
//               ),
//             ),
//             spacerheight10(),
//             const Text(
//               'Schedule Interval Slider',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(
//                 width: 500,
//                 child: Slider(
//                   value: _interval,
//                   min: 0.0,
//                   max: 24.0,
//                   divisions: 6,
//                   label: '$_interval Hours',
//                   activeColor: Colors.pink,
//                   onChanged: (value) {
//                     if (mounted) {
//                       setState(() {
//                         _interval = value.roundToDouble();
//                         print(_interval);
//                       });
//                     }
//                   },
//                 )),
//             spacerheight10(),
//             SizedBox(
//               width: 500,
//               child: TextFormField(
//                 controller: dateinput,
//                 cursorColor: Colors.pink,
//                 decoration: InputDecoration(
//                     labelText: "Pick Starting Date",
//                     icon: const Icon(Icons.calendar_today),
//                     labelStyle: const TextStyle(color: Colors.pink),
//                     focusedBorder: const UnderlineInputBorder(
//                         borderSide: BorderSide(
//                             width: 3,
//                             color: Colors.pinkAccent,
//                             style: BorderStyle.solid)),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25.0),
//                       borderSide:
//                           const BorderSide(width: 3, color: Colors.pinkAccent),
//                     )),
//                 readOnly: true,
//                 validator: (val) {
//                   if (val!.isEmpty) {
//                     return "Name cannot be empty";
//                   } else {
//                     return null;
//                   }
//                 },
//                 onTap: () async {
//                   final initialDate = DateTime.now();
//                   final selectedDate = await showDatePicker(
//                     context: context,
//                     initialDate: initialDate,
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2101),
//                   );
//                   if (selectedDate == null) {
//                     return;
//                   }
//                   final selectedTime = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.fromDateTime(initialDate),
//                     builder: (BuildContext context, Widget? child) {
//                       return MediaQuery(
//                         data: MediaQuery.of(context)
//                             .copyWith(alwaysUse24HourFormat: true),
//                         child: child!,
//                       );
//                     },
//                     // timeFormat: TimeFormat.HH_colon_mm,
//                   );
//                   if (selectedTime == null) {
//                     return;
//                   }
//                   final selectedDateTime = DateTime(
//                     selectedDate.year,
//                     selectedDate.month,
//                     selectedDate.day,
//                     selectedTime.hour,
//                     selectedTime.minute,
//                   );
//                   final formattedDateTime =
//                       DateFormat('MM/dd/yyyy H:mm').format(selectedDateTime);
//                   if (mounted) {
//                     setState(() {
//                       dateinput.text = formattedDateTime;
//                       print(dateinput.text);
//                     });
//                   }
//                 },
//                 keyboardType: TextInputType.number,
//                 inputFormatters: <TextInputFormatter>[
//                   FilteringTextInputFormatter.digitsOnly
//                 ],
//                 style: const TextStyle(
//                   fontFamily: "Poppins",
//                 ),
//               ),
//             ),
//             spacerheight10(),
//             Consumer2<AppProvider, ReminderProvider>(
//               builder: (context, state2, state3, child) {
//                 return ElevatedButton(
//                   onPressed: isAtLeastOneCheckeds
//                       ? () async {
//                           // final reminder = Reminder(
//                           //   title: data![index].medicationname,
//                           //   description: int.tryParse(intervalController.text)!,
//                           //   date: dateinput.text,
//                           // );
//                           // final reminderManager = Provider.of<ReminderProvider>(
//                           //     context,
//                           //     listen: false);
//                           DateTime dateTime = DateFormat("MM/dd/yyyy H:mm")
//                               .parse(dateinput.text);
//                           int secondsDifference = dateTime
//                               .difference(DateTime.now())
//                               .abs()
//                               .inSeconds;
//                           print(secondsDifference);
//                           // int seconds =
//                           //     int.tryParse(_secondsController.text) ?? 0;
//                           js.context.callMethod('startCountdown', [
//                             secondsDifference,
//                             data![index].medicationname,
//                             data![index].id,
//                             allowInterop(_updateCountdown),
//                             allowInterop(onCountdownFinished)
//                           ]);
//                           await state3.addReminder(
//                               data![index].medicationname,
//                               data![index].userID,
//                               data![index].id,
//                               secondsDifference,
//                               dateinput.text);
//                           // await state2.setIsTrack(
//                           //     data![index].id, data![index].isTrack);
//                           print("this is ${data![index].isTrack!}");
//                           // await state3.loadReminders(
//                           //   data![index].userID,
//                           // );
//                           // _notificationService
//                           //     .scheduleNotifications(state3.reminderitem!);

//                           // List<String> items = ['item1', 'item2', 'item3'];

//                           // Map<String, String> jsonMap = {};
//                           // for (int i = 0; i < items.length; i++) {
//                           //   jsonMap[i.toString()] = items[i];
//                           // }

//                           // String jsonString = jsonEncode(jsonMap);
//                           // print(jsonString);

//                           // Navigator.pop(context);
//                           // AppProvider state = Provider.of(context, listen: false);
//                           // state.updateReminder(
//                           //     data![index].id!,
//                           //     data![index].isTrack!,
//                           //     int.tryParse(intervalController.text)!,
//                           //     dateinput.text);
//                           // if (data![index].isTrack! == true) {
//                           //   timer = Timer.periodic(
//                           //       Duration(seconds: int.tryParse(intervalController.text)!),
//                           //       (Timer t) =>
//                           //           state.resetupdateReminder(data![index].id!, false));
//                           //   print("done");
//                           // } else {
//                           //   print("hello");
//                           // }
//                           // timer!.cancel();
//                           // handle submit button press
//                         }
//                       : null,
//                   child: const Text('Submit'),
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }



// // Widget dropdown() {
// //   return Expanded(
// //     child: Container(
// //       color: Colors.red,
// //     ),
// //   );
// // }
