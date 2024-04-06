import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/button.dart';
import '../components/textfield.dart';
import '../providers/auth_service.dart';
import '../components/progress_indicator.dart';
import '../components/error_dialog.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showEmptyEmailError = false;
  bool showEmptyPasswordError = false;

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

void signInCallback() async {
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
  if (!showEmptyEmailError && !showEmptyPasswordError) {
    GlobalKey<State> _dialogKey = GlobalKey<State>();
  showProgressIndicator(context, _dialogKey);
    AuthStatus result =
        await AuthService.signIn(emailController.text, passwordController.text);
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
              const SizedBox(height: 35),
              Image.asset('lib/assets/washing-machine.png'),
              const SizedBox(height: 25),
              Text(
                'WASH WATCH',
                style: GoogleFonts.bebasNeue(
                  fontSize: 52,
                )
              ),
              const SizedBox(height: 5),
              Text(
                'Welcome back, you\'ve been missed!',
                style: GoogleFonts.robotoCondensed(
                  fontSize: 20
                ),
              ),
              const SizedBox(height: 30),
              TextField_(
                controller: emailController, 
                hintText: 'Email', 
                obscureText: false,
                showEmptyError: showEmptyEmailError,
                emptyTextString: "Please enter your email address",
              ),
              const SizedBox(height: 10),
              TextField_(
                controller: passwordController, 
                hintText: 'Password', 
                obscureText: true,
                showEmptyError: showEmptyPasswordError,
                emptyTextString: "Please enter your password",
              ),
             const SizedBox(height: 30),
              Button(
                onTap: signInCallback,
                text: 'Sign In',
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: GoogleFonts.robotoCondensed(
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(onTap: widget.onTap,
                      child: Text(
                      'Register now',
                      style: GoogleFonts.robotoCondensed(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                     ),
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