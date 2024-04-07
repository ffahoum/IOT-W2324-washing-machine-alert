import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './bouncing_button.dart';


class ErrorDialog extends StatelessWidget {
  final String title;
  final String body;
  final String icon;

  const ErrorDialog({
    Key? key,
    required this.title,
    required this.body,
    required this.icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          backgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoCondensed(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                body,
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoCondensed(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BouncingButton(
              onTap: () {
                Navigator.of(context).pop();
              },
              text: 'OK',
            ),
              ],
            ),
          ],
        ),
        Positioned(
          top: 270, 
          right: 170, 
          child: Image.asset(
            icon,
            width: 50,
            height: 50,
          ),
        ),
      ],
    );
  }
}
