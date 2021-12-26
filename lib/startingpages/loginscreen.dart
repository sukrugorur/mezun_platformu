import 'dart:async';
import 'dart:convert';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appproje/homepages/homepage.dart';
import 'package:flutter_appproje/startingpages/forgotpasswordpage.dart';
import 'package:flutter_appproje/startingpages/registerscreen.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  String gelenMesaj;
  LoginScreen({this.gelenMesaj});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
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

  Future<void> _showMyDialog(String gelenText) async {
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
                    gelenText,
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

  AnimationController controller;
  SequenceAnimation sequenceAnimation;
  final formKey = GlobalKey<FormState>();
  String mail = "";
  String password = "";
  bool isObsecure = true;
  String mesaj = "";
  Future<dynamic> loginData;

  // GİRİŞ YAPMA İSTEĞİ
  Future<dynamic> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        "http://10.0.2.2:5000/auth/login",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        return decodedJson;
      } else if (response.statusCode == 400) {
        var decodedJson = jsonDecode(response.body);
        return decodedJson;
      }
    } catch (e) {
      _showMyDialog(
          "İnternet bağlantınız bulunmamaktadır. Lütfen internete bağlandığınızdan emin olunuz");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this);
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 400),
            from: Duration(seconds: 0),
            to: Duration(milliseconds: 250),
            tag: "width")
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 900),
            from: Duration(seconds: 0),
            to: Duration(milliseconds: 250),
            tag: "height")
        .animate(controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Colors.blueGrey.shade500,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          duration: Duration(seconds: 2),
          content: Text(
            "Çıkmak için geri tuşuna tekrar basın",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 70),
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/logo.png",
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                              ),
                              SizedBox(height: 60),
                              Text(
                                "Giriş Yap",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("E-postanız"),
                                  SizedBox(height: 10),
                                  Container(
                                    decoration: kBoxDecorationStyle,
                                    alignment: Alignment.centerLeft,
                                    height: 60,
                                    child: TextFormField(
                                      validator: emailCheck,
                                      onSaved: (value) {
                                        mail = value.trim();
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(top: 14),
                                        prefixIcon: Icon(Icons.mail, color: Colors.white),
                                        hintText: "E-postanızı giriniz",
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
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
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            isObsecure ? Icons.visibility_off : Icons.visibility,
                                            color: Colors.grey.shade700,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isObsecure = !isObsecure;
                                            });
                                          },
                                        ),
                                        hintText: "Şifrenizi giriniz",
                                      ),
                                    ),
                                  ),
                                  // FORGOT PASSWORD BUTONU
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => ForgotPassword()));
                                      },
                                      child: Text(
                                        "Şifrenizi Mi Unuttunuz?",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(mesaj,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                              // GİRİŞ YAP BUTONU
                              Container(
                                width: double.infinity,
                                child: RaisedButton(
                                  elevation: 5.0,
                                  onPressed: () {
                                    if (confirmInput()) {
                                      loginData = loginUser(mail, password).then((value) {
                                        if (value["success"]) {
                                          controller.forward().orCancel;
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                  value["access_token"], value["data"]["id"], 0)));
                                        } else {
                                          _showMyDialog(value["message"]);
                                        }
                                      });
                                    }
                                  },
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  color: Colors.white,
                                  child: Text(
                                    "Giriş Yap",
                                    style: TextStyle(
                                        color: Color(0xFF527DAA),
                                        letterSpacing: 1.5,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              // KAYIT OL BUTONU
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => RegisterScreen()));
                                },
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Hesabınız yok mu?",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "  Kayıt olun",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ANİMASYON
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Center(
                      child: Container(
                        color: Colors.white,
                        width: sequenceAnimation["width"].value,
                        height: sequenceAnimation["height"].value,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String emailCheck(String mail) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(mail.trim())) {
      return "Lütfen geçerli mail adresi giriniz";
    } else
      return null;
  }

  bool confirmInput() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    } else
      return false;
  }
}
