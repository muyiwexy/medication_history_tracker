import 'package:flutter/material.dart';

class MediDetails extends StatefulWidget {
  const MediDetails({super.key});

  @override
  State<MediDetails> createState() => _MediDetailsState();
}

class _MediDetailsState extends State<MediDetails> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  flex: 50,
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 0),
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/RegisterMedication');
                        },
                        
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image:
                                      AssetImage('images/registermedimage.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  // color: Colors.black.withOpacity(0.5),
                                  child: const Text(
                                    'Add Medication Information',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))),
              Expanded(
                  flex: 50,
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 0),
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/TrackMedication');
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'images/trackmedicationimage.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  // color: Colors.black.withOpacity(0.5),
                                  child: const Text(
                                    'Track Medication Information',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))),
            ],
          )),
    );
  }
}
