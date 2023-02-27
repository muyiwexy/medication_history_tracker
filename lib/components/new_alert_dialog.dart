import 'dart:async';
import 'dart:js';
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:medication_history_tracker/Authenticate/reminder_provider.dart';
import 'package:medication_history_tracker/Authenticate/user_reg_provider.dart';
import 'package:medication_history_tracker/components/spacers.dart';
import 'package:medication_history_tracker/models/medicationhistory.dart';
import 'package:medication_history_tracker/models/remindermodel.dart';
import 'package:medication_history_tracker/models/userdata.dart';
import 'package:medication_history_tracker/services/notification_service.dart';
import 'package:provider/provider.dart';

class NewAlertDialog extends StatefulWidget {
  const NewAlertDialog(
      {required this.user,
      required this.meditem,
      required this.reminderstate,
      super.key});
  final User? user;
  final List<Medications>? meditem;
  final ReminderProvider reminderstate;

  @override
  State<NewAlertDialog> createState() => _NewAlertDialogState();
}

class _NewAlertDialogState extends State<NewAlertDialog> {
  TextEditingController dateinput = TextEditingController();
  // final List<TimerModel> _timers = [];
  final NotificationService _notificationService = NotificationService();
  // Timer? _timer;

  // @override
  // void initState() {
  //   super.initState();
  //   // Define the startCountdown function in JavaScript
  //   js.context['startCountdown'] = (int seconds, Function callback) {
  //     int count = seconds;
  //     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //       if (count >= 0) {
  //         callback(count);
  //         count--;
  //       }
  //     });
  //   };
  // }

  bool get isAtLeastOneChecked =>
      widget.meditem!.any((element) => element.check == true);

  // bool get checkedisTracking {
  //   bool isAnyChecked = false;
  //   bool isOtherChecked = false;

  //   for (final element in widget.meditem!) {
  //     if (element.check!) {
  //       isAnyChecked = true;

  //       if (element.isTrack == true) {
  //         isOtherChecked = true;
  //         break;
  //       }
  //     }
  //   }

  //   return isAnyChecked && isOtherChecked;
  // }

  void _selectOption(int index) {
    if (mounted) {
      setState(() {
        for (int i = 0; i < widget.meditem!.length; i++) {
          if (i == index) {
            widget.meditem![i].check = true;
          } else {
            widget.meditem![i].check = false;
          }
        }
      });
    }
  }

  List? get selectedName {
    final selectedOptions =
        widget.meditem!.where((element) => element.check == true).toList();
    print("These are: ${selectedOptions[0].id}");
    return selectedOptions;
  }

  void submitButtonAction(int index) async {
    int idMaker = widget.reminderstate.reminderitem!.length + 1;
    print(idMaker);
    await widget.reminderstate.addReminder(
        widget.meditem![index].medicationname!,
        widget.meditem![index].id!,
        widget.meditem![index].userID!,
        dateinput.text);
    // await widget.reminderstate.loadReminders(widget.user!.id!);
  }
  

  // void _addTimer() {
  //   for (var i = 0; i < widget.reminderstate.reminderitem!.length; i++) {
  //     var telltime = widget.reminderstate.reminderitem![i];
  //     DateTime dateTime = DateFormat("MM/dd/yyyy H:mm").parse(telltime.date!);
  //     int secondsDifference = DateTime.now().difference(dateTime).inSeconds;
  //     if (secondsDifference < 0) {
  //       widget.reminderstate.reminderitem!.removeAt(i);
  //       i--;
  //       continue;
  //     }
  //     int seconds = secondsDifference;
  //     TimerModel newTimer =
  //         TimerModel(id: telltime.id!, countdown: seconds, isRunning: true);
  //     setState(() {
  //       _timers.add(newTimer);
  //     });
  //     js.context.callMethod('startCountdown', [
  //       seconds,
  //       allowInterop((seconds) => _updateCountdown(newTimer.id, seconds))
  //     ]);
  //   }
  // }

  // void _updateCountdown(int id, int seconds) {
  //   if (_timers.isEmpty) {
  //     _timer!.cancel();
  //     return;
  //   }
  //   int index = _timers.indexWhere((timer) => timer.id == id);
  //   // if (index == -1) {
  //   //   print("Timer with ID $id not found");
  //   //   return;
  //   // }
  //   TimerModel updatedTimer = _timers[index].copyWith(countdown: seconds);
  //   setState(() {
  //     _timers[index] = updatedTimer;
  //     print("${updatedTimer.id}: ${updatedTimer.countdown}");
  //   });
  //   if (seconds == 0) {
  //     print("hello");
  //     _onCountdownEnd(updatedTimer.id);
  //   }
  // }

