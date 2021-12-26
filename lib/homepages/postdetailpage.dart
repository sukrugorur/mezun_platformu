import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_appproje/homepages/displayImage.dart';
import 'package:flutter_appproje/homepages/postdetails.dart';
import 'package:flutter_appproje/startingpages/loginscreen.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';

class PostDetailPage extends StatefulWidget {
  String token;
  String userId;
  String postId;
  bool control;
  PostDetailPage(this.token, this.userId, this.postId, this.control);
  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  PostDetails postdetail;
  Future<PostDetails> postDetailData;
  Future<dynamic> likePostData;
  Future<dynamic> addCommentData;
  final formKey = GlobalKey<FormState>();

  //ID'Lİ POSTU GETİRME İSTEĞİ
  Future<PostDetails> buildIDPost(String postId) async {
    var response = await http.get("http://10.0.2.2:5000/post/getpost/$postId", headers: {
      "Authorization": "Bearer:" + widget.token,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      postdetail = PostDetails.fromJson(decodedJson["post"]);
      return postdetail;
    } else if (response.statusCode == 401) {
      var decodedJson = json.decode(response.body);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginScreen(gelenMesaj: decodedJson["message"])));
      return null;
    } else {
      debugPrint("hata");
      return null;
    }
  }

  //POSTU BEĞENME İSTEĞİ
  Future<dynamic> likePost(String id) async {
    var response = await http.get("http://10.0.2.2:5000/post/$id/like", headers: {
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

  // YORUM YAPMA İSTEĞİ
  Future<dynamic> addComment(String content, String postId) async {
    final response = await http.post(
      "http://10.0.2.2:5000/post/$postId/addcomment",
      headers: {
        "Authorization": "Bearer:" + widget.token,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'content': content,
      }),
    );

    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else if (response.statusCode == 401) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else {
      throw Exception('Failed to create album.');
    }
  }

  Future<void> _showMyDialog() async {
    String content;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text("Yorum Yap"),
          content: Container(
            width: 800,
            height: 125,
            child: Form(
              key: formKey,
              child: Container(
                alignment: Alignment.centerLeft,
                height: 60,
                child: TextFormField(
                  maxLength: 100,
                  validator: null,
                  onSaved: (value) => content = value,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(Icons.chat, color: Colors.black),
                    hintText: "Yorumunuzu giriniz",
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yorum Ekle'),
              onPressed: () {
                if (confirmInput()) {
                  addCommentData = addComment(content, widget.postId).then((value) {
                    if (value["success"]) {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostDetailPage(
                                  widget.token, widget.userId, widget.postId, widget.control)));
                      return value["message"];
                    } else {
                      return value["message"];
                    }
                  });
                }
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
    postDetailData = buildIDPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xFFE2E3E9),
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(
          future: postDetailData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              return SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFBFD4DB).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 20),
                                  alignment: Alignment.topLeft,
                                  child: IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      iconSize: 30,
                                      onPressed: () {
                                        if (widget.control) {
                                          Navigator.pop(context);
                                        } else if (!widget.control) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(widget.token, widget.userId, 0)));
                                        }
                                      }),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 30),
                                    child: Text(
                                      snapshot.data.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 22,
                                        fontFamily: "Fonts1",
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(thickness: 2, height: 30),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: ListTile(
                                            leading: snapshot.data.user.profileImage == "default.jpg"
                                                ? CircleAvatar(
                                                    radius: 24,
                                                    backgroundColor: Color(0xFF78A2CC),
                                                    child: Text(
                                                      snapshot.data.user.name[0].toUpperCase(),
                                                      style:
                                                          TextStyle(fontSize: 24, color: Colors.white),
                                                    ),
                                                  )
                                                : Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              "http://10.0.2.2:5000/static/uploads/userImage/" +
                                                                  snapshot.data.user.profileImage)),
                                                      borderRadius:
                                                          BorderRadius.all(Radius.circular(26.0)),
                                                      color: Colors.redAccent,
                                                    ),
                                                  ),
                                            title: Text(
                                              snapshot.data.user.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 20,
                                                fontFamily: "Fonts1",
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                            trailing: IconButton(
                                              icon: Icon(Icons.more_vert),
                                              color: Colors.black,
                                              onPressed: () {
                                                debugPrint(snapshot.data.toString());
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  //POSTA EKLENEN RESİM
                                  snapshot.data.imgPath != null
                                      ? InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => DisplayImage(
                                                        widget.token,
                                                        widget.userId,
                                                        "http://10.0.2.2:5000/static/uploads/postImage/" +
                                                            snapshot.data.imgPath)));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Image.network(
                                              "http://10.0.2.2:5000/static/uploads/postImage/" +
                                                  snapshot.data.imgPath,
                                              fit: BoxFit.contain,
                                              scale: 0.5,
                                            ),
                                          ),
                                        )
                                      : Container(),

                                  SizedBox(height: 10),
                                  //post içeriği
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                    width: double.infinity,
                                    child: Text(
                                      snapshot.data.content,
                                      style: TextStyle(
                                        height: 1.3,
                                        letterSpacing: 0.2,
                                        wordSpacing: 1,
                                        fontSize: 20,
                                        fontFamily: "Fonts1",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
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
                                                  IconButton(
                                                    icon: snapshot.data.likes.contains(widget.userId)
                                                        ? Icon(Icons.favorite, color: Colors.red)
                                                        : Icon(Icons.favorite_border),
                                                    iconSize: 32,
                                                    onPressed: () {
                                                      setState(() {
                                                        if (snapshot.data.likes
                                                            .contains(widget.userId)) {
                                                          int idx =
                                                              snapshot.data.likes.indexOf(widget.userId);
                                                          snapshot.data.likes.removeAt(idx);
                                                        } else {
                                                          snapshot.data.likes.add(widget.userId);
                                                        }
                                                      });
                                                      likePostData =
                                                          likePost(snapshot.data.id).then((value) {
                                                        if (value["success"]) {
                                                          return value["message"];
                                                        } else
                                                          return value["message"];
                                                      });
                                                    },
                                                  ),
                                                  Text(snapshot.data.likes.length.toString(),
                                                      style: TextStyle(
                                                          fontSize: 14, fontWeight: FontWeight.w600)),
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
                                                    onPressed: () {},
                                                  ),
                                                  Text(snapshot.data.comments.length.toString(),
                                                      style: TextStyle(
                                                          fontSize: 14, fontWeight: FontWeight.w600)),
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
                            // HASHTAGS
                            !snapshot.data.hashtags.isEmpty
                                ? GridView.builder(
                                    padding: EdgeInsets.only(bottom: 8),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.hashtags.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: (7 / 2),
                                    ),
                                    itemBuilder: (context, index1) {
                                      return Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Color(0xFF78A2CC),
                                          ),
                                          child: Center(
                                            child: Text(
                                              snapshot.data.hashtags[index1][0] == "#"
                                                  ? snapshot.data.hashtags[index1]
                                                  : "#" + snapshot.data.hashtags[index1],
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                : Container()
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // YORUM EKLEME BUTONU
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 1),
                        width: double.infinity,
                        child: RaisedButton(
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          color: Color(0xFF78A2CC),
                          child: Text(
                            "Yorum Ekle",
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.5,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            _showMyDialog();
                          },
                        ),
                      ),

                      //YORUMLAR

                      !snapshot.data.comments.isEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.comments.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
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
                                              leading: snapshot
                                                          .data.comments[index].author.profileImage ==
                                                      "default.jpg"
                                                  ? CircleAvatar(
                                                      radius: 24,
                                                      backgroundColor: Color(0xFF78A2CC),
                                                      child: Text(
                                                        snapshot.data.comments[index].author.name[0]
                                                            .toUpperCase(),
                                                        style:
                                                            TextStyle(fontSize: 24, color: Colors.white),
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                                "http://10.0.2.2:5000/static/uploads/userImage/" +
                                                                    snapshot.data.comments[index].author
                                                                        .profileImage)),
                                                        borderRadius:
                                                            BorderRadius.all(Radius.circular(26.0)),
                                                      ),
                                                    ),
                                              title: Text(
                                                snapshot.data.comments[index].author.name,
                                                style:
                                                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                              ),
                                              trailing: IconButton(
                                                icon: Icon(Icons.more_vert),
                                                color: Colors.black,
                                                onPressed: () {},
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Container(
                                              padding:
                                                  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                              width: double.infinity,
                                              //height: 400,
                                              child: Text(
                                                snapshot.data.comments[index].content,
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(
                              height: 100,
                              child: Center(
                                child: Text(
                                  "Henüz yorum yapılmamış",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              );
            } else
              return Center(child: Text("Hata"));
          },
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

  Future<bool> _onWillPop() {
    if (widget.control) {
      Navigator.pop(context);
    } else if (!widget.control) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage(widget.token, widget.userId, 0)));
    }
  }
}
