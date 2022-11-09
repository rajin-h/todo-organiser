import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputBox extends StatefulWidget {
  InputBox(
      {Key? key,
      required this.controller,
      this.hintText,
      required this.labelText,
      required this.isReadOnly,
      required this.isPassword,
      required this.isPrimary,
      this.maxLines,
      this.padding,
      this.centerText,
      this.isNumber})
      : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final String labelText;
  final bool isPassword;
  final bool isReadOnly;
  final bool isPrimary;
  final int? maxLines;
  final List<double>? padding;
  final bool? centerText;
  final bool? isNumber;

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding != null
          ? EdgeInsets.fromLTRB(widget.padding![0], widget.padding![1],
              widget.padding![2], widget.padding![3])
          : const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            cursorColor: const Color.fromRGBO(99, 152, 255, 1),
            keyboardType: widget.isNumber != null && widget.isNumber == true
                ? TextInputType.number
                : TextInputType.name,
            textAlign:
                widget.centerText != null ? TextAlign.center : TextAlign.left,
            maxLines: widget.maxLines ?? 1,
            obscureText: widget.isPassword,
            readOnly: widget.isReadOnly,
            controller: widget.controller,
            style: GoogleFonts.inter(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
                hintStyle: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 56, 56, 56)),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 56, 56, 56)),
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: const Color.fromARGB(255, 56, 56, 56),
                filled: true,
                hintText: widget.hintText),
          ),
        ],
      ),
    );
  }
}
