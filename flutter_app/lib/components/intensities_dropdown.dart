import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class IntensitiesDropdwdown extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(String?) onMachineSelected;

  const IntensitiesDropdwdown({Key? key, required this.formKey, required this.onMachineSelected,}) : super(key: key);

  @override
  _IntensitiesDropdwdownState createState() => _IntensitiesDropdwdownState(formKey: formKey,  );
}

class _IntensitiesDropdwdownState extends State<IntensitiesDropdwdown> {
  String? selectedIntensity;
  final code = TextEditingController();
  List<String> intensities = <String>['Low', 'Medium', 'High'];
  final GlobalKey<FormState> formKey;

  _IntensitiesDropdwdownState({required this.formKey,});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonFormField2<String>(
          isExpanded: true,
          isDense: true,
          alignment: Alignment.center,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200), 
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(20), 
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red), 
              borderRadius: BorderRadius.circular(20),
            ),
            errorStyle: GoogleFonts.roboto(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: 'Select Intensity',
            hintStyle: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          hint: Text(
            'Please Select an Intensity',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          items: intensities
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  alignment: Alignment.center,
                  child: Text(
                    item,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              )
              .toList(),
          validator: (value) {
            if (value == null) {
              return 'Please select an intensity!';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              selectedIntensity = value;
            });
            widget.onMachineSelected(value);
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(right: 8),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black45,
            ),
            iconSize: 24,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ),
    );
  }
}
