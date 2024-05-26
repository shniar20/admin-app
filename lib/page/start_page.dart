import 'package:employee/store/admin_provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    final AdminProvider adminProvider =
        Provider.of<AdminProvider>(context, listen: false);
    _initializeApp(adminProvider);
  }

  Future<void> _initializeApp(AdminProvider adminProvider) async {
    Timer(const Duration(milliseconds: 500), () async {
      _controller.forward();

      await adminProvider.checkSignIn();

      Timer(const Duration(seconds: 2), () {
        adminProvider.isSignedIn
            ? Navigator.pushReplacementNamed(context, '/navigation')
            : Navigator.pushReplacementNamed(context, '/login');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _animation,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("image/persons.jpg"),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 200.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تیمەکانی فریاکەوتن',
                  style: TextStyle(
                    fontFamily: 'rabar',
                    color: Color.fromARGB(255, 110, 14, 7),
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(height: 200),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_hospital,
                        size: 30, color: Color.fromARGB(255, 110, 14, 7)),
                    SizedBox(width: 20),
                    Icon(Icons.local_fire_department,
                        size: 30, color: Color.fromARGB(255, 110, 14, 7)),
                    SizedBox(width: 20),
                    Icon(Icons.local_police,
                        size: 30, color: Color.fromARGB(255, 110, 14, 7)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
