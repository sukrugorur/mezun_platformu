// To parse this JSON data, do
//
//     final postDetails = postDetailsFromJson(jsonString);

import 'dart:convert';

PostDetails postDetailsFromJson(String str) => PostDetails.fromJson(json.decode(str));

String postDetailsToJson(PostDetails data) => json.encode(data.toJson());

class PostDetails {
  PostDetails({
    this.likes,
    this.comments,
    this.hashtags,
    this.id,
    this.title,
    this.content,
    this.user,
    this.createAt,
    this.v,
    this.imgPath,
    this.filePath,
  });

  List<String> likes;
  List<Comment> comments;
  List<String> hashtags;
  String id;
  String title;
  String content;
  User user;
  DateTime createAt;
  int v;
  String imgPath;
  String filePath;

  factory PostDetails.fromJson(Map<String, dynamic> json) => PostDetails(
        likes: json["likes"] == null ? null : List<String>.from(json["likes"].map((x) => x)),
        comments: json["comments"] == null
            ? null
            : List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
        hashtags: json["hashtags"] == null ? null : List<String>.from(json["hashtags"].map((x) => x)),
        id: json["_id"] == null ? null : json["_id"],
        title: json["title"] == null ? null : json["title"],
        content: json["content"] == null ? null : json["content"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        createAt: json["createAt"] == null ? null : DateTime.parse(json["createAt"]),
        v: json["__v"] == null ? null : json["__v"],
        imgPath: json["imgPath"] == null ? null : json["imgPath"],
        filePath: json["filePath"] == null ? null : json["filePath"],
      );

  Map<String, dynamic> toJson() => {
        "likes": likes == null ? null : List<dynamic>.from(likes.map((x) => x)),
        "comments": comments == null ? null : List<dynamic>.from(comments.map((x) => x.toJson())),
        "hashtags": hashtags == null ? null : List<dynamic>.from(hashtags.map((x) => x)),
        "_id": id == null ? null : id,
        "title": title == null ? null : title,
        "content": content == null ? null : content,
        "user": user == null ? null : user.toJson(),
        "createAt": createAt == null ? null : createAt.toIso8601String(),
        "__v": v == null ? null : v,
        "imgPath": imgPath == null ? null : imgPath,
        "filePath": filePath == null ? null : filePath,
      };
}

class Comment {
  Comment({
    this.content,
    this.author,
  });

  String content;
  User author;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        content: json["content"] == null ? null : json["content"],
        author: json["author"] == null ? null : User.fromJson(json["author"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content == null ? null : content,
        "author": author == null ? null : author.toJson(),
      };
}

class User {
  User({
    this.profileImage,
    this.id,
    this.name,
  });

  String profileImage;
  String id;
  String name;

  factory User.fromJson(Map<String, dynamic> json) => User(
        profileImage: json["profileImage"] == null ? null : json["profileImage"],
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "profileImage": profileImage == null ? null : profileImage,
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
