import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/subscription_dialog.dart';
import '../components/scheduling_dialog.dart';
import 'package:connectivity/connectivity.dart';
import '../components/card.dart';
import '../components/customized_button.dart';

class SubscribeButton extends StatefulWidget {
  const SubscribeButton({
    Key? key,
    required this.icon,
    this.margin,
    this.color,
    this.pressed,
    this.disabled,
    
    required this.initiallySubscribed,
    required this.subscriptionCallback,
  }) : super(key: key);

  final Icon icon;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final bool? pressed;
  final bool? disabled;
  final bool initiallySubscribed;
  final Function(bool) subscriptionCallback;

  @override
  _SubscribeButton createState() => _SubscribeButton();
}

class _SubscribeButton extends State<SubscribeButton> {
  late bool isSubscribed;

  @override
  void initState() {
    super.initState();
    isSubscribed = widget.initiallySubscribed;
  }

  void toggleSubscription() {
    subscribeUser();
  }

  void subscribeUser() async {
    final result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SubscriptionDialog();
      },
    );
    if (result != null) {
      setState(() {
        isSubscribed = result == 1 || result == 2;
      });
      widget.subscriptionCallback(result == 1 || result == 2);
    }
    if (result != null && result == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  
                  content: Text('Subscription Successful! Stay Tuned for Washing Machine Alerts!', style: GoogleFonts.robotoCondensed(
              fontSize: 12, 
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ), textAlign: TextAlign.center,),
                  backgroundColor: Colors.green[400],
                ),
      );
    } else if (result != null && result == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  
                  content: Text('You are already subscribed!', style: GoogleFonts.robotoCondensed(
              fontSize: 12, 
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ), textAlign: TextAlign.center,),
                  backgroundColor: Colors.green[400],
                ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onTap: toggleSubscription,
      margin: widget.margin,
      color: widget.color,
      pressed: widget.pressed,
      disabled: widget.disabled,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.icon,
          const SizedBox(height: 5),
          Text(
            'SUBSCRIBE',
            style: GoogleFonts.roboto(
              fontSize: 8,
              color: const Color.fromRGBO(144, 149, 166, 1),
            ),
          ),
        ],
      ),
    );
  }
}


class ScheduleButton extends StatefulWidget {
  const ScheduleButton({
    Key? key,
    required this.icon,
    this.margin,
    this.color,
    this.pressed,
    this.disabled,
    
    required this.subscriptionCallback,
  }) : super(key: key);

  final Icon icon;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final bool? pressed;
  final bool? disabled;
  final Function(bool) subscriptionCallback;

  @override
  _ScheduleButton createState() => _ScheduleButton();
}

class _ScheduleButton extends State<ScheduleButton> {
  late bool isSubscribed;

  @override
  void initState() {
    super.initState();
  }

  void toggleSubscription() {
    subscribeUser();
  }

  void subscribeUser() async {
    final result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SchedulingDialog();
      },
    );
    if (result != null) {
      setState(() {
        isSubscribed = result == 1 || result == 2;
      });
      widget.subscriptionCallback(result == 1 || result == 2);
    }
    String messageResult = "";
    print(result);
    switch (result) {
      case 1:
      messageResult = "Scheduled successfully! Your selected wash cycle has been reserved for your laundry time.";
      break;
      case 2:
      messageResult = "Failed to schedule. You're not on the waiting list for this machine. Please join the waiting list to schedule your wash cycle.";
      break;
      case 3:
      messageResult = "Failed to schedule. Someone else has already scheduled a wash cycle for this machine. Please select another time or join the waiting list.";
      break;
      case 4:
      messageResult = "Failed to schedule. The machine is currently unavailable. Please try again later.";
      break;
      case 5:
      messageResult = "You are already scheduled for this machine. Please wait for your wash cycle to start.";
      break;
    }
    if (result != null && result == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  
                  content: Text(messageResult, style: GoogleFonts.robotoCondensed(
              fontSize: 12, 
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ), textAlign: TextAlign.center,),
                  backgroundColor: Colors.green[400],
                ),
      );
    } else if (result != null && result == 2 || result == 3 || result == 4 || result == 5) {
      ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  
                  content: Text(messageResult, style: GoogleFonts.robotoCondensed(
              fontSize: 12, 
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ), textAlign: TextAlign.center,
          ),
          backgroundColor: Color.fromARGB(255, 255, 182, 46),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onTap: toggleSubscription,
      margin: widget.margin,
      color: widget.color,
      pressed: widget.pressed,
      disabled: widget.disabled,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.icon,
          const SizedBox(height: 5),
          Text(
            'SCHEDULE',
            style: GoogleFonts.roboto(
              fontSize: 8,
              color: const Color.fromRGBO(144, 149, 166, 1),
            ),
          ),
        ],
      ),
    );
  }
}

