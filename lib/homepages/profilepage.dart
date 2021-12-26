import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appproje/homepages/addingpage.dart';
import 'package:flutter_appproje/homepages/displaypdfpage.dart';
import 'package:flutter_appproje/homepages/editprofilepage.dart';
import 'package:flutter_appproje/homepages/homepage.dart';
import 'package:flutter_appproje/homepages/postdetailpage.dart';
import 'package:flutter_appproje/homepages/userdetails.dart';
import 'package:flutter_appproje/startingpages/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as mime;
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  String token;
  String userId;
  String myId;
  String title;
  ProfilePage(this.token, this.userId, this.myId, this.title);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserDetails userDetails;
  Future<UserDetails> profilePageData;

  Future<dynamic> logoutData;
  Future<dynamic> followUserData;

  Future<dynamic> deleteInternshipData;
  Future<dynamic> addInternshipData;
  Future<dynamic> editInternshipData;

  Future<dynamic> deletePlacesWorkedData;
  Future<dynamic> addPlacesWorkedData;
  Future<dynamic> editPlacesWorkedData;
  Future<void> launchData;

  Future<dynamic> getFile;
  Future<dynamic> deleteTranscriptData;

  String filePathData = "Belirtilmemis";

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  //ID'Lİ KULLANICIYI GETİRME
  Future<UserDetails> getUser(String id) async {
    var response = await http.get("http://10.0.2.2:5000/auth/getuser/$id", headers: {
      "Authorization": "Bearer:" + widget.token,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      userDetails = UserDetails.fromJson(decodedJson["data"]);
      return userDetails;
    } else if (response.statusCode == 401) {
      var decodedJson = json.decode(response.body);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginScreen(gelenMesaj: decodedJson["message"])));
      return null;
    } else if (response.statusCode == 400) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage(widget.token, widget.userId, 0)));
      return null;
    }
  }

  // LINKE TIKLAMA
  _launchURL(String url) async {
    List<String> urlEdited = url.split(".");
    debugPrint(urlEdited.toString());

    if (urlEdited[0] == "www") {
      url = "https://" + url;
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final snackBar = SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        backgroundColor: Color(0xFF78A2CC),
        duration: Duration(seconds: 2),
        content: Text(
          "Link hatalı",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // ÇIKIŞ YAPMA
  Future<dynamic> userExit() async {
    var response = await http.get("http://10.0.2.2:5000/auth/logout", headers: {
      "Authorization": "Bearer:" + widget.token,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else if (response.statusCode == 401) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    }
  }

  // KULLANICIYI TAKİP ETME
  Future<dynamic> followUser(String id) async {
    var response = await http.get("http://10.0.2.2:5000/auth/follow/$id", headers: {
      "Authorization": "Bearer:" + widget.token,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else if (response.statusCode == 401) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    }
  }

  //STAJ BİLGİSİ EKLEME
  Future<dynamic> addInternship(
      String company, String department, List<String> programmingLanguages) async {
    var response = await http.post("http://10.0.2.2:5000/auth/internship/add",
        headers: {
          "Authorization": "Bearer:" + widget.token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'company': company,
          'department': department,
          "programmingLanguages": programmingLanguages,
        }));

    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else if (response.statusCode == 401) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    }
  }

  // STAJ BİLGİSİ SİLME
  Future<dynamic> deleteInternship(String id) async {
    var response = await http.delete("http://10.0.2.2:5000/auth/internship/delete/$id", headers: {
      "Authorization": "Bearer:" + widget.token,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else if (response.statusCode == 401) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    }
  }

  //ÇALIŞMA YERİ BİLGİSİ EKLEME
  Future<dynamic> addPlacesWorked(String company, String department, List<String> programmingLanguages,
      String project, List<String> technologys, String timeWorked) async {
    var response = await http.post("http://10.0.2.2:5000/auth/workedplace/add",
        headers: {
          "Authorization": "Bearer:" + widget.token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'company': company,
          'department': department,
          "programmingLanguages": programmingLanguages,
          "project": project,
          "technologys": technologys,
          "timeWorked": timeWorked
        }));

    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else if (response.statusCode == 401) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    }
  }

  // ÇALIŞMA YERİ BİLGİSİ SİLME
  Future<dynamic> deletePlacesWorked(String id) async {
    var response = await http.delete("http://10.0.2.2:5000/auth/workedplace/delete/$id", headers: {
      "Authorization": "Bearer:" + widget.token,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else if (response.statusCode == 401) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    }
  }

  // UYGULAMADAN TRANSKRİPT ALMA
  Future<dynamic> filePick() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
      debugPrint(file.path);
      return file.path;
    } else {
      final snackBar = SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        backgroundColor: Color(0xFF78A2CC),
        duration: Duration(seconds: 2),
        content: Text(
          "Dosya seçilirken hata",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  //TRANSKRİPTİ VERİTABANINA GÖNDERME
  Future<String> addTranscript(filename) async {
    List<String> newList = filename.split(".");
    String extension = newList[newList.length - 1];
    var request = http.MultipartRequest('POST', Uri.parse("http://10.0.2.2:5000/auth/addtranscript"));
    request.fields["authorization"] = "Bearer:" + widget.token;
    request.files.add(await http.MultipartFile.fromPath('transcript', filename,
        contentType: mime.MediaType("file", extension)));
    var res = await request.send();
    return res.reasonPhrase;
  }

  //TRANSKRİPT DOSYASINI KALDIRMA
  Future<dynamic> deleteTranscript() async {
    var response = await http.delete("http://10.0.2.2:5000/auth/deletetranscript", headers: {
      "Authorization": "Bearer:" + widget.token,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else if (response.statusCode == 401) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    }
  }

  // ÇIKIŞ SORUSU
  Future<void> _showMyDialogLogOut() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Çıkmak istediğinize emin misiniz?"),
          actions: <Widget>[
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Evet'),
              onPressed: () {
                logoutData = userExit().then((value) {
                  if (value["success"]) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profilePageData = getUser(widget.userId);
  }

  int _profileSegmentedValue = 0;
  Map<int, Widget> _profileTabs = <int, Widget>{
    0: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Paylaşım",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    ),
    1: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Profil",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    ),
    2: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Staj",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    ),
    3: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Çalışma",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    ),
  };

  Widget _profilePageWidgets(var snapshotData, List<DataRow> internship, List<DataRow> placesWorked) {
    switch (_profileSegmentedValue) {
      case 0:
        return !snapshotData.posts.isEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshotData.posts.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostDetailPage(
                                  widget.token, widget.userId, snapshotData.posts[index].id, true)));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        //color: Colors.blueGrey.shade100,
                        color: Color(0xFFBFD4DB).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: snapshotData.profileImage == "default.jpg"
                                      ? CircleAvatar(
                                          radius: 24,
                                          backgroundColor: Color(0xFF78A2CC),
                                          child: Text(
                                            snapshotData.name[0].toUpperCase(),
                                            style: TextStyle(fontSize: 24, color: Colors.white),
                                          ),
                                        )
                                      : Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    "http://10.0.2.2:5000/static/uploads/userImage/" +
                                                        snapshotData.profileImage)),
                                            borderRadius: BorderRadius.all(Radius.circular(26.0)),
                                          ),
                                        ),
                                  title: Text(
                                    snapshotData.posts[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      fontFamily: "Fonts1",
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  width: double.infinity,
                                  child: Text(snapshotData.posts[index].content,
                                      style: TextStyle(
                                        height: 1.3,
                                        letterSpacing: 0.2,
                                        wordSpacing: 1,
                                        fontSize: 20,
                                        fontFamily: "Fonts1",
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          //bu padding
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      child: Row(
                                        children: <Widget>[
                                          snapshotData.posts[index].likes.contains(widget.userId)
                                              ? Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                  size: 32,
                                                )
                                              : Icon(
                                                  Icons.favorite_border,
                                                  size: 32,
                                                ),
                                          Text(
                                            snapshotData.posts[index].likes.length.toString(),
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      child: Row(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.chat),
                                            iconSize: 32,
                                          ),
                                          Text(snapshotData.posts[index].comments.length.toString(),
                                              style:
                                                  TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Container(
                width: double.infinity,
                height: 480,
                child: Center(
                    child: Text(
                  "Kullanıcıya ait paylaşım bulunmamaktadır",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )),
              );

        break;
      case 1:
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
          child: Container(
            padding: EdgeInsets.all(10),
            //color: Colors.blueGrey.shade200,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Üniversite: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: snapshotData.university,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Branş: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: snapshotData.branch,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Genel Akademik Ortalama: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: snapshotData.gpa == null ? "Belirtilmemiş " : snapshotData.gpa,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Mail: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: snapshotData.email,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Hakkında: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: snapshotData.about == null ||
                                snapshotData.about == " " ||
                                snapshotData.about == ""
                            ? "Belirtilmemiş"
                            : snapshotData.about,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                widget.userId == widget.myId
                    ? snapshotData.transcript != null
                        ? Column(
                            children: [
                              RaisedButton(
                                color: Colors.white.withOpacity(0.6),
                                elevation: 0,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DisplayPdfPage(
                                              widget.token,
                                              widget.userId,
                                              "http://10.0.2.2:5000/static/uploads/userTranscript/" +
                                                  snapshotData.transcript,
                                              "Transkript dosyası")));
                                },
                                child: Text(
                                  "Transkript dosyasını göster",
                                  style: TextStyle(
                                      color: Color(0xFF78A2CC),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              RaisedButton(
                                color: Colors.white.withOpacity(0.6),
                                elevation: 0,
                                onPressed: () {
                                  deleteTranscriptData = deleteTranscript().then((value) {
                                    if (value["success"]) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePage(widget.token, widget.userId, 3)));
                                      final snackBar = SnackBar(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15))),
                                        backgroundColor: Color(0xFF78A2CC),
                                        duration: Duration(seconds: 2),
                                        content: Text(
                                          "Transkript dosyası silindi",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    } else {
                                      final snackBar = SnackBar(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15))),
                                        backgroundColor: Color(0xFF78A2CC),
                                        duration: Duration(seconds: 2),
                                        content: Text(
                                          "Transkript silinirken hata oluştu",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                  });
                                },
                                child: Text(
                                  "Transkript dosyasını kaldır",
                                  style: TextStyle(
                                      color: Color(0xFF78A2CC),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              )
                            ],
                          )
                        : RaisedButton(
                            color: Colors.white.withOpacity(0.6),
                            elevation: 0,
                            onPressed: () {
                              getFile = filePick().then((value) {
                                if (value == null) {
                                  filePathData = "Belirtilmemis";
                                  final snackBar = SnackBar(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15))),
                                    backgroundColor: Color(0xFF78A2CC),
                                    duration: Duration(seconds: 2),
                                    content: Text(
                                      "Dosya ekleme işlemi iptal edildi.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                } else {
                                  filePathData = value.toString();
                                  if (filePathData != "Belirtilmemis") {
                                    addTranscript(filePathData).then((value) {
                                      if (value == "OK") {
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage(widget.token, widget.userId, 3)));
                                        return value.toString();
                                      } else {
                                        debugPrint(value);
                                        debugPrint("Dosya Hatası");
                                        return value.toString();
                                      }
                                    });
                                  }
                                }
                              });
                            },
                            child: Text(
                              "Transkript dosyası ekle",
                              style: TextStyle(
                                  color: Color(0xFF78A2CC), fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          )
                    : snapshotData.transcript != null
                        ? RaisedButton(
                            color: Colors.white.withOpacity(0.6),
                            elevation: 0,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DisplayPdfPage(
                                          widget.token,
                                          widget.userId,
                                          "http://10.0.2.2:5000/static/uploads/userTranscript/" +
                                              snapshotData.transcript,
                                          "Transkript dosyası")));
                            },
                            child: Text(
                              "Transkript dosyasını göster",
                              style: TextStyle(
                                  color: Color(0xFF78A2CC), fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          )
                        : Container()
              ],
            ),
          ),
        );
        break;
      case 2:
        return Column(
          children: <Widget>[
            SizedBox(height: 10),
            widget.myId == widget.userId
                ? FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddPage(widget.token, widget.userId, 1)));
                    },
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                    child: Text("Staj Bilgisi Ekle",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white)),
                    color: Color(0xFF78A2CC),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  )
                : Container(),
            snapshotData.internships.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshotData.internships.length,
                    itemBuilder: (context, index) {
                      List<TextSpan> programmingLanguagesInternshipList = [];

                      for (int i = 0;
                          i < snapshotData.internships[index].programmingLanguages.length;
                          i++) {
                        programmingLanguagesInternshipList.add(
                          TextSpan(
                            text: snapshotData.internships[index].programmingLanguages[i] ==
                                    snapshotData.internships[index].programmingLanguages[
                                        snapshotData.internships[index].programmingLanguages.length - 1]
                                ? snapshotData.internships[index].programmingLanguages[i]
                                : snapshotData.internships[index].programmingLanguages[i] + ", ",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        );
                      }

                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFBFD4DB).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(5),
                              alignment: Alignment.topLeft,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "Şirket:  ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: snapshotData.internships[index].company,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            Divider(
                              color: Color(0xFF78A2CC),
                              thickness: 1,
                            ),
                            Container(
                              margin: EdgeInsets.all(5),
                              alignment: Alignment.topLeft,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "Departman:  ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: snapshotData.internships[index].department,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            Divider(
                              color: Color(0xFF78A2CC),
                              thickness: 1,
                            ),
                            Container(
                              margin: EdgeInsets.all(5),
                              alignment: Alignment.topLeft,
                              child: RichText(
                                maxLines: 3,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Programlama Dilleri:  ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      children: programmingLanguagesInternshipList,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Color(0xFF78A2CC),
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      deleteInternshipData =
                                          deleteInternship(snapshotData.internships[index].id)
                                              .then((value) {
                                        if (value["success"]) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(widget.token, widget.userId, 3)));
                                          final snackBar = SnackBar(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(15),
                                                    topRight: Radius.circular(15))),
                                            backgroundColor: Color(0xFF78A2CC),
                                            duration: Duration(seconds: 2),
                                            content: Text(
                                              "Staj bilgisi silindi",
                                              textAlign: TextAlign.center,
                                              style:
                                                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        } else {
                                          final snackBar = SnackBar(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(15),
                                                    topRight: Radius.circular(15))),
                                            backgroundColor: Color(0xFF78A2CC),
                                            duration: Duration(seconds: 2),
                                            content: Text(
                                              "Staj bilgisi silinirken hata oluştu",
                                              textAlign: TextAlign.center,
                                              style:
                                                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                      });
                                    });
                                  },
                                  child: Icon(Icons.delete),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Container(
                    height: 300,
                    child: Center(
                        child: Text(
                      "Staj bilgisi bulunmamaktadır",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )))
          ],
        );
        break;

      case 3:
        return Column(
          children: <Widget>[
            SizedBox(height: 10),
            widget.myId == widget.userId
                ? FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddPage(widget.token, widget.userId, 2)));
                    },
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                    child: Text("Çalışma Geçmişi Bilgisi Ekle",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white)),
                    color: Color(0xFF78A2CC),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  )
                : Container(),
            snapshotData.workedplaces.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshotData.workedplaces.length,
                    itemBuilder: (context, index) {
                      List<TextSpan> programmingLanguagesWorkedPlacesList = [];
                      List<TextSpan> technologiesWorkedPlacesList = [];

                      for (int i = 0;
                          i < snapshotData.workedplaces[index].programmingLanguages.length;
                          i++) {
                        programmingLanguagesWorkedPlacesList.add(
                          TextSpan(
                            text: snapshotData.workedplaces[index].programmingLanguages[i] ==
                                    snapshotData.workedplaces[index].programmingLanguages[
                                        snapshotData.workedplaces[index].programmingLanguages.length - 1]
                                ? snapshotData.workedplaces[index].programmingLanguages[i]
                                : snapshotData.workedplaces[index].programmingLanguages[i] + ", ",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        );
                      }

                      for (int i = 0; i < snapshotData.workedplaces[index].technologys.length; i++) {
                        technologiesWorkedPlacesList.add(
                          TextSpan(
                            text: snapshotData.workedplaces[index].technologys[i] ==
                                    snapshotData.workedplaces[index].technologys[
                                        snapshotData.workedplaces[index].technologys.length - 1]
                                ? snapshotData.workedplaces[index].technologys[i]
                                : snapshotData.workedplaces[index].technologys[i] + ", ",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        );
                      }

                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFBFD4DB).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(5),
                              alignment: Alignment.topLeft,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "Şirket:  ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: snapshotData.workedplaces[index].company,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            Divider(
                              color: Color(0xFF78A2CC),
                              thickness: 1,
                            ),
                            Container(
                              margin: EdgeInsets.all(5),
                              alignment: Alignment.topLeft,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "Çalışma Süresi:  ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: snapshotData.workedplaces[index].timeWorked,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            Divider(
                              color: Color(0xFF78A2CC),
                              thickness: 1,
                            ),
                            Container(
                              margin: EdgeInsets.all(5),
                              alignment: Alignment.topLeft,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "Departman:  ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: snapshotData.workedplaces[index].department,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            Divider(
                              color: Color(0xFF78A2CC),
                              thickness: 1,
                            ),
                            Container(
                              margin: EdgeInsets.all(5),
                              alignment: Alignment.topLeft,
                              child: RichText(
                                maxLines: 3,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Programlama Dilleri:  ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      children: programmingLanguagesWorkedPlacesList,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Color(0xFF78A2CC),
                              thickness: 1,
                            ),
                            technologiesWorkedPlacesList.length > 0
                                ? Container(
                                    margin: EdgeInsets.all(5),
                                    alignment: Alignment.topLeft,
                                    child: RichText(
                                      maxLines: 3,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Teknolojiler:  ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            children: technologiesWorkedPlacesList,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            technologiesWorkedPlacesList.length > 0
                                ? Divider(
                                    color: Color(0xFF78A2CC),
                                    thickness: 1,
                                  )
                                : Container(),
                            snapshotData.workedplaces[index].project != ""
                                ? InkWell(
                                    onTap: () {
                                      launchData = _launchURL(snapshotData.workedplaces[index].project);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      alignment: Alignment.topLeft,
                                      child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: "Proje:  ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: snapshotData.workedplaces[index].project,
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  )
                                : Container(),
                            snapshotData.workedplaces[index].project != ""
                                ? Divider(
                                    color: Color(0xFF78A2CC),
                                    thickness: 1,
                                  )
                                : Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      deletePlacesWorkedData =
                                          deletePlacesWorked(snapshotData.workedplaces[index].id)
                                              .then((value) {
                                        if (value["success"]) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(widget.token, widget.userId, 3)));
                                          final snackBar = SnackBar(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(15),
                                                    topRight: Radius.circular(15))),
                                            backgroundColor: Color(0xFF78A2CC),
                                            duration: Duration(seconds: 2),
                                            content: Text(
                                              "Çalışma geçmişi bilgisi silindi",
                                              textAlign: TextAlign.center,
                                              style:
                                                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        } else {
                                          final snackBar = SnackBar(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(15),
                                                    topRight: Radius.circular(15))),
                                            backgroundColor: Color(0xFF78A2CC),
                                            duration: Duration(seconds: 2),
                                            content: Text(
                                              "Çalışma geçmişi bilgisi silinirken hata oluştu",
                                              textAlign: TextAlign.center,
                                              style:
                                                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                      });
                                    });
                                  },
                                  child: Icon(Icons.delete),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Container(
                    height: 300,
                    child: Center(
                        child: Text(
                      "Çalışma geçmişi bilgisi bulunmamaktadır",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )))
          ],
        );
      default:
        return Center(child: Text("Yanlışlık oldu"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: widget.userId == widget.myId
          ? Drawer(
              child: FutureBuilder(
                future: profilePageData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    return Column(
                      children: [
                        UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color: Color(0xFF78A2CC).withOpacity(0.6),
                          ),
                          currentAccountPicture: snapshot.data.profileImage == "default.jpg"
                              ? CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Color(0xFF78A2CC),
                                  child: Text(
                                    snapshot.data.name[0].toUpperCase(),
                                    style: TextStyle(fontSize: 40, color: Colors.white),
                                  ),
                                )
                              : Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "http://10.0.2.2:5000/static/uploads/userImage/" +
                                                snapshot.data.profileImage)),
                                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                  ),
                                ),
                          accountName: Text(
                            snapshot.data.name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          accountEmail: Text(snapshot.data.email,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          minWidth: MediaQuery.of(context).size.width * 0.6,
                          onPressed: () {
                            _showMyDialogLogOut();
                          },
                          color: Color(0xFF78A2CC),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Çıkış Yap",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text("boş");
                  }
                },
              ),
            )
          : null,
      backgroundColor: Color(0xFFE2E3E9),
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 0,
        title: widget.userId != widget.myId
            ? Text(widget.title + "'in profili", style: TextStyle(color: Colors.black, fontSize: 20))
            : Text("Profilim", style: TextStyle(color: Colors.black, fontSize: 20)),
        backgroundColor: Colors.blueGrey.shade100,
        actions: [
          widget.myId == widget.userId
              ? IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    _scaffoldKey.currentState.openEndDrawer();
                  })
              : Container()
        ],
      ),
      body: FutureBuilder(
        future: profilePageData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            List<DataRow> listeRowInternship = [];
            List<DataRow> listeRowPlacesWorked = [];

            for (int i = 0; i < snapshot.data.internships.length; i++) {
              listeRowInternship.add(DataRow(cells: [
                DataCell(Text(snapshot.data.internships[i].company == null
                    ? "Belirtilmemiş"
                    : snapshot.data.internships[i].company)),
                DataCell(Text(snapshot.data.internships[i].department == null
                    ? "Belirtilmemiş"
                    : snapshot.data.internships[i].department)),
              ]));
            }

            for (int j = 0; j < snapshot.data.workedplaces.length; j++) {
              listeRowPlacesWorked.add(DataRow(cells: [
                DataCell(Text(snapshot.data.workedplaces[j].company == null
                    ? "Belirtilmemiş"
                    : snapshot.data.workedplaces[j].company)),
                DataCell(Text(snapshot.data.workedplaces[j].department == null
                    ? "Belirtilmemiş"
                    : snapshot.data.workedplaces[j].department)),
                DataCell(Text(snapshot.data.workedplaces[j].timeWorked == null
                    ? "Belirtilmemiş"
                    : snapshot.data.workedplaces[j].timeWorked)),
                DataCell(Text(snapshot.data.workedplaces[j].project == null
                    ? "Belirtilmemiş"
                    : snapshot.data.workedplaces[j].project)),
              ]));
            }

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFBFD4DB).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      snapshot.data.profileImage == "default.jpg"
                                          ? CircleAvatar(
                                              radius: 28,
                                              backgroundColor: Color(0xFF78A2CC),
                                              child: Text(
                                                snapshot.data.name[0].toUpperCase(),
                                                style: TextStyle(fontSize: 24, color: Colors.white),
                                              ),
                                            )
                                          : Container(
                                              width: 70.0,
                                              height: 70.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        "http://10.0.2.2:5000/static/uploads/userImage/" +
                                                            snapshot.data.profileImage)),
                                                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                              ),
                                            ),
                                      SizedBox(height: 15),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data.name,
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 125,
                                width: 225,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          snapshot.data.posts.length.toString(),
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          snapshot.data.follower.length.toString(),
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          snapshot.data.following.length.toString(),
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Paylaşım",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          "Takipçi",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          "Takip",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    ),

                                    //PROFİLİ DÜZENLE // TAKİP BUTONU
                                    widget.userId == widget.myId
                                        ? FlatButton(
                                            onPressed: () {
                                              List<String> internshipCompanies = [];
                                              List<String> internshipDepartments = [];

                                              List<String> placesWorkedCompanies = [];
                                              List<String> placesWorkedDepartments = [];
                                              List<String> placesWorkedTimeWorked = [];

                                              for (int i = 0;
                                                  i < snapshot.data.internships.length;
                                                  i++) {
                                                internshipCompanies
                                                    .add(snapshot.data.internships[i].company);
                                                internshipDepartments
                                                    .add(snapshot.data.internships[i].department);
                                              }
                                              for (int i = 0;
                                                  i < snapshot.data.workedplaces.length;
                                                  i++) {
                                                placesWorkedCompanies
                                                    .add(snapshot.data.workedplaces[i].company);
                                                placesWorkedDepartments
                                                    .add(snapshot.data.workedplaces[i].department);
                                                placesWorkedTimeWorked
                                                    .add(snapshot.data.workedplaces[i].timeWorked);
                                              }
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => EditProfilePage(
                                                      widget.token,
                                                      widget.userId,
                                                      widget.myId,
                                                      widget.title,
                                                      snapshot.data.about,
                                                      snapshot.data.branch,
                                                      snapshot.data.gpa,
                                                      snapshot.data.university,
                                                    ),
                                                  ));
                                            },
                                            minWidth: 225,
                                            child: Text("Profili Düzenle",
                                                style: TextStyle(color: Colors.white)),
                                            color: Color(0xFF78A2CC),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10)),
                                          )
                                        : FlatButton(
                                            child: snapshot.data.follower.contains(widget.myId)
                                                ? Text(
                                                    "Takibi Bırak",
                                                    style: TextStyle(color: Colors.white),
                                                  )
                                                : Text("Takip Et",
                                                    style: TextStyle(color: Colors.white)),
                                            color: Color(0xFF78A2CC),
                                            minWidth: 225,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10)),
                                            onPressed: () {
                                              followUserData =
                                                  followUser(snapshot.data.id).then((value) {
                                                if (value["success"]) {
                                                  final snackBar = SnackBar(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(15),
                                                            topRight: Radius.circular(15))),
                                                    backgroundColor: Colors.blueGrey.shade500,
                                                    duration: Duration(seconds: 2),
                                                    content: Text(
                                                      value["message"],
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16, fontWeight: FontWeight.bold),
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (context, animation1, animation2) =>
                                                            ProfilePage(widget.token, widget.userId,
                                                                widget.myId, widget.title),
                                                        transitionDuration: Duration(seconds: 0),
                                                      ));
                                                } else {
                                                  final snackBar = SnackBar(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(15),
                                                            topRight: Radius.circular(15))),
                                                    backgroundColor: Colors.blueGrey.shade500,
                                                    duration: Duration(seconds: 2),
                                                    content: Text(
                                                      "Bir hata oluştu",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16, fontWeight: FontWeight.bold),
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                }
                                              });
                                            },
                                          )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    color: Color(0xFFE2E3E9).withOpacity(0.4),
                    child: CupertinoSlidingSegmentedControl(
                      groupValue: _profileSegmentedValue,
                      thumbColor: Color(0xFF78A2CC),
                      backgroundColor: Colors.blueGrey.shade300,
                      children: _profileTabs,
                      onValueChanged: (index) {
                        setState(() {
                          _profileSegmentedValue = index;
                        });
                      },
                    ),
                  ),
                  _profilePageWidgets(snapshot.data, listeRowInternship, listeRowPlacesWorked),
                ],
              ),
            );
          } else
            return Center(child: Text("Hata"));
        },
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
}
