import 'package:flutter/material.dart';
import 'package:jess_project/screens/about.dart';
import 'package:jess_project/screens/edit.dart' as edit;
import 'package:jess_project/screens/expense.dart';
import 'package:jess_project/screens/home.dart';
import 'package:jess_project/utilitys/user.dart';
import 'package:jess_project/widgets/widgets.dart';

import '../services/firebaseauth_service.dart';
import '../services/firestore_service.dart';
import '../utilitys/colors.dart';
import 'chart.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Profile> _cp;

  bool _loading;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        backgroundColor: hexStringToColor("B9C3FF"),
      ),
      drawer: _cp == null
          ? Container(
              alignment: AlignmentDirectional.center,
              child: CircularProgressIndicator(),
            )
          : Drawer(
              backgroundColor: Color(0xFFFFFFFF),
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color(0xffB9C3FF),
                    ),
                    accountName: Text(
                      _cp.first.name,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                    accountEmail: Text(
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
                              builder: (BuildContext context) =>
                                  ProfileScreen()));
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
                              builder: (BuildContext context) =>
                                  LoginScreen()));
                    },
                  )
                ],
              ),
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
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(children: [
            const SizedBox(height: 50),
            editAboutButton(context, true, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const edit.EditScreen()));
            }),
            editAboutButton(context, false, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()));
            }),
          ]),
        )),
      ),
    );
  }
}
