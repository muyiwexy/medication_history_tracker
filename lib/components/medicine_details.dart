import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medication_history_tracker/Authenticate/app_provider.dart';
import 'package:medication_history_tracker/Authenticate/user_reg_provider.dart';
import 'package:medication_history_tracker/components/spacers.dart';
import 'package:provider/provider.dart';

class MedcineDetails extends StatefulWidget {
  const MedcineDetails({super.key});

  @override
  State<MedcineDetails> createState() => _MedcineDetailsState();
}

class _MedcineDetailsState extends State<MedcineDetails> {
  final medicationNameController = TextEditingController();
  final dosageController = TextEditingController();
  bool checkbox1 = false;
  bool checkbox2 = false;
  bool checkbox3 = false;

  bool get isAtLeastOneChecked => checkbox1 || checkbox2 || checkbox3 == true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 500,
              child: TextFormField(
                controller: medicationNameController,
                cursorColor: Colors.pink,
                decoration: InputDecoration(
                    labelText: "Enter Medication name",
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
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Medication Name cannot be empty";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ),
            spacerheight10(),
            SizedBox(
              width: 500,
              child: TextFormField(
                controller: dosageController,
                textCapitalization: TextCapitalization.words,
                cursorColor: Colors.pink,
                decoration: InputDecoration(
                    labelText: "Enter Dosage (in mg)",
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
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Name cannot be empty";
                  } else {
                    return null;
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
            ListTile(
              title: const Text("Injection"),
              leading: Checkbox(
                value: checkbox1,
                onChanged: (newvalue) {
                  // _selectOption(index);
                  setState(() {
                    checkbox1 = newvalue!;
                    if (newvalue) {
                      checkbox2 = false;
                      checkbox3 = false;
                    }
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Syrup"),
              leading: Checkbox(
                value: checkbox2,
                onChanged: (newvalue) {
                  // _selectOption(index);
                  setState(() {
                    checkbox2 = newvalue!;
                    if (newvalue) {
                      checkbox1 = false;
                      checkbox3 = false;
                    }
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Tablet"),
              leading: Checkbox(
                value: checkbox3,
                onChanged: (newvalue) {
                  // _selectOption(index);
                  setState(() {
                    checkbox3 = newvalue!;
                    if (newvalue) {
                      checkbox1 = false;
                      checkbox2 = false;
                    }
                  });
                },
              ),
            ),
            spacerheight10(),
            Consumer2<UserRegProvider, AppProvider>(
              builder: (context, state1, state2, child) {
                return Container(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: isAtLeastOneChecked
                        ? () {
                            state2.addMedication(
                                medicationNameController.text,
                                state1.user!.id!,
                                int.tryParse(dosageController.text)!,
                                checkbox1,
                                checkbox3,
                                checkbox2,
    
                              );
                            setState(() {
                              medicationNameController.clear();
                              dosageController.clear();
                              checkbox1 = false;
                              checkbox2 = false;
                              checkbox3 = false;
                            });
                            // UserRegProvider state =
                            //     Provider.of(context, listen: false);
                            // if (state.user != null) {
                            //   AppProvider state1 =
                            //       Provider.of(context, listen: false);
                            //   state1.loadReminders(
                            //     state.user!.id!,
                            //   );
                            // }
                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.pinkAccent),
                    ),
                    child: state2.isloading == true
                        ? circularloader()
                        : const Text('Add Medication History'),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

Widget circularloader() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}
