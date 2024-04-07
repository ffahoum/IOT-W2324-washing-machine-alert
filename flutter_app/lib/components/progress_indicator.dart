 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showProgressIndicator(BuildContext context, GlobalKey key) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        key: key,
        elevation: 0,
        child: Center( 
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200), 
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey), 
              ),
              const SizedBox(height: 20),
              Text(
                'Hang tight!',
                style: GoogleFonts.robotoCondensed(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      )
      );
    },
  );
}
