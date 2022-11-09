import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Sign In Method
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final User? user = authResult.user;

    if (authResult.additionalUserInfo!.isNewUser) {
      if (user != null) {
        // Add user document to "Users" collections
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser?.uid.toString())
              .set({
            'tasks': [],
            'buckets': [],
          });
        }
      }
    }
  }

  Future<void> signInWithGitHub() async {
    GithubAuthProvider githubProvider = GithubAuthProvider();
    await FirebaseAuth.instance.signInWithProvider(githubProvider);
  }

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
                      "Welcome Back To Your Todo Organiser",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: signInWithGoogle,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Center(
                            child: Text(
                          "Google",
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(41, 41, 41, 1)),
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: signInWithGitHub,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 31, 31, 31),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Center(
                            child: Text(
                          "GitHub",
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        )),
                      ),
                    ),
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
