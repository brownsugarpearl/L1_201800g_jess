import 'package:flutter/material.dart';
import 'package:jess_project/utilitys/colors.dart';
import 'package:jess_project/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        backgroundColor: hexStringToColor("B9C3FF"),
      ),
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * .2, 20, 0),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: <
                Widget>[
              const Text(
                "About Piggy Bank",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              Material(
                  elevation: 30.0, child: logoWidget("assets/images/team.png")),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: const <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'About Piggy Bank',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome To Piggy Bank. Piggy Bank is a Professional Budget Tracking App. Here we will provide you with interesting content, which you will like very much. We're dedicated to providing you the best of Budget Tracking App, with a focus on dependability and track budget. ",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () => launch('tel: +65 82187002'),
                child: Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 200, 218),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                    child: Text(
                      'Make a call',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () => launch('sms: +65 8218 7002'),
                child: Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 200, 218),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                    child: Text(
                      'Drop a message',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () => launch('mailto: 201800g@mymail.nyp.edu.sg'),
                child: Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 200, 218),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                    child: Text(
                      'Drop an email',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 15),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
