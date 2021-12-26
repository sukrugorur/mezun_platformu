// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.school,
    this.verification,
    this.name,
    this.email,
    this.password,
    this.about,
  });

  String id;
  School school;
  bool verification;
  String name;
  String email;
  String password;
  String about;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] == null ? null : json["_id"],
        school: json["school"] == null ? null : School.fromJson(json["school"]),
        verification: json["verification"] == null ? null : json["verification"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        password: json["password"] == null ? null : json["password"],
        about: json["about"] == null ? null : json["about"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "school": school == null ? null : school.toJson(),
        "verification": verification == null ? null : verification,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "password": password == null ? null : password,
        "about": about == null ? null : about,
      };
}

class School {
  School({
    this.university,
    this.branch,
  });

  String university;
  String branch;

  factory School.fromJson(Map<String, dynamic> json) => School(
        university: json["university"] == null ? null : json["university"],
        branch: json["branch"] == null ? null : json["branch"],
      );

  Map<String, dynamic> toJson() => {
        "university": university == null ? null : university,
        "branch": branch == null ? null : branch,
      };
}
