import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultButton extends StatefulWidget {
  const DefaultButton(
      {Key? key, required this.onTap, required this.labelText, this.isPrimary})
      : super(key: key);

  final void Function()? onTap;
  final String labelText;
  final bool? isPrimary;

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: widget.isPrimary == null || widget.isPrimary == true
                ? const Color.fromRGBO(99, 152, 255, 1)
                : Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Text(
          widget.labelText,
          style: GoogleFonts.inter(
              color: widget.isPrimary == null || widget.isPrimary == true
                  ? Colors.white
                  : Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
