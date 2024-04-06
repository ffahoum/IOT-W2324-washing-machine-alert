import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class MachinesDropDown extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(String?) onMachineSelected; 

  const MachinesDropDown({Key? key, required this.formKey, required this.onMachineSelected,
}) : super(key: key);

  @override
  _MachinesDropDown createState() => _MachinesDropDown(formKey: formKey,  );
}

class _MachinesDropDown extends State<MachinesDropDown> {
  String? selectedMachine;
  final code = TextEditingController();
  List<String> machines = <String>['EcoClean Pro', 'TurboWash Elite', 'FreshCycle Max', 'AquaSonic Deluxe'];
  final GlobalKey<FormState> formKey;

  _MachinesDropDown({required this.formKey, });

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
            hintText: 'Select Machine',
            hintStyle: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          hint: Text(
            'Please Select a Machine',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          items: machines
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
              return 'Please select a machine!';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              selectedMachine = value;
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
