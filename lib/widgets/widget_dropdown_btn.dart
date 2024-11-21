import 'package:flutter/material.dart';

class Win11DropdownButton extends StatelessWidget {
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?>? onChanged;

  Win11DropdownButton({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: DropdownButton<String>(
        value: value,
        items: items,
        onChanged: onChanged,
        isExpanded: true,
        underline: Container(),
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade700),
        style: TextStyle(fontSize: 16.0, color: Colors.black),
        dropdownColor: Colors.white,
      ),
    );
  }
}