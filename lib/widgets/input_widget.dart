import 'package:flower_vault/utils/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputLayout extends StatelessWidget {
  String label;
  StatefulWidget inputField;

  InputLayout(
    this.label,
    this.inputField, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: headerStyle(level: 3)),
        const SizedBox(height: 5),
        Container(
          child: inputField,
        ),
        const SizedBox(height: 15)
      ],
    );
  }
}

InputDecoration customInputDecoration(String hintText, {Widget? suffixIcon}) {
  return InputDecoration(
    hintText: hintText,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
