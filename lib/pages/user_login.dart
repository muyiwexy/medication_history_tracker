import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:medication_history_tracker/Authenticate/user_reg_provider.dart';
import 'package:medication_history_tracker/pages/user_signup.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future<void> login() async {
    try {
      UserRegProvider state = Provider.of<UserRegProvider>(context, listen: false);
      await state.login(_email.text, _password.text);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 18),
        body: SafeArea(child: buildcomponent()),
      );

  Widget circularloader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildcomponent() {
    return Center(
      child: IntrinsicHeight(
          child: Container(
              padding: const EdgeInsets.all(50.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    child: Text("Login",
                        style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                            fontSize: 22)),
                  ),
                  spacer50(),
                  SizedBox(
                    width: 500,
                    child: TextFormField(
                      controller: _email,
                      cursorColor: Colors.pink,
                      decoration: InputDecoration(
                          labelText: "Enter Email",
                          labelStyle: const TextStyle(color: Colors.pink),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.pinkAccent,
                                  style: BorderStyle.solid)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                                width: 3, color: Colors.pinkAccent),
                          )),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Name cannot be empty";
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
                  spacer20(),
                  SizedBox(
                    width: 500,
                    child: TextFormField(
                      controller: _password,
                      cursorColor: Colors.pink,
                      decoration: InputDecoration(
                          labelText: "Enter Password",
                          labelStyle: const TextStyle(color: Colors.pink),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.pinkAccent,
                                  style: BorderStyle.solid)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                                width: 3, color: Colors.pinkAccent),
                          )),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Name cannot be empty";
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
                  spacer50(),
                  Consumer<UserRegProvider>(builder: (context, state, child) {
                    return SizedBox(
                      width: 300,
                      child: Align(
                        alignment: Alignment.center,
                        child: state.isloading == true
                            ? circularloader()
                            : FloatingActionButton.extended(
                                onPressed: login,
                                label: const Text('Log in'),
                                backgroundColor: Colors.pinkAccent,
                              ),
                      ),
                    );
                  }),
                  spacer20(),
                  SizedBox(
                    width: 300,
                    child: writeredirect(),
                  )
                ],
              ))),
    );
  }

  Widget spacer20() {
    return const SizedBox(
      height: 20,
    );
  }

  Widget spacer50() {
    return const SizedBox(
      height: 50,
    );
  }

  Widget writeredirect() {
    return Align(
      alignment: Alignment.center,
      child: Text.rich(TextSpan(children: [
        const TextSpan(
            text: "New User?",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 232, 159, 184))),
        TextSpan(
            text: "  Signup!",
            style: const TextStyle(
                fontWeight: FontWeight.w900, color: Colors.pinkAccent),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Signup()))
                    ;
              })
      ])),
    );
  }
}
