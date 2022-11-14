import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/Providers/CategorySubCategoryProvider.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/Doctors/AllDoctorsList.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistration.dart';
import 'package:healthcare2050/Screens/SubCategories.dart/SubCategories.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class PreviousSideDrawer extends StatelessWidget {
  
  static  String ? name;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DrawerScreen(),

    );
  }
}

class DrawerScreen extends StatefulWidget {
  

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {

  
 // late SharedPreferences customerPrefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final data= Provider.of<CategorySubCategoryProvider>(context,listen: false);
    data.fetchCategory();
     
  }


  @override
  Widget build(BuildContext context) {

    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /// screen Orientation end///////////
    
    final data= Provider.of<CategorySubCategoryProvider>(context);
    
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return false;
      }, 
      child: Container(
        color: Colors.white,

         child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                // UserAccountsDrawerHeader(
                //   accountName: Text("Hi ! "),
                //   accountEmail: Text("user"),
                //   currentAccountPicture:
                //   Image.network('https://hammad-tariq.com/img/profile.png'),
                  
                //   decoration: BoxDecoration(color: themColor),
                 
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DrawerHeader(
                    child: Text(''),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage("assets/Logo/2050logo.png"),
                        fit: BoxFit.contain
                      )
                    ),
                   
                  ),
                ),
                ListTile(
                  focusColor: Colors.white,
                  leading: Icon(Icons.home,color: Colors.black54,size: 30,),
                  title: Text('Home',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 14)),
                  onTap: () {

                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>BottomNavigationBarPage()));
                   
                  },
                ),

                ListTile(
                  focusColor: Colors.white,
                  leading: Icon(Icons.source,color: Colors.black54,size: 30,),
                  title: Text('Resources',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 14)),
                  onTap: () {

                    //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> AppointmentHistory()));
                   
                  },
                ),
                ListTile(
                  focusColor: Colors.white,
                  leading: Icon(Icons.person,color: Colors.black54,size: 30,),
                  title: Text('Doctors',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 14)),
                  onTap: () {

                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SubCategories()));
                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> AllDoctorListPage()));
                   
                  },
                ),

                Divider(
                  height: 2.0,
                ),

                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: data.categoryList.length,
                    itemBuilder: (context,index){

                      String category_name=data.categoryList[index]['CategoryName'].toString().split('-').join(' ');
                                        category_name.split('-').join('');
                      return ExpansionTile(
                        title: Text(category_name,style: TextStyle(color: themColor,fontFamily: 'WorkSans',fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                        children: [

                           ListTile(
                        focusColor: Colors.white,
                        leading: Icon(Icons.medical_services,color: Colors.black54),
                        title: Text(category_name,style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 14)),
                        onTap: () {

                          //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> AppointmentHistory()));
                        
                        },
                      ),


                        ],
                      );
                    }
                  ),
                ),

                // ExpansionTile(
                //   leading: Icon(Icons.medical_services_sharp),
                //   title: Text(
                //     "Services",
                //     style: TextStyle(
                //       fontSize: 14.0,
                //       fontWeight: FontWeight.bold
                //     ),
                //   ),

                //   children: [

                //     ListTile(
                //       focusColor: Colors.white,
                //       leading: Icon(Icons.medical_services,color: Colors.black54),
                //       title: Text('All Services',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 14)),
                //       onTap: () {

                //         //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> AppointmentHistory()));
                      
                //       },
                //     ),

                //     ListTile(
                //       focusColor: themColor,
                //       leading: Icon(Icons.medical_services),
                //       title: Text('Rehabiliation',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                //       onTap: (){
                        
                //       },
                //     ),

                //     ListTile(
                //       focusColor: themColor,
                //       leading: Icon(Icons.medical_services),
                //       title: Text('Home HealthCare',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                //       onTap: (){},
                //     ),

                //     ListTile(
                //       focusColor: themColor,
                //       leading: Icon(Icons.local_hospital),
                //       title: Text('Multi Speciality Clinic',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                //       onTap: (){},
                //     ),

                //     ListTile(
                //       focusColor: themColor,
                //       leading: Icon(Icons.medical_services),
                //       title: Text('Ayurveda & Wellness',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                //       onTap: (){},
                //     ),

                //     ListTile(
                //       focusColor: themColor,
                //       leading: Icon(Icons.medical_services),
                //       title: Text('Medical Equipments',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                //       onTap: (){},
                //     ),

                //     ListTile(
                //       focusColor: themColor,
                //       leading: Icon(Icons.medical_services),
                //       title: Text('Pharmacy',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                //       onTap: (){},
                //     ),

                //     ListTile(
                //       focusColor: themColor,
                //       leading: Icon(Icons.medical_services),
                //       title: Text('Diagnostics',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                //       onTap: (){},
                //     ),

                //     ListTile(
                //       focusColor: themColor,
                //       leading: Icon(Icons.medical_services),
                //       title: Text('Medical Tourisim',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                //       onTap: (){},
                //     ),

                //     ListTile(
                //       focusColor: themColor,
                //       leading: Icon(Icons.medical_services),
                //       title: Text('HealthCare Consulting',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                //       onTap: (){},
                //     ),

                //     ListTile(
                //       focusColor: themColor,
                //       leading: Icon(Icons.medical_services),
                //       title: Text('Home HealthCare',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                //       onTap: (){},
                //     ),

                //     ListTile(
                //       focusColor: themColor,
                //       leading: Icon(Icons.medical_services),
                //       title: Text('Request a Service',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                //       onTap: (){},
                //     ),
                //   ]
                // ), 

                Divider(
                  height: 2.0,
                ),

                ExpansionTile(
                  leading: Icon(Icons.help),
                  title: Text(
                    "Help and Settings",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  children: [

                    ListTile(
                      focusColor: Colors.white,
                      leading: Icon(Icons.badge,color: Colors.black54),
                      title: Text('Careers',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 14)),
                      onTap: () {

                        //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> AppointmentHistory()));
                      
                      },
                    ),

                    ListTile(
                      focusColor: themColor,
                      leading: Icon(Icons.details),
                      title: Text('About Us',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                      onTap: (){
                        
                      },
                    ),

                    ListTile(
                      focusColor: themColor,
                      leading: Icon(Icons.contact_mail),
                      title: Text('Contact Us',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                      onTap: (){},
                    ),
                  ]
                ), 
               
               
                Divider(
                  height: 2.0,
                ),
                ListTile(
                  focusColor: Colors.white,
                  leading: Icon(Icons.logout),
                  title: Text('Sign Out',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 14)),
                  onTap: ()async{

                    SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                    loginPrefs.clear();

                   
                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>LoginRegistration()));
                  },
                ),

                ListTile(
                 focusColor: Colors.white,
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Exit',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 14)),
                  onTap: ()=> exit(0),
                ),
                Divider(
                  height: 2.0,
                ),
          
               
              ]  
            ),
          ),
        
      ),
    );
  }

  
}