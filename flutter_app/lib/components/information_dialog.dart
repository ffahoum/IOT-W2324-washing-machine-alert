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
            leading: Icon(Icons.category, color: Colors.blueGrey[400], size: 40),
            title: Text(
              "Catalog Page",
              style: GoogleFonts.openSansCondensed(
                fontSize: 13,
                color: Colors.blueGrey[900],
              fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "Show supported washing machines. Click on the tile to show more info.",
              style: GoogleFonts.openSansCondensed(
                fontSize: 14,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.schedule, color: Colors.blueGrey[400], size: 40),
            title: Text(
              "Schedule",
              style: GoogleFonts.openSansCondensed(
                fontSize: 13,
                color: Colors.blueGrey[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "Reserve and start a washing cycle.",
              style: GoogleFonts.openSansCondensed(
                fontSize: 14,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.subscriptions, color: Colors.blueGrey[400], size: 40),
            title: Text(
              "Subscribe",
              style: GoogleFonts.openSansCondensed(
                fontSize: 13,
                color: Colors.blueGrey[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "Join the waiting list if the washing machine is reserved or busy.",
              style: GoogleFonts.openSansCondensed(
                fontSize: 14,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list_alt, color: Colors.blueGrey[400], size: 40),
            title: Text(
              "My Subscribed Washing Machines",
              style: GoogleFonts.openSansCondensed(
                fontSize: 13,
                color: Colors.blueGrey[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "Display the machines that you are subscribed to.",
              style: GoogleFonts.openSansCondensed(
                fontSize: 13,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.assignment, color: Colors.blueGrey[400], size: 40),
            title: Text(
              "Active Washing Machines",
              style: GoogleFonts.openSansCondensed(
                fontSize: 14,
                color: Colors.blueGrey[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "A list of the on-going reserved washing machines.",
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
