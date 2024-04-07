import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washwatch/components/connection_failed_dialog.dart';
import 'package:washwatch/components/intensities_dropdown.dart';
import 'package:washwatch/components/progress_indicator.dart';
import 'package:washwatch/components/textfield.dart';
import './machines_dropdown.dart';
import 'bouncing_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cycles_dropdown.dart';

class SchedulingDialog extends StatefulWidget {
  @override
  _SchedulingDialog createState() => 
  _SchedulingDialog();
}

enum PinVerificationResult {
  Success,
  IncorrectPin,
  FailedToRetreive
}

class _SchedulingDialog extends State<SchedulingDialog> {
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  final intensitiesKey = GlobalKey<FormState>(); 
  final machinesKey = GlobalKey<FormState>(); 
  final optionsKey = GlobalKey<FormState>(); 
  String? selectedMachine;
  String? selectedCycleOption;
  String? selectedIntensity;
  final code = TextEditingController();
  bool _showPasswordError = false;
  bool _showEmptyError = false;

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

void schedule(BuildContext context) async {
  bool intensitiesValidate = intensitiesKey.currentState!.validate();
  bool machinesValidate = machinesKey.currentState!.validate();
  bool optionsValidate = optionsKey.currentState!.validate();
  if (code.text.isEmpty) {
    setState(() {
      _showEmptyError = true;
    });
  } else {
    setState(() {
      _showEmptyError = false;
    });  
  }
  if (!intensitiesValidate || !machinesValidate || !optionsValidate || _showEmptyError) {
    return;
  }
  GlobalKey<State> _dialogKey = GlobalKey<State>();
  showProgressIndicator(context, _dialogKey);
  PinVerificationResult pinVerifResult = await verifyMachineCode();
  if (pinVerifResult == PinVerificationResult.Success) {
      setState(() {
        _showPasswordError = false;
        });
    }
    else if (pinVerifResult == PinVerificationResult.IncorrectPin) {
      Navigator.of(_dialogKey.currentContext!, rootNavigator: true).pop();
      setState(() {
        _showPasswordError = true;
      });
      return;
    } else if (pinVerifResult == PinVerificationResult.FailedToRetreive) {
      Navigator.of(_dialogKey.currentContext!, rootNavigator: true).pop();
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
  int result = await verifyIfEligible();
  Navigator.of(_dialogKey.currentContext!, rootNavigator: true).pop();
  if (result == 1) {
    // user is eligible to schedule a job for the selected washing machine
    const timeoutDuration = Duration(seconds: 10);
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    String machineId = mapMachineToId();
    final messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    bool userExists = false;
    final usersSnapshot = await database.child('users').get().timeout(timeoutDuration);
    if (usersSnapshot.exists) {
      if (usersSnapshot.hasChild(userId)) {
          userExists = true;
        } 
      if (userExists) {
        final jobsSnapshot = await database.child('users/$userId/jobs').get().timeout(timeoutDuration);
        if (jobsSnapshot.exists) {
        database.child('users/$userId/jobs').update(
        { 
            machineId: {
              'name': selectedMachine,
              'intensity': selectedIntensity,
              'option': selectedCycleOption,
              'status': 'Processing',
              'start_time': 0
            }
        }).timeout(timeoutDuration);
      } else {
         database.child('users/$userId/').update(
        {
          'jobs': { 
            machineId: {
              'name': selectedMachine,
              'intensity': selectedIntensity,
              'option': selectedCycleOption,
              'status': 'Processing',
              'start_time': 0
            }
        }
        }).timeout(timeoutDuration);
      }
      } else {
        DatabaseReference ref = FirebaseDatabase.instance.ref("users/");
        ref.update({
        userId: {"token": token, "jobs": {machineId: {
              'name': selectedMachine,
              'intensity': selectedIntensity,
              'option': selectedCycleOption,
              'status': 'Processing',
              'start_time': 0
            }}}
        }).timeout(timeoutDuration);
      }
      FirebaseDatabase.instance.ref().child('users/$userId/subscribed_machines').child(machineId).remove().timeout(timeoutDuration);
    } else {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      ref.update({
        "users": {userId: {"token": token, "jobs": {machineId: {
              'name': selectedMachine,
              'intensity': selectedIntensity,
              'option': selectedCycleOption,
              'status': 'Processing',
              'start_time': 0
            }}}}
      }).timeout(timeoutDuration);
    }
  }
  Navigator.pop(context, result);
}



Future<bool> addUserToken() async {
  try {
    String machineId = mapMachineToId();
    const timeoutDuration = Duration(seconds: 10);
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    final snapshot = await database.child('washing_machines/$machineId/subscribers').get().timeout(timeoutDuration);
    if (snapshot.exists) {
      int tokenKey = snapshot.children.length;
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

Future<int> verifyIfEligible() async {
  try {
    bool isSubscribed = false;
    bool isFirstOnList = false;
    bool isOperating = false;
    String machineId = mapMachineToId();
    const timeoutDuration = Duration(seconds: 10);
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    final snapshot = await database.child('washing_machines/$machineId/subscribers').get().timeout(timeoutDuration);
    if (snapshot.exists) {
      for (int i = 0; i < snapshot.children.length; i++) {
        if (snapshot.children.elementAt(i).value == userId) {
          isSubscribed = true;
          if (i == 0) {
            isFirstOnList = true;
          }
        }
      }
      final statusSnapshot = await database.child('washine_machines/$machineId/status').get().timeout(timeoutDuration);
      if (statusSnapshot.value == true) {
        isOperating = true;
      }
    } else {
        if (snapshot.children.length == 0) {
        // The washing machine is free and there is no one on the waiting list.
        if (!await addUserToken()) {
          return 0;
        }
        return 1;
      }
    }
    if (isSubscribed && isFirstOnList && isOperating == false) {
      print("koko");
        final machineJobSnapshot = await database.child('users/$userId/jobs/$machineId').get().timeout(timeoutDuration);
        if (machineJobSnapshot.exists) {
          // the user is already scheduled
          return 5;
        }
      return 1;
    } else if (isSubscribed == false){
      return 2;
    } else if (isFirstOnList == false) {
      return 3;
    } else {
      return 4;
    }
  } catch (e)
  {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return const ConnectionFailedDialog(
        title: "Scheduling Failed",
        body: "We couldn't complete your subscription due to a network issue. Please check your internet connection and try again later.",
      );
    },
  );  
  return 0;
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
            'Time to Spin: Schedule Your Cycle',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSansCondensed(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          Text(
            'Reserve your spot for squeaky clean laundry!',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSansCondensed(
              fontSize: 14, 
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Image.asset('lib/assets/schedule.png', height: 100, width: 100),
          const SizedBox(height: 10),
          MachinesDropDown(formKey: machinesKey, 
          
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
          const SizedBox(height: 5),
          CycleOptionsDropDown(formKey: optionsKey, 
          onMachineSelected: (option) {
              setState(() {
                selectedCycleOption = option; 
              });
            },
          ),
          const SizedBox(height: 5),
          IntensitiesDropdwdown(formKey: intensitiesKey, 
          
          onMachineSelected: (intensity) {
              setState(() {
                selectedIntensity = intensity;
              });
            },
          ),
        ],),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
              children: [
BouncingButton(
          onTap: () {schedule(context);},
          text: 'Schedule',
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