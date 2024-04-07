import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart'; 

class JobTile extends StatefulWidget {
  final String name;
  final String intensity;
  final String option;
  final String status;
  final Color statusColor;
  final DateTime duration;

  JobTile({
    required this.name,
    required this.intensity,
    required this.option,
    required this.status,
    required this.statusColor,
    required this.duration
  });

  @override
  _JobTile createState() => _JobTile();
}

class _JobTile extends State<JobTile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), 
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 18, 106, 179).withOpacity(0.8), 
              const Color.fromARGB(255, 201, 223, 241).withOpacity(0.5), 
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          trailing: widget.status == 'In Progress' ? TimerCountdown(endTime: widget.duration, format: CountDownTimerFormat.minutesSeconds, timeTextStyle: GoogleFonts.orbitron( 
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, 
            ), colonsTextStyle: GoogleFonts.orbitron( 
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ), descriptionTextStyle: GoogleFonts.orbitron( 
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),) : null,
          title: Text(
            widget.name,
            style: GoogleFonts.openSansCondensed( 
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.flash_on, color: Colors.orange, size: 15,),
                  SizedBox(width: 4),
                  Text(
                    widget.intensity,
                    style: GoogleFonts.openSansCondensed(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.settings, color: const Color.fromARGB(255, 0, 70, 128), size: 15,),
                  SizedBox(width: 4),
                  Text(
                    widget.option,
                    style: GoogleFonts.openSansCondensed(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
               Container(
                  
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
                          color: widget.statusColor, 

          borderRadius: BorderRadius.circular(30),
        ),
            child: Text(
              widget.status,
              textAlign: TextAlign.center,
              style:  GoogleFonts.roboto(
                      fontSize: 9,
                      color: Colors.white,
                    ),
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }  
}