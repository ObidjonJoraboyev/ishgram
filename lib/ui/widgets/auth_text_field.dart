import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UniversalTextField extends StatefulWidget {
  const UniversalTextField({
    super.key,
    required this.hinText,
    this.svgPath = "",
    this.isPassword = false,
    required this.width,
    required this.controller,
  });

  final String hinText;
  final String svgPath;
  final bool isPassword;
  final double width;
  final TextEditingController controller;

  @override
  State<UniversalTextField> createState() => _UniversalTextFieldState();
}

class _UniversalTextFieldState extends State<UniversalTextField> {
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.1),
              offset: const Offset(0, 12),
              spreadRadius: .2,
              blurRadius: 12)
        ],
      ),
      child: TextField(
        obscureText: check,
        controller: widget.controller,
        keyboardType: TextInputType.text,
        cursorColor: const Color(0xff1317DD),
        decoration: InputDecoration(
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    check = !check;
                    setState(() {});
                  },
                  icon: Icon(check
                      ? CupertinoIcons.eye_solid
                      : CupertinoIcons.eye_slash_fill))
              : null,
          hintText: widget.hinText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
