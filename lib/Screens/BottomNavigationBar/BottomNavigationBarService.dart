import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:healthcare2050/Providers/DoctorsListProvider.dart';
import 'package:healthcare2050/Screens/Bookings/BookingHistory.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/Doctors/AllDoctorsList.dart';
import 'package:healthcare2050/Screens/Home/Home.dart';
import 'package:healthcare2050/Screens/Service/Service.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarService extends StatelessWidget {
  const BottomNavigationBarService({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigationBarScreen(),
    );
  }
}

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({ Key? key }) : super(key: key);

  @override
  _BottomNavigationBarScreenState createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {

  int _currentIndex = 0;
  late PageController _pageController;


  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => exit(0),
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
     _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
    
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)
                )
              ),
              elevation: 4,
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: new Icon(Icons.person),
                      title: new Text('Our Doctors'),
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangeNotifierProvider(
                        //   create: (context)=> DoctorListProvider(),
                        //   child: DoctorListPage()))
                        // );
                      },
                    ),
                    ListTile(
                      leading: new Icon(Icons.music_note),
                      title: new Text('Music'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: new Icon(Icons.videocam),
                      title: new Text('Video'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: new Icon(Icons.share),
                      title: new Text('Share'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              }
            );
          },
          tooltip: "Get More Options",
          child: Icon(Icons.more_vert, color: themColor,size: 30),
          elevation: 4.0,
          backgroundColor: Colors.white,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
       
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              Service(),
              Home(),
              
              BookingHistory(),
              
              // Container(color: Colors.red,),
              // Container(color: Colors.green,),
              // Container(color: Colors.blue,),
            ],
          ),
    
          
        ),
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: Colors.white,
          selectedIndex: _currentIndex,
          
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[

            BottomNavyBarItem(
              activeColor: Colors.indigo,
              title: Text('Services'),
              icon: Icon(Icons.medical_services,color: themColor,)
            ),

            BottomNavyBarItem(
              activeColor: Colors.indigo,
              title: Text('Home'),
              icon: Icon(Icons.home,color: themColor,)
            ),
           
            BottomNavyBarItem(
              activeColor: Colors.indigo,
              title: Text('Bookings'),
              icon: Icon(Icons.history,color: themColor,)
            ),
            BottomNavyBarItem(
              activeColor: Colors.white,
              title: Text(''),
              icon: Icon(Icons.more_vert,color: Colors.white),
            ),
          ],
        )
        
      ),
    );
  }

  
  
}