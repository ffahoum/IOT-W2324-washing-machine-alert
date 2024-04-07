import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washwatch/components/job_tile.dart';
import 'dart:core';

class JobsPage extends StatefulWidget {
  @override
  _JobsPage createState() => _JobsPage();
}

class _JobsPage extends State<JobsPage> with AutomaticKeepAliveClientMixin{
  StreamSubscription<DatabaseEvent>? jobsHook;
  List<JobTile> _scheduledJobs = [];


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    jobsHook = FirebaseDatabase.instance.ref()
    .child('users/$userId/jobs')
    .onValue.listen((event) {
            List<JobTile> jobs = [];
    if (event.snapshot.value != null) {
       Map<dynamic, dynamic> jobsMap = event.snapshot.value as Map<dynamic, dynamic>;
      jobsMap.forEach((key, value) {
        jobs.add( JobTile(
          name: value['name'],
          intensity: value['intensity'],
          option: value['option'],
          status: value['status'],
          statusColor: getStatusColor(value['status']),
          duration: DateTime.fromMillisecondsSinceEpoch(value['start_time']).add(Duration(minutes: getOptionMins(value['option']), seconds: -1))
          )
        );
      });
    }
         setState(() {
       this._scheduledJobs = jobs;
      });
    });
  }

  int getOptionMins(String option) {
    switch(option) {
      case "Quick Wash":
      return 3;
      case "Normal Wash":
      return 5;
      case "Delicate Wash":
      return 10;
      default:
      return 10;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'In Progress':
        return Colors.green.shade400;
      case 'Processing':
          return  Color.fromARGB(255, 255, 162, 41);
      case 'Error':
          return Colors.red;
      default:
          return Colors.black;
    }
  }

  @override
  void dispose() { 
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  super.build(context);
  return Scaffold(
    body: _scheduledJobs.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                'lib/assets/laundry-basket.png',
                width: 150,
                height: 150,
              ),
                SizedBox(height: 20),
                Text(
                  "No laundry day blues here!\nYour laundry basket is feeling light and happy.",
                  style: GoogleFonts.openSansCondensed(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: _scheduledJobs.length,
            itemBuilder: (BuildContext context, int index) {
              return _scheduledJobs[index];
            },
          ),
  );
}
}