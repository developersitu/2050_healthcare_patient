import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Model/LoginRegistrationModel/VallidOtpModel.dart';
import 'package:healthcare2050/Model/ProfileDetailsUpdateModel/ProfileDetailsUpdateModel.dart';
import 'package:healthcare2050/Model/ProfileImageUploadModel/ProfileImageUploadModel.dart';
import 'package:healthcare2050/Providers/OnlineDoctorConsultProvider.dart';
import 'package:healthcare2050/Providers/ProfileDetailsUpdateProvider.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/Home/HomeNew.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as Io;
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  //final String urlImage;

  
  const ProfilePage({
    Key? key,
    required this.name,
    //required this.urlImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){ 

    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /// screen Orientation end///////////
    

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
      
    );
    
    // return Scaffold(
    //     appBar: AppBar(
    //       toolbarHeight: 50,
    //       backgroundColor: Colors.pink,
    //       //title: Text(name),
    //       title: Text("2050 Health Care"),
    //       centerTitle: true,
    //       backwardsCompatibility: false,
    //       systemOverlayStyle: const SystemUiOverlayStyle(
    //         statusBarColor: Colors.transparent,
    //         statusBarBrightness: Brightness.light,
    //         statusBarIconBrightness: Brightness.light
    //       ),
  
    //     ),
    //     // body: Image.network(
    //     //   urlImage,
    //     //   width: double.infinity,
    //     //   height: double.infinity,
    //     //   fit: BoxFit.cover,
    //     // ),


        
        
    //   );
  }   
}


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({ Key? key }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var _selected =""; // for full screen dialog
  var _test = "Full Screen"; // for full screen dialog


  String ? email,mobile,state,city,pincode,address;

  SharedPreferences ? loginPrefs;


  late TextEditingController _mobileController,_stateController,_pincodeController,
  _emailController,_cityController,_addressController;


  GlobalKey<FormState> _formkey =GlobalKey<FormState>(); 
    // global key for form.
  bool _autovalidate = false;




  Uint8List ? bytes;
  String ? ProfileImage;
  File ? imageFile;

  

  Future<ProfileImageUploadModel> profileEditProcess() async {
    

    final http.Response response = await http.post(
      Uri.parse(profileImageUploadApi.toString()),
      headers: <String, String>{
        // 'Accept': 'application/json',
        //'Content-type': 'application/json',
        'Accept': 'application/json'
      },

      body: {
        'userId': Home.userid.toString(),
        
        'Image' : base64Encode(bytes!)
        
      },
      
    );
     
    if (response.statusCode == 200) {

      var responseBody=json.decode(response.body);
      var profileimage_response=responseBody['Image'];

      print("profileImage  serveeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeer "+profileimage_response.toString());
      SharedPreferences loginPrefs = await SharedPreferences.getInstance();

      setState(() {
        loginPrefs.setString("profileImage", "http://101.53.150.64/2050Healthcare/public/profileImage/${profileimage_response}");

       Home.profileImage = "http://101.53.150.64/2050Healthcare/public/profileImage/${profileimage_response}";
       // ProfilePage.profileImage=loginPrefs.getString("profileImage");
      });

      print('Profile update body <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
      print(response.body);
      
      return ProfileImageUploadModel.fromJson(json.decode(response.body));
    } else {

      print('Profile update body');
      print(response.body);
      throw Exception('Failed to create album.');
    }
  }

  void _openGallery(ImageSource gallery) async {
    final pickedFileGalery = await ImagePicker().getImage(source: ImageSource.gallery);

    if(pickedFileGalery!=null){
      setState(() {
        imageFile = File(pickedFileGalery.path);
        },
      );

      bytes= imageFile!.readAsBytesSync();

      var response=await profileEditProcess();
      SharedPreferences loginPrefs = await SharedPreferences.getInstance();

      setState(() {
        Home.profileImage = "http://101.53.150.64/2050Healthcare/public/profileImage/${response.image}";
        loginPrefs.setString("profileImage", "http://101.53.150.64/2050Healthcare/public/profileImage/${response.image}");
       // ProfilePage.profileImage=loginPrefs.getString("profileImage");
      });
      print("Profile image ??????????????????????????????????// "+ ProfileImage.toString());
    }

  }

 
  void _openCamera(ImageSource camera) async {
    final pickedFileCamera = await ImagePicker().getImage(source: ImageSource.camera);
    if(pickedFileCamera!=null){
      setState(() {
        imageFile = File(pickedFileCamera.path);
        },
      );

      bytes= imageFile!.readAsBytesSync();

      var response=await profileEditProcess();
      SharedPreferences loginPrefs = await SharedPreferences.getInstance();

      setState(() {
        Home.profileImage= "http://101.53.150.64/2050Healthcare/public/profileImage/${response.image}";
        loginPrefs.setString("profileImage","http://101.53.150.64/2050Healthcare/public/profileImage/${response.image}");
       // ProfilePage.profileImage=loginPrefs.getString("profileImage");
      });
      print("Profile image ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"+ ProfileImage.toString());
    }
  }


  Widget _buildCity(){
    return  Container(
      // decoration: BoxDecoration(
      //   color: Color(0xffEFF3F6),
      //   borderRadius: BorderRadius.circular(0),
      //   boxShadow: [

      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       spreadRadius: 5,
      //       blurRadius: 7,
      //       offset: Offset(0, 3), // changes position of shadow
      //     ),
      //   ]
      // ),
    
      child: 
      TextFormField(
        controller: _cityController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 5,right: 5),
          hintText: "Enter City",
          hintStyle: TextStyle(fontSize: 12),
          labelText: "City",

          focusedBorder: focusborder(),
          enabledBorder: enableborder(),
          errorBorder: errorborder(),
          disabledBorder: dissableborder(),
          border: border(),
          focusedErrorBorder: errorborder()
          
          //border: InputBorder.none
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0)
          // )
            
        ),
        validator: (String ? value){
          if(value!.isEmpty){
            return 'City is required!';
          }
          return null;
        },
        
        
          
      )
        
    );
  }

  Widget _buildState(){
    return  Container(
      // decoration: BoxDecoration(
      //   color: Color(0xffEFF3F6),
      //   borderRadius: BorderRadius.circular(0),
      //   boxShadow: [

      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       spreadRadius: 5,
      //       blurRadius: 7,
      //       offset: Offset(0, 3), // changes position of shadow
      //     ),
      //   ]
      // ),
    
      child: 
      TextFormField(
        controller: _stateController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 5,right: 5),
          hintText: "Enter State",
          hintStyle: TextStyle(fontSize: 12),
          labelText: "State",

          focusedBorder: focusborder(),
          enabledBorder: enableborder(),
          errorBorder: errorborder(),
          disabledBorder: dissableborder(),
          border: border(),
          focusedErrorBorder: errorborder()
          
          //border: InputBorder.none
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0)
          // )
            
        ),
        validator: (String ? value){
          if(value!.isEmpty){
            return 'State is required!';
          }
          return null;
        },
        
        
          
      )
        
    );
  }


  Widget _buildPincode(){
    return  Container(
      // decoration: BoxDecoration(
      //   color: Color(0xffEFF3F6),
      //   borderRadius: BorderRadius.circular(0),
      //   boxShadow: [

      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       spreadRadius: 5,
      //       blurRadius: 7,
      //       offset: Offset(0, 3), // changes position of shadow
      //     ),
      //   ]
      // ),
    
      child: 
      TextFormField(
        controller: _pincodeController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 5,right: 5),
          hintText: "Enter Pincode",
          hintStyle: TextStyle(fontSize: 12),
          labelText: "PinCode",

          focusedBorder: focusborder(),
          enabledBorder: enableborder(),
          errorBorder: errorborder(),
          disabledBorder: dissableborder(),
          border: border(),
          focusedErrorBorder: errorborder()
          
          //border: InputBorder.none
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0)
          // )
            
        ),
        validator: (String ? value){
          if(value!.isEmpty){
            return 'Pincode is required!';
          }
          return null;
        },
        
        
          
      )
        
    );
  }


  

  Widget _buildEmail(){
    return Container(
      // decoration: BoxDecoration(
      //   color: Color(0xffEFF3F6),
      //   borderRadius: BorderRadius.circular(0),
      //   boxShadow: [

      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       spreadRadius: 5,
      //       blurRadius: 7,
      //       offset: Offset(0, 3), // changes position of shadow
      //     ),
      //   ]
      // ),
    
      child:
      TextFormField(
      
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 5,right: 5),
          hintText: "Enter Email",
          hintStyle: TextStyle(fontSize: 12),
          labelText: "email",

          //border: InputBorder.none
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0)
          // )
        
          focusedBorder: focusborder(),
          enabledBorder: enableborder(),
          errorBorder: errorborder(),
          disabledBorder: dissableborder(),
          border: border(),
          focusedErrorBorder: errorborder()
            
        ),

        validator: (String ? value) {
          if (value!.isEmpty) {
            return 'Email is Required';
          }

          if (!RegExp(
                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(value)) {
            return 'Please enter a valid email Address';
          }

          return null;
        },
        
        
          
      )
        
    );
  }

  Widget _buildMobileNumber(){
    return Container(
      // decoration: BoxDecoration(
      //   color: Color(0xffEFF3F6),
      //   borderRadius: BorderRadius.circular(0),
      //   boxShadow: [

      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       spreadRadius: 5,
      //       blurRadius: 7,
      //       offset: Offset(0, 3), // changes position of shadow
      //     ),
      //   ]
      // ),
    
      child: 
      TextFormField(
        maxLength: 10,
       // maxLengthEnforced: true,
        maxLengthEnforcement: MaxLengthEnforcement.enforced, //replaced maxLengthEnforced
        controller: _mobileController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 5,right: 5),
          hintText: "Enter Mobile Number",
          hintStyle: TextStyle(fontSize: 12),
          labelText: "Mobile Number",

          focusedBorder: focusborder(),
          enabledBorder: enableborder(),
          errorBorder: errorborder(),
          disabledBorder: dissableborder(),
          border: border(),
          focusedErrorBorder: errorborder()
          
          // border: InputBorder.none
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0)
          // )
            
        ),

        validator: (String ? value){
          if(value!.isEmpty){
            return 'Mobile Number is required!';
          }

          if(value.length!=10){
            return 'Mobile Number is less than 10';

          }
          return null;
        },
              
      )
        
    );
  }

    //////////// Login Start///////////
  Future<VallidOtpModel> otpProcess() async {

    // print(otp);
    // print(Login.phoneNumber.toString());
    // print(Login.userTypeId.toString());
    // print(organizationTextEditingController.text.toString());
    // print(gstTextEditingController.text.toString());

    String validOtp_url= validOtpApi;
    final http.Response response = await http.post(
        Uri.parse("http://101.53.150.64/iigfarmfresh/public/api/iigfarmfresh/validate_otp"),
        headers: <String, String>{
          // 'Accept': 'application/json',
         // 'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: {
          "Otp": "123456",
          "MobileNumber": "7008323469",
          "UserTypeId" : "3"

          
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
        loginPrefs.setString("userId", json.decode(response.body)['userdetaildata']['UserId'].toString());
        loginPrefs.setString("mobileno", json.decode(response.body)['userdetaildata']['MobileNumber'].toString());
        
       // loginPrefs.setString("profileImage", "http://101.53.150.64/2050Healthcare/public/profileImage/${json.decode(response.body)['userDetails']['Image']}");

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCredentials();

    


  }

  @override
  Widget build(BuildContext context) {

   // final data = Provider.of<ProfileDetailsUpdateProvider>(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;


   

    return Scaffold(
      backgroundColor: themColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: width,
              height: height*0.4,
              color: themColor,
              child: Row(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 40,bottom: 20,left: 10),

                    // child: AvatarGlow(
                    //   glowColor: Colors.blue,
                    //   endRadius: 90.0,
                    //   duration: Duration(milliseconds: 2000),
                    //   repeat: true,
                    //   showTwoGlows: true,
                    //   repeatPauseDuration: Duration(milliseconds: 100),
                    //   child: Material(     // Replace this child with your own
                    //     elevation: 8.0,
                    //     shape: CircleBorder(),
                    //     child: CircleAvatar(
                    //       backgroundColor: Colors.grey[100],
                    //       child: Container(
                    //         width: MediaQuery.of(context).size.width,
                    //         height: height*0.25,
                    //         decoration: BoxDecoration(
                             
                    //           shape: BoxShape.circle,
                    //           image: DecorationImage(
                    //             fit: BoxFit.cover,
                    //             image: NetworkImage("${Home.profileImage.toString()}"),
                    //           ),
                    //         ),
                    //       )
                    //      // radius: 40.0,
                    //     ),
                    //   ),
                    //   ),



                    
                    child: 
                      CircleAvatar(
                          radius:height*0.11,
                          backgroundColor: Colors.transparent,
                        
                          child: CircleAvatar(
                            radius: height*0.25,
                            backgroundColor: Colors.transparent,
                            child:
                            
                            // Home.profileImage.toString()=="null" ?
                            // CircularProgressIndicator() :


                            Stack(
                              children: [
                                SizedBox.expand(
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Image.network(
                                      "${Home.profileImage.toString()}"
                                    ),
                                  )
                                ),
                                     
                              ]
                            )
                            
                            // Container(
                            //   width: width,
                            //   height: height*0.2,
                            //  // child: Image.network("${Home.profileImage.toString()}"),
                            //   decoration: BoxDecoration(
                                
                            //     shape: BoxShape.circle,
                            //     image: DecorationImage(
                            //       fit: BoxFit.cover,
                            //       image: NetworkImage("${Home.profileImage.toString()}" )
                                
                                  
                            //     ),
                            //   ),
                            // )



                            // child: Container(
                            //   width: 100,
                            //   height: 100,
                            //   decoration: BoxDecoration(
                            //   color: Colors.grey,
                            //   shape: BoxShape.circle,
                            //   image: DecorationImage(
                            //     image: FileImage(imageFile!),
                            //   )
                            // ),
                            //   child: CachedNetworkImage(
                            //     imageUrl: "${ProfilePage.profileImage.toString()}",
                            //     // imageUrl: "http://101.53.150.64/2050Healthcare/public/profileImage/7907724201651124561.jpg",
                            //     placeholder: (context, url) => new CircularProgressIndicator(),
                            //     errorWidget: (context, url, error) => new Icon(Icons.error),
                            //   ),
                            // ),
                          ),
                        ),

                        

                   

                    // child: Container(
                    //   width: 200,
                    //   height: 200,
                    //   child: Image.network(ProfilePage.profileImage.toString())
                    // ),
                   // child: FittedBox(
                      // child: Container(
                      //   width: width*0.6,
                      //   height: height*0.6,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     shape: BoxShape.circle
                      //   ),
                      //   child: imageFile != null ?
                      //   Container(
                      //     height: height*0.2,
                      //     width: width*0.5,
                      //     decoration: BoxDecoration(
                      //       color: Colors.grey,
                      //       shape: BoxShape.circle,
                      //       image: DecorationImage(
                      //         image: 
                              
                      //         //NetworkImage(ProfilePage.profileImage.toString())
                              
                      //          FileImage(imageFile!),
                      //       )
                      //     ),
                      //   ) :
                      //   Container(
                      //     height: height*0.2,
                      //     width: width*0.5,
                      //     // decoration: BoxDecoration(
                      //     //   color: Colors.grey,
                      //     //   image: DecorationImage(
                      //     //     image: FileImage(imageFile!),
                      //     //   )
                      //     // ),
                      //   ),
                      // ),
                  //  ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      width: width*0.4,
                      height: height*0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        
                        children: [

                          // AvatarGlow(
                          //   endRadius: 60.0,
                          //   child: Material(     // Replace this child with your own
                          //     elevation: 8.0,
                          //     shape: CircleBorder(),
                          //     child: CircleAvatar(
                          //       backgroundColor: Colors.transparent,
                          //       child: Icon(Icons.camera_alt,color: Colors.red,),
                          //       radius: 20.0,
                          //     ),
                          //   ),
                          // ),

                          InkWell(
                            child: Row(
                              children: [
                                AvatarGlow(
                                  endRadius: 40.0,
                                  child: Material(     // Replace this child with your own
                                    elevation: 8.0,
                                    shape: CircleBorder(),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: IconButton(
                                        onPressed: (){
                                          _openCamera(ImageSource.camera);
                                        }, 
                                        icon: Icon(Icons.camera_alt,color: themGreenColor,)
                                      ),
                                      radius: 20.0,
                                    ),
                                  ),
                                ),
                                
                                Text("Camera",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.white))
                              ],
                            ),
                          ),

                          InkWell(
                            child: Row(
                              children: [

                                AvatarGlow(
                                  endRadius: 40.0,
                                  child: Material(     // Replace this child with your own
                                    elevation: 8.0,
                                    shape: CircleBorder(),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: IconButton(
                                        onPressed: (){
                                          _openGallery(ImageSource.gallery);
                                        }, 
                                        icon: Icon(Icons.image,color: themGreenColor)
                                      ),
                                      radius: 20.0,
                                    ),
                                  ),
                                ),
                                
                                Text("Galery",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.white))
                              ],
                            ),
                          ),

                          InkWell(
                            child: Row(
                              children: [

                                AvatarGlow(
                                  endRadius: 40.0,
                                  child: Material(     // Replace this child with your own
                                    elevation: 8.0,
                                    shape: CircleBorder(),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: IconButton(
                                        onPressed: (){

                                          _openUpdateProfileDialog();

                                        }, 
                                        icon: Icon(Icons.edit,color: themRedColor,)
                                      ),
                                      radius: 20.0,
                                    ),
                                  ),
                                ),
                                
                                Text("Edit",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.white))
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            Container(
              width: width,
              height: height*0.1,
              color: themColor,
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom:10,right: 10,left: 10,top: 10),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Row(
                        children: [

                          AvatarGlow(
                            endRadius: 40.0,
                            child: Material(     // Replace this child with your own
                              elevation: 8.0,
                              shape: CircleBorder(),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: IconButton(
                                  onPressed: (){

                                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>BottomNavigationBarPage()));

                                  }, 
                                  icon: Icon(Icons.home,color: themGreenColor)
                                ),
                                radius: 20.0,
                              ),
                            ),
                          ),
                          
                          Text("Home",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700,color: Colors.white))
                        ],
                      ),

                      
                      DigitalClock(
                        digitAnimationStyle: Curves.elasticOut,
                        is24HourTimeFormat: false,
                        areaDecoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        hourMinuteDigitTextStyle: TextStyle(
                          color: themGreenColor,
                          fontSize: 50,
                        ),
                        amPmDigitTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),              
                      ),
                     // FittedBox(child: Text(  CustomerProfile.name.toString() ,style: TextStyle(fontFamily: 'DancingScript',fontSize: 35,fontWeight: FontWeight.w700,color: themWhiteColor))),
                     // FittedBox(child: Text(  CustomerProfile.customerType.toString(),style: TextStyle(fontFamily: 'DancingScript',fontSize: 35,fontWeight: FontWeight.w700,color: themWhiteColor))),
                     // Text( CustomerProfileEdit.customerType.toString() == null ? WelcomeScreen.customerTypeName.toString() : CustomerProfileEdit.customerType.toString(),style: TextStyle(fontFamily: 'DancingScript',fontSize: 35,fontWeight: FontWeight.w700,color: themWhiteColor))
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: width,
              height: height*0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                color: Colors.white,
              ),

              child: Padding(
                padding: const EdgeInsets.only(top: 20,left: 10,right: 10,bottom: 10),
                child: Container(
                  width: width,
                  height: height*0.3,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                  
                  
                        Card(
                          elevation: 10,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(loginPrefs!.getString("email").toString()=="null" ? "":loginPrefs!.getString("email").toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.black87))
                                      
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: themColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text("Email",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white)),
                                        Icon(Icons.email,color: Colors.white70,)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                  
                        Card(
                          elevation: 10,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(loginPrefs!.getString("mobileno").toString()=="null" ? "": loginPrefs!.getString("mobileno").toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.black87))
                                      
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: themColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text("Contact No.",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white)),
                                        Icon(Icons.phone_android,color: Colors.white,)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                  
                        Card(
                          elevation: 10,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(loginPrefs!.getString("state").toString()=="null" ? "": loginPrefs!.getString("state").toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.black87))
                                      
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: themColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("State",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white)),
                                        Icon(Icons.location_city,color: Colors.white)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                  
                        
                        Card(
                          elevation: 10,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(loginPrefs!.getString("city").toString()=="null" ? "": loginPrefs!.getString("city").toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.black87))
                                      
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: themColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("City",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white)),
                                        Icon(Icons.location_city,color: Colors.white)

                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                  
                         Card(
                          elevation: 10,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(loginPrefs!.getString("pincode").toString() == "null" ? "" : loginPrefs!.getString("pincode").toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.black87))
                                      
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: themColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Pincode",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white)),
                                        Icon(Icons.pin,color: Colors.white,)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                  
                        Card(
                          elevation: 10,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(loginPrefs!.getString("address").toString() =="null" ? "" : loginPrefs!.getString("address").toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.black87))
                                      
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: themColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Address",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white)),
                                        Icon(Icons.location_city,color:Colors.white)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                  
                    ),
                  ),
                  
                ),
              ),
            )
          ],
        ),
      ),
      
      
    );
  }


  void getCredentials() async {
    loginPrefs = await SharedPreferences.getInstance();

    setState(() {

      // CustomerProfile.email=customerPrefs.getString("email");
      // CustomerProfile.contactNo=customerPrefs.getString("contact");
      // CustomerProfile.name=customerPrefs.getString("name");
      // CustomerHome.customerToken=customerPrefs.getString("token");
      // CustomerHome.customerId=customerPrefs.getString("customerId");
      // CustomerHome.customerCode=customerPrefs.getString("customerCode");
      // CustomerProfile.customerType=customerPrefs.getString("customerTypeName");
      // CustomerProfile.address=customerPrefs.getString("customerAddress");
      Home.profileImage=loginPrefs!.getString("profileImage");


      _emailController = TextEditingController(text: loginPrefs!.getString("email").toString());
      _mobileController = TextEditingController(text: loginPrefs!.getString("mobileno").toString());
      _cityController = TextEditingController(text: loginPrefs!.getString("city").toString());
      _stateController = TextEditingController(text: loginPrefs!.getString("state").toString());
      _pincodeController = TextEditingController(text: loginPrefs!.getString("pincode").toString());
      _addressController = TextEditingController(text: loginPrefs!.getString("address").toString());

      // setState(() {
      //   email=loginPrefs.getString("email").toString();
      //   mobile=loginPrefs.getString("mobileno").toString();
      //   city=loginPrefs.getString("city").toString();
      //   state=loginPrefs.getString("state").toString();
      //   pincode= loginPrefs.getString("pincode").toString();
      //   address=loginPrefs.getString("address").toString();


      // });


      print("profile image ......................................................12 "+Home.profileImage.toString()+ "   end");
            
    });
  }


  void _openUpdateProfileDialog() async {

    _selected = (await Navigator.of(context).push(new MaterialPageRoute<String>(
        builder: (BuildContext context) {

          final data = Provider.of<ProfileDetailsUpdateProvider>(context);

          double width= MediaQuery.of(context).size.width;
          double height= MediaQuery.of(context).size.height;

          return StatefulBuilder(
            builder: (context, setState) {

            //  print("dialog checking "+showZoneWiseStateList.toString());

            //  showSearchHeaderServiceList = searchBody;
            return new Scaffold(
              appBar: new AppBar(
                backgroundColor: themColor,
                title: const Text('Profile'),
                actions: [

                  Padding(
                    padding: const EdgeInsets.only(left: 2,right: 2,bottom: 5,top: 5),
                    child: Container(
                      width: width*0.3,
                     
                      child: new ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          primary: themGreenColor, // Background color
                        ),

                        onPressed: () async{

                               
                          if (_formkey.currentState!.validate()) {
                            try {
              
                              data.sendDataToProfileDetailsUpdateProvider(context,Home.userid.toString(),_emailController.text.toString(),_mobileController.text.toString(),
                              _cityController.text.toString(),_stateController.text.toString(),_pincodeController.text.toString(),_addressController.text.toString());
                          
                            } 
                            catch (e) {
              
                              ScaffoldMessenger.of(context).showSnackBar(
            
                                SnackBar(content: new Text("Failed  !!!"),backgroundColor: Colors.red,)
                              );
                            
                            }

                            _formkey.currentState!.save();
                          }  
                          
                        },
                        child: new Text('Submit',
                          style: TextStyle(color: Colors.white),
                        )
                      ),
                    ),
                  ),

                 
                  Padding(
                    padding: const EdgeInsets.only(left: 2,right: 2,bottom: 5,top: 5),
                    child: new ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        primary: themGreenColor, // Background color
                      ),
                      
                      onPressed: () {
                        Navigator.of(context).pop("hai");
                      },
                      child: new Text('Back',
                        style: TextStyle(color: Colors.white),
                      )
                    ),
                  ),
                ],
              ),
              body: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return false;
                }, 
                child: Form(
                 key: _formkey,
                  child: Container(
                    height: height,
                    width: width,
                    padding: EdgeInsets.only(left: 5,right: 5,top: 20),
                    
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                                  
                          
                          Container(
                    
                            height: height*0.85,
                            width: width,
                            
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                              
                                    Container(
                                      width: width,
                                      child: Text("Please Update Profile..",textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themColor,fontWeight: FontWeight.w800,fontSize: 15),),
                                    ),
                    
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: _buildEmail()
                                    ),
                
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: _buildMobileNumber(),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child:  _buildState(),
                                    ),
                
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: _buildCity(),
                                    ),
                
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),                            
                                      child:  _buildPincode(),
                                    ),
                
                
                                    Container(
                                      width: width,
                                      height: height*0.25,
                                      child:  Padding(
                                        padding: EdgeInsets.only(left: 2,right: 2,top: 0),
                                        child: Container(
                                          height: 180,
                                          //color: Color(0xffeeeeee),
                                          color: Colors.white,
                                          padding: EdgeInsets.only(left: 0,right: 0),
                                          child: new ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxHeight: 180.0,
                                            ),
                                            child: new Scrollbar(
                                              child: new SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                reverse: true,
                                                child: SizedBox(
                                                  height: 160.0,
                                                  child: new TextFormField(
                                                    maxLength: 500,
                                                    //maxLengthEnforced: true,
                                                    maxLengthEnforcement: MaxLengthEnforcement.enforced, //replaced maxLengthEnforced
                                                    maxLines: 100,
                                                    controller: _addressController,
                                                    decoration: new InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      hintText: "Please Fill Address",hintStyle: TextStyle(fontFamily: 'Raleway',fontWeight: FontWeight.w300),
                                                      labelText: "Address",
                
                                                      focusedBorder: focusborder(),
                                                      enabledBorder: enableborder(),
                                                      errorBorder: errorborder(),
                                                      disabledBorder: dissableborder(),
                                                      
                                                    ),
                
                                                    validator: (String ? value){
                                                      if(value!.isEmpty){
                                                        return 'Please fill up!';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                              
                                      ),
                              
                                    ),
                
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10,bottom: 10,left: 2,right: 2),
                                      child: Container(
                                        width: width,
                                        height: height*0.05,
                                        child: ElevatedButton(
                                          child: Text('Submit'),
                                          onPressed: () async{

                                                               
                                            if (_formkey.currentState!.validate()) {
                                              try {
                                                
                                                data.sendDataToProfileDetailsUpdateProvider(context,Home.userid.toString(),_emailController.text.toString(),_mobileController.text.toString(),
                                                _cityController.text.toString(),_stateController.text.toString(),_pincodeController.text.toString(),_addressController.text.toString());
                                                
                                              } 
                                              catch (e) {
                                
                                                ScaffoldMessenger.of(context).showSnackBar(
                              
                                                  SnackBar(content: new Text("Failed  !!!"),backgroundColor: Colors.red,)
                                                );


                                              
                                              }

                                              _formkey.currentState!.save();
                                            }  
                                          
                                          },
                                        ),
                                      ),
                                    )
                
                                   
                                   
                                  ]
                                ),
                              ),
                                              
                            ),
                           
                          ),
                            
                        
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
            }
          );
        },
        fullscreenDialog: true
    )))!;
    if(_selected != null)
    setState(() {
      _selected = _selected;
    });
  }

  


  OutlineInputBorder enableborder(){ //return type is OutlineInputBorder
    return const OutlineInputBorder( //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(2)),
      borderSide: BorderSide(color: themColor, width: 2.0),
    );
  }

  OutlineInputBorder focusborder(){
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      borderSide: BorderSide(color: themBlueColor, width: 2.0),
    );
  }

  OutlineInputBorder errorborder(){
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      borderSide: BorderSide(color: Colors.red, width: 2.0),
    );
  }


  OutlineInputBorder dissableborder(){
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      borderSide: BorderSide(width: 2.0,color: Colors.grey),
    );
  }

  OutlineInputBorder border(){
    return const OutlineInputBorder(
       borderRadius: BorderRadius.all(Radius.circular(2)),
      borderSide: BorderSide(width: 2.0,)
    );
  }
   
}


