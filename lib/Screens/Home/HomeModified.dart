import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocode/geocode.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Providers/CategorySubCategoryProvider.dart';
import 'package:healthcare2050/Screens/Doctors/DoctorSpecializationList.dart';
import 'package:healthcare2050/Screens/Doctors/AllDoctorsList.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistration.dart';
import 'package:healthcare2050/Screens/NoInternetPage/NoInternetHome.dart';
import 'package:healthcare2050/Screens/SplashScreen/SplashScreen.dart';
import 'package:healthcare2050/Screens/SubCategories.dart/SubCategories.dart';
import 'package:healthcare2050/Screens/SubCategories.dart/SubCategoriesNew.dart';
import 'package:healthcare2050/Screens/Whatsup.dart';
import 'package:healthcare2050/SideNavigationDrawer/SideNavigationDrawerPrevious.dart';
import 'package:healthcare2050/SideNavigationDrawer/navigation_drawer_widget.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:hybrid_image/hybrid_image.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;


class Home extends StatelessWidget {
  
  static List subCategoryList=[];
  static String ? categoryImage,categoryName,userid;


  @override
  Widget build(BuildContext context) {

    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /// screen Orientation end///////////
    
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
    
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  LocationData? currentLocation;
  String address = "";

  void _getLocation() {
    _getLocationData().then((value) {
      
      LocationData? location = value;
      _getAddress(location?.latitude, location?.longitude).then((value) {
        setState(() {
          currentLocation = location;
          address = value;

          // print("value ");

          // print("address "+address);
          // print("value "+value);
        });
      });
    });
  }


  // var whatsapp ="+919439490871";

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
            //onPressed: () => Navigator.of(context).pop(true),
            onPressed: () => exit(0),
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  //// checking internet connectivity start
  bool _isConnected=true;
  Future<void> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty) {
        setState(() {
          _isConnected = true;
        });
      }
    } on SocketException catch (err) {
      setState(() {
        _isConnected = false;
      });
      print(err);
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          // backgroundColor: Colors.red,
          message:
              "No Internet \n Please Check Internet Connection !!!",
        ),
      );
     // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>const NoInternetHome()));
    }
  }
  //// checking internet connectivity end

  
  // //// checking  connectivity start
  // String status = "Waiting...";
  // Connectivity _connectivity = Connectivity();
  // late StreamSubscription _streamSubscription;
  
  // void checkConnectivity() async {
  //   var connectionResult = await _connectivity.checkConnectivity();

  //   if (connectionResult == ConnectivityResult.mobile) {
  //     status = "MobileData";
     
  //   } else if (connectionResult == ConnectivityResult.wifi) {
  //     status = "Wifi";
    
  //   } else {
  //     status = "Not Connected";
  
  //   }
  //   setState(() {});
  // }

  // void checkRealtimeConnection() {
  //   _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
  //     if (event == ConnectivityResult.mobile) {
  //       status = "MobileData";
  //      print("status "+status.toString());
  //     } else if (event == ConnectivityResult.wifi) {
  //       status = "Wifi";
  //       print("status "+status.toString());
  //     } else {
  //       status = "Not Connected";
  //       print("status "+status.toString());

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
  // //// checking  connectivity end
  
  openwhatsapp() async{
    var whatsapp ="+919439490871";
    var whatsappURl_android = "whatsapp://send?phone="+whatsapp;
    var whatappURL_ios ="https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if(Platform.isIOS){
      // for iOS phone only
      if( await canLaunch(whatappURL_ios)){
         await launch(whatappURL_ios, forceSafariVC: false);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp not installed ios")));
      }
    }else{
      // android , web
      if( await canLaunch(whatsappURl_android)){
        await launch(whatsappURl_android);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp not installed android")));
      }
    }
  }

 


 // VideoPlayerController ? _controller;
  
  
  bool isLoadingCategory=false;
 // isLoadingCity=false,isLoadingDoctor= false;

  // openwhatsapp() async{
  //   var whatsapp ="7008323469";
  //   var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text=hello";
  //   var whatappURL_ios ="https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
  //   if(Platform.isIOS){
  //     // for iOS phone only
  //     if( await canLaunch(whatappURL_ios)){
  //        await launch(whatappURL_ios, forceSafariVC: false);
  //     }else{
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: new Text("whatsapp not installed")));
  //     }
  //   }else{
  //     // android , web
  //     if( await canLaunch(whatsappURl_android)){
  //       await launch(whatsappURl_android);
  //     }else{
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: new Text("whatsapp no installed")));

           // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     behavior: SnackBarBehavior.floating,
        //     margin: EdgeInsets.only(bottom: 100.0),
        //      duration: const Duration(seconds: 2),
        //     content: new Text("No Internet",style: TextStyle(color: Colors.white),),
        //     backgroundColor: Colors.red,
        //   )
        // );
  //     }
  //   }
  // }


  

  //// Greeting Message started
  var timeNow;
  late String greetingMessageStatus;

  String greetingMessage(){
  
    var timeNow = DateTime.now().hour;

    if (timeNow <= 12) {
      return 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  void upDateGreetingMessageAccordingToTime(){
    setState(() {
      greetingMessageStatus = greetingMessage();
    });
  }

  ///////////////// Greeting Message End

  /// checkInternet start
  bool connected=false;
  void checkInternet() async{
    try{
      final result =await InternetAddress.lookup("google.com");
      if(result.isNotEmpty && result[0].rawAddress.isEmpty){

        setState(() {
          connected=true;
          //print("connection "+ connected.toString());
        });
          
      }
    } on SocketException  catch (_) {

      setState(() {
        connected=false;
       // print("connection "+ connected.toString());
      });

      showTopSnackBar(
        context,
        
        CustomSnackBar.error(
          // backgroundColor: Colors.red,
          message: "No Internet \n Please Check Internet Connection !!!",
        ),
      );
      
    }
  }
  /// checkInternet end

  @override
  void initState() {
    super.initState();

    checkInternet();
     _getLocation();

    // checkRealtimeConnection();
    // if(Splash.internetConnection=="Not Connected"){
    //   showTopSnackBar(
    //       context,
          
    //       CustomSnackBar.error(
    //        // backgroundColor: Colors.red,
    //         message:
    //             "No Internet \n Please Check Internet Connection !!!",
    //       ),
    //     );
    // }
    timeNow = DateTime.now().hour;
    getCredentials();
    // greetingMessage();
    // upDateGreetingMessageAccordingToTime();
    //_checkInternetConnection();
    //checkRealtimeConnection();
    

   
    // _getUserLocation = getUserLocation(); // by situ
    final data= Provider.of<CategorySubCategoryProvider>(context,listen: false);
    data.fetchCategory();
    //openwhatsapp();
    

  }

  @override
  void dispose() {
    // TODO: implement dispose
  //  _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final data= Provider.of<CategorySubCategoryProvider>(context);

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;
    final margin1 = const EdgeInsets.only(bottom: 5.0, right: 20.0, left: 20.0);


    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          elevation: 1,
          backwardsCompatibility: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: themColor,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light
          ),
        
          backgroundColor: themColor,
          toolbarHeight: height*0.05,
          
          
          leading: IconButton(
            
            icon: Icon(Icons.search,color: themAmberColor,size: 40,),
            onPressed: (){
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>Service()));
              // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Service()));
            },
          ),

           // title: ,
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
          data.isloading==true ? Center(child: Text("Please Wait...")) :
          
           Column(
            children: [


              Container(
                color: Colors.white,
                height: height*0.2,
                child: Stack(
                  children: [

                    Container(
                      color: themColor,
                      width: width,
                      height: height*0.1,
                      child: Container(
                        padding: const EdgeInsets.only(left:10),
                        child: Column(
                          children: [
                              if (currentLocation != null) 
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  width: width,
                                  // height: height*0.02,
                                  child: Row(
                                    children: [
                                      Image.asset("assets/images/location.png",width: 20,height: 20),
                                      
                                      Expanded(child: Text("$address", style: TextStyle(color: Colors.white,fontFamily: "WorkSans"),)),
                                      
                                    ],
                                  ),
                                ),
                              ),
                            // Row(
                            //   children: [
                            //     const Icon(Icons.search,color: themAmberColor, size: 30,),
                            //     SizedBox(
                            //       width: width*0.6,
                            //       height: 10,
                            //       child: const FittedBox(child: Text("Search to find healing experience..", style: TextStyle(fontSize: 6,fontWeight: FontWeight.w600,color: themAmberColor,fontFamily: 'RaleWay',),))
                            //     ),
                            //   ]  
                            // ),
                            SizedBox(height: 2,)
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 60,left: 10,right: 10),
                      child: Container(
                        height: height*0.12,
                        child: Column(
                          children: [

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                elevation: 10,
                                color: themBlueColor,
                                child: Container(
                                
                                  width: width,
                                  height: height*0.1,
                                  decoration: BoxDecoration(
                                    color: themColor,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                                  ),
                                  
                              
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                          
                          
                                      Card(
                                        elevation: 20,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Container(
                                          width: width*0.4,
                                          height: height*0.1,
                                          child:  InkWell(
                                            onTap: () {
                                              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DoctorSpecializationListPage()));
                                              if(_isConnected==false){
                                                showTopSnackBar(
                                                  context,
                                                  CustomSnackBar.error(
                                                    // backgroundColor: Colors.red,
                                                    message:
                                                        "No Internet \n Please Check Internet Connection !!!",
                                                  ),
                                                );
                                              }
                                              if(_isConnected==true)
                                              
                                              {
                                                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> DoctorSpecializationListPage()));
                                              }
                                              
                          
                                              // if( status == "Not Connected"){
                                              //   showTopSnackBar(
                                              //     context,
                                                  
                                              //     CustomSnackBar.error(
                                              //     // backgroundColor: Colors.red,
                                              //       message:
                                              //           "No Internet \n Please Check Internet Connection !!!",
                                              //     ),
                                              //   );
                                              // }
                          
                                              // if(status=="MobileData" && status=="Wifi"){
                                                
                                              // }
                          
                                              
                                            },
                                            child: Column(
                                              children: [
                                                Card(
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(150),
                                                  ),
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      // The child of a round Card should be in round shape 
                                                        shape: BoxShape.circle, 
                                                        color: themBlueColor,
                                                        
                                                    ),
                                                    child: Center(child: Image.asset("assets/images/appointment.png",width: 30,height: 50,color: Colors.white,)),
                                                  )
                                                ),
                                                
                                                Container(
                                                  //alignment: Alignment.centerLeft,
                                                  //color: Colors.white,
                                                  width: width*0.35,
                                                  // height: 30,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 5),
                                                    child: Text("Book Appointment",textAlign: TextAlign.center,style: TextStyle(color: Colors.black54,fontFamily: 'WorkSans',fontWeight: FontWeight.w800,fontSize: 10)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ),
                          
                          
                                      Card(
                                        elevation: 20,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Container(
                                          width: width*0.4,
                                          height: height*0.1,
                                          child:  InkWell(
                                            onTap: () async{
                                              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DoctorSpecializationListPage()));
                                              if(_isConnected==false){
                                                showTopSnackBar(
                                                  context,
                                                  CustomSnackBar.error(
                                                    // backgroundColor: Colors.red,
                                                    message:
                                                        "No Internet \n Please Check Internet Connection !!!",
                                                  ),
                                                );
                                              }
                                              if(_isConnected==true)
                                              
                                              {
                                                var whatsapp ="+918988980202";
                                                var whatsappURl_android = "whatsapp://send?phone="+whatsapp;
                                                var whatappURL_ios ="https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
                                                if(Platform.isIOS){
                                                  // for iOS phone only
                                                  if( await canLaunch(whatappURL_ios)){
                                                    await launch(whatappURL_ios, forceSafariVC: false);
                                                  }else{
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: new Text("whatsapp not installed ios")));
                                                  }
                                                }else{
                                                  // android , web
                                                  if( await canLaunch(whatsappURl_android)){
                                                    await launch(whatsappURl_android);
                                                  }else{
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: new Text("whatsapp not installed android")));
                                                  }
                                                }
                          
                                              }
                                              
                          
                                              // if( status == "Not Connected"){
                                              //   showTopSnackBar(
                                              //     context,
                                                  
                                              //     CustomSnackBar.error(
                                              //     // backgroundColor: Colors.red,
                                              //       message:
                                              //           "No Internet \n Please Check Internet Connection !!!",
                                              //     ),
                                              //   );
                                              // }
                          
                                              // if(status=="MobileData" && status=="Wifi"){
                                                
                                              // }
                          
                                              
                                            },
                                            child: Column(
                                              children: [
                                                Card(
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(150),
                                                  ),
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      // The child of a round Card should be in round shape 
                                                      shape: BoxShape.circle, 
                                                      color: themBlueColor,
                                                        
                                                    ),
                                                    child: Center(child: Image.asset("assets/images/whatsup.png",width: 30,height: 50,color: Colors.white,)),
                                                  )
                                                ),
                                                
                                                Container(
                                                  //alignment: Alignment.centerLeft,
                                                  //color: Colors.white,
                                                  width: width*0.35,
                                                  // height: 30,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 5),
                                                    child: Text("Whats' App",textAlign: TextAlign.center,style: TextStyle(color: Colors.black54,fontFamily: 'WorkSans',fontWeight: FontWeight.w800,fontSize: 10)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ),
                                      
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        )
                      )    
                    )
                  ]
                ),
              ), 

              //Spacer(),

              Container(
               
                child: GestureDetector(
                  onTap: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>Screen2()));

                  },
                  child: Container(
                    height: height*0.25,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(color: Colors.blueGrey[300],
                                borderRadius: BorderRadius.circular(20),
                                  boxShadow: shadowList,
                                ),
                                margin: EdgeInsets.only(top: 50),
                              ),
                              Align(
                                child: Hero(
                                  tag:1,child: Image.asset("assets/images/doctor.png",height: 250,)
                                ),
                              )

                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 70,bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,

                              boxShadow: shadowList,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20)
                              )
                            ),

                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Having Health Issues ?",style: TextStyle(color: Colors.black54,fontFamily: 'WorkSans',fontWeight: FontWeight.w900,fontSize: 20),),
                                  Text("Find a doctor who will take the best care...",style: TextStyle(color: Colors.black45,fontFamily: 'WorkSans',fontWeight: FontWeight.w600),),

                                ],
                                
                              ),
                            ),

                          )
                        ) 

                      ],
                    ),

                  ),
                ),

              ),

              Padding(
                padding: const EdgeInsets.only(left: 5,right: 5,top: 30,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("What do you need ?",style: TextStyle(fontFamily: 'WorkSans',color: Colors.black54,fontSize: 20,fontWeight: FontWeight.w900),),
                  //  Text("View All",style: TextStyle(fontFamily: 'WorkSans',color: Colors.black45,fontSize: 12,fontWeight: FontWeight.w900),)
                  ],
                ),
              ),

              Container(
                child: Container(
                  height: height*0.32,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 1, mainAxisSpacing: 1),
                      padding: EdgeInsets.all(1),
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: data.categoryList.length,
                      itemBuilder: (BuildContext context,int index){
                          
                        String category_name=data.categoryList[index]['CategoryName'].toString().split('-').join(' ');
                        category_name.split('-').join('');
                        return SizedBox(
                          //child: Text(categoryList![index]['CategoryName'])
                          
                        
                          child: SizedBox(
                            // width: 80,
                            // height: 50,
                            child: InkWell(
                              onTap: () {

                                if( Splash.internetConnection == "Not Connected"){
                                  showTopSnackBar(
                                    context,
                                    
                                    CustomSnackBar.success(
                                    // backgroundColor: Colors.red,
                                      message:
                                          "No Internet \n Please Check Internet Connection !!!",
                                    ),
                                  );
                                }

                                if(Splash.internetConnection!="Not Connected"){
                                  Home.subCategoryList.clear();
                                  Home.subCategoryList.addAll(data.categoryList[index]['subcategory']);
                                  Home.categoryImage=data.categoryList[index]['Icon'].toString();
                                  Home.categoryName=data.categoryList[index]['CategoryName'].toString();
                  
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SubCategoriesNew()));
                                  print("sub category "+Home.subCategoryList.length.toString() );
                                }
                                
                              },
                              child: Card(
                                color: themColor,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      
                                      // child: Image.asset("assets/images/rehabilation.png",width: 100,height: 60,)
                                      child: Hero(
                                        tag: "category",
                                        child: SvgPicture.network("http://101.53.150.64/2050Healthcare/public/category/"+data.categoryList[index]['Icon'],width: 20,height: 80,allowDrawingOutsideViewBox: true,color: themAmberColor,)
                                      ),
                                    ),
                                    
                                    SizedBox(
                                      // height: 20,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8,right: 8,top: 2),
                                        //child: FittedBox(
                                          child: Text(category_name,style: TextStyle(color: Colors.white,fontFamily: 'WorkSans',fontWeight: FontWeight.w900),textAlign: TextAlign.center,)
                                        //),
                                        //child: FittedBox(child: Text(categoryList[index]['CategoryName'].toString(),style: TextStyle(color: Colors.black45,fontFamily: 'WorkSans',fontWeight: FontWeight.w600),)),
                                      ),
                                    )
                                    
                                  ],
                                ),
                              ),
                            ),
                          ),
                          
                        );
                      }
                    ),
                  ),
                ),
             )  
               



                        

                                  
 

                      
               // )]  
                //  ),
               // ),
             // ),


                       





               

              
          //   ],
          // ), 


          // child: CustomScrollView(
          //   slivers: [







          //     SliverAppBar(
                
          //       backwardsCompatibility: false,
          //       systemOverlayStyle: const SystemUiOverlayStyle(
          //         statusBarColor: themColor,
          //         statusBarBrightness: Brightness.light,
          //         statusBarIconBrightness: Brightness.light
          //       ),
            
          //       snap: true,
          //       pinned: true,
          //       floating: true,
          //       iconTheme: const IconThemeData(color: Colors.white),

          //       actions: [
          //         IconButton(
          //           onPressed: () {},
          //           icon: Icon(Icons.notifications,color: Colors.white),
          //         ),
          //       ],
            
          //       flexibleSpace: FlexibleSpaceBar(
          //         centerTitle: true,
          //         title: SizedBox(
          //           child: InkWell(
          //             onTap: (){
          //              // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Search()));
          //             } ,
          //             child: Padding(
          //               padding: const EdgeInsets.only(left: 10,right: 10),
          //               child: Container(
          //                 height: 18,
          //                 width: MediaQuery.of(context).size.width*0.6,
          //                 decoration: const BoxDecoration(
          //                   color: Colors.white,
          //                   borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
          //                   boxShadow: [
          //                     BoxShadow(color: Colors.black45, spreadRadius: 1),
          //                   ],
          //                 ),
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(left:10),
          //                   child: Row(
          //                     children: [
          //                       const Icon(Icons.search,color: Colors.black45, size: 16,),
          //                       SizedBox(
          //                         width: width*0.5,
          //                         height: 15,
          //                         child: const FittedBox(child: Text("Search to find healing experience..", style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black38,fontFamily: 'RaleWay'),))
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
                  
          //       ), //FlexibleSpaceBar
          //       expandedHeight: 30,
          //       backgroundColor: themColor,
          //     ),

              
            
            
          //     SliverFillRemaining(
          //       hasScrollBody: false,
          //       child: SingleChildScrollView(
                  
          //         child: Column(
          //           children: [
            
          //            // const SizedBox(height: 2,),
        
          //             Padding(
          //               padding: const EdgeInsets.only(top: 5),
          //               child: Container(
          //                 //width: width,
          //                 height: height,
          //                 child: ChangeNotifierProvider<CategorySubCategoryProvider>(
          //                   create: (context)=>CategorySubCategoryProvider(),
          //                   child:
                            
          //                   data.isloading==true ? Center(child: Text("Please Wait...")) :
                          
                            
          //                   Column(
          //                     children: [

          //                       if (currentLocation != null) 
          //                       Padding(
          //                         padding: const EdgeInsets.all(2.0),
          //                         child: Container(
          //                           width: width,
          //                          // height: height*0.02,
          //                           child: Row(
          //                             children: [
          //                               Image.asset("assets/images/location.png",width: 20,height: 40),
                                        
          //                               Expanded(child: Text("$address", style: TextStyle(color: Colors.black54,fontFamily: "WorkSans"),)),
                                        
          //                             ],
          //                           ),
          //                         ),
          //                       ),

                               


          //                       Padding(
          //                         padding: const EdgeInsets.only(left: 5,right: 5),
          //                         child: SingleChildScrollView(
          //                           scrollDirection: Axis.horizontal,
          //                           child: Container(
          //                            // width: width,
          //                             child: Row(
          //                               mainAxisAlignment: MainAxisAlignment.center,
          //                               children: [
                                             
                                             
          //                                 // apointment
          //                                 InkWell(
          //                                   onTap: () {
          //                                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DoctorSpecializationListPage()));
          //                                     if(_isConnected==false){
          //                                       showTopSnackBar(
          //                                         context,
          //                                         CustomSnackBar.error(
          //                                           // backgroundColor: Colors.red,
          //                                           message:
          //                                               "No Internet \n Please Check Internet Connection !!!",
          //                                         ),
          //                                       );
          //                                     }
          //                                     if(_isConnected==true)
                                              
          //                                     {
          //                                       Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> DoctorSpecializationListPage()));
          //                                     }
                                              

          //                                     // if( status == "Not Connected"){
          //                                     //   showTopSnackBar(
          //                                     //     context,
                                                  
          //                                     //     CustomSnackBar.error(
          //                                     //     // backgroundColor: Colors.red,
          //                                     //       message:
          //                                     //           "No Internet \n Please Check Internet Connection !!!",
          //                                     //     ),
          //                                     //   );
          //                                     // }

          //                                     // if(status=="MobileData" && status=="Wifi"){
                                                
          //                                     // }

                                             
          //                                   },
          //                                   child: Row(
          //                                     children: [
          //                                       Card(
          //                                         elevation: 2,
          //                                         shape: RoundedRectangleBorder(
          //                                           borderRadius: BorderRadius.circular(150),
          //                                         ),
          //                                         child: Container(
          //                                           width: 50,
          //                                           height: 50,
          //                                           decoration: BoxDecoration(
          //                                             // The child of a round Card should be in round shape 
          //                                               shape: BoxShape.circle, 
          //                                               color: themAmberColor,
                                                        
          //                                           ),
          //                                           child: Center(child: Image.asset("assets/images/appointment.png",width: 30,height: 50,color: Colors.black,)),
          //                                         )
          //                                       ),
                                                
          //                                       Container(
          //                                         alignment: Alignment.centerLeft,
          //                                         //color: Colors.white,
          //                                         //width: width*0.35,
          //                                         // height: 30,
          //                                         child: Padding(
          //                                           padding: const EdgeInsets.only(left: 5),
          //                                           child: Text("Book Appointment",style: TextStyle(color: Colors.black54,fontFamily: 'WorkSans',fontWeight: FontWeight.w600,fontSize: 10)),
          //                                         ),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 ),
                                  
          //                                 // video call
                                          
                                          //  InkWell(
                                          //   onTap: () async{

                                          //     var whatsapp ="+918988980202";
                                          //     var whatsappURl_android = "whatsapp://send?phone="+whatsapp;
                                          //     var whatappURL_ios ="https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
                                          //     if(Platform.isIOS){
                                          //       // for iOS phone only
                                          //       if( await canLaunch(whatappURL_ios)){
                                          //         await launch(whatappURL_ios, forceSafariVC: false);
                                          //       }else{
                                          //         ScaffoldMessenger.of(context).showSnackBar(
                                          //             SnackBar(content: new Text("whatsapp not installed ios")));
                                          //       }
                                          //     }else{
                                          //       // android , web
                                          //       if( await canLaunch(whatsappURl_android)){
                                          //         await launch(whatsappURl_android);
                                          //       }else{
                                          //         ScaffoldMessenger.of(context).showSnackBar(
                                          //             SnackBar(content: new Text("whatsapp not installed android")));
                                          //       }
                                          //     }

                                          //     //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>IndexPage()));
                                          //     // print("status "+status.toString());

                                          //     // if( status == "Not Connected"){
                                          //     //   showTopSnackBar(
                                          //     //     context,
                                                  
                                          //     //     CustomSnackBar.error(
                                          //     //     // backgroundColor: Colors.red,
                                          //     //       message:
                                          //     //           "No Internet \n Please Check Internet Connection !!!",
                                          //     //     ),
                                          //     //   );
                                          //     // }

                                          //     // if(status=="MobileData" || status=="Wifi"){
                                               
                                          //     // }

                                              
                                          //   },
                                          //   child: Row(
                                          //     children: [
                                          //       Card(
                                          //         elevation: 5,
                                          //         shape: RoundedRectangleBorder(
                                          //           borderRadius: BorderRadius.circular(150),
                                          //         ),
                                          //         child: Container(
                                          //           width: 50,
                                          //           height: 50,
                                          //           decoration: BoxDecoration(
                                          //             // The child of a round Card should be in round shape 
                                          //               shape: BoxShape.circle, 
                                          //               color: themGreenColor,
                                                        
                                          //           ),
                                          //           child: Center(child: Image.asset("assets/images/whatsup.png",width: 30,height: 50,color: Colors.white,)),
                                          //         )
                                          //       ),
                                          //       Container(
                                          //         alignment: Alignment.centerLeft,
                                          //         //color: Colors.white,
                                          //         // width: width*0.35,
                                          //         // height: 30,
                                          //         child: Padding(
                                          //           padding: const EdgeInsets.only(left: 5,right: 5),
                                          //           child: Text("Whats App",style: TextStyle(color: Colors.black54,fontFamily: 'WorkSans',fontWeight: FontWeight.w600,fontSize: 10)),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                  
                                  
          //                               ],
          //                             ),
          //                           ),
          //                         ),
          //                       ),

          //                       Padding(
          //                         padding: const EdgeInsets.only(top: 20),
          //                         child: GestureDetector(
          //                           onTap: (){
          //                           // Navigator.push(context, MaterialPageRoute(builder: (context)=>Screen2()));

          //                           },
          //                           child: Container(
          //                             height: height*0.25,
          //                             margin: EdgeInsets.symmetric(horizontal: 20),
          //                             child: Row(
          //                               children: [
          //                                 Expanded(
          //                                   child: Stack(
          //                                     children: [
          //                                       Container(
          //                                         decoration: BoxDecoration(color: Colors.blueGrey[300],
          //                                         borderRadius: BorderRadius.circular(20),
          //                                          boxShadow: shadowList,
          //                                         ),
          //                                         margin: EdgeInsets.only(top: 50),
          //                                       ),
          //                                       Align(
          //                                         child: Hero(
          //                                           tag:1,child: Image.asset("assets/images/doctor.png",height: 250,)
          //                                         ),
          //                                       )

          //                                     ],
          //                                   ),
          //                                 ),
          //                                 Expanded(
          //                                   child: Container(
          //                                     margin: EdgeInsets.only(top: 70,bottom: 20),
          //                                     decoration: BoxDecoration(
          //                                       color: Colors.white,

          //                                       boxShadow: shadowList,
          //                                       borderRadius: BorderRadius.only(
          //                                         topRight: Radius.circular(20),
          //                                         bottomRight: Radius.circular(20)
          //                                       )
          //                                     ),

          //                                     child: Padding(
          //                                       padding: const EdgeInsets.only(left: 5),
          //                                       child: Column(
          //                                         mainAxisAlignment: MainAxisAlignment.center,
          //                                         children: [
          //                                           Text("Having Health Issues ?",style: TextStyle(color: Colors.black54,fontFamily: 'WorkSans',fontWeight: FontWeight.w900,fontSize: 20),),
          //                                           Text("Find a doctor who will take the best care...",style: TextStyle(color: Colors.black45,fontFamily: 'WorkSans',fontWeight: FontWeight.w600),),

          //                                         ],
                                                  
          //                                       ),
          //                                     ),

          //                                   )
          //                                 ) 

          //                               ],
          //                             ),

          //                           ),
          //                         ),
          //                       ),


                                
          //                       Padding(
          //                         padding: const EdgeInsets.only(left: 5,right: 5,top: 30,bottom: 10),
          //                         child: Row(
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           children: [
          //                             Text("What do you need ?",style: TextStyle(fontFamily: 'WorkSans',color: Colors.black54,fontSize: 20,fontWeight: FontWeight.w900),),
          //                           //  Text("View All",style: TextStyle(fontFamily: 'WorkSans',color: Colors.black45,fontSize: 12,fontWeight: FontWeight.w900),)
          //                           ],
          //                         ),
          //                       ),

                                       
          //                       Padding(
          //                         padding: const EdgeInsets.only(left: 5,right: 5),
          //                         child: GridView.builder(
          //                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 1, mainAxisSpacing: 1),
          //                           padding: EdgeInsets.all(1),
          //                           shrinkWrap: true,
          //                           physics: BouncingScrollPhysics(),
          //                           scrollDirection: Axis.vertical,
          //                           itemCount: data.categoryList.length,
          //                           itemBuilder: (BuildContext context,int index){
                                        
          //                             String category_name=data.categoryList[index]['CategoryName'].toString().split('-').join(' ');
          //                             category_name.split('-').join('');
          //                             return SizedBox(
          //                               //child: Text(categoryList![index]['CategoryName'])
                                        
                                      
          //                               child: SizedBox(
          //                                 // width: 80,
          //                                 // height: 50,
          //                                 child: InkWell(
          //                                   onTap: () {

          //                                     if( Splash.internetConnection == "Not Connected"){
          //                                       showTopSnackBar(
          //                                         context,
                                                  
          //                                         CustomSnackBar.success(
          //                                         // backgroundColor: Colors.red,
          //                                           message:
          //                                               "No Internet \n Please Check Internet Connection !!!",
          //                                         ),
          //                                       );
          //                                     }

          //                                     if(Splash.internetConnection!="Not Connected"){
          //                                       Home.subCategoryList.clear();
          //                                       Home.subCategoryList.addAll(data.categoryList[index]['subcategory']);
          //                                       Home.categoryImage=data.categoryList[index]['Icon'].toString();
          //                                       Home.categoryName=data.categoryList[index]['CategoryName'].toString();
                                
          //                                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SubCategoriesNew()));
          //                                       print("sub category "+Home.subCategoryList.length.toString() );
          //                                     }
                                             
          //                                   },
          //                                   child: Card(
          //                                     color: themColor,
          //                                     elevation: 5,
          //                                     shape: RoundedRectangleBorder(
          //                                       borderRadius: BorderRadius.circular(20.0),
          //                                     ),
          //                                     child: Column(
          //                                       mainAxisAlignment: MainAxisAlignment.center,
          //                                       children: [
          //                                         SizedBox(
          //                                           height: 30,
          //                                           // child: Image.asset("assets/images/rehabilation.png",width: 100,height: 60,)
          //                                           child: Hero(
          //                                             tag: "category",
          //                                             child: Image.network("http://101.53.150.64/2050Healthcare/public/category/"+data.categoryList[index]['Icon'],color: themAmberColor)
          //                                           ),
          //                                         ),
                                                  
          //                                         SizedBox(
          //                                          // height: 20,
          //                                           child: Padding(
          //                                             padding: const EdgeInsets.only(left: 8,right: 8,top: 2),
          //                                             //child: FittedBox(
          //                                               child: Text(category_name,style: TextStyle(color: Colors.white,fontFamily: 'WorkSans',fontWeight: FontWeight.w900),textAlign: TextAlign.center,)
          //                                             //),
          //                                             //child: FittedBox(child: Text(categoryList[index]['CategoryName'].toString(),style: TextStyle(color: Colors.black45,fontFamily: 'WorkSans',fontWeight: FontWeight.w600),)),
          //                                           ),
          //                                         )
                                                  
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ),
                                        
          //                             );
          //                           }
          //                         ),
          //                       ),

          //                     ]  
          //                   ),
          //                 ),


          //               ),
          //             ),


          //           ],
          //         ),
          //       ),
          //     ), 
          //   ],
            
          // ),
       // ),
    
        // floatingActionButton: DraggableFab(
        //   child: FloatingActionButton(
        //     onPressed: () async{
              
        //      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Whatsup()));

        //       var whatsapp ="+918988980202";
        //       var whatsappURl_android = "whatsapp://send?phone="+whatsapp;
        //       var whatappURL_ios ="https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
        //       if(Platform.isIOS){
        //         // for iOS phone only
        //         if( await canLaunch(whatappURL_ios)){
        //           await launch(whatappURL_ios, forceSafariVC: false);
        //         }else{
        //           ScaffoldMessenger.of(context).showSnackBar(
        //               SnackBar(content: new Text("whatsapp not installed ios")));
        //         }
        //       }else{
        //         // android , web
        //         if( await canLaunch(whatsappURl_android)){
        //           await launch(whatsappURl_android);
        //         }else{
        //           ScaffoldMessenger.of(context).showSnackBar(
        //               SnackBar(content: new Text("whatsapp not installed android")));
        //         }
        //       }
        //     },
        //     child:const  Icon(Icons.add),
        //   ),
        // ),
            ]
       
      ),
        )
      )
    );

    
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context)=>CupertinoAlertDialog(
        title: Column(
          children: [
            Text("Not Registered User"),
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
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginRegistration()));
              }
          ),
        ],
      )     
    );
    
  }

  // Internet Connection Start
  Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;
  void checkRealtimeConnection() async {
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
            message:
              "No Internet \n Please Check Internet Connection !!!",
          ),
        );
    
      }
      setState(() {});
    });
  }
  // Internet Connection end


  void getCredentials() async{

    SharedPreferences loginPrefs = await SharedPreferences.getInstance();

    setState(() {
      Home.userid=loginPrefs.getString("userid").toString();

     
     
    });

    print("User id ////////////////////////// ");

    print("User id ////////////////////////// "+ Home.userid.toString());
  }
}

Future<LocationData?> _getLocationData() async {
  Location location = new Location();
  LocationData _locationData;

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  _locationData = await location.getLocation();

  return _locationData;
}

Future<String> _getAddress(double? lat, double? lang) async {
  if (lat == null || lang == null) return "";
  GeoCode geoCode = GeoCode();
  Address address =
      await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
  return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
}