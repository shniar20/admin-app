import 'package:employee/models/admin_model.dart';
import 'package:employee/store/admin_provider.dart';
import 'package:employee/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAccount extends StatefulWidget {
  final String name;
  const EditAccount({
    super.key,
    required this.name,
  });

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  bool isEditing = false;
  bool confirmPassEnabled = false;
  late TextEditingController nameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPassController;
  late AdminProvider adminProvider;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    passwordController = TextEditingController();
    confirmPassController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    adminProvider = Provider.of<AdminProvider>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    String department = "";
    late IconData icon;
    switch (adminProvider.facility!.department) {
      case 0:
        department = "ئەمبوڵانس";
        icon = Icons.local_hospital;
        break;
      case 1:
        department = "ئاگرکوژێنەوە";
        icon = Icons.local_fire_department;
        break;
      case 2:
        department = "هاتوچۆ";
        icon = Icons.local_police;
        break;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const Icon(Icons.person, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 110, 14, 7),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chevron_right),
            color: Colors.white,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            isEditing
                ? Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        textDirection: TextDirection.rtl,
                        decoration: const InputDecoration(
                          hintText: "ناوی نوێ",
                          hintTextDirection: TextDirection.rtl,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: passwordController,
                        textDirection: TextDirection.rtl,
                        onChanged: (value) {
                          setState(() {
                            confirmPassEnabled = value.isNotEmpty;
                            if (value.isEmpty) {
                              confirmPassController.text = "";
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "وشەی تێپەڕی نوێ",
                          hintTextDirection: TextDirection.rtl,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: confirmPassController,
                        textDirection: TextDirection.rtl,
                        enabled: confirmPassEnabled,
                        decoration: const InputDecoration(
                          hintText: "دوبارە کردنەوەی وشەی تێپەڕی نوێ",
                          hintTextDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        adminProvider.name ?? "",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            department,
                            style: const TextStyle(
                              fontFamily: 'rabar',
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(icon),
                        ],
                      ),
                    ],
                  ),
            const SizedBox(height: 50),
            isEditing
                ? ElevatedButton(
                    onPressed: () {
                      if (adminProvider.isLoading) {
                        return;
                      }
                      if (passwordController.text !=
                          confirmPassController.text) {
                        showSnackBar(context, "وشەی تێپەڕەکان لە یەک ناچن");
                        return;
                      }

                      adminProvider.updateUser(
                          context: context,
                          admin: Admin(
                            id: adminProvider.id,
                            name: nameController.text.trim(),
                            password: passwordController.text.isNotEmpty
                                ? passwordController.text
                                : null,
                            facilityID: adminProvider.facilityID ?? "",
                            email: adminProvider.email ?? "",
                          ),
                          onSuccess: () {
                            Navigator.pop(context);
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 110, 14, 7),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60.0,
                        vertical: 5.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: adminProvider.isLoading
                        ? const SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'تۆمارکردنی گۆرانکاری',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 110, 14, 7),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60.0,
                        vertical: 5.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: const Text(
                      'گۆرین',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
