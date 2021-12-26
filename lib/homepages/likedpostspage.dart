import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appproje/homepages/displayImage.dart';
import 'package:flutter_appproje/homepages/displaypdfpage.dart';
import 'package:flutter_appproje/homepages/homepage.dart';
import 'package:flutter_appproje/homepages/post.dart';
import 'package:flutter_appproje/homepages/postdetailpage.dart';
import 'package:flutter_appproje/homepages/profilepage.dart';
import 'package:flutter_appproje/startingpages/loginscreen.dart';
import 'package:http/http.dart' as http;

class LikedPostsPage extends StatefulWidget {
  String userId;
  String token;
  LikedPostsPage(this.token, this.userId);
  @override
  _LikedPostsPageState createState() => _LikedPostsPageState();
}

class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}

class _LikedPostsPageState extends State<LikedPostsPage> {
  Post post;

  Future<Post> postData;

  Future<Post> buildLikedPosts() async {
    var response = await http.get("http://10.0.2.2:5000/post/likedposts", headers: {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postData = buildLikedPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.only(bottomLeft: Radius.circular(23), bottomRight: Radius.circular(23))),
        toolbarHeight: 36,
        title: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          alignment: Alignment.center,
          child: Text(
            "Beğenilen Paylaşımlar",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
          ),
        ),
        leading: Container(),
        backgroundColor: Color(0xFFBFD4DB),
        elevation: 0,
      ),
      backgroundColor: Color(0xFFE2E3E9),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context, CustomPageRoute(builder: (context) => HomePage(widget.token, widget.userId, 2)));
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
                                          style: TextStyle(fontSize: 18),
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
                                                  fontSize: 20),
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
                                                    snapshot.data.posts[index].likes
                                                            .contains(widget.userId)
                                                        ? Icon(Icons.favorite,
                                                            color: Colors.red, size: 32)
                                                        : Icon(Icons.favorite_border, size: 32),
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
                                                1) {
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
                                        )),
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
              return Center(child: Text("Beğenilen paylaşım bulunmamaktadır."));
            }
          },
        ),
      ),
    );
  }
}
