import 'dart:async';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare2050/Screens/Doctors/DoctorScheduleFromDoctorList.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistration.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DoctorSpecializationListCard extends StatelessWidget {
  const DoctorSpecializationListCard({ Key? key , required this.map}) : super(key: key);

  final Map<String, dynamic> map;

  // Determine whether the red box is shown or not
  final  bool _isShown = true;

  static String ? doctorImage,doctorName,doctorDesignation,doctorId;

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
      child: Container(
        padding: const EdgeInsets.only(left: 5,right: 5),
        color: Colors.white,
        width: double.infinity,
       
        child: Stack(
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(left: 30),
             // child: Positioned(
                child: Container(
                  decoration: BoxDecoration(
                    color: themColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  constraints: const BoxConstraints(maxHeight: 180,minHeight: 150),
                )
             // ),
            ),
           

            Padding(
              padding: EdgeInsets.only(top: 25,),
              child: Row(
                children: [
                  map['Image'].toString()=="null" ? 
                  Container(
                    width: width*0.3,height: height*0.15,
                    color: Colors.white,
                    child: Image.asset("assets/images/no_doctor.png"),
                  ) :
                  map['Image'].toString()==" " ? 
                  Container(
                    width: width*0.3,height: height*0.15,
                    color: Colors.white,
                    child: Image.asset("assets/images/no_doctor.png"),
                  ) :
                  Image.network('http://101.53.150.64/2050Healthcare/public/doctor/'+map['Image'],width: width*0.3,height: height*0.15,),
                ],
              )
            ),

            Padding(
              padding: const EdgeInsets.only(top: 25,left: 160),
              child: Column(
                children: [

                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(

                      map['FullName'].toString()=="null"  ? "FullName Not Available !!" :
                      map['FullName'].toString()==" "  ? "FullName Not Available !!" :
                      
                      '${map['FullName']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,color: Colors.white
                      ),
                    ),
                  ),

                  const SizedBox(height: 5,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(

                      map['Education'].toString()=="null"  ? "Education Not Available !!" :
                      map['Education'].toString()==" "  ? "Education Not Available !!" :
                      
                      '${map['Education']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,color: Colors.white
                      ),
                    ),
                  ),
                 

                  const SizedBox(height: 5,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(

                      map['Designation'].toString()=="null"  ? "Designation Not Available !!" :
                      map['Designation'].toString()==" "  ? "Designation Not Available !!" :
                      
                      '${map['Designation']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,color: Colors.white
                      ),
                    ),
                  ),
                 

                  const SizedBox(height: 5,),
                  InkWell(
                    onTap: () async{

                      SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                      bool  loginStatus=loginPrefs.getBool("islogedin") ?? false;
                      print("userid   >>>>>>>>>>>>>>>>>"+loginStatus.toString());
                      
                      if(loginStatus){

                        DoctorSpecializationListCard.doctorId='${map['Id']}';
                        DoctorSpecializationListCard.doctorName='${map['FullName']}';
                        DoctorSpecializationListCard.doctorDesignation='${map['Designation']}';
                        DoctorSpecializationListCard.doctorImage='http://101.53.150.64/2050Healthcare/public/doctor/'+map['Image'];
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DoctorScheduleFromDoctorList()));
                        
                      }

                      else{

                        _showDialog(context); 
                      
                      }
                     // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>IndexPage()));
                      
                     

                     // 



                     
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(Icons.video_call_sharp,size: 30,color: themBlueColor,),
                      ),
                    ),
                  )
                 
                ],
              )
            ),

          ],
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