import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CycleOptionsDropDown extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(String?) onMachineSelected;

  const CycleOptionsDropDown({Key? key, required this.formKey, required this.onMachineSelected,}) : super(key: key);

  @override
  _CycleOptionsDropDown createState() => _CycleOptionsDropDown(formKey: formKey,  );
}

class _CycleOptionsDropDown extends State<CycleOptionsDropDown> {
  String? selectedCycleOption;
  final code = TextEditingController();
  List<String> cycleOptions = <String>['Quick Wash', 'Normal Wash', 'Delicate Wash'];
  final GlobalKey<FormState> formKey;

  _CycleOptionsDropDown({required this.formKey,});

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
            hintText: 'Select Cycle Option', 
            hintStyle: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          hint: Text(
            'Please Select a Cycle Option',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          items: cycleOptions
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
              return 'Please select a cycle option!';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              selectedCycleOption = value;
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
