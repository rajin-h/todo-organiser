import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Log In",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                    ),
                    Text(
                      "Welcome back to your Todo Organiser",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(60, 60, 60, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: TextField(
                          cursorColor: Colors.white,
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            hintText: "Email",
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 184, 183, 183)),
                            border: InputBorder.none,
                          ),
                        )),
                    const SizedBox(height: 15),
                    Container(
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(60, 60, 60, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: TextField(
                          scrollPadding: const EdgeInsets.only(bottom: 10),
                          obscureText: true,
                          cursorColor: Colors.white,
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 184, 183, 183)),
                            border: InputBorder.none,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