Future<ProfileDetailsUpdateModel> postDataToProfileDetailsUpdateServer(BuildContext context,String userId,String email,String mobileNumber,String city,String state,String pincode,String address) async {

  final response = await http.post(
    Uri.parse(profileEditApi.toString()),
      // headers: {"Content-type": "application/x-www-form-urlencoded"},
      // encoding: convert.Encoding.getByName("utf-8"),

    headers: <String, String>{
      // 'Accept': 'application/json',
      // 'Content-type': 'application/json',
      'Accept': 'application/json'
    },

    body: {
      "userId": userId,
      "Email" : email,
      "MobileNumber": mobileNumber,
      "City": city,
      "State": state,
      "Pincode": pincode,
      "Address": address,
    },
     
  );


  if (response.statusCode == 200) {

    print(response.statusCode);
    print(response.body);

    // print("response :"+ json.decode(response.body)['success']);

    bool response_status =json.decode(response.body)['status'];
    var response_message =json.decode(response.body)['title'];

    var response_email = json.decode(response.body)['userDetails']['Email'];
    var response_mobilenumber = json.decode(response.body)['userDetails']['MobileNumber'];
    var response_City = json.decode(response.body)['userDetails']['City'];
    var response_State = json.decode(response.body)['userDetails']['State'];
    var response_Pincode = json.decode(response.body)['userDetails']['Pincode'];
    var response_Address = json.decode(response.body)['userDetails']['Address'];

    // var successMessage = json.decode(response.body)['success'].toString();

    //print("message "+successMessage);

    if(response_status){

      SharedPreferences loginPrefs = await SharedPreferences.getInstance();
      loginPrefs.setString("email", "${response_email}");
      loginPrefs.setString("mobileno", "${response_mobilenumber}");
      loginPrefs.setString("city", "${response_City}");
      loginPrefs.setString("state", "${response_State}");
      loginPrefs.setString("pincode", "${response_Pincode}");
      loginPrefs.setString("address", "${response_Address}");

      Fluttertoast.showToast(
        msg: "${response_message}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );

      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfilePage(name: '',)));
      
    }

    if(response_status==false){

      ScaffoldMessenger.of(context).showSnackBar(
                              
        SnackBar(content: new Text("Details Save Failed  !!!"),backgroundColor: Colors.red,)
      );

    }
    //  Get.to(HomeTable());
    return ProfileDetailsUpdateModel.fromJson(json.decode(response.body));
  }
  else{
    throw Exception('Something went wrong');
  }
}
