import 'package:employee/store/admin_provider.dart';
import 'package:employee/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  late AdminProvider adminProvider;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  bool passIsHidden = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    adminProvider = Provider.of<AdminProvider>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 70,
                  backgroundImage: AssetImage('image/admin1.png'),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "تکایە ئەم بۆشاییە پڕبکەرەوە";
                      }
                      return null;
                    },
                    style: const TextStyle(
                      fontFamily: 'rabar',
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      prefixIcon: Icon(
                        Icons.text_increase,
                        color: Color.fromARGB(255, 110, 14, 7),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 40,
                      ),
                      labelText: "ناو",
                      hintText: "ناو داخل بکە",
                      labelStyle: TextStyle(),
                      errorStyle: TextStyle(
                        fontFamily: 'rabar',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      RegExp regex = RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                      if (value == null || value.isEmpty) {
                        return "تکایە ئەم بۆشاییە پڕبکەرەوە";
                      } else if (!regex.hasMatch(value)) {
                        return "تکایە ئیمەیڵێکی درووست بنووسە";
                      }
                      return null;
                    },
                    style: const TextStyle(
                      fontFamily: 'rabar',
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Color.fromARGB(255, 110, 14, 7),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 40,
                      ),
                      labelText: "ئیمەیڵ",
                      hintText: "ئیمەیڵ داخل بکە",
                      labelStyle: TextStyle(),
                      errorStyle: TextStyle(
                        fontFamily: 'rabar',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            RegExp regex = RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
                            if (value == null || value.isEmpty) {
                              return 'تکایە ئەم بۆشاییە پڕبکەرەوە';
                            } else if (!regex.hasMatch(value)) {
                              return 'وشەی نهێنی نابێت لە ٨ پیت کەمتر بێت، پێویستە بە لایەنی کەمەوە یەک پیتی گەورە، یەک پیتی بچووک، یەک ژمارەی تێدابێت';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontFamily: 'rabar',
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: passIsHidden,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20.0),
                            prefixIcon: Icon(
                              Icons.password,
                              color: Color.fromARGB(255, 110, 14, 7),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 40,
                            ),
                            labelText: "وشەی تێپەڕ",
                            hintText: "وشەی تێپەڕ بنووسە",
                            labelStyle: TextStyle(),
                            errorStyle: TextStyle(
                              fontFamily: 'rabar',
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          passIsHidden = !passIsHidden;
                        });
                      },
                      icon: Icon(
                        passIsHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: confirmPassController,
                          style: const TextStyle(
                            fontFamily: 'rabar',
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: passIsHidden,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20.0),
                            prefixIcon: Icon(
                              Icons.password,
                              color: Color.fromARGB(255, 110, 14, 7),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 40,
                            ),
                            labelText: "دڵنیابوونەوە لە وشەی تێپەڕ",
                            hintText: "دڵنیابەرەوە لە وشەی تێپەڕ",
                            labelStyle: TextStyle(),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          passIsHidden = !passIsHidden;
                        });
                      },
                      icon: Icon(
                        passIsHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    controller: codeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "تکایە ئەم بۆشاییە پڕکەرەوە";
                      }
                      return null;
                    },
                    style: const TextStyle(
                      fontFamily: 'rabar',
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      prefixIcon: Icon(
                        Icons.code,
                        color: Color.fromARGB(255, 110, 14, 7),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 40,
                      ),
                      labelText: "کۆدی دامەزراوە",
                      hintText: "کۆدی دامەزراوە داخل بکە",
                      labelStyle: TextStyle(),
                      errorStyle: TextStyle(
                        fontFamily: 'rabar',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50.0),
                SizedBox(
                  width: 180,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (passwordController.text !=
                            confirmPassController.text) {
                          showSnackBar(context, "وشەی تێپەڕەکان لە یەک ناچن");
                          return;
                        }

                        adminProvider.saveUser(
                          context: context,
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          code: codeController.text,
                          onSuccess: () {},
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      backgroundColor: const Color.fromARGB(255, 110, 14, 7),
                    ),
                    child: adminProvider.isLoading
                        ? const SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 4.0,
                            ),
                          )
                        : const Text(
                            "چونە ژوورەوە",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'rabar'),
                          ),
                  ),
                ),
                // const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      "هەژمارت هەیە؟ ",
                      style: TextStyle(
                        fontFamily: 'rabar',
                        color: Colors.grey[700],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xff6d1500),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text(
                        "بچۆ ژوورەوە",
                        style: TextStyle(
                          fontFamily: 'rabar',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
