import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee/utils/snackbar.dart';
import 'package:employee/models/admin_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool _isLoading = false;
  String? _id;
  String? _name;
  String? _email;
  String? _password;
  String? _facilityID;
  Facility? _facility;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  bool get isSignedIn => _isSignedIn;
  bool get isLoading => _isLoading;
  String? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get password => _password;
  String? get facilityID => _facilityID;
  Facility? get facility => _facility;

  set isSignedIn(bool isSignedIn) {
    _isSignedIn = isSignedIn;
    notifyListeners();
  }

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  set id(String? id) {
    _id = id;
    notifyListeners();
  }

  set name(String? name) {
    _name = name;
    notifyListeners();
  }

  set email(String? email) {
    _email = email;
    notifyListeners();
  }

  set password(String? password) {
    _password = password;
    notifyListeners();
  }

  set facilityID(String? facilityID) {
    _facilityID = facilityID;
    notifyListeners();
  }

  set facility(Facility? facility) {
    _facility = facility;
    notifyListeners();
  }

  Future<void> checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signed_in") ?? false;
    notifyListeners();

    if (!_isSignedIn) {
      return;
    }

    Map<String, dynamic> decodedJson =
        jsonDecode(s.getString("user_model") ?? "{}");

    Admin loggedInUser = Admin.fromMap(decodedJson);

    DocumentSnapshot fetchedUserData = await _firebaseFirestore
        .collection("admins")
        .doc(loggedInUser.id)
        .get();

    if (!fetchedUserData.exists) {
      return;
    }

    id = fetchedUserData.id;
    name = fetchedUserData.get("name");
    email = fetchedUserData.get("email");
    facilityID = fetchedUserData.get("facilityID");

    DocumentSnapshot fetchedFacility =
        await _firebaseFirestore.collection("facilities").doc(facilityID).get();

    facility = Facility.fromMap(fetchedFacility.data() as Map<String, dynamic>);
    print("done");
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setBool("is_signed_in", true);
    isSignedIn = true;
  }

  void signOut({required BuildContext context}) async {
    isSignedIn = false;
    id = null;
    name = null;
    email = null;
    password = null;
    facilityID = null;
    facility = null;

    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.clear();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        "/login",
        (route) => false,
      );
    }
  }

  void saveUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String code,
    required Function onSuccess,
  }) async {
    isLoading = true;
    email = email.toLowerCase().trim();
    try {
      QuerySnapshot fetchFacility = await _firebaseFirestore
          .collection("facilities")
          .where("code", isEqualTo: code)
          .get();

      if (fetchFacility.size == 0) {
        throw FirebaseException(
          plugin: "firestore",
          message: "کۆدی دامەزراوە هەڵەیە",
        );
      }

      QuerySnapshot fetchEmail = await _firebaseFirestore
          .collection("admins")
          .where("email", isEqualTo: email)
          .get();

      if (fetchEmail.size > 0) {
        throw FirebaseException(
          plugin: "firestore",
          message: "ببورە، ئەم ئیمەیڵە پێشتر بەکار هاتووە",
        );
      }

      Admin adminModel = Admin(
        name: name,
        email: email,
        password: password,
        facilityID: fetchFacility.docs[0].id,
        facility: Facility.fromMap(
            fetchFacility.docs[0].data() as Map<String, dynamic>),
      );

      await _firebaseFirestore
          .collection("admins")
          .add(adminModel.toMap())
          .then((value) {
        adminModel.id = value.id;
        onSuccess();
        isLoading = false;
      });
      await saveUserToSharedPreferences(adminModel).then((value) {
        setSignIn().then((value) {
          id = adminModel.id;
          name = adminModel.name;
          email = adminModel.email;
          facilityID = adminModel.facilityID;
          facility = adminModel.facility;
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/navigation',
            (route) => false,
          );
        });
      });
    } on FirebaseException catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.message.toString());
      }
      isLoading = false;
    }
  }

  void loadUser({
    required BuildContext context,
    required String email,
    required String password,
    required Function onSuccess,
  }) async {
    email = email.toLowerCase().trim();
    isLoading = true;
    try {
      QuerySnapshot document = await _firebaseFirestore
          .collection("admins")
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: password)
          .get();

      if (document.size == 0) {
        throw FirebaseException(
          plugin: "firestore",
          message: "ببورە، زانیاریەکانت هەڵەیە",
        );
      }

      Admin admin =
          Admin.fromMap(document.docs[0].data() as Map<String, dynamic>);
      admin.id = document.docs[0].id;

      DocumentSnapshot fetchFacility = await _firebaseFirestore
          .collection("facilities")
          .doc(admin.facilityID)
          .get();

      admin.facility =
          Facility.fromMap(fetchFacility.data() as Map<String, dynamic>);

      onSuccess();
      isLoading = false;

      await saveUserToSharedPreferences(admin).then((value) {
        setSignIn().then((value) {
          id = admin.id;
          name = admin.name;
          email = admin.email;
          facilityID = admin.facilityID;
          facility = admin.facility;
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/navigation',
            (route) => false,
          );
        });
      });
    } on FirebaseException catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.message.toString());
      }
      isLoading = false;
    }
  }

  void updateUser({
    required BuildContext context,
    required Admin admin,
    required Function onSuccess,
  }) async {
    isLoading = true;
    try {
      await _firebaseFirestore.collection("admins").doc(_id).set(admin.toMap());
      isLoading = false;

      name = admin.name;

      onSuccess();
    } on FirebaseException catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.message.toString());
      }
      isLoading = false;
    }
  }

  Future saveUserToSharedPreferences(Admin adminModel) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString("user_model", jsonEncode(adminModel.toMap()));
  }
}
