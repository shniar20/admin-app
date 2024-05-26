class Admin {
  String? id;
  String name;
  String email;
  String? password;
  String facilityID;
  Facility? facility;
  String? imagePath;
  DateTime? createdAt = DateTime.now();

  Admin({
    this.id,
    required this.name,
    required this.facilityID,
    required this.email,
    this.password,
    this.facility,
    this.imagePath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Admin.fromMap(Map<String, dynamic> data) {
    return Admin(
      id: data["id"],
      name: data["name"],
      email: data["email"],
      password: data["password"],
      facilityID: data["facilityID"],
      imagePath: data["imagePath"],
      createdAt:
          data["createdAt"] != null ? DateTime.parse(data["createdAt"]) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "facilityID": facilityID,
      "createdAt": createdAt?.toIso8601String(),
    };
  }
}

class Facility {
  int department;
  String code;

  Facility({
    required this.department,
    required this.code,
  });

  factory Facility.fromMap(Map<String, dynamic> data) {
    return Facility(
      department: data["department"],
      code: data["code"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "department": department,
      "code": code,
    };
  }
}
