import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/RequestAservice/RequestAservice.dart';
import 'package:healthcare2050/Screens/SubCategories.dart/SubCategories.dart';
import 'package:healthcare2050/Screens/SubCategories.dart/SubCategoriesNew.dart';
import 'package:healthcare2050/SideNavigationDrawer/SideNavigationDrawerPrevious.dart';
import 'package:healthcare2050/SideNavigationDrawer/navigation_drawer_widget.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:readmore/readmore.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';


class SubCategoriesDtails extends StatelessWidget {
  const SubCategoriesDtails({ Key? key }) : super(key: key);

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

class _ScreenState extends State<Screen> with SingleTickerProviderStateMixin {

  late AnimationController animationController;
  late Animation<double> animation;

  //// checking  connectivity start
  String status = "Waiting...";
  Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;
  void checkConnectivity() async {
    var connectionResult = await _connectivity.checkConnectivity();

    if (connectionResult == ConnectivityResult.mobile) {
      status = "MobileData";
     
    } else if (connectionResult == ConnectivityResult.wifi) {
      status = "Wifi";
    
    } else {
      status = "Not Connected";
  
    }
    setState(() {});
  }

  void checkRealtimeConnection() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile) {
        status = "MobileData";

      } else if (event == ConnectivityResult.wifi) {
        status = "Wifi";

      } else {
        status = "Not Connected";

        showTopSnackBar(
          context,
          
          CustomSnackBar.error(
           // backgroundColor: Colors.red,
            message:
                "No Internet \n Please Check Internet Connection !!!",
          ),
        );
    
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     behavior: SnackBarBehavior.floating,
        //     margin: EdgeInsets.only(bottom: 100.0),
        //      duration: const Duration(seconds: 2),
        //     content: new Text("No Internet",style: TextStyle(color: Colors.white),),
        //     backgroundColor: Colors.red,
        //   )
        // );
      }
      setState(() {});
    });
  }
  //// checking  connectivity end
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkRealtimeConnection();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
  }
  
  @override
  Widget build(BuildContext context) {

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          radius: 0.8,
          colors: [
            Colors.white,
            Colors.white,
            //Color(0xFFb6e5e5),
            
          ],
        )
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,

        endDrawer: SizedBox(
          width: MediaQuery.of(context).size.width*0.7,
          
          child: SideDrawer()
        ), 
          
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SubCategoriesNew()));
                // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> BottomNavigationBarPage()));
              },
            ),
          ),

          title: const Text("Products Details",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20,fontFamily: 'WorkSans')),
          
        ),
        
        // appBar: AppBar(
        //   backwardsCompatibility: false,
        //   systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarColor: Colors.transparent,
        //     statusBarBrightness: Brightness.dark,
        //     statusBarIconBrightness: Brightness.dark
        //   ),
  
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        //   leading:  Padding(
        //     padding: const EdgeInsets.only(left: 5),
        //     child: Container(
              
        //       decoration: BoxDecoration(
        //         border: Border.all(
        //           color: Colors.white,
        //         ),
        //         color: Colors.white,
        //         borderRadius: BorderRadius.all(Radius.circular(30))
        //       ),
              
        //       child: IconButton(
        //         icon: const Icon(Icons.keyboard_arrow_left,color: themColor,size: 30,),
        //         onPressed: (){
        //           Navigator.push(context, MaterialPageRoute(builder: (context)=>SubCategories()));
        //          // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> BottomNavigationBarPage()));
        //         },
        //       ),
        //     ),
        //   ),
        //   title: const Text("Products Details",style: TextStyle(color: themColor,fontWeight: FontWeight.w600,fontSize: 20,fontFamily: 'Ubuntu')),
        // ),

        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return false;
          },
          child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
            child: Container(
             
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 2,right: 2,bottom: 5,top: 5),
                    child: new ElevatedButton.icon(

                      style: ElevatedButton.styleFrom(
                        primary: themColor, // Background color
                      ),
                      
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RequestAservice()));
                      },
                      icon: Icon(
                        Icons.medical_services,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      label: Text('Request A Service',style: TextStyle(color: Colors.white),)
                     
                    )
                  ),
                  

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       Hero(
                          tag: "sub",
                          child: Image.network(SubCategoriesNew.subCategoryImage.toString(),color: Colors.blue,height: 30,width: 60,)
                        ),
        
                        Expanded(
                          child: Container(
                            width: width*0.9,
                            child: Text( SubCategoriesNew.subCategoryName.toString(),maxLines: 1,overflow: TextOverflow.ellipsis ,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontFamily: "WorkSans",fontSize: 18))
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20,),

                  SubCategoriesNew.details.toString()== "" ? Container() :
        
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo, 
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                    ),
                    padding: EdgeInsets.all(15),
                    child: ReadMoreText(
                      SubCategoriesNew.details.toString() == "null" ? " " : SubCategoriesNew.details.toString() == "" ? "":SubCategoriesNew.details.toString(),textDirection: TextDirection.ltr,
                      trimLines: 3,
                      textAlign: TextAlign.justify,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: " Show More ",
                      trimExpandedText: " Show Less ",
                      lessStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themAmberColor,
                      ),
                      moreStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themAmberColor,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        height: 2,color: Colors.white
                      ),
                    ),
                  ),
                  
                ]  
              ),
            ),
          ),
              ),
        ),

      ),
            
      
    );
  }

  
}