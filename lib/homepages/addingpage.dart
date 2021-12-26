import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as mime;
import 'package:image_picker/image_picker.dart';

import 'homepage.dart';

class AddPage extends StatefulWidget {
  String token;
  String userId;
  int index;
  AddPage(this.token, this.userId, this.index);
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final formKey = GlobalKey<FormState>();
  final formKeyNew = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textController = TextEditingController();
  }

  final inputDecoration = BoxDecoration(
    color: Color(0xFF78A2CC).withOpacity(0.6),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  Future<void> _showMyDialog() async {
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
                    "Lütfen hashtagler arasında 1 boşluk olacak şekilde yazınız",
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

  String title = "";
  String content = "";
  Future<dynamic> newPostData;
  Future<dynamic> profileImage;
  Future<dynamic> newPostWithImageData;
  var hashtags = [];

  String departmentInternship = "";
  String companyInternship = "";
  List<String> programmingLanguagesInternship = [];
  bool checkedValue = false;

  String companyWorkedPlaces = "";
  String timeWorked = "";
  String departmentWorkedPlaces = "";
  List<String> programmingLanguagesWorkedPlaces = [];
  String project = "";

  Future<dynamic> addPlacesWorkedData;
  Future<dynamic> addInternshipData;

  List<String> allProgrammingLanguages = [
    "C",
    "C++",
    "C#",
    "Java",
    "Php",
    "Dart",
    "JavaScript",
    "Python",
    "Ruby",
    "R",
    "Swift",
    "Kotlin",
    "Go",
    "FORTRAN",
    "SQL"
  ];

  String technologie;
  List<String> technologies = [];

  TextEditingController textController;

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

  //PAYLAŞIM EKLEME
  Future<dynamic> newPost(String title, String content, var hashtags) async {
    final response = await http.post(
      "http://10.0.2.2:5000/post/add",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer:" + widget.token,
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'content': content,
        'hashtags': hashtags,
      }),
    );

    if (response.statusCode == 201) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else if (response.statusCode == 401) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else {
      final snackBar = SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        backgroundColor: Color(0xFF78A2CC),
        duration: Duration(seconds: 2),
        content: Text(
          "Post eklenirken hata oluştu",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<dynamic> getFile;

  // UYGULAMADAN DOSYA ALMA
  Future<dynamic> filePick() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
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

  //DOSYAYI VERİTABANINA GÖNDERME
  Future<String> newPostWithFile(filename, String title, String content, List<String> hashtags) async {
    List<String> hashtagsToSv = hashtags;
    List<String> newList = filename.split(".");
    String extension = newList[newList.length - 1];
    var request = http.MultipartRequest('POST', Uri.parse("http://10.0.2.2:5000/post/addfiletopost"));
    request.fields["title"] = title;
    request.fields["content"] = content;
    request.fields["authorization"] = "Bearer:" + widget.token;
    request.files.add(await http.MultipartFile.fromPath('post_file', filename,
        contentType: mime.MediaType("file", extension)));
    for (String item in hashtagsToSv) {
      request.files.add(http.MultipartFile.fromString('hashtags', item));
    }
    var res = await request.send();
    return res.reasonPhrase;
  }

  String imagePathData = "Belirtilmemis";
  String filePathData = "Belirtilmemis";
  File _image;
  double _height = 0;
  final picker = ImagePicker();

  // RESMİ UYGULAMADAN ALMA
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
  Future<String> newPostWithImage(filename, String title, String content, List<String> hashtags) async {
    List<String> hashtagsToSv = hashtags;
    List<String> newList = filename.split(".");
    String extension = newList[newList.length - 1];
    var request = http.MultipartRequest('POST', Uri.parse("http://10.0.2.2:5000/post/addimgtopost"));
    request.fields["title"] = title;
    request.fields["content"] = content;
    request.fields["authorization"] = "Bearer:" + widget.token;
    request.files.add(await http.MultipartFile.fromPath('post_file', filename,
        contentType: mime.MediaType("image", extension)));
    for (String item in hashtagsToSv) {
      request.files.add(http.MultipartFile.fromString('hashtags', item));
    }
    var res = await request.send();
    return res.reasonPhrase;
  }

  Widget bodyWidgets(int bodyIndex) {
    switch (bodyIndex) {
      //paylaşım ekleme
      case 0:
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Text(
                            "Yeni Paylaşım Ekle",
                            style: TextStyle(
                                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Başlık",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: inputDecoration,
                                alignment: Alignment.centerLeft,
                                height: 80,
                                child: TextFormField(
                                  maxLength: 20,
                                  validator: (String input) {
                                    if (input.length < 1) {
                                      return "Lütfen deger giriniz";
                                    } else
                                      return null;
                                  },
                                  onSaved: (value) => title = value,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefixIcon: Icon(Icons.title, color: Colors.white),
                                    hintText: "Başlık giriniz",
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "İçerik",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: inputDecoration,
                                alignment: Alignment.centerLeft,
                                height: 60,
                                child: TextFormField(
                                  maxLength: 500,
                                  validator: (String input) {
                                    if (input.length < 1) {
                                      return "Lütfen deger giriniz";
                                    } else
                                      return null;
                                  },
                                  onSaved: (value) => content = value,
                                  keyboardType: TextInputType.name,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefixIcon: Icon(Icons.chat, color: Colors.white),
                                    hintText: "İçerik giriniz",
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Etiketler",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: inputDecoration,
                                alignment: Alignment.centerLeft,
                                height: 60,
                                child: TextFormField(
                                  maxLength: 50,
                                  validator: null,
                                  onSaved: (value) {
                                    if (value.trim().length > 0) {
                                      hashtags = value.split(" ");
                                      hashtags.forEach((hashtag) {
                                        if (hashtag != " ") {
                                          if (hashtag[0] != "#") {
                                            hashtag = "#" + hashtag;
                                          }
                                        }
                                      });
                                    }
                                  },
                                  keyboardType: TextInputType.name,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefixIcon: Icon(Icons.chat, color: Colors.white),
                                    hintText: "Araya boşluk koyarak giriniz",
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                width: double.infinity,
                                child: RaisedButton(
                                  onPressed: () {
                                    profileImage = getImage().then((value) {
                                      if (value == null) {
                                        imagePathData = "Belirtilmemis";
                                        final snackBar = SnackBar(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15))),
                                          backgroundColor: Color(0xFF78A2CC),
                                          duration: Duration(seconds: 2),
                                          content: Text(
                                            "Resim ekleme işlemi iptal edildi.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      } else {
                                        imagePathData = value.toString();
                                        final snackBar = SnackBar(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15))),
                                          backgroundColor: Color(0xFF78A2CC),
                                          duration: Duration(seconds: 2),
                                          content: Text(
                                            "Resim eklendi",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                    });
                                  },
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  color: Color(0xFF78A2CC),
                                  child: Text(
                                    "Paylaşıma resim ekle",
                                    style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                width: double.infinity,
                                child: RaisedButton(
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
                                        final snackBar = SnackBar(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15))),
                                          backgroundColor: Color(0xFF78A2CC),
                                          duration: Duration(seconds: 2),
                                          content: Text(
                                            "Dosya eklendi",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                    });
                                  },
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  color: Color(0xFF78A2CC),
                                  child: Text(
                                    "Paylaşıma dosya ekle",
                                    style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 25),
                            width: double.infinity,
                            child: RaisedButton(
                              elevation: 5.0,
                              onPressed: () {
                                try {
                                  if (confirmInput()) {
                                    if (filePathData != "Belirtilmemis") {
                                      newPostWithFile(filePathData, title, content, hashtags)
                                          .then((value) {
                                        if (value == "OK") {
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(widget.token, widget.userId, 0)));
                                          return value.toString();
                                        } else {
                                          return value.toString();
                                        }
                                      });
                                    } else if (imagePathData != "Belirtilmemis") {
                                      newPostWithImage(imagePathData, title, content, hashtags)
                                          .then((value) {
                                        if (value == "OK") {
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(widget.token, widget.userId, 0)));
                                          return value.toString();
                                        } else {
                                          return value.toString();
                                        }
                                      });
                                    } else {
                                      newPostData = newPost(title, content, hashtags).then((value) {
                                        if (value["success"]) {
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(widget.token, widget.userId, 0)));
                                          return value["message"];
                                        } else {
                                          return value["message"];
                                        }
                                      });
                                    }
                                  }
                                } catch (e) {
                                  _showMyDialog();
                                }
                              },
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              color: Color(0xFF78A2CC),
                              child: Text(
                                "Paylaş",
                                style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        break;
      // Staj bilgisi ekleme
      case 1:
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Yeni Staj Ekle",
                            style: TextStyle(
                                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Şirket",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                              SizedBox(height: 10),
                              Container(
                                decoration: inputDecoration,
                                alignment: Alignment.centerLeft,
                                height: 60,
                                child: TextFormField(
                                  maxLength: 25,
                                  validator: (value) {
                                    if (value.length == 0) {
                                      value = "Lütfen yeni değeri giriniz";
                                      return value;
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) => companyInternship = value,
                                  keyboardType: TextInputType.name,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefixIcon: Icon(Icons.chat, color: Colors.white),
                                    hintText: "Staj şirketi giriniz",
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Departman",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: inputDecoration,
                                alignment: Alignment.centerLeft,
                                height: 60,
                                child: TextFormField(
                                  maxLength: 25,
                                  validator: (value) {
                                    if (value.length == 0) {
                                      value = "Lütfen yeni değeri giriniz";
                                      return value;
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) => departmentInternship = value,
                                  keyboardType: TextInputType.name,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefixIcon: Icon(Icons.chat, color: Colors.white),
                                    hintText: "Staj departmanı giriniz",
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Teknolojiler",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xFFBFD4DB),
                                ),
                                child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: (7 / 2),
                                    ),
                                    itemCount: allProgrammingLanguages.length,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        contentPadding: EdgeInsets.all(2),
                                        title: Text(allProgrammingLanguages[index]),
                                        value: programmingLanguagesInternship
                                                .contains(allProgrammingLanguages[index])
                                            ? true
                                            : false,
                                        onChanged: (newValue) {
                                          setState(() {
                                            programmingLanguagesInternship
                                                    .contains(allProgrammingLanguages[index])
                                                ? programmingLanguagesInternship
                                                    .remove(allProgrammingLanguages[index])
                                                : programmingLanguagesInternship
                                                    .add(allProgrammingLanguages[index]);
                                            checkedValue = newValue;
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity.leading,
                                      );
                                    }),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 25),
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: () {
                                if (confirmInput()) {
                                  addInternshipData = addInternship(companyInternship,
                                          departmentInternship, programmingLanguagesInternship)
                                      .then((value) {
                                    if (value["success"]) {
                                      Navigator.pop(context);
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
                                          "Staj bilgisi eklendi",
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
                                          "Staj bilgisi eklenirken hata oluştu",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                  });
                                }
                              },
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              color: Color(0xFF78A2CC).withOpacity(0.6),
                              child: Text(
                                "Bilgileri Onayla",
                                style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        break;
      // Çalışma Yeri Bilgisi Ekleme
      case 2:
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Çalışma Bilgisi Ekle",
                            style: TextStyle(
                                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Şirket",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: inputDecoration,
                                alignment: Alignment.centerLeft,
                                height: 60,
                                child: TextFormField(
                                  maxLength: 25,
                                  validator: (value) {
                                    if (value.length == 0) {
                                      value = "Lütfen yeni değeri giriniz";
                                      return value;
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) => companyWorkedPlaces = value,
                                  keyboardType: TextInputType.name,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefixIcon: Icon(Icons.chat, color: Colors.white),
                                    hintText: "Şirket giriniz",
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Departman",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                              SizedBox(height: 10),
                              Container(
                                decoration: inputDecoration,
                                alignment: Alignment.centerLeft,
                                height: 60,
                                child: TextFormField(
                                  maxLength: 25,
                                  validator: (value) {
                                    if (value.length == 0) {
                                      value = "Lütfen yeni değeri giriniz";
                                      return value;
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) => departmentWorkedPlaces = value,
                                  keyboardType: TextInputType.name,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefixIcon: Icon(Icons.chat, color: Colors.white),
                                    hintText: "Departman giriniz",
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Çalışma Süresi",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: inputDecoration,
                                alignment: Alignment.centerLeft,
                                height: 60,
                                child: TextFormField(
                                  maxLength: 25,
                                  validator: (value) {
                                    if (value.length == 0) {
                                      value = "Lütfen yeni değeri giriniz";
                                      return value;
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) => timeWorked = value,
                                  keyboardType: TextInputType.name,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefixIcon: Icon(Icons.chat, color: Colors.white),
                                    hintText: "Çalışma sürenizi giriniz",
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Programlama Dilleri",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xFFBFD4DB),
                                ),
                                child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: (7 / 2),
                                    ),
                                    itemCount: allProgrammingLanguages.length,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        contentPadding: EdgeInsets.all(2),
                                        title: Text(allProgrammingLanguages[index]),
                                        value: programmingLanguagesWorkedPlaces
                                                .contains(allProgrammingLanguages[index])
                                            ? true
                                            : false,
                                        onChanged: (newValue) {
                                          setState(() {
                                            programmingLanguagesWorkedPlaces
                                                    .contains(allProgrammingLanguages[index])
                                                ? programmingLanguagesWorkedPlaces
                                                    .remove(allProgrammingLanguages[index])
                                                : programmingLanguagesWorkedPlaces
                                                    .add(allProgrammingLanguages[index]);
                                            checkedValue = newValue;
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity.leading,
                                      );
                                    }),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Teknoloji Ekle",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: inputDecoration,
                                      alignment: Alignment.centerLeft,
                                      height: 60,
                                      child: Form(
                                        key: formKeyNew,
                                        child: TextFormField(
                                          controller: textController,
                                          maxLength: 25,
                                          validator: (value) {
                                            if (value.length == 0) {
                                              value = "Lütfen yeni değeri giriniz";
                                              return value;
                                            } else {
                                              return null;
                                            }
                                          },
                                          onSaved: (value) => technologie = value,
                                          keyboardType: TextInputType.name,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(top: 14),
                                            prefixIcon: Icon(Icons.chat, color: Colors.white),
                                            hintText: "Teknoloji ekle",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  RaisedButton(
                                    color: Color(0xFFBFD4DB),
                                    shape:
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                                    onPressed: () {
                                      if (confirmInputNew()) {
                                        setState(() {
                                          technologies.add(technologie);
                                          textController.clear();
                                        });
                                      }
                                    },
                                    child: Text(
                                      "Ekle",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              technologies.length != 0
                                  ? Text(
                                      "Teknolojiler",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                    )
                                  : Text(""),
                              technologies.length != 0 ? SizedBox(height: 10) : SizedBox(height: 0),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: technologies.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFBFD4DB).withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          technologies[index],
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              technologies.removeAt(index);
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Proje",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: inputDecoration,
                                alignment: Alignment.centerLeft,
                                height: 60,
                                child: TextFormField(
                                  maxLength: 25,
                                  validator: null,
                                  onSaved: (value) => project = value,
                                  keyboardType: TextInputType.name,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefixIcon: Icon(Icons.chat, color: Colors.white),
                                    hintText: "Proje linkinizi giriniz",
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 25),
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: () {
                                if (confirmInput()) {
                                  addPlacesWorkedData = addPlacesWorked(
                                          companyWorkedPlaces,
                                          departmentWorkedPlaces,
                                          programmingLanguagesWorkedPlaces,
                                          project,
                                          technologies,
                                          timeWorked)
                                      .then((value) {
                                    if (value["success"]) {
                                      Navigator.pop(context);
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
                                          "Çalışma yeri bilgisi eklendi",
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
                                          "Çalışma yeri bilgisi eklenirken hata oluştu",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                  });
                                }
                              },
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              color: Color(0xFF78A2CC).withOpacity(0.6),
                              child: Text(
                                "Bilgileri Onayla",
                                style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPopMethod,
      child: Scaffold(
        appBar: AppBar(
          elevation: 8,
          backgroundColor: Color(0xFFE2E3E9),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              iconSize: 32,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage(widget.token, widget.userId, 0)));
              }),
        ),
        //backgroundColor: Color(0xFFEDF0F6),
        backgroundColor: Color(0xFFE2E3E9),
        body: bodyWidgets(widget.index),
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

  bool confirmInputNew() {
    if (formKeyNew.currentState.validate()) {
      formKeyNew.currentState.save();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onWillPopMethod() {
    Navigator.pop(context);
    switch (widget.index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage(widget.token, widget.userId, 0)));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage(widget.token, widget.userId, 3)));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage(widget.token, widget.userId, 3)));
        break;
      default:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage(widget.token, widget.userId, 0)));
        break;
    }
  }
}
