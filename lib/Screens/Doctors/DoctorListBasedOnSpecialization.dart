import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Model/Doctor/SpecializationDoctorListModel.dart';
import 'package:healthcare2050/Screens/Doctors/DoctorSpecializationList.dart';
import 'package:healthcare2050/SideNavigationDrawer/navigation_drawer_widget.dart';
import 'package:healthcare2050/Widgets/DoctorSpecializatinCard.dart';
import 'package:healthcare2050/Widgets/DoctorSpecializationListCard.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:http/http.dart' as http;

class DoctorListBasedOnSpecializationPage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {

    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /// screen Orientation end///////////
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Screen(),
      
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({ Key? key }) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  List doctorSpecializationList=[];
  bool ? status;

  String message="Please wait...";

  //////////// Fetch Doctor Start///////////
  Future<SpecializationDoctorListModel> fetchDoctorProcess() async {
    String entryMobileNo_url= doctorListOnSpecializationApi;
    final http.Response response = await http.post(
      Uri.parse(entryMobileNo_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
      // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },

      body: {
        "SpecId": DoctorSpecializatinCard.doctorSpecializationId.toString(),
        
      },
      // body: {
      //   'email': email,
      //   'password': password,
      // }
    );
    
    if (response.statusCode == 200) {

      print("doctor Body "+ response.body);
      bool responseStatus= json.decode(response.body)['status'] ?? "";
      setState(() {
        status=responseStatus;
        status==false ?
        message="No Doctors":"";
      });
      var listItems=json.decode(response.body)['categoryDoctor'] ?? [];
      var mess=json.decode(response.body)['message'] ?? "";
      print("message Body 1>>>>>>>>>>>>>>>"+ mess.toString());

      setState(() {
        doctorSpecializationList=listItems;
      });
      
      print("List items Body 1>>>>>>>>>>>>>>>"+ doctorSpecializationList.toString());

      return SpecializationDoctorListModel.fromJson(json.decode(response.body));

    } else {
    
      Fluttertoast.showToast(
        msg: "Please Check ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );

      throw Exception('Failed to create album.');
    }
  }
  //////////// Fetch Doctor End///////////
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDoctorProcess();
  }

  @override
  Widget build(BuildContext context) {

    double width= MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        gradient:  RadialGradient(
          radius: 0.8,
          colors: [
            Colors.white,
           // Color(0xFFb6e5e5),
           Colors.white
           
          ],
        )
      ),

      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 50,
            backwardsCompatibility: false,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light
            ),
  
            elevation: 0,
            backgroundColor: themColor,

