import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washwatch/components/connection_failed_dialog.dart';

class SubscribedTile extends StatefulWidget {
  final String name;
  final String status;
  final Color statusColor;
  final int position;
  final String image;

  SubscribedTile({
    required this.name,
    required this.status,
    required this.statusColor,
    required this.position,
    required this.image
  });

  @override
  _SubscribedTile createState() => _SubscribedTile();
}

class _SubscribedTile extends State<SubscribedTile> {
  bool _dismissAllowed = true; 

  @override
  void initState() {
    super.initState();
  }

String getMachineName(String machineId) {
    switch(machineId) {
      case 'AquaSonic Deluxe':
        return 'aqua_sonic_deluxe';
      case 'EcoClean Pro':
        return 'eco_clean_pro';
      case 'TurboWash Elite':
        return 'turbo_wash_elite';
      case 'FreshCycle Max':
        return 'fresh_cycle_max';
      default:
        return 'cannot arrive here';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void unsubscribe(DismissDirection) async{
    try {
    const timeoutDuration = Duration(seconds: 10);
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    String machineId = getMachineName(widget.name);
    DatabaseReference subscribersRef = FirebaseDatabase.instance.ref().child('washing_machines/$machineId/subscribers');
    DataSnapshot snapshot = await subscribersRef.get().timeout(timeoutDuration);
    List<Object?> subscribersMap = snapshot.value as List<Object?>;
    int index = subscribersMap.indexOf(userId);
    if (index != -1) {
      await subscribersRef.child(index.toString()).remove().timeout(timeoutDuration);
    }
    await FirebaseDatabase.instance.ref().child('users/$userId/subscribed_machines/$machineId').remove().timeout(timeoutDuration);
    // Reindexing subscribers list
    Map<String, Object?> newSubscribersList = {};
    for (int i = 0; i < subscribersMap.length - 1; i++) {
      newSubscribersList[i.toString()] = subscribersMap[i + 1];
    }
    
    await subscribersRef.set(newSubscribersList);
    } catch (e) {
        setState(() {
          _dismissAllowed = false; 
        });
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



@override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(), 
      onDismissed: unsubscribe,
      direction: DismissDirection.endToStart,
            confirmDismiss: (_) async {
        return _dismissAllowed;
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Card(
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
            trailing: SizedBox(
              height: 110,
              width: 110,
              child: Image.asset(widget.image, fit: BoxFit.cover),
            ),
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
                    Icon(Icons.numbers, color: Colors.orange, size: 15,),
                    SizedBox(width: 4),
                    Text(
                      widget.position.toString(),
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
      ),
    );
  }
}