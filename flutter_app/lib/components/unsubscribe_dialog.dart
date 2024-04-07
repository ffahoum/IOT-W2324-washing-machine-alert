import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bouncing_button.dart';
import 'package:firebase_database/firebase_database.dart';
import './progress_indicator.dart';
import './connection_failed_dialog.dart';

class UnsubscribeDialog extends StatefulWidget {
  @override
  _UnsubscribeDialogState createState() => _UnsubscribeDialogState();
}

class _UnsubscribeDialogState extends State<UnsubscribeDialog> {
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  void unsubscribe(BuildContext context) async {
    try {
      const timeoutDuration = Duration(seconds: 10);
      final database = FirebaseDatabase.instance.ref();
      await database.child('washing_machines/default_id/subscribers').remove().timeout(timeoutDuration);
      Navigator.pop(context);
      Navigator.pop(context, true);
    } catch (e) {
      Navigator.pop(context);
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ConnectionFailedDialog(
          title: "Unubscription Failed",
          body: "We couldn't complete your unsubscription due to a network issue. Please check your internet connection and try again later.",
        );
      },
    );  
    }
  }

  void cancelCallback(BuildContext context) {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Are you sure you want to unsubscribe ?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Don't leave us hanging!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Stick around for more spins and surprises.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 11,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BouncingButton(
                      onTap: () => unsubscribe(context),
                      text: 'Unsubscribe',
                    ),
                    const SizedBox(width: 5),
                    BouncingButton(
                      onTap: () => cancelCallback(context),
                      text: 'Cancel',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 165,
            child: Image.asset(
              'lib/assets/unsubscribe.png',
              width: 50,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
