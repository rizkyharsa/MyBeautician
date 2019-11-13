import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final String email,radius,name,credit;

 const MainScreen({Key key,this.email,this.radius,this.name,this.credit}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
 List<Widget> tabs;

 int currentTabIndex = 0;

  String $pagetitle = "My Beautician";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        //backgroundColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed ,
        
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search,color: Color.fromRGBO(159, 30, 99, 1)),
            title: Text("Jobs"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event,color: Color.fromRGBO(159, 30, 99, 1)),
            title: Text("My Jobs"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail,color: Color.fromRGBO(159, 30, 99, 1)),
            title: Text("Messages"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Color.fromRGBO(159, 30, 99, 1)),
            title: Text("Profile"),
          )
        ],
      ),
    );
  }

  
}