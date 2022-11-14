import 'dart:async';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/InternetConnection/InternetConnection.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistration.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:new_version/new_version.dart';


class Splash extends StatelessWidget {
  
  static String  internetConnection="waiting...";
  static bool connected=false;
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
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  void startTimer() {
    Timer(Duration(seconds: 12), () {

      isLogedInChecking();
     
     // Navigator.(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Registration()));
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginRegistration()));
    //  chooseUser(); //It will redirect  after 3 seconds
    });
  }

  void isLogedInChecking() async {
    SharedPreferences loginPrefs = await SharedPreferences.getInstance();
    bool  loginStatus=loginPrefs.getBool("islogedin") ?? false;
    print("userid   >>>>>>>>>>>>>>>>>"+loginStatus.toString());
    
    if(loginStatus){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> BottomNavigationBarPage()));
    }

    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginRegistration()));
    }
    
  }

  
  //// checking  connectivity start
 // String internetConnection="waiting...";
  Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;
  
  void checkConnectivity() async {
    var connectionResult = await _connectivity.checkConnectivity();

    if (connectionResult == ConnectivityResult.mobile) {
      
      setState(() {
        Splash.internetConnection = "MobileData";
      });
     
     
    } else if (connectionResult == ConnectivityResult.wifi) {

      setState(() {
        Splash.internetConnection = "Wifi";
      });
      
    
    } else {

      setState(() {
         Splash.internetConnection = "Not Connected";
      });
     
  
    }
    setState(() {});
  }

  void checkRealtimeConnection() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile) {

        setState(() {
          Splash.internetConnection = "MobileData";
        });
        checkInternet();
        print(Splash.internetConnection);
      
        print("Connectvity "+Splash.internetConnection.toString());
        startTimer();
      } else if (event == ConnectivityResult.wifi) {

        setState(() {
          Splash.internetConnection = "Wifi";
        });
        checkInternet();
        print("Connectvity "+Splash.internetConnection.toString());
        startTimer();
      } else {

        setState(() {
          Splash.internetConnection = "Not Connected";
        });
         print("Connectvity "+Splash.internetConnection.toString());
        

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

  // checkInternet start
  void checkInternet() async{
    try{
      final result =await InternetAddress.lookup("google.com");
      if(result.isNotEmpty && result[0].rawAddress.isEmpty){

        setState(() {
          Splash.connected=true;
          //print("connection "+ connected.toString());
        });
          
        startTimer();
       
      }
    } on SocketException  catch (_) {

      setState(() {
        Splash.connected=false;
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
  // checkInternet end

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   // _checkVersion(); // modified by situ

    // CheckInternet().connected;
    // print("connection >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+ CheckInternet().connected.toString());

    // if(CheckInternet().connected==false){
    //   showTopSnackBar(
    //     context,
    //     CustomSnackBar.error(
    //        // backgroundColor: Colors.red,
    //       message: "No Internet \n Please Check Internet Connection !!!",
                
    //     ),
    //   );
    // }

    checkInternet();
    checkRealtimeConnection();

    

    // if(internetConnection=="Not Connected"){
    //   showTopSnackBar(
    //     context,
    //     CustomSnackBar.error(
    //        // backgroundColor: Colors.red,
    //       message: "No Internet \n Please Check Internet Connection !!!",
                
    //     ),
    //   );
    // }
    
   // startTimer();

   // isLogedInChecking();
  }

  

  void _checkVersion() async {
    final newVersion = NewVersion(
      androidId: "com.iigTechnology.healthcare2050",
    );
    final status = await newVersion.getVersionStatus();
    newVersion.showUpdateDialog(
      context: context,
     // versionStatus: status,
      dialogTitle: "UPDATE!!!",
      dismissButtonText: "Skip",
      dialogText: "Please update the app from " + "${status!.localVersion}" + " to " + "${status.storeVersion}",
      dismissAction: () {
        SystemNavigator.pop();
      },
      updateButtonText: "Lets update", versionStatus: status,
    );

    print("DEVICE : " + status.localVersion);
    print("STORE : " + status.storeVersion);
  }

  

  Widget build(BuildContext context) {

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;
    final margin = const EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 10,
        backgroundColor:  themColor,
        backwardsCompatibility: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light
        ),
      ),


      body: Container(
        width: width,
        height: height,
        color: themColor,
        child: Column(
          children: [
            new Expanded(
              flex: 2,
              child: new Container(
                width: width*0.6,
                height: height/2, // this will give you flexible width not fixed width
              // margin: margin, // variable
                color: themColor,// variable
                child: new Column(
                  
                  children: <Widget>[

                    new Expanded(
                     // flex: 2,
                      child: new Container(
                        alignment: Alignment.bottomCenter,
                          // height:animation.value, //value from animation controller
                          // width: animation.value, 

                        child: Card(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(150),
                          ),

                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: height*0.17,
                            width: width*0.35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50), 
                              color: Colors.transparent,
                                //set border radius to 50% of square height and width
                              image: DecorationImage(
                                image: AssetImage("assets/Logo/logo_gif.gif"),
                                fit: BoxFit.contain, //change image fill type
                              ),
                            ),
                          ),  
                          // child: Container(
                          //   width: width*0.3,
                          //   height: height*0.15,
                          //   decoration: BoxDecoration(
                          //     // The child of a round Card should be in round shape 
                          //     shape: BoxShape.circle, 
                          //     color: Colors.white,
                                
                          //   ),
                          //   child: Center(child: Image.asset("assets/Logo/logo_gif.gif",width: 90,height: 90,)),
                          // )
                        ),
                      ),
                    ),
                    // new Expanded(
                    //   flex: 1,
                      // new Container(
                      //   alignment: Alignment.topCenter,
                      //   child: Shimmer.fromColors(
                      //     baseColor: Colors.white,
                      //     highlightColor: Colors.white,
                      //     child: Text(
                      //       '2050 Health Care',
                      //       maxLines: 2,overflow: TextOverflow.ellipsis,
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //         fontSize: 20.0,
                      //         fontWeight:
                      //         FontWeight.bold,
                      //       ),
                      //     ),
                      //   ), //variable above
                      // ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                        child:TextLiquidFill(
                          text: 'Bridging the Gap',
                          waveColor: themAmberColor,
                          boxBackgroundColor: themColor,
                          textStyle: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                          boxHeight: height*0.15,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,bottom: 100),
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Agne',
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText('We are India’s largest Transitional Care facility looking after all your healthcare needs'),
                             // TyperAnimatedText('your healthcare needs'),
                              
                            ],
                            onTap: () {
                              print("Tap Event");
                            },
                          ),
                        ),
                      ),

                      

                      new Container(
                        alignment: Alignment.topCenter,
                        child: Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: Colors.white,
                          child: AnimatedTextKit(
                            
                            animatedTexts: [
                              WavyAnimatedText('IIG Technology',textStyle: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                ),
                              ),
                              WavyAnimatedText('2050 Health Care',textStyle: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                ),),
                            ],
                            isRepeatingAnimation: true,
                            onTap: () {
                              print("Tap Event");
                            },
                          ),
                          // child: Text(
                          //   '2050 Health Care',
                          //   maxLines: 2,overflow: TextOverflow.ellipsis,
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //     fontSize: 20.0,
                          //     fontWeight:
                          //     FontWeight.bold,
                          //   ),
                          // ),
                        ), //variable above
                      ),
                    // ),
                  ],
                ),
              ),
            ),

            // Spacer(),
            // new Expanded(
            //   flex: 5,
            //   child: new Container(
            //     alignment: Alignment.bottomLeft,
            //     width: width, // this will give you flexible width not fixed width
            //     //margin: margin, //variable
            //     color: themColor,

            //     child: Container(
            //       height: height*0.6,
            //       child: Image.asset("assets/images/Doctor_2050.png",height: height*0.6,)
            //     )
                
              
            //   ),
            // ),
          ],
        ),


        // decoration: new BoxDecoration(
        //   image: new DecorationImage(
        //     image: new AssetImage("assets/images/Splash_background.png"),
        //     fit: BoxFit.fill,
        //   ),
        // ),

        
          //child: Image.asset("assets/images/2050logo.png",width: 300,height: 300,)


        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [

            

        //     Card(
        //       elevation: 20,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(150),
        //       ),
        //       child: Container(
        //         width: width*0.3,
        //         height: height*0.15,
        //         decoration: BoxDecoration(
        //           // The child of a round Card should be in round shape 
        //             shape: BoxShape.circle, 
        //             color: Colors.white,
                    
        //         ),
        //         child: Center(child: Image.asset("assets/Logo/logo_gif.gif",width: 90,height: 90,)),
        //       )
        //     ),
            

        //     SizedBox(
        //       width: width,
        //       //height: height*0.1,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Shimmer.fromColors(
        //             baseColor: Colors.white,
        //             highlightColor: Colors.white,
        //             child: Text(
        //               '2050',
        //               textAlign: TextAlign.center,
        //               style: TextStyle(
        //                 fontSize: 30.0,
        //                 fontWeight:
        //                 FontWeight.bold,
        //               ),
        //             ),
        //           ),

        //           SizedBox(width: 10,),

        //           Shimmer.fromColors(
        //             baseColor: Colors.white,
        //             highlightColor: Colors.white,
        //             child: Text(
        //               'Health Care',
        //               textAlign: TextAlign.center,
        //               style: TextStyle(
        //                 fontSize: 30.0,
        //                 fontWeight:
        //                 FontWeight.bold,
        //               ),
        //             ),
        //           ),

                

        //         ]
                  
        //       ),
        //     )
        //   ]  
        // )
        

      ),
    );
  }

 
}

