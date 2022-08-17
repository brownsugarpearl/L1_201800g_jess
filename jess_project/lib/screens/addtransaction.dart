import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jess_project/database/dive_db.dart';
import 'package:jess_project/screens/chart.dart';
import 'package:jess_project/screens/expense.dart';
import 'package:jess_project/screens/home.dart';
import 'package:jess_project/screens/login.dart';
import 'package:jess_project/screens/profile.dart';
import 'package:jess_project/utilitys/colors.dart';
import 'package:jess_project/utilitys/user.dart';

import '../services/firebaseauth_service.dart';
import '../services/firestore_service.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  int amount;
  String note = "Expense";
  String type = "Income";
  DateTime selectedDate = DateTime.now();

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

// array for months
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  Future<void> selectDate(BuildContext context) async {
    final DateTime pick = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022, 01),
        lastDate: DateTime(2050, 01));

    if (pick != null && pick != selectedDate) {
      setState(() {
        selectedDate = pick;
      });
    }
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
                        style: const TextStyle(
                            color: Colors.black, fontSize: 20.0),
                      ),
                      accountEmail: Text(
                        _cp.first.email,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 20.0),
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
                                builder: (BuildContext context) =>
                                    HomeScreen()));
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
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("B9C3FF"),
            hexStringToColor("14C1E0"),
            hexStringToColor("009FD5")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: ListView(
            padding: const EdgeInsets.all(12.0),
            children: <Widget>[
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                'Add Budget',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: hexStringToColor("B9C3FF"),
                        borderRadius: BorderRadius.circular(50.0)),
                    padding: const EdgeInsets.all(12.0),
                    child: const Icon(Icons.attach_money_rounded, size: 24.0),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: "0", border: InputBorder.none),
                      style: const TextStyle(fontSize: 22.0),

                      onChanged: (val) {
                        try {
                          amount = int.parse(val);
                        } catch (e) {
                          print("numbers only");
                        }
                      },
                      // to only allow number inputs
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],

                      //  to show keyboard numbers only
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: hexStringToColor("B9C3FF"),
                        borderRadius: BorderRadius.circular(50.0)),
                    padding: const EdgeInsets.all(12.0),
                    child: const Icon(Icons.description_rounded, size: 24.0),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: TextField(
                        decoration: const InputDecoration(
                            hintText: "Note on Budget",
                            border: InputBorder.none),
                        style: const TextStyle(fontSize: 22.0),
                        // maxLength: 24,

                        onChanged: (val) {
                          note = val;
                        }),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: hexStringToColor("B9C3FF"),
                        borderRadius: BorderRadius.circular(50.0)),
                    padding: const EdgeInsets.all(12.0),
                    child: const Icon(Icons.moving_rounded, size: 24.0),
                  ),
                  const SizedBox(width: 12.0),
                  ChoiceChip(
                    label: Text(
                      "Income",
                      style: TextStyle(
                          color: type == "Income" ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    selectedColor: Color(0xffB9C3FF),

                    selected: type == "Income" ? true : false,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          type = "Income";
                        });
                      }
                    },
                    // backgroundColor:
                  ),
                  const SizedBox(width: 12.0),
                  ChoiceChip(
                    label: Text(
                      "Expense",
                      style: TextStyle(
                          color:
                              type == "Expense" ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    selectedColor: const Color(0xffB9C3FF),

                    selected: type == "Expense" ? true : false,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          type = "Expense";
                        });
                      }
                    },
                    // backgroundColor:
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                  height: 45.0,
                  child: TextButton(
                      onPressed: () {
                        selectDate(context);
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: hexStringToColor("B9C3FF"),
                                  borderRadius: BorderRadius.circular(50.0)),
                              padding: const EdgeInsets.all(12.0),
                              child: const Icon(Icons.date_range_rounded,
                                  size: 24.0, color: Colors.black)),
                          const SizedBox(width: 12.0),
                          Text(
                            "${months[selectedDate.month - 1]} ${selectedDate.day}",
                            // "date",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16.0),
                          ),
                        ],
                      ))),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 45.0,
                child: ElevatedButton(
                    onPressed: () {
                      if (amount != null && note.isNotEmpty) {
                        DiveDB diveDB = DiveDB();
                        diveDB.addData(amount, selectedDate, note, type);
                      } else {
                        print('not all values given');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFB9C3FF)),
                    child: const Text(
                      "Add",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ));
  }
}
