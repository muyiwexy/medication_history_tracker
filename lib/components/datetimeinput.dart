// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class DateInput extends StatefulWidget {
//   const DateInput({Key? key}) : super(key: key);

//   @override
//   _DateInputState createState() => _DateInputState();
// }

// class _DateInputState extends State<DateInput> {
//   final dateInputController = TextEditingController();
//   final timeInputController = TextEditingController();

//   @override
//   void dispose() {
//     dateInputController.dispose();
//     timeInputController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final initialDate = DateTime.now();
//     final selectedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (selectedDate == null) {
//       return;
//     }
//     final selectedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(initialDate),
//     );
//     if (selectedTime == null) {
//       return;
//     }
//     final selectedDateTime = DateTime(
//       selectedDate.year,
//       selectedDate.month,
//       selectedDate.day,
//       selectedTime.hour,
//       selectedTime.minute,
//     );
//     final formattedDateTime = DateFormat.yMd().add_jm().format(selectedDateTime);
//     setState(() {
//       dateInputController.text = formattedDateTime;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: dateInputController,
//       readOnly: true,
//       decoration: InputDecoration(
//         labelText: "Select Date and Time",
//         icon: const Icon(Icons.calendar_today),
//       ),
//       onTap: () => _selectDate(context),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return "Please select a date and time";
//         }
//         return null;
//       },
//     );
//   }
// }
