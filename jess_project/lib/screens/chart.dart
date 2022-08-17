import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jess_project/database/dive_db.dart';
import 'package:jess_project/screens/addtransaction.dart';
import 'package:jess_project/screens/expense.dart';
import 'package:jess_project/screens/home.dart';
import 'package:jess_project/screens/login.dart';
import 'package:jess_project/screens/profile.dart';
import 'package:jess_project/utilitys/colors.dart';
import 'package:jess_project/utilitys/user.dart';

import '../services/firebaseauth_service.dart';
import '../services/firestore_service.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key key}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  DiveDB diveDB = DiveDB();
  List<FlSpot> dataSet = [];
  DateTime today = DateTime.now();

  List<FlSpot> getPlotPoint(Map entireData) {
    dataSet = [];
    entireData.forEach((key, value) {
      if (value['type'] == "Expense" &&
          (value['date'] as DateTime).month == today.month) {
        dataSet.add(FlSpot((value['date'] as DateTime).month.toDouble(),
            (value['amount'] as int).toDouble()));
      }
    });
    return dataSet;
  }

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
                    decoration: BoxDecoration(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xffB9C3FF),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => const AddTransactionScreen()))
                .whenComplete(() {
              setState(() {});
            });
          },
          child: const Icon(Icons.add_rounded, size: 33.0)),
      body: FutureBuilder<Map>(
        future: diveDB.fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("error"),
            );
          }

          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return const Center(
                child: Text(
                  "no values inserted",
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              );
            }

            return ListView(
              children: [
                // Container
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.all(12.0),
                  child: Container(
                    // height: 35,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            hexStringToColor("B9C3FF"),
                            hexStringToColor("14C1E0"),
                            hexStringToColor("009FD5")
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),

                //
                //
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Expenses",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 230, 230, 230),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: const Offset(0, 5))
                      ]),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 60.0),
                  height: 300.0,
                  child: LineChart(
                    LineChartData(
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                            spots: getPlotPoint(snapshot.data),
                            isCurved: false,
                            barWidth: 4.0,
                            colors: [Color(0xffB9C3FF)]),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("unexpected error"),
            );
          }
        },
      ),
    );
  }
}
