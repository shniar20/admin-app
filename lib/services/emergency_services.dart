import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee/models/emergency_model.dart';
import 'package:employee/models/user_model.dart';

class EmergencyServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Emergency>> getEmergencies({
    required int department,
    bool? answered,
    bool? ambulanceAnswered,
  }) async {
    List<int> departmentsToFilter = [];

    switch (department) {
      case 0:
        departmentsToFilter = [0, 10, 20];
        break;
      case 1:
        departmentsToFilter = [1, 10];
        break;
      case 2:
        departmentsToFilter = [2, 20];
        break;
    }

    List<Emergency> emergencies = [];
    QuerySnapshot documents;
    QuerySnapshot ambulanceAnsweredDocuments;
    if (department == 0) {
      // Query for "answered" condition.
      documents = await _firebaseFirestore
          .collection("emergencies")
          .where("answered", isEqualTo: answered)
          .where("department", whereIn: departmentsToFilter)
          .get();

// Query for "ambulanceAnswered" condition.
      ambulanceAnsweredDocuments = await _firebaseFirestore
          .collection("emergencies")
          .where("ambulanceAnswered", isEqualTo: ambulanceAnswered)
          .where("department", whereIn: departmentsToFilter)
          .get();

// Combine results.
      Set<String> documentIds = {};

      for (var document in documents.docs) {
        if (!documentIds.contains(document.id)) {
          documentIds.add(document.id);
          Emergency emergency =
              Emergency.fromMap(document.data() as Map<String, dynamic>);
          emergency.id = document.id;
          emergencies.add(emergency);
        }
      }

      for (var document in ambulanceAnsweredDocuments.docs) {
        if (!documentIds.contains(document.id)) {
          documentIds.add(document.id);
          Emergency emergency =
              Emergency.fromMap(document.data() as Map<String, dynamic>);
          emergency.id = document.id;
          emergencies.add(emergency);
        }
      }
    } else {
      documents = await _firebaseFirestore
          .collection("emergencies")
          .where("answered", isEqualTo: answered)
          .where("department", whereIn: departmentsToFilter)
          .get();

      for (var document in documents.docs) {
        Emergency emergency =
            Emergency.fromMap(document.data() as Map<String, dynamic>);
        emergency.id = document.id;
        emergencies.add(emergency);
      }
    }

    for (Emergency emergency in emergencies) {
      DocumentSnapshot user = await _firebaseFirestore
          .collection("users")
          .doc(emergency.userID)
          .get();

      emergency.user = User.fromMap(user.data() as Map<String, dynamic>);
    }

    return emergencies;
  }

  Future<bool> approveEmergency(
      {required Emergency emergency, bool withAmbulance = false}) async {
    emergency.answered = true;
    if (withAmbulance) {
      emergency.ambulanceAnswered = true;
    }
    try {
      DocumentSnapshot document = await _firebaseFirestore
          .collection("users")
          .doc(emergency.userID)
          .get();
      User user = User.fromMap(document.data() as Map<String, dynamic>);
      user.emergencyPending!.approved = true;

      await _firebaseFirestore
          .collection("users")
          .doc(user.id)
          .set(user.toMap());

      await _firebaseFirestore
          .collection("emergencies")
          .doc(emergency.id!)
          .set(emergency.toMap());

      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  Future<bool> rejectEmergency(Emergency emergency) async {
    try {
      DocumentSnapshot document = await _firebaseFirestore
          .collection("users")
          .doc(emergency.userID)
          .get();
      User user = User.fromMap(document.data() as Map<String, dynamic>);
      user.emergencyPending!.approved = false;

      await _firebaseFirestore
          .collection("users")
          .doc(user.id)
          .set(user.toMap());

      await _firebaseFirestore
          .collection("emergencies")
          .doc(emergency.id!)
          .set(emergency.toMap());

      await _firebaseFirestore
          .collection("emergencies")
          .doc(emergency.id!)
          .delete();

      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }
}
