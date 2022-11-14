import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Model/DoctotAppointmentModel/DoctorAppointmentModel.dart';
import 'package:healthcare2050/Providers/OnlineDoctorConsultProvider.dart';
import 'package:healthcare2050/Screens/BookDoctorPage/OnlineBookDoctorPage.dart';
import 'package:healthcare2050/Screens/Home/HomeNew.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistration.dart';
import 'package:healthcare2050/Screens/Payment/Razorpay/OnlineConsultRazorpay.dart';
import 'package:healthcare2050/Screens/SplashScreen/SplashScreen.dart';
import 'package:healthcare2050/Screens/VideoTelePhoneCall/Specialization/Specialization.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class OnlineConsultPreviewPage extends StatelessWidget {
  const OnlineConsultPreviewPage({ Key? key }) : super(key: key);

  static int ? bookscheduleid;

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
      home: PreviewPageScreen(),
      
    );
  }
}

class PreviewPageScreen extends StatefulWidget {
  const PreviewPageScreen({ Key? key }) : super(key: key);

  @override
  State<PreviewPageScreen> createState() => _PreviewPageScreenState();
}

class _PreviewPageScreenState extends State<PreviewPageScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  /////Oderid Api Start ///////////
  fetchOrderIdProcess() async {

    var response = await http.post(
      Uri.parse(oderIdApi.toString()),
      headers: <String,String> {

      },
      body: {
        "UserId" : Home.userid.toString()
      }
    );
    // print(response.body);
    if(response.statusCode == 200){

      
      var items = json.decode(response.body) ?? {};
      bool bookscheduleid_status=json.decode(response.body)['status'] ?? false;

      setState(() {
        OnlineConsultPreviewPage.bookscheduleid= json.decode(response.body)['OrderId'] ?? 0;
      });
     
      print('orderid body');
      print(items);
      
      if(bookscheduleid_status){
       
        goToRazorpayPymentProcess();
             
      }
      if (bookscheduleid_status==false) {
       // scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text(message.toString()))); 
       
        scaffoldKey.currentState!.showSnackBar(
          SnackBar(content:Text("Sorry Payment Issue !!!"),backgroundColor: Colors.red,)
        ); 
      }  
      
     

    }else{
     
     
    }
  }
  ///// Oderid Api End ///////////
  
  /////Oderid Api Start ///////////
  goToRazorpayPymentProcess() async {

    var response = await http.post(
      Uri.parse(goToRazorPayApi.toString()),
      headers: <String,String> {

      },
      body: {
        "userId" : Home.userid.toString(),
        "bookscheduleid" : OnlineConsultPreviewPage.bookscheduleid.toString(),
        "amount" : OnlineBookDoctorPage.price.toString(),
      }
    );
    // print(response.body);
    if(response.statusCode == 200){

      
      var items = json.decode(response.body) ?? {};
      bool orderid_status=json.decode(response.body)['status'] ?? false;
      String message=json.decode(response.body)['message'] ?? "";

      setState(() {
        Home.razorpay_OrderId= json.decode(response.body)['orderId'] ?? 0;
      });
     
     
      print('razorpay orderid body');
      print(items);

      
      
      if(orderid_status){

        showTopSnackBar(
          context,
          
          CustomSnackBar.success(
           // backgroundColor: Colors.red,
            message:
                "Thank to Choose Us !!!",
          ),
        );
      
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OnlineRazorpayPage()));
             
      }
      if (orderid_status==false) {
       // scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text(message.toString()))); 
       
        scaffoldKey.currentState!.showSnackBar(
          SnackBar(content:Text("Sorry Payment Issue !!!"),backgroundColor: Colors.red,)
        ); 
      }  
      
     

    }else{
     
     
    }
  }
  ///// Oderid ApiApi End ///////////
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCredentials();

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

    final data = Provider.of<OnlineDoctorConsultProvider>(context);

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Preview"),
        backgroundColor: themColor,
        backwardsCompatibility: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light
        ),

        leading:  Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Container(
            // height: 20,
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: themColor,
            //   ),
            //   color: themColor,
            //   borderRadius: BorderRadius.all(Radius.circular(40))
            // ),

            child: IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white),
              onPressed: (){
                //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>BottomNavigationBarPage()));


                Navigator.push(context, MaterialPageRoute(builder: (context)=>OnlineBookDoctorPage(text: '',)));
                
               
                // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> BottomNavigationBarPage()));
              },
            ),
          ),
        ),

        actions: [
          // Navigate to the Search Screen
          // IconButton(
          //   onPressed: () => Navigator.of(context)
          //       .push(MaterialPageRoute(builder: (_) => SearchDoctorList())),
          //   icon: Icon(Icons.search)
          // )
        ],

        // actions: [

        //   IconButton(
        //     onPressed: (){
        //       Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchDoctorList()));
        //     }, 
        //     icon: const Icon(Icons.search)
        //   ),
        //   IconButton(
        //     onPressed: (){
        //       context.read<DoctorListProvider>().intialvalues();
        //       context.read<DoctorListProvider>().fetchData;
        //     }, 
        //     icon: const Icon(Icons.refresh)
        //   )
        // ],
      ),

      body:  NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return false;
          },
        child: Container(
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: Column(
              children: [
          
                Container(
                 
                  height: height*0.7,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(color: themColor,
                              borderRadius: BorderRadius.circular(20),
                                boxShadow: shadowList,
                              ),
                              margin: EdgeInsets.only(top: height*0.15),
                            ),
                            Align(
                              child: Column(
                                children: [
              
                                  CircleAvatar(
                                    radius:90.0,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 80.0,
                                      backgroundImage:
                                        NetworkImage(Specialization.selectedDoctorImage.toString()),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
              
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10,right: 10),
                                      child: Container(
                                        width: width,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text(Specialization.selectedDoctorName.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,),
                                            Text(Specialization.selectedDoctorDesignation.toString(),maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),textAlign: TextAlign.center,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text("₹",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(/*decoration: TextDecoration.lineThrough,*/color: themAmberColor,fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.end,),
                                                Text(OnlineBookDoctorPage.price.toString()=="null" ? "0.0" : OnlineBookDoctorPage.price.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(/*decoration: TextDecoration.lineThrough,*/color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.end,),
                                              ],
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 10),
                                              child: Text("Patient Details",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(/*decoration: TextDecoration.lineThrough,*/color: themGreenColor,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                                            ),

                                            Row(
                                              //mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.person,color: Colors.white,),
                                                Text("Name: ",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(/*decoration: TextDecoration.lineThrough,*/color: themAmberColor,fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.end,),
                                                Text(OnlineBookDoctorPage.patientName.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(/*decoration: TextDecoration.lineThrough,*/color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),

                                              ],
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.person,color: Colors.white,),
                                                Text("Age: ",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(/*decoration: TextDecoration.lineThrough,*/color: themAmberColor,fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.end,),
                                                Text(OnlineBookDoctorPage.patientAge.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(/*decoration: TextDecoration.lineThrough,*/color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.end,),
                                              ],
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.phone_android,color: Colors.white,),
                                                Text("Contact: ",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(/*decoration: TextDecoration.lineThrough,*/color: themAmberColor,fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.end,),
                                                Text(OnlineBookDoctorPage.patientMobileNo.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(/*decoration: TextDecoration.lineThrough,*/color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.end,),
                                              ],
                                            ),

                                            //SlideAction(),

                                            SizedBox(height: height*0.1,),

                                            Container(
                                              width: width,
                                              height: height*0.08,
                                              child: ListView(
                                                children: <Widget>[
                                                  
                                                  // Builder(
                                                  //   builder: (context) {
                                                  //     return Padding(
                                                  //       padding: const EdgeInsets.all(8.0),
                                                  //       child: SlideAction(),
                                                  //     );
                                                  //   },
                                                  // ),

                                                  // Builder(
                                                  //   builder: (context) {
                                                  //     final GlobalKey<SlideActionState> _key = GlobalKey();
                                                  //     return Padding(
                                                  //       padding: const EdgeInsets.all(8.0),
                                                  //       child: SlideAction(
                                                  //         key: _key,
                                                  //         onSubmit: () {
                                                  //           Future.delayed(
                                                  //             Duration(seconds: 1),
                                                  //           // () => _key.currentState.reset(),
                                                  //           );
                                                  //         },
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // ),

                                                  // Builder(
                                                  //   builder: (context) {
                                                  //     final GlobalKey<SlideActionState> _key = GlobalKey();
                                                  //     return Padding(
                                                  //       padding: const EdgeInsets.all(8.0),
                                                  //       child: SlideAction(
                                                  //         key: _key,
                                                  //         onSubmit: () {
                                                  //           Future.delayed(
                                                  //             Duration(seconds: 1),
                                                  //           // () => _key.currentState.reset(),
                                                  //           );
                                                  //         },
                                                  //         innerColor: Colors.black,
                                                  //         outerColor: Colors.white,
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // ),

                                                  // Builder(
                                                  //   builder: (context) {
                                                  //     final GlobalKey<SlideActionState> _key = GlobalKey();
                                                  //     return Padding(
                                                  //       padding: const EdgeInsets.all(8.0),
                                                  //       child: SlideAction(
                                                  //         key: _key,
                                                  //         onSubmit: () {
                                                  //           Future.delayed(
                                                  //             Duration(seconds: 1),
                                                  //           //() => _key.currentState.reset(),
                                                  //           );
                                                  //         },
                                                  //         alignment: Alignment.centerRight,
                                                  //         child: Text(
                                                  //           'Unlock',
                                                  //           style: TextStyle(
                                                  //             color: Colors.white,
                                                  //           ),
                                                  //         ),
                                                  //         sliderButtonIcon: Icon(Icons.lock),
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // ),

                                                  // Builder(
                                                  //   builder: (context) {
                                                  //     final GlobalKey<SlideActionState> _key = GlobalKey();
                                                  //     return Padding(
                                                  //       padding: const EdgeInsets.all(8.0),
                                                  //       child: SlideAction(
                                                  //         key: _key,
                                                  //         onSubmit: () {
                                                  //           Future.delayed(
                                                  //             Duration(seconds: 1),
                                                  //           // () => _key.currentState.reset(),
                                                  //           );
                                                  //         },
                                                  //         height: 100,
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // ),
                                                  // Builder(
                                                  //   builder: (context) {
                                                  //     final GlobalKey<SlideActionState> _key = GlobalKey();
                                                  //     return Padding(
                                                  //       padding: const EdgeInsets.all(8.0),
                                                  //       child: SlideAction(
                                                  //         key: _key,
                                                  //         onSubmit: () {
                                                  //           Future.delayed(
                                                  //             Duration(seconds: 1),
                                                  //           //  () => _key.currentState.reset(),
                                                  //           );
                                                  //         },
                                                  //         sliderButtonIconSize: 48,
                                                  //         sliderButtonYOffset: -20,
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // ),
                                                  // Builder(
                                                  //   builder: (context) {
                                                  //     final GlobalKey<SlideActionState> _key = GlobalKey();
                                                  //     return Padding(
                                                  //       padding: const EdgeInsets.all(8.0),
                                                  //       child: SlideAction(
                                                  //         key: _key,
                                                  //         onSubmit: () {
                                                  //           Future.delayed(
                                                  //             Duration(seconds: 1),
                                                  //           // () => _key.currentState.reset(),
                                                  //           );
                                                  //         },
                                                  //         elevation: 24,
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // ),
                                                  // Builder(
                                                  //   builder: (context) {
                                                  //     final GlobalKey<SlideActionState> _key = GlobalKey();
                                                  //     return Padding(
                                                  //       padding: const EdgeInsets.all(8.0),
                                                  //       child: SlideAction(
                                                  //         key: _key,
                                                  //         onSubmit: () {
                                                  //           Future.delayed(
                                                  //             Duration(seconds: 1),
                                                  //             //() => _key.currentState.reset(),
                                                  //           );
                                                  //         },
                                                  //         borderRadius: 16,
                                                  //         animationDuration: Duration(seconds: 1),
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // ),
                                                  // Builder(
                                                  //   builder: (context) {
                                                  //     final GlobalKey<SlideActionState> _key = GlobalKey();
                                                  //     return Padding(
                                                  //       padding: const EdgeInsets.all(8.0),
                                                  //       child: SlideAction(
                                                  //         key: _key,
                                                  //         onSubmit: () {
                                                  //           Future.delayed(
                                                  //             Duration(seconds: 1),
                                                  //           // () => _key.currentState.reset(),
                                                  //           );
                                                  //         },
                                                  //         reversed: true,
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // ),
                                                  SizedBox(
                                                    height: height*0.07,
                                                    child: Builder(
                                                      builder: (context) {
                                                        final GlobalKey<SlideActionState> _key = GlobalKey();
                                                        return Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: SlideAction(
                                                            innerColor: themColor,
                                                            outerColor: Colors.white,
                                                            text: "Slide To Payment",
                                                            sliderButtonIconSize: 20,
                                                            sliderButtonIconPadding: 10,
                                                            sliderButtonIcon: Icon(Icons.arrow_forward,color: themAmberColor,),
                                                            key: _key,
                                                            onSubmit: () {

                                                              print("good job");

                                                              print("user "+Home.userid.toString());

                                                              fetchOrderIdProcess();



                                                              Future.delayed(
                                                                Duration(seconds: 1),
                                                              //  () => _key.currentState.reset(),
                                                              );


                                                            },
                                                            submittedIcon: Icon(
                                                              Icons.done_all,
                                                              color: Colors.green,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                            //       Builder(
                                            //         builder: (context) {
                                            //           final GlobalKey<SlideActionState> _key = GlobalKey();
                                            //           return Padding(
                                            //             padding: const EdgeInsets.all(8.0),
                                            //             child: SlideAction(
                                            //               key: _key,
                                            //               onSubmit: () {
                                            //                 Future.delayed(
                                            //                   Duration(seconds: 1),
                                            //                 // () => _key.currentState.reset(),
                                            //                 );
                                            //               },
                                            //             ),
                                            //           );
                                            //         },
                                            //       ),
                                            //       Builder(
                                            //         builder: (context) {
                                            //           return Padding(
                                            //             padding: const EdgeInsets.all(8.0),
                                            //             child: SlideAction(
                                            //               sliderRotate: false,
                                            //             ),
                                            //           );
                                            //         },
                                            //       ),
                                                 ],
                                               ),
                                             ),


                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
              
              
                                  // Hero(
                                  //   tag:1,child: Image.asset("assets/images/Doctor_2050.png",height: 200,)
                                  // ),
                                  
              
                                ],
                              
                              ),
                            )
              
                          ],
                        ),
                      ),
                      // Expanded(
                      //   child: Container(
                      //     margin: EdgeInsets.only(top: 70,bottom: 20),
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
              
                      //       boxShadow: shadowList,
                      //       borderRadius: BorderRadius.only(
                      //         topRight: Radius.circular(20),
                      //         bottomRight: Radius.circular(20)
                      //       )
                      //     ),
              
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(left: 5),
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Text("Having Health Issues ?",style: TextStyle(color: Colors.black54,fontFamily: 'WorkSans',fontWeight: FontWeight.w900,fontSize: 20),),
                      //           Text("Find a doctor who will take the best care of your health...",style: TextStyle(color: Colors.black45,fontFamily: 'WorkSans',fontWeight: FontWeight.w600),),
              
                      //         ],
                              
                      //       ),
                      //     ),
              
                      //   )
                      // ) 
              
                    ],
                  ),
              
                ),
          
                SizedBox(
                  height: 20,
                ),
          
              ],
            ),
          )
          
                     
        ),
      ),


      
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginRegistration()));
              }
          ),
        ],
      )     
    );
  }


  void getCredentials() async{

    SharedPreferences loginPrefs = await SharedPreferences.getInstance();

    setState(() {
      Home.mobileNo=loginPrefs.getString("mobileno").toString();
      Home.userid=loginPrefs.getString("userid").toString();
    });


    print("Home.userid "+Home.userid.toString());
  

  }
}


