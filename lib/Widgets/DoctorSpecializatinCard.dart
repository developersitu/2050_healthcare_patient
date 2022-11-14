import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare2050/Screens/Doctors/DoctorListBasedOnSpecialization.dart';
import 'package:healthcare2050/Screens/Doctors/DoctorScheduleFromDoctorList.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistration.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DoctorSpecializatinCard extends StatelessWidget {
  const DoctorSpecializatinCard({ Key? key , required this.map}) : super(key: key);

  final Map<String, dynamic> map;

  // Determine whether the red box is shown or not
  final  bool _isShown = true;

  static String ? doctorSpecializationIcon,doctorSpecializationId,doctorSpecializationName;
  @override
  Widget build(BuildContext context) {
   
    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

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
      
      });
    }
    //// checking  connectivity end


    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () async{
          
          SharedPreferences loginPrefs = await SharedPreferences.getInstance();
          bool  loginStatus=loginPrefs.getBool("islogedin") ?? false;
          print("userid   >>>>>>>>>>>>>>>>>"+loginStatus.toString());
          
          if(loginStatus){

            DoctorSpecializatinCard.doctorSpecializationId ='${map['SpecializationId']}';
            DoctorSpecializatinCard.doctorSpecializationName ='${map['SepcializationName']}';
            DoctorSpecializatinCard.doctorSpecializationIcon ='${map['Icon']}';
            
            DoctorSpecializatinCard.doctorSpecializationIcon='http://101.53.150.64/2050Healthcare/public/speciality/'+map['Icon'];
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DoctorListBasedOnSpecializationPage()));
            
          }

          else{

            _showDialog(context); 
          
          }

        },
        child: Container(
          padding: const EdgeInsets.only(left: 5,right: 5),
          color: Colors.white,
          width: double.infinity,
         
          child: Stack(
            children: <Widget>[
      
              // Padding(
              //   padding: const EdgeInsets.only(left: 0),
              //  // child: Positioned(
              //     child: Container(
              //       decoration: BoxDecoration(
              //         color: themAmberColor,
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       constraints: const BoxConstraints(maxHeight: 100,minHeight: 48),
              //     )
              //  // ),
              // ),
      
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 50),
               // child: Positioned(
                  child: Container(
                    height: height*0.1,
                    decoration: BoxDecoration(
                      color: themAmberColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30)),
                    ),
                   // constraints: const BoxConstraints(maxHeight: 70,minHeight: 60),
                  )
               // ),
              ),
             
      
              Padding(
                padding: EdgeInsets.only(top: 0,),
                child: Row(
                  children: [
                    map['Icon'].toString()=="null" ? 
                    Container(
                      width: width*0.2,height: height*0.1,
                      color: Colors.white,
                      child: Image.asset("assets/images/no_doctor.png"),
                    ) :
                    map['Icon'].toString()==" " ? 
                    Container(
                      width: width*0.2,height: height*0.1,
                      color: Colors.white,
                      child: Image.asset("assets/images/no_doctor.png"),
                    ) :
                    Card(
                      child: Container(
                        height: height*0.1,
                        width: width*0.2,
                        child: Center(
                          child: Image.network('http://101.53.150.64/2050Healthcare/public/speciality/'+map['Icon'],width: width*0.12,height: height*0.08,color: themColor,),
                        ),
                      ),
                      elevation: 8,
                      shadowColor: themAmberColor,
                      margin: EdgeInsets.only(top: 10),
                      shape: CircleBorder(side: BorderSide(width: 4, color: themAmberColor),
                      ),
                    ) 
                    
                  ],
                )
              ),
      
              Padding(
                padding: const EdgeInsets.only(top: 0,left: 100),
                child: Container(
                 // color: Colors.red,
                  height: height*0.1,
                  width: width*0.8,
      
                  decoration: BoxDecoration(
                    color: themColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30)),
                  ),
                  //padding: const EdgeInsets.only(top: 0,left: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
                    children: [
      
                      // Align(
                      //   alignment: Alignment.center,
                        // Expanded(
                        //   child: Container(
                        //    // width: width*0.7,
                        //     child: Center(
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          color: Colors.red,
                          width: width*0.5,
                          child: Text(
                                            
                            map['SepcializationName'].toString()=="null"  ? "Sepcialization Not Available !!" :
                            map['SepcializationName'].toString()==" "  ? "Sepcialization Not Available !!" :
                            
                            '${map['SepcializationName'].split('-').join(' ')}',
                              maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.left ,
                            style: const TextStyle(
                              fontFamily: "WorkSans",
                              fontWeight: FontWeight.w800,
                              fontSize: 15,color: themAmberColor
                            ),
                          ),
                        ),
                      ),
                        //      ),
                        //    ),
                        // ),
                      //),
      
                     
                     
      
                      InkWell(
                       
      
                        child: Card(
                          child: Container(
                            height:50,
                            width: 50,
                            child: Center(
                              child: Icon(Icons.arrow_forward,color: themBlueColor,),
                              
                            ),
                          ),
                          elevation: 8,
                          shadowColor: themBlueColor,
                          margin: EdgeInsets.all(20),
                          shape: CircleBorder(side: BorderSide(width: 2, color: themBlueColor),
                          ),
                        )
      
      
                        // child: Container(
                        //   width: width*0.1,
                        //   color: Colors.transparent,
                        //   child: const Align(
                        //     alignment: Alignment.centerRight,
                        //     child: Icon(Icons.arrow_forward,size: 30,color: Colors.white,),
                        //   ),
                        // ),
                      )
                     
                    ],
                  )
                ),
              ),
      
            ],
          ),
        ),
      ),

    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (context)=>CupertinoAlertDialog(
        title: Column(
          children: [
            Text("Not Registered User"),
            Icon(
              Icons.person,
              color: Colors.red,
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

  
}