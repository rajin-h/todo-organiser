import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';
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
  }

  Future<void> signInWithGitHub() async {
    // GithubAuthProvider githubProvider = GithubAuthProvider();
    // await FirebaseAuth.instance.signInWithProvider(githubProvider);

    print('start...');

    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: "440805037bb91c60b05f",
        clientSecret: "291bf51803c77e580f702ba596db6ab91b72193e",
        redirectUrl: 'https://todo-organiser.firebaseapp.com/__/auth/handler');
    final result = await gitHubSignIn.signIn(context);

    print('result ' + result.token.toString());
    print('result ' + result.errorMessage);
    print('result ' + result.status.name);

    final githubAuthCredential =
        GithubAuthProvider.credential(result.token ?? "");

    final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);

    print('here....');
    print(authResult);
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