Future<DoctorConsultModel> postDataDoctorAppointment(BuildContext context, String doctorId,String userId,String specializationId,String patientName,String patientAge,String mobileNumber,String scheduleDate,String slotId) async {
  //var dataInput = {"title": title, "userId": userId};

  // print("remarks "+ remarks);
  // print("loginId "+loginId);
  // print("CallingDataId "+callingDataId);
  // print("CallAgentId "+callAgentId);
  // print("ChildName "+childName);
  // print("StudyClass "+studyClass);
  // print("ShareFile "+shareFile);
  // print("AgreeToVisit "+agreeToVisit);
  // print("DateOfVisitPlanned "+dateOfVisitPlanned);
  // print("FollowUpDate "+followUpDate);
  // print("CallDoneOnFollowupDat "+callDoneOnFollowupDate);
  // print("CallStatus "+callStatus);
  // print("UpdatedBy "+updatedBy);
  // print("ContactDate "+contactDate);

  final response = await http.post(
      Uri.parse(DoctorAppointmentApi.toString()),
      // headers: {"Content-type": "application/x-www-form-urlencoded"},
      // encoding: convert.Encoding.getByName("utf-8"),

      headers: <String, String>{
          // 'Accept': 'application/json',
         // 'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: {
          "DoctorId": doctorId,
          "UserId" : userId,
          "SpecializationId": specializationId,
          "PatientName": patientName,
          "PatientAge": patientAge,
          "MobileNumber": mobileNumber,
          "ScheduleDate": scheduleDate,
          "SlotId ": slotId,
          "ConsultationType": Specialization.consultType.toString(),
        },
     
    );
  if (response.statusCode == 200) {

    print(response.statusCode);
    print(response.body);

    

    // print("response :"+ json.decode(response.body)['success']);

    // CallStatusUpdatePage.message=json.decode(response.body)['success'];
    // var successMessage = json.decode(response.body)['success'].toString();

    //print("message "+successMessage);

    SharedPreferences loginPrefs = await SharedPreferences.getInstance();
   // loginPrefs.setString("msg", successMessage);

    Fluttertoast.showToast(
      msg: "Sucess",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
    );
    
  //  Get.to(HomeTable());
    return DoctorConsultModel.fromJson(json.decode(response.body));
  }else{
    throw Exception('Something went wrong');
  }
}