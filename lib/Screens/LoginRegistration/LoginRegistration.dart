import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Model/LoginRegistrationModel/EntryMobileNoModel.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistrationAutoFillOtp.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistrationOtp.dart';
import 'package:healthcare2050/Screens/NoInternetPage/NoInternetLoginRegistration.dart';
import 'package:healthcare2050/Screens/SplashScreen/SplashScreen.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';


class LoginRegistration extends StatelessWidget {
  
  static String ? phoneNumber;
 

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
      home: const LoginRegistrationScreen(),
    );
  }
}

class LoginRegistrationScreen extends StatefulWidget {
  const LoginRegistrationScreen({ Key? key }) : super(key: key);

  @override
  _LoginRegistrationScreenState createState() => _LoginRegistrationScreenState();
}

class _LoginRegistrationScreenState extends State<LoginRegistrationScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formkey =GlobalKey<FormState>(); 
    // global key for form.
  bool _autovalidate = false;

  late String _name,_phoneNumber;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  // String initialCountry = 'IN';
  // PhoneNumber number = PhoneNumber(isoCode: 'IN');

  String buttonText="Submit";

  String ? internationalNumber;


  //// checking internet connectivity start
  bool _isConnected=false;

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
    }
  }
  //// checking internet connectivity end

  
  //////////// Login Start///////////
  Future<EntryMobileNoModel> entryMobileNoProcess() async {
    String entryMobileNo_url= entryMobileNoApi;
    final http.Response response = await http.post(
        Uri.parse(entryMobileNo_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
         // 'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: {
          "MobileNumber": internationalNumber,
          
        },
        // body: {
        //   'email': email,
        //   'password': password,
        // }
    );
     
    if (response.statusCode == 200) {

      print("mobile Body "+ response.body);
      var mess=json.decode(response.body)['message'];
      print("message Body "+ mess.toString());

      return EntryMobileNoModel.fromJson(json.decode(response.body));
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
  String internetConnection="waiting...";
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
        
        
      } else if (event == ConnectivityResult.wifi) {

        setState(() {
          Splash.internetConnection = "Wifi";
        });
        
       
      } else {

        setState(() {
          Splash.internetConnection = "Not Connected";
        });
       

        showTopSnackBar(
          context,
          
          CustomSnackBar.success(
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
    
    super.initState();

    // if(Splash.connected==false){
    //   showTopSnackBar(
    //     context,
    //     CustomSnackBar.error(
    //        // backgroundColor: Colors.red,
    //       message: "No Internet \n Please Check Internet Connection !!!",
                
    //     ),
    //   );
    // }
    //checkInternet();
   // _checkInternetConnection();
     checkRealtimeConnection();
    // checkRealtimeConnection();
    // if(Splash.internetConnection=="Not Connected"){
    //   showTopSnackBar(
    //     context,
    //     CustomSnackBar.error(
    //        // backgroundColor: Colors.red,
    //       message: "No Internet \n Please Check Internet Connection !!!",
                
    //     ),
    //   );
    //  }

    

    _nameController=TextEditingController();
    _phoneController=TextEditingController();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _nameController.dispose();
    _phoneController.dispose();
  }

   
  @override
  Widget build(BuildContext context) {

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    Widget _buildName(){
      return Card(
        elevation: 10,
        child: TextFormField(
          controller: _nameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            //contentPadding: const EdgeInsets.only(left: 10),
            hintText: "Name",
            hintStyle: const TextStyle(fontSize: 18),
            labelText: "Name",
            border:  InputBorder.none,
            contentPadding: new EdgeInsets.symmetric(vertical: 2.0, horizontal: 1.0),
           // border: InputBorder.none,
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(0)
            // )
      
           // enabledBorder: myinputborder(),
           // focusedBorder: myfocusborder(),
              
          ),
      
          validator: (String ? value){
            if(value!.isEmpty){
              return 'Name is required!';
            }
            return null;
          },
          
          onSaved: (String ? value) {
            _name = value!;
          },
         
            
        ),
      );
    }

    Widget _buildInternationalPhoneNumber(){
      return  Card(
        elevation: 10,

        child: IntlPhoneField(

          // validator: (String ? value){
          //   if(value!.isEmpty){
          //     return 'Phone No. is required!';
          //   }
          //   return null;
          // },
          controller: _phoneController ,
          
          decoration: InputDecoration( //decoration for Input Field
            hintText: "phone",
            // contentPadding: EdgeInsetsDirectional.only(top: 0.0, bottom: 0.0, start: 5.0, end: 5.0),
            contentPadding: new EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
            fillColor: Colors.white70,
            filled: true,
            // prefixIcon: Icon(Icons.mobile_friendly),
            
            
            // labelText: 'Phone Number',
            //enabledBorder: myinputborder(),
            // focusedBorder: myfocusborder(),
            // border: const OutlineInputBorder(
            //   borderSide: BorderSide(),
            // ),
            border: InputBorder.none
          ),
          style: TextStyle(color: themColor, fontSize: 20.0),  //<-- weak solution
          initialCountryCode: 'IN', //default contry code, NP for Nepal
          onChanged: (phone) {
            //when phone number country code is changed
            print(phone.completeNumber); //get complete number
            print(phone.countryCode); // get country code only
            print(phone.number); // only phone number
                          
            setState(() {
              LoginRegistration.phoneNumber=phone.completeNumber.toString();
            });
          },
        
        ),
      ) ;
    }

    // Widget _buildInternationalPhoneNo(){
    //   return InternationalPhoneNumberInput(
    //     onInputChanged: (PhoneNumber number) {
    //       print(number.phoneNumber);
    //     },
    //     onInputValidated: (bool value) {
    //       print(value);
    //     },
    //     selectorConfig: SelectorConfig(
    //       selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
    //     ),
    //     ignoreBlank: false,
    //     autoValidateMode: AutovalidateMode.disabled,
    //     selectorTextStyle: TextStyle(color: Colors.black),
    //     initialValue: number,
    //     textFieldController: _phoneController,
    //     formatInput: false,
    //     keyboardType:
    //     TextInputType.numberWithOptions(signed: true, decimal: true),
    //     inputBorder: OutlineInputBorder(),
    //     onSaved: (PhoneNumber number) {
    //       print('On Saved: $number');
    //     },
    //   );
    // }

    Widget _buildContactNumber(){
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [

            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ]
        ),
      
        child: 
        Padding(
          padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
          child: 
          TextFormField(
            controller: _phoneController,
            maxLength: 10,
            keyboardType: TextInputType.number,
           // maxLines: 10,
            decoration: InputDecoration(
              labelText: "Phone No.",
              labelStyle: TextStyle(
	              color: Colors.black45,
              ),
              helperText: "Please Enter Phone No. To Get Otp",
              prefix: Text("+91 ",style: TextStyle(color: Colors.black87,fontSize: 18),),
              suffix: Image.asset("assets/Logo/india.jpg",width: 20,height: 20,),
              // prefixIcon: Icon(
              //   Icons.account_circle,
              //   color: Colors.black45,
              // ),
              // suffixIcon: Icon(
              //   Icons.account_box,
              //   color: Colors.black45,
              // ),

              
        
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 3,
                  color: themColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color:Colors.green,
                  width: 3
                ),
              ),
              hintText: "Enter Phone No.", 
              hintStyle: TextStyle(color: themColor), 
            ),
            validator: (String ? value){
              if(value!.isEmpty){
                return 'Phone No. is required!';
              }
              return null;
            },
          )
          
          // TextFormField(
          //   maxLength: 10,
          //   maxLengthEnforced: true,
          //   controller: _phoneController,
          //   keyboardType: TextInputType.number,
          //   decoration: InputDecoration(
              
          //     contentPadding: EdgeInsets.only(left: 0),
          //     hintText: "Enter Phone Number",
          //     hintStyle: TextStyle(fontSize: 12),
          //     prefix: Text("+91 ",style: TextStyle(color: Colors.black87,fontSize: 18),),
          //     suffix: Image.asset("assets/Logo/india.jpg",width: 20,height: 20,),
          //     // prefix: Row(
          //     //   children: [
          //     //     Text("+91",style: TextStyle(color: Colors.black87),),
          //     //     Image.asset("assets/Logo/india.jpg",width: 20,height: 20,)

          //     //   ],
             
          //     // ),
          //    // labelText: "Contact Number.",
              
          //    // border: InputBorder.none,
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(0)
          //     )
             
          //   ),

          //   validator: (String ? value){
          //     if(value!.isEmpty){
          //       return 'Mobile Number is required!';
          //     }

          //     if(value.length!=10){
          //       return 'Mobile Number is less than 10';

          //     }
          //     return null;
          //   },
            
          //   // onSaved: (String ? value) {
          //   //   _contactNumber = value!;
          //   // },
            
                
                  
          // ),
        )
          
      );
    }

    Widget _buildOtpGetButton(){
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
            
            //checkRealtimeConnection();
            
            // if(_isConnected== false){

            // }

            print("checking connection "+ internetConnection.toString());
          //  if(_isConnected==true)
               
          //   {

            if(Splash.internetConnection=="Not Connected"){
              showTopSnackBar(
                context,
                CustomSnackBar.error(
                // backgroundColor: Colors.red,
                  message: "No Internet \n Please Check Internet Connection !!!",
                ),
              );
            }

            if(Splash.internetConnection!="Not Connected"){
              if(_formkey.currentState!.validate()){
                print("validate...");

                if(internationalNumber==null){
                  scaffoldKey.currentState!.showSnackBar(
                    SnackBar(content:Text("Mobile No. is required"),backgroundColor: Colors.red,)
                  ); 
                }

            

                else{

                  setState(() {
                    buttonText="Please wait..";
                  });

                  try{

                    var response =await entryMobileNoProcess();
                    bool res=response.status;
                    String mobileNo=response.userDetails.mobileNumber;
                    LoginRegistration.phoneNumber=mobileNo.toString();
                    if(res){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginRegistrationOtp()));
                      
                    }

                    if(res==false){
                      setState(() {
                        buttonText="Retry !!";
                      });
                    }

                  }

                  catch(err){

                    print(err);
                  
                  }

                }
              
                _formkey.currentState!.validate();
              }
            }  


           // }

            // if (_formkey.currentState!.validate()) {
            //   //form is valid, proceed further

            //   setState(() {
            //     buttonText="Please wait..";
            //   });

            //   try{

            //     var response =await entryMobileNoProcess();
            //     bool res=response.status;
            //     String mobileNo=response.userDetails.mobileNumber;
            //     LoginRegistration.phoneNumber=mobileNo.toString();
            //     if(res){
            //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginRegistrationOtp()));
            //     }

            //   }

            //   catch(err){

            //     print(err);
              
            //   }

            //   _formkey.currentState!.save();

            // }  
            print("do");

              //code to execute when this button is pressed.
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

            

      //       //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginRegistrationOtp()));

      //       if (_formkey.currentState!.validate()) {
      //         //form is valid, proceed further

      //         setState(() {
      //           message="Please wait..";
      //         });

      //         try{

      //           var response =await entryMobileNoProcess();
      //           bool res=response.status;
      //           String mobileNo=response.userDetails.mobileNumber;
      //           LoginRegistration.phoneNumber=mobileNo.toString();
      //           if(res){
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
      //       padding: EdgeInsets.only(left: 10,right: 10),
      //       height: 50.0,//MediaQuery.of(context).size.width * .08,
      //       width: width,//MediaQuery.of(context).size.width * .3,
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(8.0),
      //         color: themColor
      //       ),
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Row(
      //           children: <Widget>[
      //             LayoutBuilder(builder: (context, constraints) {
      //               print(constraints);
      //               return Container(
      //                 height: constraints.maxHeight,
      //                // width: constraints.maxHeight,
      //                 width: width-150,
      //                // width: width,
      //                 decoration: BoxDecoration(
      //                   color: Colors.white,
      //                   borderRadius: BorderRadius.circular(8.0),
      //                 ),
      //                 //child: Icon( Icons.login,color: Colors.white,),
      //                 child: Center(child: Text( 'Submit', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: themColor),)),
      //               );
      //             }),

      //             message=="" ? Text("") :
      //             Expanded(
                    
      //               child: Container(
      //                 color: themGreenColor,
      //                 child: 
      //                 //message=="" ?
      //                 //Icon( Icons.login,color: Colors.white,) :
      //                 Text( message, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.white),)
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // );     
      
      // SizedBox(
      //   height: 50,
      //   width: width,
      //   child: Padding(
      //     padding: const EdgeInsets.only(top: 10),
      //     child: ElevatedButton(
      //       label: const FittedBox(
      //         child: Padding(
      //           padding: EdgeInsets.all(0.0),
      //           child:  Text("Submit",style: TextStyle(fontFamily: 'Ubuntu',fontSize: 20,fontWeight: FontWeight.w700,color: Colors.white),),
      //         ),
      //       ),
      //      // icon: const Icon(Icons.arrow_forward),
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

      //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginRegistrationOtp()));

      //         if (_formkey.currentState!.validate()) {
      //           //form is valid, proceed further

      //           try{

                    

                  
  
      //           }
          
      //           catch(err){

      //            print(err);
                
              
      //           }

      //           _formkey.currentState!.save();


      //         }  
      //       }  
            
      //     ),
      //   ),
      // );
    }

    Widget _buildGuestUser(){
      return Container(
        child: 

        InkWell(
          onTap: (){
            //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>BottomNavigationBarPage()));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNavigationBarPage()));
          },
          child: Text("Guest User ? Click Here ",style: TextStyle( fontSize: 18,fontWeight: FontWeight.w900,color: themGreenColor),textAlign: TextAlign.center,),
        )
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text("Guest User ?  ",style: TextStyle( fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black54),),
        //     SizedBox(width: 2,),
        //     InkWell(
        //       child: Text("Click here.!!!",style: TextStyle(decoration: TextDecoration.underline, fontSize: 20,fontWeight: FontWeight.w500,color: themColor),),
        //       onTap: (){
        //         Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>BottomNavigationBarPage()));
        //       },
        //     )
        //   ],
          
        // )
      );

    }

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
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 10,
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

        body:  NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return false;
          }, 
          child: SingleChildScrollView(
            child: Container(
              child: Form(
                key: _formkey,
                child: SingleChildScrollView(
                  reverse: false,
                  
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Container(
                      //   width: width,
                      //   height: height*0.1,
                      // ),
          
                      // Container(
                      //   color: Colors.transparent,
                      //   width: width,
                      //   height: height*0.15,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.stretch,
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.only(left: 10,right: 10),
                      //         child: Container(
                      //           height: 40,
                      //           width:width,
                      //           alignment: Alignment.centerLeft, 
                      //           child: const FittedBox(
                      //             child: Text("One-stop solution for all your",style: TextStyle(color: themColor,fontWeight: FontWeight.w500,fontSize: 30,fontFamily: 'Ubuntu'))
                      //           )
                      //         ),
                      //       ),
                          
                      //       Padding(
                      //         padding: const EdgeInsets.only(left: 10,right: 10),
                      //         child: Container(
                      //           height: 40,
                      //           width:width,
                      //           alignment: Alignment.centerLeft, 
                      //           child: const FittedBox(
                      //             child: Text("Health Issues",style: TextStyle(color: themColor,fontWeight: FontWeight.bold,fontSize: 40,fontFamily: 'WorkSans'))
                      //           )
                      //         ),
                      //       ),
                          
                      //       Padding(
                      //         padding: const EdgeInsets.only(left: 10,right: 10),
                      //         child: Container(
                      //           height: 20,
                      //           width:width,
                      //           alignment: Alignment.centerLeft, 
                      //           child: const FittedBox(
                      //             child: Text("Find a doctor who will take the best care of your health",style: TextStyle(color: themColor,fontWeight: FontWeight.w500,fontSize: 20))
                      //           )
                      //         ),
                      //       ),
                           
                      //     ],
                      //   ),
                      // ),
          
          
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Container(
                          
                          width: width,
                          height: height*0.35,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                              image: AssetImage("assets/Registration/registration.png"),
                              fit: BoxFit.contain
                            )
                          ),
                        ),
                      ),
                      Container(
                        
                        alignment: Alignment.topCenter,
                        color: Colors.white,
                        width: width,
                        height: height*0.45,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // SizedBox(
                              //   width: width,
                              //   height: 20,
                              //   child: FittedBox(
                              //     child: Builder(
                              //       builder: (context) {
                              //         return const Text("Enter your phone number to continue",style: TextStyle(color: Colors.black45,fontWeight: FontWeight.w800,fontSize: 20,fontFamily: "Ubuntu"));
                              //       }
                              //     )
                              //   ),
                              // ),
                              const SizedBox(height: 10,),
                             // _buildName(),
          
                             // const SizedBox(height: 10,),
                              // IntlPhoneField(
                              //   decoration: InputDecoration(
                              //     labelText: 'Phone Number',
                              //     border: OutlineInputBorder(
                              //       borderSide: BorderSide(),
                              //     ),
                              //   ),
                              //   onChanged: (phone) {
                              //     print(phone.completeNumber);
                              //   },
                              //   onCountryChanged: (phone) {
                          
                              //     print('Country code changed to: ' + phone.completeNumber);
                              //   },
                              // ),
                          
                              //phone number
                             // _buildInternationalPhoneNumber(),
          
                            // _buildInternationalPhoneNo(),
          
                            //  _buildContactNumber(),

                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [

                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 5), // changes position of shadow
                                    ),
                                  ]
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2,right: 2),
                                  child: IntlPhoneField(

                                    decoration: InputDecoration(
                                      hintText: "Mobile No.",
                                      helperText: "Enter Mobile No. here...",
                                      //labelText: 'Phone Number',
                                      // border: OutlineInputBorder(
                                      //     borderSide: BorderSide(),
                                      // ),
                                
                                      border: myinputborder(),
                                        enabledBorder: myinputborder(),
                                        focusedBorder: myfocusborder(),
                                      ),
                                      initialCountryCode: 'IN',
                                      
                                      onChanged: (phone) {
                                      
                                      print("complete no "+phone.completeNumber);
                                      print("country code "+phone.countryCode);
                                      print("phone number "+phone.number);
                                      setState(() {
                                        internationalNumber=phone.number.toString();
                                      });
                                      
                                    },
                                    // validator: (String ? value){
                                    //   if(value!.isEmpty){
                                    //     return 'Phone No. is required!';
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                ),
                              ),
          
                              SizedBox(height: 20,),
                          
                              SizedBox(
                                height: height*0.099,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5,left: 0,right: 0),
                                    child: _buildOtpGetButton()
                                  ),
                                ),
                              ),
          
                              SizedBox(height: 10,),
          
                              _buildGuestUser()
          
                              // Container(
                              //   width: width,
                              //   height: 20,
                              //   alignment: Alignment.center,
                              //   child: _buildGuestUser()
                              // )
                             
                            ],
                          ),
                        ),
                      ),
                  
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      
    );
  }

  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return const OutlineInputBorder( //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
          color:Colors.indigo,
          width: 3,
        )
    );
  }

  OutlineInputBorder myfocusborder(){
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
          color:Colors.green,
          width: 3,
        )
    );
  }

  
}