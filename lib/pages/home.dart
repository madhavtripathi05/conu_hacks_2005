import 'package:conu_hacks_2005/pages/add_page.dart';
import 'package:conu_hacks_2005/pages/orders.dart';
import 'package:conu_hacks_2005/pages/profile.dart';
import 'package:conu_hacks_2005/pages/requests.dart';
import 'package:conu_hacks_2005/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'groups.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final authService = AuthService.instance;
  int currIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPage(currIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: performAdd,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (i) => setState(() {
                if (i == 2) {
                  performAdd();
                  return;
                }
                currIndex = i;
                setState(() {});
              }),
          currentIndex: currIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.card_travel), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
            BottomNavigationBarItem(icon: Icon(Icons.abc, color: Colors.transparent), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Requests'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'profile'),
          ]),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const AddPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Widget buildPage(int index) {
    Widget widget = Container();
    switch (index) {
      case 0:
        widget = const Orders();
        break;
      case 1:
        widget = Groups();
        break;
      case 3:
        widget = const Requests();
        break;
      case 4:
        widget = const Profile();
        break;
    }

    return widget;
  }

  void performAdd() {
    Navigator.of(context).push(_createRoute());
  }
}
