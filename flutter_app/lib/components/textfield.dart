import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextField_ extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool showError;
  final bool showEmptyError;
  final String emptyTextString;
  final String incorrectTextString;

  TextField_({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.showError = false,
    this.showEmptyError = false,
    this.emptyTextString = "Please enter a PIN",
    this.incorrectTextString = "Incorrect PIN"
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: TextField(
        textAlign: TextAlign.center,
        controller: controller,
        obscureText: obscureText,
        style: GoogleFonts.roboto(
          fontSize: 12,
          color: const Color.fromRGBO(144, 149, 166, 1),
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red), 
            borderRadius: BorderRadius.circular(20),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          errorText: showEmptyError ? emptyTextString : (showError ? incorrectTextString : null),
          errorStyle: GoogleFonts.roboto(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
