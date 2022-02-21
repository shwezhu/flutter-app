import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputWidget extends StatelessWidget {
  TextEditingController? controller;
  String? label;
  String? Function(String?)? validator;
  InputWidget({Key? key, this.controller, this.label, this.validator})
      : super(key: key);

  String? myValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 80),
      child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)
              ),
              hintText: label,
          ),
          validator: validator ?? myValidator
      )
    );
  }
}