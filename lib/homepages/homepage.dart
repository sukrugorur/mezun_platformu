import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_appproje/homepages/likedpostspage.dart';
import 'package:flutter_appproje/homepages/profilepage.dart';
import 'package:flutter_appproje/homepages/searchpage.dart';

import 'addingpage.dart';
import 'homepagemain.dart';

class HomePage extends StatefulWidget {
  String token;
  String userId;
  int chosenMenuIndex;
  HomePage(this.token, this.userId, this.chosenMenuIndex);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int chosenMenuItemIndex = 0;
  List<Widget> allPages;

  @override
  void initState() {
    // TODO: implement initState
    chosenMenuItemIndex = widget.chosenMenuIndex;
    super.initState();
    allPages = [
      HomePageMain(widget.token, widget.userId),
      SearchPage(widget.token, widget.userId),
      LikedPostsPage(widget.token, widget.userId),
      ProfilePage(widget.token, widget.userId, widget.userId, "")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: chosenMenuItemIndex != 3
          ? AppBar(
              leading: Padding(
                padding: EdgeInsets.all(2.0),
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.cover,
                ),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              backgroundColor: Color(0xFFE2E3E9),
              title: Text(
                "Mezunlar Buluşuyor",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontFamily: "Fonts3",
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3),
                textAlign: TextAlign.center,
              ))
          : null,
      backgroundColor: Color(0xFFEDF0F6),
      body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            backgroundColor: Colors.blueGrey.shade50,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
            duration: Duration(milliseconds: 1500),
            content: Text(
              "Çıkmak için geri tuşuna tekrar basın",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          child: allPages[chosenMenuItemIndex]),
      //BOTTOM NAVIGATION BAR
      floatingActionButton: chosenMenuItemIndex == 0
          ? FloatingActionButton(
              backgroundColor: Color(0xFF78A2CC),
              child: Icon(
                Icons.add,
                size: 32,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPage(widget.token, widget.userId, 0)));
              },
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey.shade100,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.dashboard,
              size: 35,
              color: Colors.black,
            ),
            icon: Icon(
              Icons.dashboard_outlined,
              size: 30,
              color: Colors.grey,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.saved_search,
              size: 35,
              color: Colors.black,
            ),
            icon: Icon(
              Icons.search,
              size: 30,
              color: Colors.grey,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.favorite,
              size: 35,
              color: Colors.red,
            ),
            icon: Icon(
              Icons.favorite_border,
              size: 30,
              color: Colors.grey,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.person,
              size: 35,
              color: Colors.black,
            ),
            icon: Icon(
              Icons.person_outline,
              size: 30,
              color: Colors.grey,
            ),
            label: "",
          ),
        ],
        currentIndex: chosenMenuItemIndex,
        onTap: (index) {
          setState(() {
            chosenMenuItemIndex = index;
          });
        },
      ),
    );
  }
}
