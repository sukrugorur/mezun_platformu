import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appproje/startingpages/loginscreen.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final kBoxDecorationStyle = BoxDecoration(
    color: Color(0xFF6CA8F1),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  // BİLGİ MESAJI
  Future<void> _showMyDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Anladım'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final formKey = GlobalKey<FormState>();
  bool isObsecure = true;
  String mail = "";
  String password = "";
  String name = "";
  String university = "";
  String branch = "";
  Future<dynamic> registerData;
  String message = "";

  // KULLANICI OLUŞTURMA İSTEĞİ
  Future<dynamic> createUser(
      String name, String email, String password, String university, String branch) async {
    final response = await http.post(
      "http://10.0.2.2:5000/auth/register",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
        'university': university,
        'branch': branch,
      }),
    );

    if (response.statusCode == 201) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    }
    // kullanıcı adı veya email kullanımda
    else if (response.statusCode == 400) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    }
    // email gönderme hatası
    else if (response.statusCode == 500) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else {
      _showMyDialog("Bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: Color(0xFF73AEF5), elevation: 0),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.3, 0.5, 0.7],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Kayıt Ol",
                          style:
                              TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        //KULLANICI ADI
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Kullanıcı Adı"),
                            SizedBox(height: 10),
                            Container(
                              decoration: kBoxDecorationStyle,
                              alignment: Alignment.centerLeft,
                              height: 60,
                              child: TextFormField(
                                validator: confirmText,
                                onSaved: (value) => name = value,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14),
                                  prefixIcon: Icon(Icons.person, color: Colors.white),
                                  hintText: "Kullanıcı adınızı giriniz",
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30),
                        //ÜNİVERSİTE
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Üniversite"),
                            SizedBox(height: 10),
                            Container(
                              decoration: kBoxDecorationStyle,
                              alignment: Alignment.centerLeft,
                              height: 60,
                              child: TextFormField(
                                validator: confirmText,
                                onSaved: (value) => university = value,
                                keyboardType: TextInputType.name,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14),
                                  prefixIcon: Icon(Icons.school, color: Colors.white),
                                  hintText: "Üniversite bilginizi giriniz",
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30),
                        // BÖLÜM
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Bölüm"),
                            SizedBox(height: 10),
                            Container(
                              decoration: kBoxDecorationStyle,
                              alignment: Alignment.centerLeft,
                              height: 60,
                              child: TextFormField(
                                validator: confirmText,
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
                        SizedBox(height: 30),
                        // E POSTA
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("E-posta"),
                            SizedBox(height: 10),
                            Container(
                              decoration: kBoxDecorationStyle,
                              alignment: Alignment.centerLeft,
                              height: 60,
                              child: TextFormField(
                                validator: confirmEmail,
                                onSaved: (value) => mail = value,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14),
                                  prefixIcon: Icon(Icons.mail, color: Colors.white),
                                  hintText: "E-postanızı giriniz",
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30),
                        //ŞİFRE
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Şifre"),
                            SizedBox(height: 10),
                            Container(
                              decoration: kBoxDecorationStyle,
                              alignment: Alignment.centerLeft,
                              height: 60,
                              child: TextFormField(
                                validator: (String input) {
                                  if (input.length < 6) {
                                    return "\nEn az 6 karakterli bir şifre giriniz";
                                  } else
                                    return null;
                                },
                                onSaved: (value) => password = value,
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.white),
                                obscureText: isObsecure,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14),
                                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                                  hintText: "Şifrenizi giriniz",
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isObsecure ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isObsecure = !isObsecure;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: Text(
                                message,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 25),
                              width: double.infinity,
                              child: RaisedButton(
                                elevation: 5.0,
                                onPressed: () {
                                  if (confirmInput()) {
                                    registerData = createUser(name, mail, password, university, branch)
                                        .then((value) {
                                      if (value["success"]) {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen(gelenMesaj: value["message"])));
                                        _showMyDialog(value["message"]);
                                      } else {
                                        _showMyDialog(value["message"]);
                                      }
                                    });
                                  } else {
                                    _showMyDialog("Lütfen bilgileri eksiksiz girdiğinizden emin olunuz");
                                  }
                                },
                                padding: EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                color: Colors.white,
                                child: Text(
                                  "Kayıt Ol",
                                  style: TextStyle(
                                      color: Color(0xFF527DAA),
                                      letterSpacing: 1.5,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(height: 200),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String confirmEmail(String mail) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(mail)) {
      return "Lütfen geçerli mail adresi giriniz";
    } else
      return null;
  }

  String confirmText(String input) {
    RegExp regex = RegExp("^[a-zA-ZiİçÇşŞğĞÜüÖö ]+\$");
    if (!regex.hasMatch(input)) {
      return "İsim numara içermemeli";
    } else
      return null;
  }

  bool confirmInput() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    } else {
      return false;
    }
  }
}
