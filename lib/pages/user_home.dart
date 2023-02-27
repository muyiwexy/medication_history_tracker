import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medication_history_tracker/Authenticate/app_provider.dart';
import 'package:medication_history_tracker/Authenticate/reminder_provider.dart';
import 'package:medication_history_tracker/Authenticate/user_reg_provider.dart';
import 'package:medication_history_tracker/pages/component_pages/mainbody.dart';
import 'package:medication_history_tracker/components/userinfodisplay.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Timer? timer;
  @override
  void initState() {
    UserRegProvider state1 = Provider.of(context, listen: false);
    AppProvider state2 = Provider.of(context, listen: false);
    ReminderProvider state3 = Provider.of(context, listen: false);
    state2.loadMedication(
      state1.user!.id!,
    );
    state3.loadReminders(
      state1.user!.id!,
    );
    state3.loadReminderstrue(
      state1.user!.id!,
    );
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
}

// Circular loader to check if there is a user session available
Widget circularloader() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

// if there is a session available, logged in container
Widget appcontainer(BuildContext context) {
  return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 50, right: 50, top: 25, bottom: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: const Color.fromARGB(238, 238, 232, 198),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          UserInfoDisplay(),
          MediDetails(),
        ],
      ));
}
