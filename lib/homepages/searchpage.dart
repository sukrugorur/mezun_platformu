import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_appproje/homepages/postdetailpage.dart';
import 'package:flutter_appproje/homepages/profilepage.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  String token, userId;
  SearchPage(this.token, this.userId);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final formKey = GlobalKey<FormState>();

  Future<dynamic> searchUserData;
  Future<dynamic> searchPostData;
  Future<dynamic> searchProgLangData;
  Future<dynamic> searchCompanyData;

  int dropdownValue = 1;

  String _hintText(int index) {
    switch (index) {
      case 1:
        return "Aramak istediğiniz kişinin adını giriniz";
        break;
      case 2:
        return "Etiketine göre post aramak için tıklayınız";
        break;
      case 3:
        return "Programlama diline göre aramak için tıklayınız";
        break;
      case 4:
        return "Çalışılan şirkete göre aramak için tıklayınız";
    }
  }

  //KULLANICI BULMA
  Future<dynamic> findUserByName(String input) async {
    var response = await http.get("http://10.0.2.2:5000/auth/searchuser?searchString=$input", headers: {
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

  // POST BULMA
  Future<dynamic> findPostByHashtag(String input) async {
    var response = await http.get("http://10.0.2.2:5000/post/searchpost?searchString=$input", headers: {
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

  // PROGRAMLAMA DİLİNE GÖRE USER BULMA
  Future<dynamic> findUserByProgLang(String input) async {
    var response = await http.get("http://10.0.2.2:5000/auth/searchpl?searchString=$input", headers: {
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

  // ŞİRKETE GÖRE USER BULMA
  Future<dynamic> findUserByCompany(String input) async {
    var response =
        await http.get("http://10.0.2.2:5000/auth/searchcompany?searchString=$input", headers: {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchUserData = findUserByName("");
    searchPostData = findPostByHashtag("");
    searchProgLangData = findUserByProgLang("");
    searchCompanyData = findUserByCompany("");
  }

  //DROPDOWN DEGERİNE GÖRE ARAMA SONUÇLARI
  Widget searchTypes(int index) {
    switch (index) {
      case 1:
        return Expanded(
          child: Container(
            child: FutureBuilder(
                future: searchUserData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        itemCount: snapshot.hasData ? snapshot.data["data"].length : 0,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                    widget.token,
                                    snapshot.data["data"][index]["_id"],
                                    widget.userId,
                                    snapshot.data["data"][index]["name"],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFBFD4DB).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: ListTile(
                                leading: snapshot.data["data"][index]["profileImage"] == "default.jpg"
                                    ? CircleAvatar(
                                        backgroundColor: Color(0xFF78A2CC),
                                        radius: 24,
                                        child: Text(
                                            snapshot.data["data"][index]["name"][0].toUpperCase(),
                                            style: TextStyle(fontSize: 24, color: Colors.white)),
                                      )
                                    : Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  "http://10.0.2.2:5000/static/uploads/userImage/" +
                                                      snapshot.data["data"][index]["profileImage"])),
                                          borderRadius: BorderRadius.all(Radius.circular(26.0)),
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                title: Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    snapshot.data["data"][index]["name"],
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                trailing: Container(
                                    height: double.infinity,
                                    child: Icon(Icons.arrow_forward_ios, size: 24, color: Colors.black)),
                                subtitle: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Üniversite: " + snapshot.data["data"][index]["university"],
                                          style: TextStyle(fontSize: 16)),
                                      Text("Branş: " + snapshot.data["data"][index]["branch"],
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  } else
                    return Center(child: Text("Kullanıcı Aramak İçin Değer Giriniz"));
                }),
          ),
        );
        break;
      case 2:
        return Expanded(
          child: Container(
            child: FutureBuilder(
                future: searchPostData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        itemCount: snapshot.hasData ? snapshot.data["posts"].length : 0,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostDetailPage(widget.token, widget.userId,
                                        snapshot.data["posts"][index]["_id"].toString(), true)),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFBFD4DB).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: ListTile(
                                leading: snapshot.data["posts"][index]["user"]["profileImage"] ==
                                        "default.jpg"
                                    ? CircleAvatar(
                                        backgroundColor: Color(0xFF78A2CC),
                                        radius: 24,
                                        child: Text(
                                            snapshot.data["posts"][index]["user"]["name"][0]
                                                .toUpperCase(),
                                            style: TextStyle(fontSize: 24, color: Colors.white)),
                                      )
                                    : Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  "http://10.0.2.2:5000/static/uploads/userImage/" +
                                                      snapshot.data["posts"][index]["user"]
                                                          ["profileImage"])),
                                          borderRadius: BorderRadius.all(Radius.circular(26.0)),
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                title: Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    snapshot.data["posts"][index]["user"]["name"],
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                trailing: Container(
                                    height: double.infinity,
                                    child: Icon(Icons.arrow_forward_ios, size: 24, color: Colors.black)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child: Container(
                                        child: Text(
                                          snapshot.data["posts"][index]["title"],
                                          textAlign: TextAlign.end,
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    GridView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data["posts"][index]["hashtags"].length,
                                        shrinkWrap: true,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3, childAspectRatio: 7 / 2),
                                        itemBuilder: (context, index1) {
                                          if (!snapshot.data["posts"][index]["hashtags"].isEmpty) {
                                            return Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Color(0xFF78A2CC),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    snapshot.data["posts"][index]["hashtags"][index1] !=
                                                                "" &&
                                                            snapshot.data["posts"][index]["hashtags"]
                                                                    [index1][0] ==
                                                                "#"
                                                        ? snapshot.data["posts"][index]["hashtags"]
                                                            [index1]
                                                        : "#" +
                                                            snapshot.data["posts"][index]["hashtags"]
                                                                [index1],
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else
                                            return Container();
                                        })
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  } else
                    return Center(child: Text("Paylaşım Aramak İçin Değer Giriniz"));
                }),
          ),
        );
        break;

      case 3:
        return Expanded(
          child: Container(
            child: FutureBuilder(
                future: searchProgLangData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        itemCount: snapshot.hasData ? snapshot.data["users"].length : 0,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                    widget.token,
                                    snapshot.data["users"][index]["_id"],
                                    widget.userId,
                                    snapshot.data["users"][index]["name"],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFBFD4DB).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: ListTile(
                                leading: snapshot.data["users"][index]["profileImage"] == "default.jpg"
                                    ? CircleAvatar(
                                        backgroundColor: Color(0xFF78A2CC),
                                        radius: 24,
                                        child: Text(
                                            snapshot.data["users"][index]["name"][0].toUpperCase(),
                                            style: TextStyle(fontSize: 24, color: Colors.white)),
                                      )
                                    : Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  "http://10.0.2.2:5000/static/uploads/userImage/" +
                                                      snapshot.data["users"][index]["profileImage"])),
                                          borderRadius: BorderRadius.all(Radius.circular(26.0)),
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                title: Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    snapshot.data["users"][index]["name"],
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                trailing: Container(
                                    height: double.infinity,
                                    child: Icon(Icons.arrow_forward_ios, size: 24, color: Colors.black)),
                                subtitle: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Üniversite: " + snapshot.data["users"][index]["university"],
                                          style: TextStyle(fontSize: 16)),
                                      Text("Branş: " + snapshot.data["users"][index]["branch"],
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  } else
                    return Center(
                        child: Text("Programlama Diline Göre Kullanıcı Aramak İçin Değer Giriniz"));
                }),
          ),
        );
        break;
      case 4:
        return Expanded(
          child: Container(
            child: FutureBuilder(
                future: searchCompanyData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        itemCount: snapshot.hasData ? snapshot.data["users"].length : 0,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                    widget.token,
                                    snapshot.data["users"][index]["_id"],
                                    widget.userId,
                                    snapshot.data["users"][index]["name"],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFBFD4DB).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: ListTile(
                                leading: snapshot.data["users"][index]["profileImage"] == "default.jpg"
                                    ? CircleAvatar(
                                        backgroundColor: Color(0xFF78A2CC),
                                        radius: 24,
                                        child: Text(
                                            snapshot.data["users"][index]["name"][0].toUpperCase(),
                                            style: TextStyle(fontSize: 24, color: Colors.white)),
                                      )
                                    : Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  "http://10.0.2.2:5000/static/uploads/userImage/" +
                                                      snapshot.data["users"][index]["profileImage"])),
                                          borderRadius: BorderRadius.all(Radius.circular(26.0)),
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                title: Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    snapshot.data["users"][index]["name"],
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                trailing: Container(
                                    height: double.infinity,
                                    child: Icon(Icons.arrow_forward_ios, size: 24, color: Colors.black)),
                                subtitle: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Üniversite: " + snapshot.data["users"][index]["university"],
                                          style: TextStyle(fontSize: 16)),
                                      Text("Branş: " + snapshot.data["users"][index]["branch"],
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  } else
                    return Center(child: Text("Şirkete Göre Kullanıcı Aramak İçin Değer Giriniz"));
                }),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFE2E3E9),
      child: Column(
        children: <Widget>[
          Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, style: BorderStyle.solid),
                  color: Color(0xFF78A2CC).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.centerLeft,
                height: 60,
                child: TextFormField(
                  validator: null,
                  onChanged: (value) {
                    setState(() {
                      searchUserData = findUserByName(value);
                      searchPostData = findPostByHashtag(value);
                      searchProgLangData = findUserByProgLang(value);
                      searchCompanyData = findUserByCompany(value);
                    });
                  },
                  keyboardType: TextInputType.name,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(Icons.search_outlined, color: Colors.white),
                    hintText: _hintText(dropdownValue),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFF78A2CC).withOpacity(0.7),
                  border: Border.all(width: 1, color: Color(0xFF78A2CC).withOpacity(0.2))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Arama Türü: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                  ),
                  DropdownButton(
                    iconSize: 36,
                    iconEnabledColor: Colors.white,
                    dropdownColor: Color(0xFF78A2CC),
                    elevation: 80,
                    value: dropdownValue,
                    items: [
                      DropdownMenuItem<int>(
                        child: Text("Kullanıcı Ara",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                        value: 1,
                      ),
                      DropdownMenuItem<int>(
                        child: Text("Paylaşım Ara",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                        value: 2,
                      ),
                      DropdownMenuItem<int>(
                        child: Text("Programlama Dili Ara",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                        value: 3,
                      ),
                      DropdownMenuItem<int>(
                        child: Text("Şirket Ara",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                        value: 4,
                      ),
                    ],
                    onChanged: (index) {
                      setState(() {
                        dropdownValue = index;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          searchTypes(dropdownValue),
        ],
      ),
    );
  }
}
