import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:js' as js;
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:medication_history_tracker/Authenticate/app_provider.dart';
import 'package:medication_history_tracker/Authenticate/user_reg_provider.dart';
import 'package:medication_history_tracker/components/medicine_details.dart';
import 'package:medication_history_tracker/components/userinfodisplay.dart';
import 'package:provider/provider.dart';

class RegisterMedication extends StatefulWidget {
  const RegisterMedication({super.key});

  @override
  State<RegisterMedication> createState() => _RegisterMedicationState();
}

class _RegisterMedicationState extends State<RegisterMedication> {
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
              appBar: AppBar(),
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
                UserInfoDisplay(),
                MedcineDetails(),
              ],
            ));
      },
    );
  }
}