  // void _onCountdownEnd(int id) {
  //   int mainindex = widget.reminderstate.reminderitem!
  //       .indexWhere((timerer) => timerer.id == id);
  //   // print(mainindex);
  //   int index = _timers.indexWhere((timer) => timer.id == id);
  //   setState(() {
  //     _timers.removeAt(index);
  //     widget.reminderstate.reminderitem!.removeAt(mainindex);
  //   });
  //   if (_timers.isEmpty) {
  //     _timer!.cancel();
  //     print("done");
  //     return;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Medication List"),
      content: widget.meditem != null
          ? medicationcontent()
          : const Center(
              child: Text(
                  "You have not Registered any user or You are not connected\nCheck your connection settings!"),
            ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // if (mounted) {

              // }
            },
            child: const Text(
              "Close",
              style: TextStyle(fontSize: 20),
            )),
        TextButton(
          onPressed: isAtLeastOneChecked
              ? () async {
                  // _addTimer();
                  await widget.reminderstate.loadReminders(widget.user!.id!);
                  if (mounted) {
                    await _notificationService.scheduleNotifications(
                        context, widget.reminderstate.reminderitem!);
                  }
                  await widget.reminderstate.loadReminders(widget.user!.id!);
                  await widget.reminderstate.loadReminderstrue(widget.user!.id!);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              : null,
          child: const Text("Done", style: TextStyle(fontSize: 20)),
        )
      ],
    );
  }

  Widget medicationcontent() {
    return SizedBox(
      width: 500,
      height: 500,
      child: ListView.builder(
        itemCount: widget.meditem!.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(
                    "${widget.meditem![index].medicationname ?? ''}(Dosage: ${widget.meditem![index].dosages})"),
                subtitle: Text(widget.meditem![index].id ?? ''),
                leading: Checkbox(
                  value: widget.meditem![index].check,
                  onChanged: (newvalue) {
                    _selectOption(index);
                    setState(() {
                      widget.meditem![index].check = newvalue!;
                    });
                  },
                ),
              ),
              widget.meditem![index].check == true
                  ? setReminder(context, index)
                  : const Text("")
            ],
          );
        },
      ),
    );
  }

  Widget setReminder(BuildContext context, index) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // SizedBox(
            //   child: SwitchListTile(
            //     title: const Text(
            //       'Track',
            //       style: TextStyle(
            //         fontSize: 18.0,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     value: widget.meditem![index].isTrack!,
            //     onChanged: (value) {
            //       if (mounted) {
            //         setState(() {
            //           widget.meditem![index].isTrack = value;
            //         });
            //       }
            //     },
            //   ),
            // ),
            spacerheight10(),
            SizedBox(
              width: 500,
              child: TextFormField(
                controller: dateinput,
                cursorColor: Colors.pink,
                decoration: InputDecoration(
                    labelText: "Pick Starting Date",
                    icon: const Icon(Icons.calendar_today),
                    labelStyle: const TextStyle(color: Colors.pink),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Colors.pinkAccent,
                            style: BorderStyle.solid)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          const BorderSide(width: 3, color: Colors.pinkAccent),
                    )),
                readOnly: true,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Name cannot be empty";
                  } else {
                    return null;
                  }
                },
                onTap: () async {
                  final initialDate = DateTime.now();
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate == null) {
                    return;
                  }
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(initialDate),
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    },
                  );
                  if (selectedTime == null) {
                    return;
                  }
                  final selectedDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  final formattedDateTime =
                      DateFormat('MM/dd/yyyy H:mm').format(selectedDateTime);
                  if (mounted) {
                    setState(() {
                      dateinput.text = formattedDateTime;
                      print(dateinput.text);
                    });
                  }
                },
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                style: const TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ),
            spacerheight10(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  submitButtonAction(index);
                  dateinput.clear();
                },
                child: const Text("Submit"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TimerModel {
  final int id;
  final int countdown;
  final bool isRunning;

  TimerModel({
    required this.id,
    required this.countdown,
    required this.isRunning,
  });

  TimerModel copyWith({
    int? countdown,
    bool? isRunning,
  }) {
    return TimerModel(
      id: this.id,
      countdown: countdown ?? this.countdown,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
