import 'package:flutter/material.dart';
import 'package:medication_history_tracker/Authenticate/user_reg_provider.dart';
import 'package:provider/provider.dart';

class UserInfoDisplay extends StatefulWidget {
  const UserInfoDisplay({super.key});

  @override
  State<UserInfoDisplay> createState() => _UserInfoDisplayState();
}

class _UserInfoDisplayState extends State<UserInfoDisplay> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
        child: Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        border: Border(
            bottom:
                BorderSide(width: 0.5, color: Color.fromARGB(255, 92, 92, 92))),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Live Medication Tracking",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          Consumer<UserRegProvider>(
            builder: (context, state, child) {
              if (state.user == null) {
                return const Text(
                  "Loggedin Admin: ",
                  style: TextStyle(fontSize: 14, color: Colors.pink),
                );
              } else {
                return Text(
                  "Loggedin Admin: ${state.user!.name ?? ''}",
                  style: const TextStyle(fontSize: 14, color: Colors.pink),
                );
              }
            },
          )
        ],
      ),
    ));
  }
}
