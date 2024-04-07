import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washwatch/components/subscribed_tile.dart';
import 'dart:core';

class SubscribedPage extends StatefulWidget {
  @override
  _SubscribedPage createState() => _SubscribedPage();
}

class _SubscribedPage extends State<SubscribedPage> with AutomaticKeepAliveClientMixin  {
  StreamSubscription<DatabaseEvent>? jobsHook;
  List<SubscribedTile> _subscribedMachines = [];

  @override
  bool get wantKeepAlive => true;


  @override
  void initState(){
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    jobsHook = FirebaseDatabase.instance.ref()
    .child('users/$userId/subscribed_machines')
    .onValue.listen((event) {
            List<SubscribedTile> jobs = [];
    if (event.snapshot.value != null) {
       Map<dynamic, dynamic> jobsMap = event.snapshot.value as Map<dynamic, dynamic>;
      jobsMap.forEach((key, value) {
        jobs.add( SubscribedTile(
          name: value['name'],
          status: value['status'] == true ? 'BUSY' : 'FREE',
          statusColor: getStatusColor(value['status']),
          position: value['position'],
          image: value['status'] == true ? 'lib/assets/drum.gif' : 'lib/assets/drum.png',
          )
        );
      });
    }
     setState(() {
       this._subscribedMachines = jobs;
      });
    });
  }

  String getMachineName(String machineId) {
    switch(machineId) {
      case 'aqua_sonic_deluxe':
        return 'AquaSonic Deluxe';
      case 'eco_clean_pro':
        return 'EcoClean Pro';
      case 'fresh_cycle_max':
        return 'FreshCycle Max';
      case 'turbo_wash_elite':
        return 'TurboWash Elite';
      default:
        return 'cannot arrive here';
    }
  }

  Color getStatusColor(bool status) {
    switch (status) {
      case true:
        return Colors.red;
      case false:
        return  Colors.green.shade400;
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
    body: _subscribedMachines.isEmpty
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
                  "Looks like your laundry plans are on hold! \nYou haven't subscribed to any washing machines yet.",
                  style: GoogleFonts.openSansCondensed(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: _subscribedMachines.length,
            itemBuilder: (BuildContext context, int index) {
              return _subscribedMachines[index];
            },
          ),
  );
}
}