class CatalogPage extends StatefulWidget  {
  @override
  _CatalogPage createState() => _CatalogPage();
}


class _CatalogPage extends State<CatalogPage>  with AutomaticKeepAliveClientMixin{
     @override
  bool get wantKeepAlive => true;

  final DatabaseReference database = FirebaseDatabase.instance.ref();
  bool isSubscribed = false;
  bool isMachineRunning = false;
  int subscribersCount = 0;
  int threshold = 0;
  final code = TextEditingController();
  StreamSubscription<ConnectivityResult>? subscription;
  bool isInitialized = false;

 @override
  void initState() {
    super.initState();
  }

  void handleSubscriptionResult(bool result) {
    setState(() {
      isSubscribed = result;
    });
  }

  @override
  void dispose() { 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView( child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          SizedBox(height: 30),
            WashingMachineCard(key: UniqueKey(), name: 'EcoClean Pro', imagePath: 'lib/assets/eco_clean_pro.png', brand: 'EcoTech', model: 'EP-2000', features: 'Eco-friendly', capacity: '8 kg', colors: const [Color.fromARGB(255, 192, 208, 235), Color.fromARGB(255, 182, 231, 207)], align: true, machineId: "eco_clean_pro"),
            const SizedBox(height: 10),
             WashingMachineCard(key: UniqueKey(), name: 'TurboWash Elite', imagePath: 'lib/assets/turbo_wash_elite.png', brand: 'Speedy Watch', model: 'TW-3000', features: 'Steam Clean option', capacity: '10 kg', colors: const [Color.fromARGB(255, 145, 161, 255), Color.fromARGB(104, 182, 187, 186)], align: true, machineId: "turbo_wash_elite"),
             SizedBox(height: 30),
             Row(mainAxisAlignment: MainAxisAlignment.center,
               children: [
                    SubscribeButton(
              subscriptionCallback: handleSubscriptionResult,
              icon: Icon(
                Icons.subscriptions,
                color: Color.fromRGBO(144, 149, 166, 1),
              ),
              initiallySubscribed: isSubscribed
            ),
            SizedBox(width: 30),
                ScheduleButton(
              subscriptionCallback: handleSubscriptionResult,
              icon: Icon(
                Icons.schedule,
                color: Color.fromRGBO(144, 149, 166, 1),
              ),
            )
               ]),
               SizedBox(height: 30),
              WashingMachineCard(key: UniqueKey(), name: 'FreshCycle Max', imagePath: 'lib/assets/fresh_cycle_max.png', brand: 'FreshTech', model: 'FCX500', features: 'Energy Star certified', capacity: '6 kg',colors: const [Color.fromARGB(255, 197, 235, 167), Color.fromARGB(255, 210, 216, 240)], align: false, machineId: "fresh_cycle_max"),
            const SizedBox(height: 10),
               WashingMachineCard(key: UniqueKey(), name: 'AquaSonic Deluxe', imagePath: 'lib/assets/aqua_sonic_deluxe.png', brand: 'AquaClean', model: 'ADX-700', features: 'Quick Wash option', capacity: '8 kg', colors: const [Color.fromARGB(255, 190, 168, 231), Color.fromARGB(255, 250, 255, 204)], align: false, machineId: "aqua_sonic_deluxe"),
            ],)
          ],
        ),
      ))
    );
  }
}