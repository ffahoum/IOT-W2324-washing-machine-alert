import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

class WashingMachineCard extends StatefulWidget {
  final String name;
  final String imagePath;
  final String brand;
  final String model;
  final String features;
  final String capacity;
  final List<Color> colors;
  final bool align;
  final String machineId;

  const WashingMachineCard({
    required Key key,
    required this.name,
    required this.imagePath,
    required this.brand,
    required this.model,
    required this.features,
    required this.capacity,
    required this.colors,
    required this.align,
    required this.machineId,
    }) : super(key: key);

  @override
  _WashingMachineCardState createState() => _WashingMachineCardState(name: name, imagePath: imagePath, brand: brand, model: model, features: features, capacity: capacity, colors: colors, align: align, machineId: machineId );
}

class _WashingMachineCardState extends State<WashingMachineCard> {
  bool _displayFront = true;
  final String name;
  final String imagePath;
  final String brand;
  final String model;
  final String features;
  final String capacity;
  String status = "OFF";
  int waitingListCount = 0;
  final List<Color> colors;
  final bool align;
  final String machineId;
  StreamSubscription<DatabaseEvent>? statusHook;
  StreamSubscription<DatabaseEvent>? waitingListCountHook;

  _WashingMachineCardState({required this.name, required this.imagePath, required this.brand, required this.model, required this.features, required this.capacity, required this.colors, required this.align, required this.machineId});
  

  
 @override
  void initState() {
    super.initState();
    statusHook = FirebaseDatabase.instance.ref()
    .child('washing_machines/$machineId/status')
    .onValue.listen((event) {
    var realStatus = event.snapshot.value;
   setState(() {
        status = (realStatus == true ? "ON" : "OFF");
      });
    });
    waitingListCountHook = FirebaseDatabase.instance.ref()
    .child('washing_machines/$machineId/subscribers')
    .onValue.listen((event) {
    int realSubscribersCount = event.snapshot.children.length;
   setState(() {
        waitingListCount = realSubscribersCount;
      });
    });
  }

@override
void dispose() {
  statusHook!.cancel();
  waitingListCountHook!.cancel();
  super.dispose();
}


  Widget _buildLayout(
      {required Key key, required String faceName, required Color backgroundColor}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        color: backgroundColor,
      ),
      child: Center(
        child: Text(faceName.substring(0, 1), style: TextStyle(fontSize: 80.0)),
      ),
    );
  }
Widget _buildFront() {
  if (align) {
return Container(
    key: UniqueKey(),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
       gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors, 
      ),
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.blue[50],
    ),
    width: 350, 
    height: 100, 
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: GoogleFonts.openSansCondensed(
          fontSize: 30,
          )
        ),
        SizedBox(width: 15),
        Image.asset(
          imagePath,
          width: 80,
          height: 80,
        ),        
      ],
    ),
  );
  } else {
    return Container(
    key: UniqueKey(),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
       gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors, 
      ),
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.blue[50],
    ),
    width: 350, 
    height: 100, 
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 15),
        Image.asset(
          imagePath,
          width: 80,
          height: 80,
        ),  
                SizedBox(width: 15),

         Text(
          name,
          style: GoogleFonts.openSansCondensed(
          fontSize: 30,
          )
        ),      
      ],
    ),
  );
  }
}

  void handleSubscriptionResult(bool result) {
  }

Widget _buildRear(String imagePath) {
  return Container(
    key: UniqueKey(),
    decoration: BoxDecoration(
       gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors, 
      ),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.blue[50],
    ),
    width: 350,
    height: 100,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        Text(
          'Brand: $brand',
          style: GoogleFonts.openSansCondensed(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Model: $model',
          style: GoogleFonts.openSansCondensed(
          fontSize: 9,
          fontWeight: FontWeight.bold
          ),
        ),
        Text(
          'Features: $features',
          style: GoogleFonts.openSansCondensed(
          fontSize: 9,
          fontWeight: FontWeight.bold
          ),        ),
        Text(
          'Capacity: $capacity',
          style: GoogleFonts.openSansCondensed(
          fontSize: 9,
          fontWeight: FontWeight.bold
          ),        ),
        Text(
          'Status: $status',
          style: GoogleFonts.openSansCondensed(
          fontSize: 9,
          fontWeight: FontWeight.bold
          ),        ),
          Text(
          'Waiting List Count: $waitingListCount',
          style: GoogleFonts.openSansCondensed(
          fontSize: 9,
          fontWeight: FontWeight.bold
          ),        ),
        SizedBox(height: 10),
      ],
    ),
  );
}


  Widget _transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (widget!.key != UniqueKey());
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value = isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }

  Widget _buildFlipAnimation() {
    return GestureDetector(
      onTap: () => setState(() => _displayFront = !_displayFront),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 1000),
        transitionBuilder: _transitionBuilder,
        layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
        child: _displayFront ? _buildFront() : _buildRear(imagePath),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFlipAnimation();
  }
}