            iconTheme: IconThemeData(color: themColor), // drawer icon color
            actions: <Widget>[

              IconButton(
                tooltip: "Search here",
                onPressed: () {},
                icon: Icon(Icons.search,color: Colors.white,),
              ),
              SizedBox(width: 2,), 

            
              Builder(
                builder: (context) =>  IconButton(
                  icon: Icon(Icons.menu,color: Colors.white,),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),

              // Builder(
              //   builder: (context) => Container(
              //     height: 30,
              //     decoration: BoxDecoration(
              //       border: Border.all(
              //         color: themGreenColor,
              //         width: 2
              //       ),
              //       color: themColor,
              //       borderRadius: BorderRadius.all(Radius.circular(30))
              //     ),
              //     child: IconButton(
              //       icon: Icon(Icons.menu,color: Colors.white,),
              //       onPressed: () => Scaffold.of(context).openEndDrawer(),
              //       tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              //     ),
              //   ),
              // ),

              SizedBox(width: 2,), 

            // Padding(
            //   padding: EdgeInsets.only(right: 5),
            //   child: Container(
            //     height: 30,
            //     decoration: BoxDecoration(
            //       border: Border.all(
            //         color: themGreenColor,
            //         width: 2
            //       ),
            //       color: themColor,
            //       borderRadius: BorderRadius.all(Radius.circular(30))
            //     ),

            //     child: PopupMenuButton<int>(
            //       tooltip: "Option Menu",
            //       icon: Icon(Icons.more_vert, color: Colors.white,),
            //       color: Colors.white,
            //       itemBuilder: (context) => [
            //         PopupMenuItem<int>(
            //           value: 0, 
            //           child: Text("More Services",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themGreenColor,fontWeight: FontWeight.w800),)
            //         ),
            //         PopupMenuItem<int>(
            //           value: 1, 
            //           child: Text("Book Now",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themRedColor,fontWeight: FontWeight.w800),)
            //         ),
            //         PopupMenuDivider(),
            //         PopupMenuItem<int>(
            //           value: 2,
            //           child: Row(
            //             children: [
            //               Icon(
            //                 Icons.logout,
            //                 color: Colors.red,
            //               ),
            //               const SizedBox(
            //                 width: 1,
            //               ),
            //               Text("Logout",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black45,fontWeight: FontWeight.w800))
            //             ],
            //           )
            //         ),
            //       ],
            //       onSelected: (item) => SelectedItem(context, item),
            //     ),
            //     // child: IconButton(
            //     //   tooltip: "Search here",
            //     //   onPressed: () {},
            //     //   icon: Icon(Icons.search,color: Colors.white,),
            //     // ),
            //   ), 


            //   // child: ClipRRect(
            //   //   borderRadius: BorderRadius.circular(30),
            //   //   child: Material(
            //   //     color: themColor,
            //   //     child: PopupMenuButton<int>(
            //   //       tooltip: "Option Menu",
            //   //       icon: Icon(Icons.more_vert, color: Colors.white,),
            //   //       color: Colors.white,
            //   //       itemBuilder: (context) => [
            //   //         PopupMenuItem<int>(
            //   //           value: 0, 
            //   //           child: Text("More Services",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themGreenColor,fontWeight: FontWeight.w800),)
            //   //         ),
            //   //         PopupMenuItem<int>(
            //   //           value: 1, 
            //   //           child: Text("Book Now",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themRedColor,fontWeight: FontWeight.w800),)
            //   //         ),
            //   //         PopupMenuDivider(),
            //   //         PopupMenuItem<int>(
            //   //           value: 2,
            //   //           child: Row(
            //   //             children: [
            //   //               Icon(
            //   //                 Icons.logout,
            //   //                 color: Colors.red,
            //   //               ),
            //   //               const SizedBox(
            //   //                 width: 1,
            //   //               ),
            //   //               Text("Logout",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black45,fontWeight: FontWeight.w800))
            //   //             ],
            //   //           )
            //   //         ),
            //   //       ],
            //   //       onSelected: (item) => SelectedItem(context, item),
            //   //     ),
            //   //   ),
            //   // ),
            // ),

            // PopupMenuButton<String>(
            //   color: Colors.white,
            //   icon: Icon(Icons.more_vert, color: themColor,),
            //   onSelected: onSelect,
            //   itemBuilder: (BuildContext context) {
            //     return myMenuItems.map((String choice) {
            //       return PopupMenuItem<String>(
            //         child: Text(choice),
            //         value: choice,
            //       );
            //     }).toList();
            //   }
            // )
          ],

          // leading: IconButton(
          //   icon: Icon(Icons.menu, size: 40), // change this size and style
          //   onPressed: () => SideDrawer(),
          // ),

          // leading: Builder(
          //   builder: (context) => IconButton(
          //     icon: Icon(Icons.menu_rounded),
          //     onPressed: () => SideDrawer(),
          //   ),
          // ),

          leading:  Padding(
            padding: const EdgeInsets.only(left: 5),
            child: IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white),
              onPressed: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
               // Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavigationBarService()));
                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> DoctorSpecializationListPage()));
              },
            ),
          ),

          title: const Text("Our Doctors",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20,fontFamily: 'WorkSans')),
          
        ),
          
        endDrawer: SizedBox(
          width: MediaQuery.of(context).size.width*0.7,
          child: SideDrawer()
        ),

        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return false;
          },
          child:
          
          doctorSpecializationList.length==0 ? 

          
           
          Center(
            child: 
            message=="No Doctors"? 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Image.asset("assets/images/no_doctor1.png",width: 150,height: 150,),
                  Text(message,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontSize: 20,fontFamily: 'WorkSans')),
              ],
            ): Text(message)
          )
              
           
           :

        
          // status==false ?

          // Text("No Data...") :

            
          
           ListView.builder(
            itemCount: doctorSpecializationList.length,
            itemBuilder: (context,index){
              return DoctorSpecializationListCard(map: doctorSpecializationList[index]);
          
            }
          ) 
        ),

      ),
      
    );
  }
}