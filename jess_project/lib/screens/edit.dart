import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jess_project/screens/chart.dart';
import 'package:jess_project/screens/expense.dart';
import 'package:jess_project/screens/home.dart';
import 'package:jess_project/screens/profile.dart';
import 'package:jess_project/utilitys/colors.dart';
import 'package:jess_project/utilitys/user.dart';

import '../services/firebaseauth_service.dart';
import '../services/firestore_service.dart';
import 'login.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart'; // to get filename

class EditScreen extends StatefulWidget {
  const EditScreen({Key key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

String email = FirebaseAuth.instance.currentUser.email;
String name = FirebaseAuth.instance.currentUser.displayName;

class _EditScreenState extends State<EditScreen> {
  File _image;
  String name;

  @override
  Widget build(BuildContext context) {
    List<Profile> _cp;

    bool _loading;
    TextEditingController controller_phone;

    TextEditingController controller_name;
    TextEditingController controller_email;
    @override
    void initState() {
      super.initState();
      _loading = true;
      FirestoreService().readAccountData().then((value) {
        setState(() {
          _cp = Profile.filterList(value, email.toString());
          _loading = false;
          controller_name = TextEditingController(text: _cp.first.name);
          controller_email =
              TextEditingController(text: _cp.first.email.toString());
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: hexStringToColor("B9C3FF"),
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFFFFFFFF),
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xffB9C3FF),
              ),
              accountName: _cp == null
                  ? Container(
                      alignment: AlignmentDirectional.center,
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      _cp.first.name,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
              accountEmail: _cp == null
                  ? Container(
                      alignment: AlignmentDirectional.center,
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      _cp.first.email,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://i.pinimg.com/736x/1a/43/b4/1a43b48f35df97062c44108c5c27c42d.jpg"),
              ),
            ),
            ListTile(
              trailing: const Icon(Icons.home_rounded),
              iconColor: Colors.black,
              title: const Text(
                'Home',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen()));
              },
            ),
            ListTile(
              trailing: const Icon(Icons.money_rounded),
              iconColor: Colors.black,
              title: const Text(
                'Expense',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const ExpenseScreen()));
              },
            ),
            ListTile(
              trailing: const Icon(Icons.add_chart_rounded),
              iconColor: Colors.black,
              title: const Text(
                'Charts',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const ChartScreen()));
              },
            ),
            ListTile(
              trailing: const Icon(Icons.person_rounded),
              iconColor: Colors.black,
              title: const Text(
                'Profile',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProfileScreen()));
              },
            ),
            ListTile(
              trailing: const Icon(Icons.logout_rounded),
              iconColor: Colors.black,
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () async {
                await FirebaseAuthService().signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
              },
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("B9C3FF"),
            hexStringToColor("14C1E0"),
            hexStringToColor("009FD5")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(
            height: 20,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  child: ClipOval(
                    child: SizedBox(
                      width: 180.0,
                      height: 180.0,
                      child: (_image != null)
                          ? Image.file(_image, fit: BoxFit.fill)
                          : Image.network(
                              "https://previews.123rf.com/images/dazdraperma/dazdraperma1409/dazdraperma140900040/31808470-illustration-of-very-cute-piggy.jpg",
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.black,
                  size: 30.0,
                ),
              )

              // camera
            ],
          ),

          const SizedBox(
            height: 15.0,
          ),

          TextFormField(
            controller: controller_name,
            decoration: const InputDecoration(
              hintText: 'Name: ',
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 20.0),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0))),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 93, 94, 96))),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: controller_phone,
            decoration: const InputDecoration(
              hintText: 'Phone: ',
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 228, 222, 222),
                  fontSize: 20.0),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffB9C3FF))),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  FirestoreService().updateAccountData(_cp.first.uid, email,
                      controller_name.text, _cp.first.phone, _cp.first.pic);
                });
                Fluttertoast.showToast(
                    msg: "data updated successfully",
                    gravity: ToastGravity.TOP);
              },
              child: Text("Save Changes"))
          // Text(controller_phone.toString())
        ]),
      ),
    );
  }
}
