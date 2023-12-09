import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
        decoration: BoxDecoration(color: Color.fromARGB(255, 96, 125, 139)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultTextStyle(
                style: TextStyle(fontSize: 40), child: Text("GuessFlag")),
            SizedBox(
              height: 30,
            ),
            SpinKitRing(color: Color.fromARGB(255, 69, 90, 100))
          ],
        ));
  }
}
