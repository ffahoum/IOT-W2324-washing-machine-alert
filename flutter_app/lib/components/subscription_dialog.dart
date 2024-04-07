import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washwatch/components/connection_failed_dialog.dart';
import './textfield.dart';
import './machines_dropdown.dart';
import 'bouncing_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionDialog extends StatefulWidget {
  @override
  _SubscriptionDialogState createState() => 
  _SubscriptionDialogState();
}

enum PinVerificationResult {
  Success,
  IncorrectPin,
  FailedToRetreive
}

class _SubscriptionDialogState extends State<SubscriptionDialog> {
  final code = TextEditingController();
  bool _showPasswordError = false;
  bool _showEmptyError = false;
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  final _formKey = GlobalKey<FormState>(); 
  String? selectedMachine;



  mapMachineToId() {
    switch(selectedMachine) {
      case 'EcoClean Pro':
        return 'eco_clean_pro';
      case 'TurboWash Elite':
        return 'turbo_wash_elite';
      case 'FreshCycle Max':
        return 'fresh_cycle_max';
      case 'AquaSonic Deluxe':
        return 'aqua_sonic_deluxe';
    }
  }

  Future<PinVerificationResult> verifyMachineCode() async {
    String machineId = mapMachineToId();
    try {
      const timeoutDuration = Duration(seconds: 10);
      final snapshot = await database.child('washing_machines/$machineId/secret_code').get().timeout(timeoutDuration);
      if (snapshot.value != null && snapshot.exists && snapshot.value == code.text)
      {
        return PinVerificationResult.Success;
      } else {
        return PinVerificationResult.IncorrectPin;
      }
    } catch(e) {
      return PinVerificationResult.FailedToRetreive;
    }
  }

void subscribe(BuildContext context) async {
  bool pinTextValidate = _formKey.currentState!.validate();
  if (pinTextValidate == false) {
    return;
  }
  if (code.text.isEmpty) {
    setState(() {
      _showEmptyError = true;
    });
  } else {
    setState(() {
      _showEmptyError = false;
    });      
    GlobalKey<State> _dialogKey = GlobalKey<State>();
    showProgressIndicator(context, _dialogKey);      
    PinVerificationResult pinVerifResult = await verifyMachineCode();
    Navigator.of(_dialogKey.currentContext!, rootNavigator: true).pop();
    if (pinVerifResult == PinVerificationResult.Success) {
      setState(() {
        _showPasswordError = false;
      });
    }
    else if (pinVerifResult == PinVerificationResult.IncorrectPin) {
      setState(() {
        _showPasswordError = true;
      });
    } else if (pinVerifResult == PinVerificationResult.FailedToRetreive) {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConnectionFailedDialog(
        title: "PIN Retrieval Failed",
        body: "We couldn't verify the PIN due to a network issue. Please check your internet connection and try again later.",
      );
    },
  );
    }
    if (pinVerifResult == PinVerificationResult.Success && pinTextValidate) {
      bool addResult = await addUserToken();
      if (addResult == true) {
        Navigator.pop(context, 1);
      } else {
        Navigator.pop(context, 2);
      }
    }
  }
}

Future<bool> addUserToken() async {
  try {
    String machineId = mapMachineToId();
    const timeoutDuration = Duration(seconds: 10);
    final messaging = FirebaseMessaging.instance;
    bool tokenExists = false;
    int position = 0;
    final statusSnapshot = await database.child('washing_machines/$machineId/status').get().timeout(timeoutDuration);
    bool machineStatus = statusSnapshot.value as bool;
    String? token = await messaging.getToken();
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    final snapshot = await database.child('washing_machines/$machineId/subscribers').get().timeout(timeoutDuration);
    if (snapshot.exists) {
      snapshot.children.forEach((element) {
        if(element.value == userId) {
          tokenExists = true;
        } 
      });
      if (tokenExists) {
        return false;
      }
      int tokenKey = snapshot.children.length;
      position = tokenKey;
      database.child('washing_machines/$machineId/subscribers').update(
      {
      "$tokenKey": userId
      }).timeout(timeoutDuration);
    } else {
    DatabaseReference ref = FirebaseDatabase.instance.ref("washing_machines/$machineId//");
      ref.update({
        "subscribers": {"0": userId}
      }).timeout(timeoutDuration);
    }
    final usersSnapshot = await database.child('users').get().timeout(timeoutDuration);
    if (usersSnapshot.exists) {
      bool userExists = false;
      if (usersSnapshot.hasChild(userId)) {
          userExists = true;
        } 
      if (userExists) {
        database.child('users/$userId/subscribed_machines').update(
        {
        machineId: {"name": selectedMachine, "status": machineStatus, "position": position}
        }).timeout(timeoutDuration);
      } else {
        DatabaseReference ref = FirebaseDatabase.instance.ref("users/");
        ref.update({
        userId: {"token": token, "subscribed_machines": {machineId: {"name": selectedMachine, "status": machineStatus, "position": position}}}
        }).timeout(timeoutDuration);
      }
    } else {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      ref.update({
        "users": {userId: {"token": token, "subscribed_machines": {machineId: {"name": selectedMachine, "status": machineStatus, "position": position}}}}
      }).timeout(timeoutDuration);
    }
    return true;
  } catch (e)
  {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return const ConnectionFailedDialog(
        title: "Subscription Failed",
        body: "We couldn't complete your subscription due to a network issue. Please check your internet connection and try again later.",
      );
    },
  );  
  return false;
  }
 }

  void cancelCallback(BuildContext context) {
    Navigator.pop(context, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:SingleChildScrollView(
      child:
    AlertDialog(
      content: SingleChildScrollView(),
      backgroundColor: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(
            'Get in Line: Join the Wash Queue',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSansCondensed(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          Text(
            'Join the waiting list and be next in line for laundry bliss!',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSansCondensed(
              fontSize: 14, 
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Image.asset('lib/assets/queue.png',
          height: 100, width: 100),
          const SizedBox(height: 10),
          MachinesDropDown(formKey: _formKey, 
          
          onMachineSelected: (machine) {
              setState(() {
                selectedMachine = machine;
              });
            },
          ),
          const SizedBox(height: 5),
          TextField_(
            controller: code,
            hintText: 'Washing Machine Pin',
            obscureText: true,
            showError: _showPasswordError,
            showEmptyError: _showEmptyError,
            ),
        ],),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
              children: [
BouncingButton(
          onTap: () {subscribe(context);},
          text: 'Subscribe',
        ),
        const SizedBox(width: 5),
        BouncingButton(
          onTap: () {cancelCallback(context);},
          text: 'Cancel',
        ),
              ]

            
,),
      
      ]
    )
    )
    );
  }
}