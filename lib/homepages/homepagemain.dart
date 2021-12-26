import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appproje/homepages/displayImage.dart';
import 'package:flutter_appproje/homepages/displaypdfpage.dart';
import 'package:flutter_appproje/homepages/post.dart';
import 'package:flutter_appproje/homepages/postdetailpage.dart';
import 'package:flutter_appproje/homepages/profilepage.dart';
import 'package:flutter_appproje/startingpages/loginscreen.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';

class HomePageMain extends StatefulWidget {
  String token;
  String userId;
  HomePageMain(this.token, this.userId);
  @override
  _HomePageMainState createState() => _HomePageMainState();
}

class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}

class _HomePageMainState extends State<HomePageMain> {
  Post post;

  Future<Post> postData;
  Future<dynamic> likeData;
  Future<dynamic> deleteData;
  Future<dynamic> editData;

  final formKey = GlobalKey<FormState>();
  static TextEditingController textEditingController1;
  static TextEditingController textEditingController2;

  //TÜM POSTLAR
  Future<Post> buildPost() async {
    var response = await http.get("http://10.0.2.2:5000/post/getallpost", headers: {
      "Authorization": "Bearer:" + widget.token,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      post = Post.fromJson(decodedJson);
      return post;
    } else if (response.statusCode == 401) {
      var decodedJson = json.decode(response.body);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginScreen(gelenMesaj: decodedJson["message"])));
      return null;
    } else {
      // Hata mesajı
      return null;
    }
  }

  //BEĞENME İSTEĞİ
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

  //SİLME İSTEĞİ
  Future<dynamic> deletePost(String id) async {
    var response = await http.delete("http://10.0.2.2:5000/post/$id/delete", headers: {
      "Authorization": "Bearer:" + widget.token,
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else if (response.statusCode == 400) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    }
  }

  //DÜZENLEME İSTEĞİ
  Future<dynamic> editPost(String id, String title, String content) async {
    var response = await http.put(
      "http://10.0.2.2:5000/post/$id/edit",
      headers: {
        "Authorization": "Bearer:" + widget.token,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'content': content,
        'title': title,
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

  //POP UP MENÜ
  _showPopupMenu(Offset offset, String userId, String postId, String orgTitle, String orgContent) async {
    double left = offset.dx;
    double top = offset.dy - 30;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, -10, -10),
      items: [
        PopupMenuItem(child: Text('Yorum Yap'), value: 'comment'),
        widget.userId == userId ? PopupMenuItem(child: Text('Düzenle'), value: 'edit') : null,
        widget.userId == userId ? PopupMenuItem(child: Text('Sil'), value: 'delete') : null
      ],
      elevation: 8.0,
    ).then((value) => {
          if (value == "delete")
            {
              {_showMyDialogDelete("Postu Silmek İstediğinizden Emin Misiniz?", "Mesaj", postId)}
            }
          else if (value == "edit")
            {_showMyDialogEdit(postId, orgTitle, orgContent)}
          else if (value == "comment")
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostDetailPage(widget.token, widget.userId, postId, false)),
              )
            }
        });
  }

  //SİLME SORUSU
  Future<void> _showMyDialogDelete(String title, String message, String postId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            TextButton(
              child: Text("İptal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Evet"),
              onPressed: () {
                deleteData = deletePost(postId).then((value) {
                  if (value["success"]) {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(context,
                        CustomPageRoute(builder: (context) => HomePage(widget.token, widget.userId, 0)));
                    return value["message"];
                  } else {
                    return value["message"];
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  //DÜZENLEME PANELİ
  Future<void> _showMyDialogEdit(String postId, String orgTitle, String orgContent) async {
    String content, title;
    textEditingController1.text = orgTitle;
    textEditingController2.text = orgContent;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text("Yeni içerik ve başlık giriniz"),
          content: Container(
            width: 800,
            height: 150,
            child: Form(
              key: formKey,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: textEditingController1,
                      maxLength: 20,
                      validator: (value) {
                        if (value.length == 0) {
                          value = "Lütfen yeni değeri giriniz";
                          return value;
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) => title = value,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 14),
                        prefixIcon: Icon(Icons.chat, color: Colors.black),
                        hintText: "Başlık giriniz",
                      ),
                    ),
                    TextFormField(
                      controller: textEditingController2,
                      maxLength: 100,
                      validator: (value) {
                        if (value.length == 0) {
                          value = "Lütfen yeni değeri giriniz";
                          return value;
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) => content = value,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 14),
                        prefixIcon: Icon(Icons.chat, color: Colors.black),
                        hintText: "İçerik giriniz",
                      ),
                    ),
                  ],
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
              child: Text('Düzenle'),
              onPressed: () {
                if (confirmInput()) {
                  editData = editPost(postId, title, content).then((value) {
                    if (value["success"]) {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          CustomPageRoute(
                              builder: (context) => HomePage(widget.token, widget.userId, 0)));
                      return value["message"];
                    } else {
                      return value["message"];
                    }
                  });
                } else {
                  return null;
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
    postData = buildPost();
    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE2E3E9),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context, CustomPageRoute(builder: (context) => HomePage(widget.token, widget.userId, 0)));
          return postData;
        },
        child: FutureBuilder(
          future: postData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data.posts.length > 0) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListView.builder(
                    itemCount: snapshot.data.posts.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostDetailPage(
                                    widget.token, widget.userId, snapshot.data.posts[index].id, false)),
                          );
                        },
                        child: Container(
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
                                      leading: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProfilePage(
                                                widget.token,
                                                snapshot.data.posts[index].user.id,
                                                widget.userId,
                                                snapshot.data.posts[index].user.name,
                                              ),
                                            ),
                                          );
                                        },
                                        child: snapshot.data.posts[index].user.profileImage ==
                                                "default.jpg"
                                            ? CircleAvatar(
                                                radius: 24,
                                                backgroundColor: Color(0xFF78A2CC),
                                                child: Text(
                                                  snapshot.data.posts[index].user.name[0].toUpperCase(),
                                                  style: TextStyle(fontSize: 24, color: Colors.white),
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
                                                              snapshot
                                                                  .data.posts[index].user.profileImage)),
                                                  borderRadius: BorderRadius.all(Radius.circular(26.0)),
                                                ),
                                              ),
                                      ),
                                      title: Text(
                                        snapshot.data.posts[index].title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20,
                                          fontFamily: "Fonts1",
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 4.0),
                                        child: Text(
                                          snapshot.data.posts[index].user.name,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      trailing: GestureDetector(
                                        onTapDown: (TapDownDetails details) {
                                          _showPopupMenu(
                                            details.globalPosition,
                                            snapshot.data.posts[index].user.id,
                                            snapshot.data.posts[index].id,
                                            snapshot.data.posts[index].title,
                                            snapshot.data.posts[index].content,
                                          );
                                        },
                                        child: Icon(
                                          Icons.more_vert,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),

                                    //POSTA EKLENEN RESİM
                                    snapshot.data.posts[index].imgPath != null
                                        ? InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => DisplayImage(
                                                          widget.token,
                                                          widget.userId,
                                                          "http://10.0.2.2:5000/static/uploads/postImage/" +
                                                              snapshot.data.posts[index].imgPath)));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Image.network(
                                                "http://10.0.2.2:5000/static/uploads/postImage/" +
                                                    snapshot.data.posts[index].imgPath,
                                                fit: BoxFit.contain,
                                                scale: 0.5,
                                              ),
                                            ),
                                          )
                                        : Container(),

                                    SizedBox(height: 10),

                                    //POST İÇERİK YAZISI
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                      width: double.infinity,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PostDetailPage(
                                                    widget.token,
                                                    widget.userId,
                                                    snapshot.data.posts[index].id,
                                                    false)),
                                          );
                                        },
                                        child: Text(
                                          snapshot.data.posts[index].content,
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
                                    ),

                                    //POSTA EKLENEN PDF
                                    snapshot.data.posts[index].filePath != null
                                        ? TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => DisplayPdfPage(
                                                            widget.token,
                                                            widget.userId,
                                                            "http://10.0.2.2:5000/static/uploads/postFile/" +
                                                                snapshot.data.posts[index].filePath,
                                                            "Paylaşıma eklenen pdf",
                                                          )));
                                            },
                                            child: Text(
                                              "Eklenen dosyayı göster",
                                              style: TextStyle(
                                                color: Color(0xFF78A2CC),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          )
                                        : Container(),

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
                                                      icon: snapshot.data.posts[index].likes
                                                              .contains(widget.userId)
                                                          ? Icon(Icons.favorite, color: Colors.red)
                                                          : Icon(Icons.favorite_border),
                                                      iconSize: 32,
                                                      onPressed: () {
                                                        setState(() {
                                                          if (snapshot.data.posts[index].likes
                                                              .contains(widget.userId)) {
                                                            int idx = snapshot.data.posts[index].likes
                                                                .indexOf(widget.userId);
                                                            snapshot.data.posts[index].likes
                                                                .removeAt(idx);
                                                          } else {
                                                            snapshot.data.posts[index].likes
                                                                .add(widget.userId);
                                                          }
                                                        });
                                                        likeData =
                                                            likePost(snapshot.data.posts[index].id)
                                                                .then((value) {
                                                          if (value["success"]) {
                                                            return value["message"];
                                                          } else
                                                            return value["message"];
                                                        });
                                                      },
                                                    ),
                                                    Text(
                                                      snapshot.data.posts[index].likes.length.toString(),
                                                      style: TextStyle(
                                                          fontSize: 14, fontWeight: FontWeight.w600),
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
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => PostDetailPage(
                                                                widget.token,
                                                                widget.userId,
                                                                snapshot.data.posts[index].id,
                                                                false,
                                                              ),
                                                            ));
                                                      },
                                                    ),
                                                    Text(
                                                        snapshot.data.posts[index].comments.length
                                                            .toString(),
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
                                    //HASHTAGS
                                    GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data.posts[index].hashtags.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: (7 / 2),
                                        ),
                                        itemBuilder: (context, index1) {
                                          if (!snapshot.data.posts[index].hashtags.isEmpty) {
                                            return Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Color(0xFF78A2CC),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    snapshot.data.posts[index].hashtags[index1] != "" &&
                                                            snapshot.data.posts[index].hashtags[index1]
                                                                    [0] ==
                                                                "#"
                                                        ? snapshot.data.posts[index].hashtags[index1]
                                                        : "#" +
                                                            snapshot.data.posts[index].hashtags[index1],
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else
                                            return Container();
                                        }),
                                    Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                        child: Text(
                                          (() {
                                            if (DateTime.now()
                                                    .difference(DateTime.parse(
                                                        snapshot.data.posts[index].createAt.toString()))
                                                    .inDays >=
                                                365) {
                                              return (DateTime.now()
                                                              .difference(DateTime.parse(snapshot
                                                                  .data.posts[index].createAt
                                                                  .toString()))
                                                              .inDays ~/
                                                          365)
                                                      .toString() +
                                                  " yıl önce";
                                            } else if (DateTime.now()
                                                    .difference(DateTime.parse(
                                                        snapshot.data.posts[index].createAt.toString()))
                                                    .inDays >=
                                                30) {
                                              return (DateTime.now()
                                                              .difference(DateTime.parse(snapshot
                                                                  .data.posts[index].createAt
                                                                  .toString()))
                                                              .inDays ~/
                                                          30)
                                                      .toString() +
                                                  " ay önce";
                                            } else if (DateTime.now()
                                                    .difference(DateTime.parse(
                                                        snapshot.data.posts[index].createAt.toString()))
                                                    .inDays >=
                                                7) {
                                              return (DateTime.now()
                                                              .difference(DateTime.parse(snapshot
                                                                  .data.posts[index].createAt
                                                                  .toString()))
                                                              .inDays ~/
                                                          7)
                                                      .toString() +
                                                  " hafta önce";
                                            } else if (DateTime.now()
                                                    .difference(DateTime.parse(
                                                        snapshot.data.posts[index].createAt.toString()))
                                                    .inDays >=
                                                1) {
                                              return (DateTime.now()
                                                          .difference(DateTime.parse(snapshot
                                                              .data.posts[index].createAt
                                                              .toString()))
                                                          .inDays)
                                                      .toString() +
                                                  " gün önce";
                                            } else if (DateTime.now()
                                                    .difference(DateTime.parse(
                                                        snapshot.data.posts[index].createAt.toString()))
                                                    .inHours >=
                                                1) {
                                              return (DateTime.now()
                                                          .difference(DateTime.parse(snapshot
                                                              .data.posts[index].createAt
                                                              .toString()))
                                                          .inHours)
                                                      .toString() +
                                                  " saat önce";
                                            } else if (DateTime.now()
                                                    .difference(DateTime.parse(
                                                        snapshot.data.posts[index].createAt.toString()))
                                                    .inMinutes >=
                                                1) {
                                              return (DateTime.now()
                                                          .difference(DateTime.parse(snapshot
                                                              .data.posts[index].createAt
                                                              .toString()))
                                                          .inMinutes)
                                                      .toString() +
                                                  " dakika önce";
                                            } else if (DateTime.now()
                                                    .difference(DateTime.parse(
                                                        snapshot.data.posts[index].createAt.toString()))
                                                    .inSeconds >=
                                                0) {
                                              return (DateTime.now()
                                                          .difference(DateTime.parse(snapshot
                                                              .data.posts[index].createAt
                                                              .toString()))
                                                          .inSeconds)
                                                      .toString() +
                                                  " saniye önce";
                                            }
                                          })(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              fontStyle: FontStyle.italic),
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return Center(child: Text("Hiç paylaşım yapılmamış"));
            }
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
}
