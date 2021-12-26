import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as mime;
import 'package:image_picker/image_picker.dart';

import 'homepage.dart';

class EditProfilePage extends StatefulWidget {
  String token;
  String userId;
  String myId;
  String title;
  String orgGpa;
  String orgAbout;
  String orgUniversity;
  String orgBranch;

  EditProfilePage(
    this.token,
    this.userId,
    this.myId,
    this.title,
    this.orgAbout,
    this.orgBranch,
    this.orgGpa,
    this.orgUniversity,
  );
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final inputDecoration = BoxDecoration(
    color: Color(0xFF78A2CC),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );
  TextEditingController textControllerAbout;
  TextEditingController textControllerUniversity;
  TextEditingController textControllerBranch;
  TextEditingController textControllerGPA;

  final formKey = GlobalKey<FormState>();
  final formKeyNew = GlobalKey<FormState>();

  String gpa = "";
  String about = "";
  String university = "";
  String branch = "";

  Future<dynamic> editProfileData;
  Future<dynamic> editProfileImageData;
  Future<dynamic> deleteProfilePageData;

  String path = "Belirtilmemis";
  File _image;
  final picker = ImagePicker();

  // UYGULAMADAN RESMİ ALMA
  Future<dynamic> getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery).then((value) {
        if (value != null) {
          _image = File(value.path);
        } else {
          return "Olmadı";
        }
      });
      return _image.path;
    } catch (e) {
      debugPrint("hata " + e.toString());
    }
  }

  //RESMİ VERİTABANINA GÖNDERME
  Future<String> uploadImage(filename) async {
    List<String> newList = filename.split(".");
    String extension = newList[newList.length - 1];
    var request = http.MultipartRequest('POST', Uri.parse("http://10.0.2.2:5000/auth/profileImage"));
    request.headers.addAll({
      "Authorization": "Bearer:" + widget.token,
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    });

    request.files.add(await http.MultipartFile.fromPath('profile_image', filename,
        contentType: mime.MediaType("image", extension)));

    var res = await request.send();
    return res.reasonPhrase;
  }

  //PROFİL FOTOĞRAFI SİLME İSTEĞİ
  Future<dynamic> deleteProfilePhoto() async {
    var response = await http.delete("http://10.0.2.2:5000/auth/profileImage", headers: {
      "Authorization": "Bearer:" + widget.token,
    });

    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else if (response.statusCode == 400) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else if (response.statusCode == 500) {
      final snackBar = SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        backgroundColor: Colors.blueGrey.shade500,
        duration: Duration(seconds: 2),
        content: Text(
          "Profil Fotoğrafınız kaldırılırken bir hata oluştu",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    textControllerAbout = TextEditingController(text: widget.orgAbout);
    textControllerUniversity = TextEditingController(text: widget.orgUniversity);
    textControllerBranch = TextEditingController(text: widget.orgBranch);
    textControllerGPA = TextEditingController(text: widget.orgGpa);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textControllerAbout.dispose();
    textControllerUniversity.dispose();
    textControllerBranch.dispose();
    textControllerGPA.dispose();
    super.dispose();
  }

  //PROFİL DÜZENLEME İSTEĞİ
  Future<dynamic> editProfile(String about, String university, String branch, String gpa) async {
    var response = await http.put(
      "http://10.0.2.2:5000/auth/editDetails",
      headers: {
        "Authorization": "Bearer:" + widget.token,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'about': about,
        'university': university,
        'branch': branch,
        'gpa': gpa,
      }),
    );
    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else if (response.statusCode == 400) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE2E3E9),
      appBar: AppBar(
        shadowColor: Color(0xFF78A2CC),
        backgroundColor: Color(0xFF78A2CC),
        title: Text("Profili Düzenle"),
      ),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    color: Color(0xFF78A2CC),
                    child: Text("Profil Fotoğrafını Güncelle"),
                    onPressed: () {
                      editProfileImageData = getImage().then((value) {
                        if (value == null) {
                          path = "Belirtilmemis";
                          final snackBar = SnackBar(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                            backgroundColor: Color(0xFF78A2CC),
                            duration: Duration(seconds: 2),
                            content: Text(
                              "Resim eklerken bir sorun oluştu.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          path = value.toString();
                          final snackBar = SnackBar(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                            backgroundColor: Color(0xFF78A2CC),
                            duration: Duration(seconds: 2),
                            content: Text(
                              "Bilgilerinizi kaydedince profil fotoğrafınız güncellenecektir",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    color: Color(0xFF78A2CC),
                    child: Text("Profil Fotoğrafını Kaldır"),
                    onPressed: () {
                      deleteProfilePageData = deleteProfilePhoto().then((value) {
                        if (value["success"]) {
                          final snackBar = SnackBar(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                            backgroundColor: Colors.blueGrey.shade500,
                            duration: Duration(seconds: 2),
                            content: Text(
                              "Profil Fotoğrafınız Kaldırıldı",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          final snackBar = SnackBar(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                            backgroundColor: Colors.blueGrey.shade500,
                            duration: Duration(seconds: 2),
                            content: Text(
                              "Profil Fotoğrafınız kaldırılırken bir hata oluştu",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Profil Bilgileri",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Hakkında"),
                    SizedBox(height: 10),
                    Container(
                      decoration: inputDecoration,
                      alignment: Alignment.centerLeft,
                      height: 60,
                      child: TextFormField(
                        controller: textControllerAbout,
                        validator: null,
                        onSaved: (value) => about = value,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14),
                          prefixIcon: Icon(Icons.person, color: Colors.white),
                          hintText: "Hakkında kısmını giriniz",
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Üniversite"),
                    SizedBox(height: 10),
                    Container(
                      decoration: inputDecoration,
                      alignment: Alignment.centerLeft,
                      height: 60,
                      child: TextFormField(
                        controller: textControllerUniversity,
                        validator: confirmName,
                        onSaved: (value) => university = value,
                        keyboardType: TextInputType.name,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14),
                          prefixIcon: Icon(Icons.school, color: Colors.white),
                          hintText: "Üniversite bilgisi giriniz",
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Bölüm"),
                    SizedBox(height: 10),
                    Container(
                      decoration: inputDecoration,
                      alignment: Alignment.centerLeft,
                      height: 60,
                      child: TextFormField(
                        controller: textControllerBranch,
                        validator: confirmName,
                        onSaved: (value) => branch = value,
                        keyboardType: TextInputType.name,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14),
                          prefixIcon: Icon(Icons.edit, color: Colors.white),
                          hintText: "Bölümünüzü giriniz",
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Genel Akademik Ortalama"),
                    SizedBox(height: 10),
                    Container(
                      decoration: inputDecoration,
                      alignment: Alignment.centerLeft,
                      height: 60,
                      child: TextFormField(
                        controller: textControllerGPA,
                        validator: confirmGpa,
                        onSaved: (value) => gpa = value,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14),
                          prefixIcon: Icon(Icons.mail, color: Colors.white),
                          hintText: "Genel akademik ortalamanızı giriniz",
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  width: double.infinity,
                  child: RaisedButton(
                    elevation: 5.0,
                    onPressed: () {
                      if (confirmInput()) {
                        editProfileData = editProfile(about, university, branch, gpa).then((value) {
                          if (value["success"]) {
                            if (path != "Belirtilmemis") {
                              uploadImage(path).then((value1) {
                                if (value1 == "OK") {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomePage(widget.token, widget.userId, 3)));
                                } else {
                                  debugPrint("Resim Hatası");
                                }
                              });
                            } else {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage(widget.token, widget.userId, 3)));
                            }
                          } else {
                            debugPrint("Yemedi");
                          }
                        });
                      } else {
                        final snackBar2 = SnackBar(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                          backgroundColor: Colors.blueGrey.shade500,
                          duration: Duration(seconds: 3),
                          content: Text(
                            "Lütfen bilgileri doğru girdiğinizden emin olunuz",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                      }
                    },
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    color: Color(0xFF78A2CC),
                    child: Text(
                      "Bilgileri Kaydet",
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool confirmInput() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    } else {
      return false;
    }
  }

  bool confirmEditedInput() {
    if (formKeyNew.currentState.validate()) {
      formKeyNew.currentState.save();
      return true;
    } else {
      return false;
    }
  }
}

String confirmName(String input) {
  RegExp regex = RegExp("^[a-zA-ZiİçÇşŞğĞÜüÖö ]+\$");
  if (!regex.hasMatch(input)) {
    return "İsim numara içermemeli";
  } else
    return null;
}

String confirmGpa(String gpa) {
  RegExp regex = RegExp("^[0-3]\.?\d{0,2}|[4].[0]{0,2}\$ ");
  if (!regex.hasMatch(gpa)) {
    return "Ortalamanız 4'den büyük olmamalı ve harf içermemeli";
  } else
    return null;
}
