import 'package:flutter/material.dart';
import 'package:medication_history_tracker/pages/component_pages/register_medication.dart';
import 'package:medication_history_tracker/pages/component_pages/track_medication.dart';
import 'package:medication_history_tracker/pages/user_home.dart';
import 'package:medication_history_tracker/pages/user_login.dart';
import 'package:medication_history_tracker/pages/user_signup.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting the arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/Login':
        return MaterialPageRoute(builder: (_) => const Login());
      case '/Signup':
        // Checking if the argument is of type String
        return MaterialPageRoute(builder: (_) => const Signup());
      // if (args is String) {

      // }
      // If args is not of type String, return an error page
      // return _errorRoute();
      case '/RegisterMedication':
        return MaterialPageRoute(builder: (_) => const RegisterMedication());
      case '/TrackMedication':
        return MaterialPageRoute(builder: (_) => const TrackMedication());
      default:
        // If there is no such named route, return an error page
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: const Center(
                child: Text('Oops! Something went wrong.'),
              ),
            ));
  }
}
