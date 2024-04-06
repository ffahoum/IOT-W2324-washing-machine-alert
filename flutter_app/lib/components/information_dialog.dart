import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './bouncing_button.dart';


class InformationDialog extends StatelessWidget {

  const InformationDialog({
    Key? key,
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
              const SizedBox(height: 10),
        const SizedBox(height: 10),
          Text(
            "How to Use",
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
          ListTile(
            leading: Icon(Icons.category, color: Colors.blueGrey[400]),
            title: Text(
              "Catalog Page",
              style: GoogleFonts.openSansCondensed(
                fontSize: 13,
                color: Colors.blueGrey[900],
              ),
            ),
            subtitle: Text(
              "Displays washing machines with metadata. Click a machine to view details like status, model, and waiting list.",
              style: GoogleFonts.openSansCondensed(
                fontSize: 14,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.schedule, color: Colors.blueGrey[400]),
            title: Text(
              "Schedule Button",
              style: GoogleFonts.openSansCondensed(
                fontSize: 13,
                color: Colors.blueGrey[900],
              ),
            ),
            subtitle: Text(
              "Allows immediate machine cycle scheduling from the catalog page.",
              style: GoogleFonts.openSansCondensed(
                fontSize: 14,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.subscriptions, color: Colors.blueGrey[400]),
            title: Text(
              "Subscribe Button",
              style: GoogleFonts.openSansCondensed(
                fontSize: 13,
                color: Colors.blueGrey[900],
              ),
            ),
            subtitle: Text(
              "Joins waiting list for machines if immediate scheduling is not possible.",
              style: GoogleFonts.openSansCondensed(
                fontSize: 14,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list_alt, color: Colors.blueGrey[400]),
            title: Text(
              "Subscribed Machines Page",
              style: GoogleFonts.openSansCondensed(
                fontSize: 13,
                color: Colors.blueGrey[900],
              ),
            ),
            subtitle: Text(
              "Shows machines user is waiting for.",
              style: GoogleFonts.openSansCondensed(
                fontSize: 13,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.assignment, color: Colors.blueGrey[400]),
            title: Text(
              "Jobs Page",
              style: GoogleFonts.openSansCondensed(
                fontSize: 14,
                color: Colors.blueGrey[900],
              ),
            ),
            subtitle: Text(
              "Lists scheduled machine cycles with real-time updates.",
              style: GoogleFonts.openSansCondensed(
                fontSize: 13,
                color: Colors.blueGrey[800],
              ),
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
          top: 60,
          right: 155, 
          child: Image.asset(
            'lib/assets/info.png',
            width: 70,
            height: 70,
          ),
        ),
      ],
    );
  }
}
