import 'package:flutter/material.dart';
import 'package:medication_history_tracker/Authenticate/reminder_provider.dart';
import 'package:medication_history_tracker/Authenticate/user_reg_provider.dart';
import 'package:medication_history_tracker/components/new_alert_dialog.dart';
import 'package:medication_history_tracker/components/spacers.dart';
import 'package:medication_history_tracker/components/userinfodisplay.dart';
import 'package:medication_history_tracker/models/medicationhistory.dart';
import 'package:provider/provider.dart';

import '../../Authenticate/app_provider.dart';

class TrackMedication extends StatefulWidget {
  const TrackMedication({super.key});

  @override
  State<TrackMedication> createState() => _TrackMedicationState();
}

class _TrackMedicationState extends State<TrackMedication> {
  List<Medications> data = [];

  @override
  void initState() {
    UserRegProvider state1 = Provider.of(context, listen: false);
    AppProvider state2 = Provider.of(context, listen: false);
    state2.loadMedication(
      state1.user!.id!,
    );
    // UserRegProvider state1 = Provider.of(context, listen: false);
    // AppProvider state2 = Provider.of(context, listen: false);
    // state2.loadMedication(
    //   state1.user!.id!,
    // );
    // data = state2.meditem!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserRegProvider>(
      builder: (context, state1, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.lightBlueAccent,
              Color.fromARGB(255, 196, 66, 219),
              Colors.deepOrange
            ], begin: Alignment.topLeft, end: Alignment.bottomLeft),
          ),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                  child: state1.isloading == true
                      ? circularloader()
                      : appcontainer(context))),
        );
      },
    );
  }

  Widget circularloader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget appcontainer(BuildContext context) {
    return Consumer2<UserRegProvider, AppProvider>(
      builder: (context, value, value2, child) {
        return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin:
                const EdgeInsets.only(left: 50, right: 50, top: 25, bottom: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: const Color.fromARGB(238, 238, 232, 198),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const UserInfoDisplay(),
                Expanded(
                    flex: 20,
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 0),
                        // padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: SizedBox(child: Consumer3<UserRegProvider,
                              AppProvider, ReminderProvider>(
                            builder: (context, state1, state2, state3, child) {
                              return ElevatedButton(
                                  onPressed: () async {
                                    final selectedName = await showDialog(
                                        context: context,
                                        builder: ((
                                          context,
                                        ) {
                                          return NewAlertDialog(
                                              user: state1.user,
                                              meditem: state2.meditem,
                                              reminderstate: state3);
                                        }));
                                    if (selectedName != null) {
                                      setState(() {
                                        data = selectedName;
                                        print(
                                          Text("gotten data ${data[0].userID}"),
                                        );
                                      });
                                    }
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  207, 255, 255, 255))),
                                  child: const Text(
                                    "Track Medication",
                                    style: TextStyle(color: Colors.black54),
                                  ));
                            },
                          )),
                        ))),
                Expanded(
                    flex: 80,
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 0),
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 50,
                                child: Container(
                                  color: Colors.red,
                                  child: Column(
                                    children: [
                                      Text("OverDue"),
                                      spacerheight20(),
                                      Expanded(
                                          child: Consumer<ReminderProvider>(
                                        builder: (context, state3, child) {
                                          return Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              92,
                                                              92,
                                                              92))),
                                              child: state3.reminderitem != null
                                                  ? reminderList(state3)
                                                  : null);
                                        },
                                      ))
                                    ],
                                  ),
                                )),
                            Expanded(
                                flex: 50,
                                child: Container(
                                  color: Colors.green,
                                  child: Column(
                                    children: [
                                      Text("Currently Tracking"),
                                      spacerheight20(),
                                      Expanded(
                                          child: Consumer<ReminderProvider>(
                                        builder: (context, state3, child) {
                                          return Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              92,
                                                              92,
                                                              92))),
                                              child: state3.reminderitem != null
                                                  ? reminderListtrue(state3)
                                                  : null);
                                        },
                                      ))
                                    ],
                                  ),
                                ))
                          ],
                        )))
              ],
            ));
      },
    );
  }

  Widget reminderList(state3) {
    return ListView.builder(
      itemCount: state3.reminderitem.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(state3.reminderitem[index].medicationname),
          subtitle: Text(state3.reminderitem[index].date),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => state3.removeReminderfromList(index),
          ),
        );
      },
    );
  }

  Widget reminderListtrue(state3) {
    return ListView.builder(
      itemCount: state3.reminderitemtrue.length,
      controller: ScrollController(),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(state3.reminderitemtrue[index].medicationname),
          subtitle: Text(state3.reminderitemtrue[index].date),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => state3.removeReminderfromListtrue(index),
          ),
        );
      },
    );
  }
}
