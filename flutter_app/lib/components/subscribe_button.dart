import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/subscription_dialog.dart';
import '../components/unsubscribe_dialog.dart';
import '../components/customized_button.dart';


class NeumorphicIconButton extends StatefulWidget {
  const NeumorphicIconButton({
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
  _NeumorphicIconButtonState createState() => _NeumorphicIconButtonState();
}

class _NeumorphicIconButtonState extends State<NeumorphicIconButton> {
  late bool isSubscribed;

  @override
  void initState() {
    super.initState();
    isSubscribed = widget.initiallySubscribed;
  }

  void toggleSubscription() {
    if (isSubscribed) {
      unsubscribeUser();
    } else {
      subscribeUser();
    }
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
            ), textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green[400],
        ),
      );
    }
  }


  void unsubscribeUser() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return UnsubscribeDialog();
      },
    );
    if (result != null) {
      setState(() {
      isSubscribed = !result;
    });
    }

    if (result != null && result == true) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  
                  content: Text('You have successfully unsubscribed. You will be missed!', style: GoogleFonts.robotoCondensed(
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
            isSubscribed ? 'UNSUBSCRIBE' : 'SUBSCRIBE',
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
