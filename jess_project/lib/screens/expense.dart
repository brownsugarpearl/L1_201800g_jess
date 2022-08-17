import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jess_project/database/dive_db.dart';
import 'package:jess_project/screens/addtransaction.dart';
import 'package:jess_project/screens/chart.dart';
import 'package:jess_project/screens/home.dart';
import 'package:jess_project/screens/login.dart';
import 'package:jess_project/screens/profile.dart';
import 'package:jess_project/services/firebaseauth_service.dart';
import 'package:jess_project/services/firestore_service.dart';
import 'package:jess_project/utilitys/colors.dart';

import '../utilitys/user.dart';
import '../widgets/widgets.dart';

// get email from user whos login
String email = FirebaseAuth.instance.currentUser.email;
String name = FirebaseAuth.instance.currentUser.displayName;

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({Key key}) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

String emailData = FirebaseAuth.instance.currentUser.email;
String nameData = FirebaseAuth.instance.currentUser.displayName;

class _ExpenseScreenState extends State<ExpenseScreen> {
  DiveDB diveDB = DiveDB();
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
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

  getTotalBalance(Map entireData) {
    totalExpense = 0;
    totalIncome = 0;
    totalBalance = 0;
    entireData.forEach((key, value) {
      if (value["type"] == "Income") {
        totalBalance = totalBalance + (value['amount'] as int);
        totalIncome = totalBalance + (value['amount'] as int);
      } else {
        totalBalance = totalBalance - (value['amount'] as int);
        totalExpense = totalExpense + (value['amount'] as int);
      }
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
                    currentAccountPicture: CircleAvatar(
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
                child: Text("no values inserted"),
              );
            }
            getTotalBalance(snapshot.data);
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Row(
                      //   children: [
                      //     Container(
                      //       decoration: BoxDecoration(
                      //           color: const Color(0xffB9C3FF),
                      //           borderRadius: BorderRadius.circular(12.0)),
                      //       padding: const EdgeInsets.all(12.0),
                      //       width: 64.0,
                      //       child: Image.asset("assets/images/logo.png"),
                      //     ),
                      //     const SizedBox(
                      //       width: 12.0,
                      //     ),
                      //     const Text(
                      //       "Welcome jesss",
                      //       style: TextStyle(
                      //           fontSize: 24.0,
                      //           fontWeight: FontWeight.w700,
                      //           color: Colors.black),
                      //     )
                      //   ],
                      // ),
                      // Container(
                      //     // decoration: BoxDecoration(
                      //     //     color: const Color(0xffB9C3FF),
                      //     //     borderRadius: BorderRadius.circular(12.0)),
                      //     // padding: const EdgeInsets.all(12.0),
                      //     // child: const Icon(
                      //     //   Icons.settings_rounded,
                      //     //   color: Colors.black,
                      //     //   size: 33.0,
                      //     // ),
                      //     )
                    ],
                  ),
                ),

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 20.0),
                    child: Column(children: [
                      const Text(
                        'Total Balance',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22.0, color: Colors.black),
                      ),
                      Text(
                        'SGD \$$totalBalance',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 26.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              income(totalIncome.toString()),
                              SizedBox(height: 20),
                              expense(totalExpense.toString())
                            ]),
                      )
                    ]),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Latest Expenses",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500),
                  ),
                ),

                //
                //
                //
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      // data at the index
                      Map dataIndex = snapshot.data[index];
                      if (dataIndex['type'] == "Income") {
                        return incomeWidget(
                            dataIndex['amount'], dataIndex["note"], context);
                      } else {
                        return expenseWidget(
                            dataIndex['amount'], dataIndex["note"], context);
                      }
                    })
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

Widget expenseWidget(int value, String note, BuildContext context) {
  return InkWell(
    onTap: () async {
      bool answer = await showConfirmDialog(
          context, "warning", "this record will be deleted");
      if (answer != null && answer) {}
    },
    child: Container(
        margin: const EdgeInsets.all(7.0),
        padding: const EdgeInsets.all(17.0),
        decoration: BoxDecoration(
            color: const Color(0xffB9C3FF),
            borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.arrow_circle_down_rounded,
                    size: 30.0, color: Colors.red[700]),
                const SizedBox(
                  width: 6.0,
                ),
                const Text(
                  "Expense",
                  style: TextStyle(fontSize: 18.0),
                )
              ],
            ),
            Text(
              " -$value",
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            )
          ],
        )),
  );
}

Widget incomeWidget(int value, String note, BuildContext context) {
  return InkWell(
    onTap: () async {
      bool answer = await showConfirmDialog(
          context, "warning", "this record will be deleted");
    },
    child: Container(
        margin: const EdgeInsets.all(7.0),
        padding: const EdgeInsets.all(17.0),
        decoration: BoxDecoration(
            color: const Color(0xffB9C3FF),
            borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.arrow_circle_up_rounded,
                    size: 30.0, color: Colors.green[700]),
                const SizedBox(
                  width: 6.0,
                ),
                const Text(
                  "Income",
                  style: TextStyle(fontSize: 18.0),
                )
              ],
            ),
            Text(
              " +$value",
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            )
          ],
        )),
  );
}

Widget income(String value) {
  return Row(
    children: [
      Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(30.0)),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(right: 8.0),
        child: Icon(
          Icons.arrow_upward_rounded,
          color: Colors.green[800],
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "income",
            style: TextStyle(fontSize: 14.0, color: Colors.black),
          ),
          Text(value,
              style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      )
    ],
  );
}

Widget expense(String value) {
  return Row(
    children: [
      Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(30.0)),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(right: 8.0),
        child: Icon(
          Icons.arrow_downward_rounded,
          color: Colors.red[800],
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "expense",
            style: TextStyle(fontSize: 14.0, color: Colors.black),
          ),
          Text(value,
              style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      )
    ],
  );
}
