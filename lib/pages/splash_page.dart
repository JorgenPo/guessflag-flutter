import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 96, 125, 139)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultTextStyle(
                style: const TextStyle(fontSize: 40), child: Text(AppLocalizations.of(context)!.guessFlag)),
            const SizedBox(
              height: 30,
            ),
            const SpinKitRing(color: Color.fromARGB(255, 69, 90, 100))
          ],
        ));
  }
}
