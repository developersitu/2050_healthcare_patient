import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare2050/Screens/BookNow/BookNowHistory.dart';
import 'package:healthcare2050/Screens/BookNow/PreviousBookNowHistory.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/Doctors/AllDoctorsList.dart';
import 'package:healthcare2050/Screens/Doctors/DoctorScheduleList.dart';
import 'package:healthcare2050/Screens/Home/Test.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistration.dart';
import 'package:healthcare2050/Screens/Payment/Razorpay/OnlineConsultRazorpay.dart';
import 'package:healthcare2050/Screens/RequestAService/RequestAservice.dart';
import 'package:healthcare2050/Screens/Search/SearchHeaderCityList.dart';
import 'package:healthcare2050/Screens/Search/SearchHeaderServiceList.dart';
import 'package:healthcare2050/Screens/test1.dart';
import 'package:healthcare2050/Screens/Profile/ProfilePage.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SideDrawer extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    final name = '2050 \n Health Care';
   // final email = 'sarah@abs.com';
    // final urlImage =
    //     'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80';

    return Drawer(
      child: Material(
       // color: Color.fromRGBO(50, 75, 205, 1),
       color: themColor,
        child: ListView(
          children: <Widget>[
            buildHeader(
             // urlImage: urlImage,
              name: name,
              //email: email,
              onClicked: () async{

                SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                bool  loginStatus=loginPrefs.getBool("islogedin") ?? false;
                bool  bookNowStatus=loginPrefs.getBool("isBookNow") ?? false;
                print("userid   >>>>>>>>>>>>>>>>>"+loginStatus.toString());
                
                if(loginStatus){

                  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>ProfilePage(name: '',)));
                  // if(bookNowStatus){
                  //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BookNowHistory()));
                  // }

                  // else{
                  //    _showDialogNoRecords(context); 
                  // }
                  
                
                  
                  
                }

                else {

                  _showLoginDialog(context); 
                
                }

                // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(
                //   builder: (context) => ProfilePage(
                //     name: name,
                //     //urlImage: urlImage,
                //   ),
                // )), 
              }, email: ''
              //email: '',
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  buildSearchField(),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Home',
                    icon: Icons.home,
                    onClicked: () => Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>BottomNavigationBarPage())),
                  ),
                  //const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Appointment',
                    icon: Icons.source,
                    onClicked: () async{
                      SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                      bool  loginStatus=loginPrefs.getBool("islogedin") ?? false;
                      bool  bookNowStatus=loginPrefs.getBool("isBookNow") ?? false;
                      print("userid   >>>>>>>>>>>>>>>>>"+loginStatus.toString());
                      
                      if(loginStatus){

                        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>DoctorScheduleList()));
                        // if(bookNowStatus){
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BookNowHistory()));
                        // }

                        // else{
                        //    _showDialogNoRecords(context); 
                        // }
                        
                      
                        
                        
                      }

                      else {

                        _showLoginDialog(context); 
                      
                      }
                    }
                    
                    
                   
                  ),
                  //const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Doctors',
                    icon: Icons.person,
                    onClicked: () => Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> AllDoctorListPage())),
                  ),

                  buildMenuItem(
                    text: 'Test',
                    icon: Icons.person,
                    onClicked: () => Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Test())),
                  ),
                 // const SizedBox(height: 16),
                  Divider(color: Colors.white70),
                  ExpansionTile(
                    leading: Icon(Icons.help,color: Colors.white,),
                    title: Text(
                      "Others",maxLines: 2,overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: themAmberColor,
                        fontWeight: FontWeight.bold
                      ),
                    ),

                    children: [

                      buildMenuItem(
                        text: 'Booked Status',
                        icon: Icons.badge,
                        onClicked: () async{
                          SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                          bool  loginStatus=loginPrefs.getBool("islogedin") ?? false;
                          bool  bookNowStatus=loginPrefs.getBool("isBookNow") ?? false;
                          print("userid   >>>>>>>>>>>>>>>>>"+loginStatus.toString());
                          
                          if(loginStatus){

                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BookNowHistory()));
                            // if(bookNowStatus){
                            //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BookNowHistory()));
                            // }

                            // else{
                            //    _showDialogNoRecords(context); 
                            // }
                           
                          
                            
                            
                          }

                          else {

                            _showLoginDialog(context); 
                          
                          }
                        },
                      ),

                     

                      buildMenuItem(
                        text: 'Request Servive',
                        icon: Icons.medical_services_sharp,
                        onClicked: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RequestAservice())),
                      ),
                      
                    ]
                  ), 
                 
                  Divider(color: Colors.white70),
                  
                  //const SizedBox(height: 16),             
                  ExpansionTile(
                    leading: Icon(Icons.search,color: Colors.white,),
                    title: Text(
                      "Search",maxLines: 2,overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: themAmberColor,
                        fontWeight: FontWeight.bold
                      ),
                    ),

                    
                    children: [

                      buildMenuItem(
                        text: 'Search Service',
                        icon: Icons.badge,
                        onClicked: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchHeaderServiceList())),
                      ),

                      

                      buildMenuItem(
                        text: 'Search Location',
                        icon: Icons.workspaces,
                        onClicked: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchHeaderCityList())),
                      ),
                      
                    ]
                  ),


                  ExpansionTile(
                    leading: Icon(Icons.help,color: Colors.white,),
                    title: FittedBox(

                      child: Text(
                        "Help and Settings",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: themAmberColor,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    children: [

                      buildMenuItem(
                        text: 'Careers',
                        icon: Icons.badge,
                        onClicked: () {}
                        
                      ),

                      

                      buildMenuItem(
                        text: 'About Us',
                        icon: Icons.workspaces,
                        onClicked: () => null,
                      ),
                      
                      buildMenuItem(
                        text: 'Contact Us',
                        icon: Icons.contact_mail,
                        onClicked: () => null,
                      ),
                    ]
                  ), 
               
                  Divider(color: Colors.white70),
                 // const SizedBox(height: 16),
               
                  buildMenuItem(
                    text: 'Sign Out',
                    icon: Icons.logout,
                    onClicked: () async{
                      
                      SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                      loginPrefs.clear();
                      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>LoginRegistration()));

                    }
                  ),
                //  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Exit',
                    icon: Icons.exit_to_app,
                    onClicked: () => exit(0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    //required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
             
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20, 
                child: Image.asset("assets/Logo/logo_png.png",width: 30,height: 30,fit: BoxFit.contain,),
              ),
                //backgroundImage: AssetImage(),),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.w500,fontFamily: "WorkSans"),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(width: 5,),
              //Spacer(),
              CircleAvatar(
                radius: 12,
               // backgroundColor: Color.fromRGBO(30, 60, 168, 1),
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_forward, color: themGreenColor),
              )
            ],
          ),
        ),
      );

  Widget buildSearchField() {
    final color = Colors.white;

    return TextField(
      style: TextStyle(color: color),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: 'Search',
        hintStyle: TextStyle(color: color),
        prefixIcon: Icon(Icons.search, color: color),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => PeoplePage(),
        // ));
        break;
      case 1:
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => FavouritesPage(),
        // ));
        break;
    }
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context)=>CupertinoAlertDialog(
        title: Column(
          children: [
            Text("Not Registered User"),
            Icon(
              Icons.person,
              color: themRedColor,
            ),

          ],
          
        ),
        content: Text("Please Login to get the facilities"), 
        actions: [
          CupertinoDialogAction(
            child: Text("Cancel",style: TextStyle(color: Colors.red),),
            onPressed: (){
              Navigator.of(context).pop();
            }
          ),

          CupertinoDialogAction(
            child: Text("Login"),
            onPressed: ()
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginRegistration()));
              }
          ),
        ],
      )     
    );
    
  }

  void _showDialogNoRecords(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context)=>CupertinoAlertDialog(
        title: Column(
          children: [
            Text("No Records!!"),
            Icon(
              Icons.person,
              color: themColor,
            ),

          ],
          
        ),
        content: Text("Please Login to get the facilities"), 
        actions: [
          CupertinoDialogAction(
            child: Text("Cancel"),
            onPressed: (){
              Navigator.of(context).pop();
            }
          ),

          CupertinoDialogAction(
            child: Text("Login"),
            onPressed: ()
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginRegistration()));
              }
          ),
        ],
      )     
    );
    
  }
}
