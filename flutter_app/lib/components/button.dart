import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const Button({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(2),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: 10,
              color: const Color.fromRGBO(144, 149, 166, 1),
            ),
          ),
        ),
      ),
    );
  }
}