
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistration.dart';

class NoInternetLoginRegistration extends StatelessWidget {
  const NoInternetLoginRegistration({Key? key}) : super(key: key);

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
      home: NoInternetScreen(),
    );
  }
}

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({ Key? key }) : super(key: key);

  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2),()=>Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>LoginRegistration())));
    //Timer(const Duration(seconds: 3),()=>Navigator.pop(context));
  }
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        gradient:  RadialGradient(
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
        appBar: AppBar(
         // backwardsCompatibility: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light
          ),

          elevation: 0,
          backgroundColor: Colors.transparent,
        //  title: Text("Register Here...",style: TextStyle(color: Colors.black45,fontWeight: FontWeight.w200,fontSize: 20,fontFamily: 'Ubuntu')),
        ),

        body: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            gradient:  RadialGradient(
              radius: 0.8,
              colors: [
                Colors.white,
               // Color(0xFFb6e5e5),
                Colors.white,
              
              ],
            )
          ),

          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
            // backwardsCompatibility: false,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark
              ),

              elevation: 0,
              backgroundColor: Colors.transparent,
            //  title: Text("Register Here...",style: TextStyle(color: Colors.black45,fontWeight: FontWeight.w200,fontSize: 20,fontFamily: 'Ubuntu')),
            ),

            body: Center(
              child: Container(
                width: width,
                height: height*0.5,
                child: Column(
                  children: [
                    Container(
                      width: width,
                      height: height*0.1,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/NoInternetPage/2050logo.png"),
                          fit: BoxFit.contain
                        )
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Container(
                      width: width,
                      height: height*0.3,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/NoInternetPage/NoInternet.png"),
                          fit: BoxFit.contain
                        )
                      ),
                    )
                  ],
                ),
              ),
            ),


          ),
        ),
      ),
      
    );
  }
}