import 'package:employee/page/edit_account.dart';
import 'package:employee/store/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  late AdminProvider adminProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    adminProvider = Provider.of<AdminProvider>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 110, 14, 7),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage('image/admin.jpg'),
              ),
              const SizedBox(height: 10),
              Text(
                adminProvider.name ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(CupertinoIcons.person),
          title: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditAccount(
                    name: adminProvider.name ?? "",
                  ),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'گۆڕینی هه‌ژماری بەکارهێنەر',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: TextButton(
            onPressed: () {
              show(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 90.0),
              child: Text(
                'چونەدەرەوە',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 110, 14, 7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ]),
    ));
  }

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "چونەدەرەوە",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 33, 67, 127)),
            textAlign: TextAlign.right,
          ),
          content: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.grey[200],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "ئایا تۆ دلنیایی ؟",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black, // Set text color
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    adminProvider.signOut(context: context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 16, 113, 19),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "بەلێ",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 154, 12, 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "نەخێر",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
