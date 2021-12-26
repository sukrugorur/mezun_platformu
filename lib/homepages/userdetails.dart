// To parse this JSON data, do
//
//     final userDetails = userDetailsFromJson(jsonString);

import 'dart:convert';

UserDetails userDetailsFromJson(String str) => UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails data) => json.encode(data.toJson());

class UserDetails {
  UserDetails(
      {this.verification,
      this.university,
      this.branch,
      this.internships,
      this.workedplaces,
      this.profileImage,
      this.posts,
      this.following,
      this.follower,
      this.id,
      this.name,
      this.email,
      this.createAt,
      this.v,
      this.about,
      this.gpa,
      this.transcript});

  bool verification;
  String university;
  String branch;
  List<Internship> internships;
  List<Workedplace> workedplaces;
  String profileImage;
  List<Post> posts;
  List<String> following;
  List<String> follower;
  String id;
  String name;
  String email;
  DateTime createAt;
  int v;
  String about;
  String gpa;
  String transcript;
  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        verification: json["verification"] == null ? null : json["verification"],
        university: json["university"] == null ? null : json["university"],
        branch: json["branch"] == null ? null : json["branch"],
        internships: json["internships"] == null
            ? null
            : List<Internship>.from(json["internships"].map((x) => Internship.fromJson(x))),
        workedplaces: json["workedplaces"] == null
            ? null
            : List<Workedplace>.from(json["workedplaces"].map((x) => Workedplace.fromJson(x))),
        profileImage: json["profileImage"] == null ? null : json["profileImage"],
        posts:
            json["posts"] == null ? null : List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
        following: json["following"] == null ? null : List<String>.from(json["following"].map((x) => x)),
        follower: json["follower"] == null ? null : List<String>.from(json["follower"].map((x) => x)),
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        createAt: json["createAt"] == null ? null : DateTime.parse(json["createAt"]),
        v: json["__v"] == null ? null : json["__v"],
        about: json["about"] == null ? null : json["about"],
        transcript: json["transcript"] == null ? null : json["transcript"],
        gpa: json["gpa"] == null ? null : json["gpa"],
      );

  Map<String, dynamic> toJson() => {
        "verification": verification == null ? null : verification,
        "university": university == null ? null : university,
        "branch": branch == null ? null : branch,
        "internships":
            internships == null ? null : List<dynamic>.from(internships.map((x) => x.toJson())),
        "workedplaces":
            workedplaces == null ? null : List<dynamic>.from(workedplaces.map((x) => x.toJson())),
        "profileImage": profileImage == null ? null : profileImage,
        "posts": posts == null ? null : List<dynamic>.from(posts.map((x) => x.toJson())),
        "following": following == null ? null : List<dynamic>.from(following.map((x) => x)),
        "follower": follower == null ? null : List<dynamic>.from(follower.map((x) => x)),
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "createAt": createAt == null ? null : createAt.toIso8601String(),
        "__v": v == null ? null : v,
        "about": about == null ? null : about,
        "transcript": transcript == null ? null : transcript,
        "gpa": gpa == null ? null : gpa,
      };
}

class Internship {
  Internship({
    this.company,
    this.department,
    this.programmingLanguages,
    this.id,
    this.v,
  });

  String company;
  String department;
  List<String> programmingLanguages;
  String id;
  int v;

  factory Internship.fromJson(Map<String, dynamic> json) => Internship(
        company: json["company"] == null ? null : json["company"],
        department: json["department"] == null ? null : json["department"],
        programmingLanguages: json["programmingLanguages"] == null
            ? null
            : List<String>.from(json["programmingLanguages"].map((x) => x)),
        id: json["_id"] == null ? null : json["_id"],
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "company": company == null ? null : company,
        "department": department == null ? null : department,
        "programmingLanguages":
            programmingLanguages == null ? null : List<dynamic>.from(programmingLanguages.map((x) => x)),
        "_id": id == null ? null : id,
        "__v": v == null ? null : v,
      };
}

class Post {
  Post({
    this.likes,
    this.comments,
    this.hashtags,
    this.id,
    this.title,
    this.content,
    this.createAt,
    this.v,
  });

  List<String> likes;
  List<String> comments;
  List<String> hashtags;
  String id;
  String title;
  String content;
  DateTime createAt;
  int v;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        likes: json["likes"] == null ? null : List<String>.from(json["likes"].map((x) => x)),
        comments: json["comments"] == null ? null : List<String>.from(json["comments"].map((x) => x)),
        hashtags: json["hashtags"] == null ? null : List<String>.from(json["hashtags"].map((x) => x)),
        id: json["_id"] == null ? null : json["_id"],
        title: json["title"] == null ? null : json["title"],
        content: json["content"] == null ? null : json["content"],
        createAt: json["createAt"] == null ? null : DateTime.parse(json["createAt"]),
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "likes": likes == null ? null : List<dynamic>.from(likes.map((x) => x)),
        "comments": comments == null ? null : List<dynamic>.from(comments.map((x) => x)),
        "hashtags": hashtags == null ? null : List<dynamic>.from(hashtags.map((x) => x)),
        "_id": id == null ? null : id,
        "title": title == null ? null : title,
        "content": content == null ? null : content,
        "createAt": createAt == null ? null : createAt.toIso8601String(),
        "__v": v == null ? null : v,
      };
}

class Workedplace {
  Workedplace({
    this.company,
    this.department,
    this.programmingLanguages,
    this.technologys,
    this.id,
    this.project,
    this.timeWorked,
    this.v,
  });

  String company;
  String department;
  List<String> programmingLanguages;
  List<String> technologys;
  String id;
  String project;
  String timeWorked;
  int v;

  factory Workedplace.fromJson(Map<String, dynamic> json) => Workedplace(
        company: json["company"] == null ? null : json["company"],
        department: json["department"] == null ? null : json["department"],
        programmingLanguages: json["programmingLanguages"] == null
            ? null
            : List<String>.from(json["programmingLanguages"].map((x) => x)),
        technologys:
            json["technologys"] == null ? null : List<String>.from(json["technologys"].map((x) => x)),
        id: json["_id"] == null ? null : json["_id"],
        project: json["project"] == null ? null : json["project"],
        timeWorked: json["timeWorked"] == null ? null : json["timeWorked"],
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "company": company == null ? null : company,
        "department": department == null ? null : department,
        "programmingLanguages":
            programmingLanguages == null ? null : List<dynamic>.from(programmingLanguages.map((x) => x)),
        "technologys": technologys == null ? null : List<dynamic>.from(technologys.map((x) => x)),
        "_id": id == null ? null : id,
        "project": project == null ? null : project,
        "timeWorked": timeWorked == null ? null : timeWorked,
        "__v": v == null ? null : v,
      };
}
