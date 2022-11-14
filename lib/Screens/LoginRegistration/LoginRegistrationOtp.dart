
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Model/LoginRegistrationModel/VallidOtpModel.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistration.dart';
import 'package:healthcare2050/Screens/NoInternetPage/NoInternetLoginRegistrationOtp.dart';
import 'package:healthcare2050/Screens/SplashScreen/SplashScreen.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';



class LoginRegistrationOtp extends StatelessWidget {
  const LoginRegistrationOtp({Key? key}) : super(key: key);

  

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
      home: LoginRegistrationOtpScreen(),
    );
  }
}

class LoginRegistrationOtpScreen extends StatefulWidget {
  const LoginRegistrationOtpScreen({Key? key}) : super(key: key);

  

  @override
  _LoginRegistrationOtpScreenState createState() => _LoginRegistrationOtpScreenState();
}

class _LoginRegistrationOtpScreenState extends State<LoginRegistrationOtpScreen> {

  final GlobalKey<FormState> _formkey =GlobalKey<FormState>(); 
    // global key for form.
  bool _autovalidate = false;

  bool _pinSuccess = false;
  bool _hideOTP = true;    
  final _formKey = GlobalKey<FormState>();
  String  ? otp;

 
  String  buttonText="Submit";
  
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
      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>const NoInternetLoginRegistrationOtp()));
    }
  }
  //// checking internet connectivity end
  
  //////////// Login Start///////////
  Future<VallidOtpModel> otpProcess() async {
    String validOtp_url= validOtpApi;
    final http.Response response = await http.post(
        Uri.parse(validOtp_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
         // 'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: {

          "Otp": otp,
          "MobileNumber": LoginRegistration.phoneNumber.toString()
          
        },
        // body: {
        //   'email': email,
        //   'password': password,
        // }
    );
     
    if (response.statusCode == 200) {

      

      print("otp Body "+ response.body);

      bool response_status=json.decode(response.body)['status'];
      var message =json.decode(response.body)['message'];

      if(response_status){

        SharedPreferences loginPrefs = await SharedPreferences.getInstance();
        loginPrefs.setString("email", json.decode(response.body)['userDetails']['Email'].toString());
        loginPrefs.setString("mobileno", json.decode(response.body)['userDetails']['MobileNumber'].toString());
        loginPrefs.setString("city", json.decode(response.body)['userDetails']['City'].toString());
        loginPrefs.setString("state", json.decode(response.body)['userDetails']['State'].toString());
        loginPrefs.setString("pincode", json.decode(response.body)['userDetails']['Pincode'].toString());
        loginPrefs.setString("address", json.decode(response.body)['userDetails']['Address'].toString());
        loginPrefs.setString("profileImage", "http://101.53.150.64/2050Healthcare/public/profileImage/${json.decode(response.body)['userDetails']['Image']}");

        Fluttertoast.showToast(
          msg: message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        );



      }

      if(response_status==false){

        ScaffoldMessenger.of(context).showSnackBar(
                              
        SnackBar(content: new Text("OTP Validation Failed  !!!"),backgroundColor: Colors.red,)
      );


      }

      return VallidOtpModel.fromJson(json.decode(response.body));
    } else {
       
     
      Fluttertoast.showToast(
        msg: "Please Check Mobile No",
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
  ////////////Login End///////////


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
    // TODO: implement initState
    super.initState();
    //checkInternet();
  // _checkInternetConnection();
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

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Widget _buildOtpTextField(){
      return OTPTextField(
        outlineBorderRadius: 5,
        obscureText: false,
        length: 6,
        width: width,
        fieldWidth: 40,
        style: const TextStyle(fontSize: 20,color: themColor),
        textFieldAlignment: MainAxisAlignment.spaceAround,
        fieldStyle: FieldStyle.box,
        otpFieldStyle: OtpFieldStyle(backgroundColor: Colors.white70,focusBorderColor: themGreenColor,disabledBorderColor: Colors.grey,enabledBorderColor: themColor,errorBorderColor: Colors.red),

       
        
        onChanged: (pin){
          setState(() {
            otp=pin;
            
          });

        },
        onCompleted: (pin) {
          setState(() {
            
            otp=pin;
            _pinSuccess = true;
          });
        },

         
      );
    }

    Widget _buildOtpSendButton(){
      return 

      Container( 
        height:50, //height of button
        width: width, //width of button
        child:ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: themColor, //background color of button
            side: BorderSide(width:3, color: themGreenColor), //border width and color
            elevation: 3, //elevation of button
            shape: RoundedRectangleBorder( //to set border radius to button
                borderRadius: BorderRadius.circular(10)
            ),
            padding: EdgeInsets.all(0) //content padding inside button
          ),
          onPressed: () async{ 
            
            

          //  _checkInternetConnection();

            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNavigationBarPage()));
            var response = await otpProcess();
            bool res = response.status;
            String mobileNo = response.appUserDetails.mobileNumber.toString();
            String userid = response.appUserDetails.userId.toString();
            LoginRegistration.phoneNumber=mobileNo.toString();

            print("otp userid ?????"+ userid.toString());
            print("resp .................................. "+res.toString());
            if(res){

              SharedPreferences loginPrefs = await SharedPreferences.getInstance();
              loginPrefs.setString("userid",userid);
              loginPrefs.setString("mobileno",mobileNo);
              loginPrefs.setBool("islogedin", res);

              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginRegistrationOtp()));
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNavigationBarPage()));
            }

              if (_formkey.currentState!.validate()) {
                //form is valid, proceed further
                setState(() {
                  buttonText="Please wait...";
                });
                try{

                  var response = await otpProcess();
                  bool res = response.status;
                  String mobileNo = response.appUserDetails.mobileNumber.toString();
                  String userid = response.appUserDetails.userId.toString();
                  LoginRegistration.phoneNumber=mobileNo.toString();

                 

                  print("resp .................................. "+res.toString());
                  if(res){

                    SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                    loginPrefs.setString("userid",userid);
                    loginPrefs.setString("mobileno",mobileNo);
                    loginPrefs.setBool("islogedin", res);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNavigationBarPage()));
                  }

                }

                catch(err){

                  print(err);
                  
                
                }

                _formkey.currentState!.save();


              
            }  

          
          }, 
          child: Text('$buttonText',style: TextStyle(color: Colors.white,fontSize: 20),) 
        )
      );

      // Material(
      //   elevation: 10,
      //   borderRadius: BorderRadius.circular(8.0),
      //   child: InkWell(
      //     onTap: () async{

      //       _checkInternetConnection();

      //       //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNavigationBarPage()));

      //       var response = await otpProcess();
      //       bool res = response.status;
      //       String mobileNo = response.appUserDetails.mobileNumber.toString();
      //       String userid = response.appUserDetails.userId.toString();
      //       LoginRegistration.phoneNumber=mobileNo.toString();

      //       print("resp .................................. "+res.toString());
      //       if(res){

      //         SharedPreferences loginPrefs = await SharedPreferences.getInstance();
      //         loginPrefs.setString("userid",userid);
      //         loginPrefs.setString("mobileno",mobileNo);
      //         loginPrefs.setBool("islogedin", res);
      //         //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginRegistrationOtp()));
      //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNavigationBarPage()));
      //       }

      //       if (_formkey.currentState!.validate()) {
      //         //form is valid, proceed further
      //         setState(() {
      //           message="Please wait...";
      //         });
      //         try{

      //           var response = await otpProcess();
      //           bool res = response.status;
      //           String mobileNo = response.appUserDetails.mobileNumber.toString();
      //           String userid = response.appUserDetails.userId.toString();
      //           LoginRegistration.phoneNumber=mobileNo.toString();

      //           print("resp .................................. "+res.toString());
      //           if(res){

      //             SharedPreferences loginPrefs = await SharedPreferences.getInstance();
      //             loginPrefs.setString("userid",userid);
      //             loginPrefs.setString("mobileno",mobileNo);
      //             loginPrefs.setBool("islogedin", res);
      //             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginRegistrationOtp()));
      //           }

      //         }

      //         catch(err){

      //           print(err);
                
              
      //         }

      //         _formkey.currentState!.save();


      //       }  
      //       print("do");
      //     },
      //     child: Container(
      //       padding: EdgeInsets.all(0.0),
      //       height: 50.0,//MediaQuery.of(context).size.width * .08,
      //       width: width,//MediaQuery.of(context).size.width * .3,
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(8.0),
      //         color: themColor
      //       ),
      //       child: Row(
      //         children: <Widget>[
      //           LayoutBuilder(builder: (context, constraints) {
      //             print(constraints);
      //             return Container(
      //               height: constraints.maxHeight,
      //               //width: constraints.maxHeight,
      //               width: width-150,
      //               decoration: BoxDecoration(
      //                 color: themColor,
      //                 borderRadius: BorderRadius.circular(8.0),
      //               ),
      //               //child: Icon( Icons.login,color: Colors.white,),
      //               child: Center(child: Text( 'Submit', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.white),)),
      //             );
      //           }),
      //           Expanded(
                  
      //             child: Container(
      //               color: themGreenColor,
      //               child: 
      //               message=="" ?
      //               Icon( Icons.star,color: Colors.white,) :
      //               Text( message, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.white),)
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // );     
      
      // SizedBox(
      //   height: 50,
      //   width: width,
      //   child: Padding(
      //     padding: const EdgeInsets.only(top: 10),
      //     child: ElevatedButton.icon(
      //       label: const FittedBox(
      //         child: Padding(
      //           padding: EdgeInsets.all(0.0),
      //           child: Text("Otp Submit",style: TextStyle(fontFamily: 'Ubuntu',fontSize: 20,fontWeight: FontWeight.w700,color: Colors.white),),
      //         ),
      //       ),
      //       icon: const Icon(Icons.arrow_forward),
      //       style: ElevatedButton.styleFrom(
      //         primary: themColor,
      //         onPrimary: Colors.white,
      //         shadowColor: Colors.white60,
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(12), // <-- Radius
      //         ),
      //         elevation: 10,
      //       ),
      //       //label: Text('Cancel', style: TextStyle(color: Colors.white),),
      //       onPressed:  () async{

      //         _checkInternetConnection();

      //       //  print("country code "+ Registration.phoneNumber.toString() );

      //         //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BottomNavigationBarPage()));
      //        // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>BottomNavigationBarPage()));

      //        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNavigationBarPage()));

      //         if (_formkey.currentState!.validate()) {
      //           //form is valid, proceed further

      //           try{

      //           }
          
      //           catch(err){

      //             print(err);
              
      //           }

      //           _formkey.currentState!.save();

      //         }  
      //       }  
            
      //     ),
      //   ),
      // );
    }

    
    

    return  WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Container(
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
          appBar: AppBar(
            backwardsCompatibility: false,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light
            ),
    
            elevation: 0,
            backgroundColor: themColor,
            leading:  Padding(
              padding: const EdgeInsets.only(left: 5),
              child: IconButton(
                icon: const Icon(Icons.arrow_back,color: Colors.white),
                onPressed: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
                  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> LoginRegistration()));
                },
              ),
            ),
            // leading:  Padding(
            //   padding: const EdgeInsets.only(left: 5),
            //   child: Container(
               
            //     decoration: BoxDecoration(
            //       border: Border.all(
            //         color: themColor,
            //       ),
            //       color: themColor,
            //       borderRadius: BorderRadius.all(Radius.circular(30))
            //     ),
                
            //     child: IconButton(
            //       icon: const Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 30,),
            //       onPressed: (){
            //         //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
            //         Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> LoginRegistration()));
            //       },
            //     ),
            //   ),
            // ),
            title: const Text("Phone Verification",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20,fontFamily: 'Ubuntu')),
          ),
          
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.10,0.10,0.10,0.0),
              child: SizedBox(
                width: width,
               // height: height*0.3,
                child: Column(
                  children: [

                    SizedBox(height: 10,),

                    Container(
                      width: width,
                      height: height*0.35,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: AssetImage("assets/images/otp.gif"),
                          fit: BoxFit.contain
                        )
                      ),
                    ),

                    SizedBox(height: 10,),
    
                    const Text("Enter OTP here...",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontSize: 15,fontFamily: 'Ubuntu')),
                    const SizedBox(
                      height: 5,
                    ),
    
                    Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      child: _buildOtpTextField(),
                    ),
    
                    const SizedBox(height: 10,),

                    // Padding(
                    //   padding: EdgeInsets.only(right: 20),
                    //   child: Container(
                    //     width: width,
                    //     height: 20,
                    //     alignment: Alignment.centerRight,
                    //     child: IconButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             _hideOTP = !_hideOTP;
                    //           });
                    //         },
                    //         icon: Icon(
                    //           _hideOTP
                    //           ? Icons.visibility_off
                    //           : Icons.visibility,
                    //           size: 25.0
                    //         )
                    //       ),
                    //   ),
                    // ),
                     
                    SizedBox(
                      height: height*0.099,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5,left: 5,right: 5),
                          child: _buildOtpSendButton()
                        ),
                      ),
                    ),
    
                    const SizedBox(
                      height: 5,
                    ),
    
                    const Text("Did not receive an otp ?",style: TextStyle(color: themRedColor,fontWeight: FontWeight.w200,fontSize: 20,fontFamily: 'Ubuntu')),
                   
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: SizedBox(
                        width: width,
                        //height: 20,
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Text("Resend",style: TextStyle(color: themColor,fontWeight: FontWeight.w700,fontSize: 20,fontFamily: 'Ubuntu')),
    
                        ),
                      ),
                    )
                  ],
                  
                )
              ),
            ),
          ),
          
        ),
      ),
    );
  }

}