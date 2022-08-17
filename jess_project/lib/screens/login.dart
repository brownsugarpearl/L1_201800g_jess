import 'package:jess_project/screens/forgotpw.dart';
import 'package:jess_project/screens/home.dart';
import 'package:jess_project/screens/profile.dart';
import 'package:jess_project/screens/register.dart';
import 'package:jess_project/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:jess_project/utilitys/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        hexStringToColor("B9C3FF"),
        hexStringToColor("14C1E0"),
        hexStringToColor("009FD5")
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            20, MediaQuery.of(context).size.height * 0.15, 20, 0),
        child: Column(
          children: <Widget>[
            logoWidget("assets/images/logo.png"),
            const SizedBox(
              height: 30,
            ),
            textField("Enter Email: ", Icons.person_rounded, false,
                emailTextController),
            const SizedBox(
              height: 20,
            ),
            textField("Enter Password", Icons.password_rounded, true,
                passwordTextController),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ForgotPasswordScreen();
                      }));
                    },
                    child: const Text(
                      'Forgot Password ?',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            regLogButton(context, true, () {
              FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: emailTextController.text.trim(),
                      password: passwordTextController.text.trim())
                  .then((value) {
                print("account sign in");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              }).onError((error, stackTrace) {
                print("error ${error.toString()}");
              });
            }),
            registerOption()
          ],
        ),
      ),
    ));
  }

  Row registerOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account ?",
            style: TextStyle(color: Colors.white)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterScreen()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
