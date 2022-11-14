import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/Home/HomeModified.dart';

import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistration.dart';
import 'package:healthcare2050/Screens/SplashScreen/SplashScreen.dart';
import 'package:healthcare2050/Screens/SubCategories.dart/SubCategoriesDetails.dart';
import 'package:healthcare2050/SideNavigationDrawer/SideNavigationDrawerPrevious.dart';
import 'package:healthcare2050/SideNavigationDrawer/SideNavigationDrawerPrevious.dart';
import 'package:healthcare2050/SideNavigationDrawer/SideNavigationDrawerPrevious.dart';
import 'package:healthcare2050/SideNavigationDrawer/SideNavigationDrawerPrevious.dart';
import 'package:healthcare2050/SideNavigationDrawer/SideNavigationDrawerPrevious.dart';
import 'package:healthcare2050/SideNavigationDrawer/SideNavigationDrawerPrevious.dart';
import 'package:healthcare2050/SideNavigationDrawer/navigation_drawer_widget.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:slider_button/slider_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SubCategories extends StatelessWidget {
  const SubCategories({ Key? key }) : super(key: key);

  static String ? details,subCategoryImage,subCategoryName;

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

  //// checking  connectivity start
  Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;
  
  void checkRealtimeConnection() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile) {
        Splash.internetConnection = "MobileData";

      } else if (event == ConnectivityResult.wifi) {
        Splash.internetConnection = "Wifi";

      } else {
        Splash.internetConnection = "Not Connected";

        showTopSnackBar(
          context,
          
          CustomSnackBar.error(
           // backgroundColor: Colors.red,
            message: "No Internet \n Please Check Internet Connection !!!",
          ),
        );

      }
      setState(() {});
    });
  }
  //// checking  connectivity end
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //check();
    checkRealtimeConnection();
    if(Splash.internetConnection=="Not Connected"){
      showTopSnackBar(
        context,
        CustomSnackBar.error(
           // backgroundColor: Colors.red,
          message: "No Internet \n Please Check Internet Connection !!!",
                
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    

    void SelectedItem(BuildContext context, item) {
      switch (item) {
        case 0:
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => SettingPage()));
          break;
        case 1:
          print("Privacy Clicked");
          break;
        case 2:
          print("User Logged out");
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) => LoginPage()),
          //     (route) => false);
          break;
      }
    }

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

            // IconButton(
            //   icon: Icon(Icons.menu,color: Colors.white,),
            //   onPressed: () => Scaffold.of(context).openEndDrawer(),
            //   tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            // ),

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

            Builder(
              builder: (context) =>  IconButton(
                  icon: Icon(Icons.menu,color: Colors.white,),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              
            ),

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
                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> BottomNavigationBarPage()));
              },
            ),
            
          ),

          title: const Text("Our Products",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20,fontFamily: 'WorkSans')),
          
        ),

        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return false;
          }, 
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            
            child: Stack(
              children: [
        
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Container(
        
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // Padding(
                        //   padding: const EdgeInsets.only(left: 5),
                        //   child: Container(
                        //     alignment: Alignment.center,
                        //     width: width*0.1,
                        //     height: 40,
                        //     decoration: BoxDecoration(
                        //       border: Border.all(
                        //         width: 2,
                        //         color: themGreenColor,
                        //       ),
                        //       color: themColor,
                        //       borderRadius: BorderRadius.all(Radius.circular(10))
                        //     ),
                            
                        //     child: IconButton(
                        //       icon: const Icon(Icons.arrow_back,color: Colors.white,size: 20,),
                        //       onPressed: (){
                        //         //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
                        //         Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> BottomNavigationBarPage()));
                        //       },
                        //     ),
                            
                            
                        //   ),
                        // ),

                        Hero(
                          tag: "category",
                          child: SvgPicture.network("http://101.53.150.64/2050Healthcare/public/category/"+Home.categoryImage.toString(),color: Colors.blue,height: 50,width: 80,)
                        ),
        
                        Container(
                          width: width*0.4,
                          child: Text( Home.categoryName.toString().split('-').join(' '),maxLines: 1,overflow: TextOverflow.ellipsis ,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontFamily: "WorkSans",fontSize: 18))
                        ),
                      ]
                      
                    ),
                  ),
                ),
        
                Padding(
                  padding: const EdgeInsets.only(top: 100,bottom: 0,left: 20,right: 20),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      
                      childAspectRatio: (2/ 1),
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: 1.0,
                      mainAxisExtent: 150,
                      
                      crossAxisSpacing: 20.0,
                        
                      //crossAxisCount: 2,crossAxisSpacing: 1, mainAxisSpacing: 1
                    ),
                    padding: EdgeInsets.zero,
                    //shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: Home.subCategoryList.length,
                    itemBuilder: (context,index){
        
                      String subcategoryName=Home.subCategoryList[index]['SubcategoryName'].toString().split('-').join(' ');
                     // subcategoryName.split('-').join('');
        
                      return ListTile(
              
                        title: InkWell(
                          onTap: (){

                            if( Splash.internetConnection == "Not Connected"){
                              showTopSnackBar(
                                context,
                                
                                CustomSnackBar.error(
                                // backgroundColor: Colors.red,
                                  message:
                                      "No Internet \n Please Check Internet Connection !!!",
                                ),
                              );
                            }

                            if( Splash.internetConnection!="Not Connected"){

                              setState(() {
                                SubCategories.subCategoryName=subcategoryName;
                                SubCategories.subCategoryImage="http://101.53.150.64/2050Healthcare/public/subcategory/"+Home.subCategoryList[index]['Icon'];
                                SubCategories.details=Home.subCategoryList[index]['SubcategoryMobileContent'].toString();
                              });
                            
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SubCategoriesDtails()));
                            }

                           
                          },
              
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                             
                              child: Card(
                                shadowColor: themColor,
                                color: Colors.white,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Padding(
                                    //   padding: EdgeInsets.only(top: 5),
                                    //   child: 
                                      SizedBox(
                                        height: 50,
                                        // child: Image.asset("assets/Home/rehabilation.png",width: 100,height: 60,)
                                        child: Hero(
                                          tag: "sub",
                                          child: Image.network("http://101.53.150.64/2050Healthcare/public/subcategory/"+Home.subCategoryList[index]['Icon'],color: Colors.black45,)
                                        ),
                                      ),
                                    //),
              
                                    // Padding(
                                    //   padding: EdgeInsets.only(left: 5,right: 5),
                                    //   child: Text(category_name,maxLines: 2,style: TextStyle(color: Colors.white,fontFamily: 'WorkSans',fontWeight: FontWeight.w900,fontSize: 12),)
                                    // )
              
                                    
                                    
                                    // Padding(
                                    //   padding: const EdgeInsets.only(left: 0,right: 0),
                                     // child: FittedBox(
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: Container(
                                           // color: themAmberColor,
                                           // height: 40,
                                           // width: width*0.3,
                                           // child: Align(
                                              // padding: const EdgeInsets.only(left: 8,right: 8,top: 2),
                                              //alignment: Alignment.center,
                                      
                                              child: 
                                                subcategoryName== null ? 
                                                Text("Not Available",overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color:Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")) :
                                                                                    
                                                Text(subcategoryName,style: TextStyle(color: themColor,fontWeight: FontWeight.bold,fontFamily: "Roboto"),textAlign: TextAlign.center,),
                                                // Container(
                                                  
                                                //   child: FittedBox(child: Text( Home.subCategoryList[index]['SubcategoryName'].toString() ,style: TextStyle(color:Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")))
                                                // )
                                      
                                              // child: FittedBox(child: Text(category_name,style: TextStyle(color: Colors.white,fontFamily: 'WorkSans',fontWeight: FontWeight.w900),)),
                                              //child: FittedBox(child: Text(categoryList[index]['CategoryName'].toString(),style: TextStyle(color: Colors.black45,fontFamily: 'WorkSans',fontWeight: FontWeight.w600),)),
                                            ),
                                        ),
                                       // ),
                                     // ),
                                  //  )
                                    
                                  ],
                                ),
                              ),
                            ),
                          ),
              
                        ),
                                      
              
              
              
                      );
              
                    }
                  ),
                ),
              ]  
            ),
          ),
        )

      ),
            
      
    );
  }

  // void check() async {
  //    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
  //     if (event == ConnectivityResult.mobile) {
  //       LoginRegistration.status = "MobileData";
  //      print("status "+LoginRegistration.status.toString());
  //     } else if (event == ConnectivityResult.wifi) {
  //       LoginRegistration.status = "Wifi";
  //       print("status "+LoginRegistration.status.toString());
  //     } else {
  //       LoginRegistration.status = "Not Connected";

  //        print("status "+LoginRegistration.status.toString());

  //       showTopSnackBar(
  //         context,
          
  //         CustomSnackBar.error(
  //          // backgroundColor: Colors.red,
  //           message:
  //               "No Internet \n Please Check Internet Connection !!!",
  //         ),
  //       );
    
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(
  //       //     behavior: SnackBarBehavior.floating,
  //       //     margin: EdgeInsets.only(bottom: 100.0),
  //       //      duration: const Duration(seconds: 2),
  //       //     content: new Text("No Internet",style: TextStyle(color: Colors.white),),
  //       //     backgroundColor: Colors.red,
  //       //   )
  //       // );
    

  //     }
  //     setState(() {});
  //   });
  // }
}