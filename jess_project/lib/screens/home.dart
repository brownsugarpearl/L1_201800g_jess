import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jess_project/screens/about.dart';
import 'package:jess_project/screens/expense.dart';
import 'package:jess_project/screens/profile.dart';
import 'package:jess_project/utilitys/budget_repository.dart';
import 'package:jess_project/utilitys/colors.dart';
import 'package:jess_project/utilitys/failure_model.dart';
import 'package:jess_project/utilitys/spending_chart.dart';
import 'package:jess_project/utilitys/user.dart';

import '../services/firebaseauth_service.dart';
import '../services/firestore_service.dart';
import '../utilitys/item_model.dart';
import 'chart.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Item>> _futureItems;

  List<Profile> _cp;

  bool _loading;
  TextEditingController controller_name;
  TextEditingController controller_email;
  @override
  void initState() {
    super.initState();
    _futureItems = BudgetRepository().getItems();

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

  int index = 0;
  final screens = [
    HomeScreen(),
    AboutScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: Color.fromARGB(255, 107, 129, 255),
              labelTextStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            child: NavigationBar(
              backgroundColor: Color(0XFFB9C3FF),
              selectedIndex: index,
              onDestinationSelected: (index) =>
                  setState(() => this.index = index),
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.home_rounded), label: 'home'),
                NavigationDestination(
                    icon: Icon(Icons.info_rounded), label: 'about'),
                NavigationDestination(
                    icon: Icon(Icons.home_rounded), label: 'mail'),
                NavigationDestination(
                    icon: Icon(Icons.favorite), label: 'favorite')
              ],
            )),
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
        body: RefreshIndicator(
            onRefresh: () async {
              _futureItems = BudgetRepository().getItems();
              setState(() {});
            },
            child: FutureBuilder<List<Item>>(
                future: _futureItems,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Show pie chart and list view of items
                    final items = snapshot.data;
                    return ListView.builder(
                      itemCount: items.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) return SpendingChart(items: items);
                        final item = items[index - 1];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              width: 2.0,
                              color: getCategoryColor(item.category),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 2),
                                  blurRadius: 6.0)
                            ],
                          ),
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(item.name),
                            subtitle: Text(
                                '${item.category} . ${DateFormat.yMd().format(item.date)} '),
                            trailing:
                                Text('-\$${item.price.toStringAsFixed(2)}'),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    // show failure error msg
                    final failure = snapshot.error as Failure;
                    return Center(child: Text(failure.message));
                  }
                  // show loading spinner
                  return const Center(child: CircularProgressIndicator());
                })));
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case 'Entertainment':
      return Colors.red[200];
    case 'Food':
      return Colors.green[200];
    case 'Personal':
      return Colors.blue[200];
    case 'Transportation':
      return Colors.purple[200];
    default:
      return Colors.orange[200];
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("B9C3FF"),
          hexStringToColor("14C1E0"),
          hexStringToColor("009FD5")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
            ),
          ),
        ));
  }
}
