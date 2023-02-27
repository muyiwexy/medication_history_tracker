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
  final NotificationService _notificationService = NotificationService();

  bool get isAtLeastOneChecked =>
      widget.meditem!.any((element) => element.check == true);

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
  }

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
            },
            child: const Text(
              "Close",
              style: TextStyle(fontSize: 20),
            )),
        TextButton(
          onPressed: isAtLeastOneChecked
              ? () async {
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
