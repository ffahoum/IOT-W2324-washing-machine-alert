// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/button.dart';
import '../components/textfield.dart';
import '../providers/auth_service.dart';
import '../components/progress_indicator.dart';
import '../components/error_dialog.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();
  bool showEmptyEmailError = false;
  bool showEmptyPasswordError = false;
  bool showEmptyConfirmedPasswordError = false;

  void signUpCallback() async {
    if (emailController.text.isEmpty) {
      setState(() {
        showEmptyEmailError = true;
      });
    } else {
      setState(() {
        showEmptyEmailError = false;
      });
    }
    if (passwordController.text.isEmpty) {
      setState(() {
        showEmptyPasswordError = true;
      });      
    } else {
      setState(() {
        showEmptyPasswordError = false;
      });        
    }
    if (confirmedPasswordController.text.isEmpty) {
      setState(() {
        showEmptyConfirmedPasswordError = true;
      });
    } else {
      setState(() {
        showEmptyConfirmedPasswordError = false;
      });      
    }
    if (!showEmptyEmailError && !showEmptyPasswordError && !showEmptyConfirmedPasswordError) {
      GlobalKey<State> _dialogKey = GlobalKey<State>();
      showProgressIndicator(context, _dialogKey);
      AuthStatus result = await AuthService.signUp(emailController.text, passwordController.text, confirmedPasswordController.text);
      if (_dialogKey.currentContext != null) {
        Navigator.of(_dialogKey.currentContext!, rootNavigator: true).pop();
      }
      if (result == AuthStatus.success) {
      } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            title: "Login Failed",
            body:
                AuthService.getErrorMessage(result),
            icon: 'lib/assets/cancel.png',
          );
        },
      );
    }

    }
  }
  

  void displayErrorMessage(AuthStatus errorCode) {
    String errorMessage = AuthService.getErrorMessage(errorCode);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            )
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child:  Center(
          child:  SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 25),
              Image.asset('lib/assets/washing-machine.png'),
              SizedBox(height: 25),
              Text(
                'WASH WATCH',
                style: GoogleFonts.bebasNeue(
                  fontSize: 52,
                )
              ),
              SizedBox(height: 5),
              Text(
                'Let\'s create an account for you!',
                style:  GoogleFonts.robotoCondensed(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 30),
              TextField_(
                controller: emailController, 
                hintText: 'Email', 
                showEmptyError: showEmptyEmailError,
                emptyTextString: "Please enter your email address",
                obscureText: false
              ),
              SizedBox(height: 10),
              TextField_(
                controller: passwordController, 
                hintText: 'Password', 
                showEmptyError: showEmptyPasswordError,
                emptyTextString: "Please enter your password",
                obscureText: true), 
              SizedBox(height: 10),
              TextField_(
                controller: confirmedPasswordController, 
                hintText: 'Confirm Password', 
                showEmptyError: showEmptyConfirmedPasswordError,
                emptyTextString: "Please confirm your password",
                obscureText: true),
              SizedBox(height: 25),
              Button(
                onTap: signUpCallback,
                text: 'Sign Up'
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style:  GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  GestureDetector(onTap: widget.onTap,
                      child: Text(
                      'Login now',
                      style:  GoogleFonts.robotoCondensed(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      )
                    )
                  )
                ],
              )
          ],)) 
        ),
      )      
     );
  }
}