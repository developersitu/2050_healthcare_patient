import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Model/RequestAserviceModel/RequestAserviceModel.dart';
import 'package:healthcare2050/Providers/CityListProvider.dart';
import 'package:healthcare2050/Providers/RequestAserviceProvider.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/SplashScreen/SplashScreen.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;

class RequestAservicePage extends StatelessWidget {
  const RequestAservicePage({ Key? key }) : super(key: key);

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
      home: RequestAservice(),
    );
  }
}

class RequestAservice extends StatefulWidget {
  const RequestAservice({ Key? key }) : super(key: key);

  @override
  State<RequestAservice> createState() => _RequestAserviceState();
}

class _RequestAserviceState extends State<RequestAservice> {

  final GlobalKey<FormState> _formkey =GlobalKey<FormState>(); 
    // global key for form.
  bool _autovalidate = false;

  late TextEditingController _firstNameController,_lastNameController,_mobileController,_emailController,_serviceController;

  String buttonText="Request Service";

  String ? city_dropdown_id ;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    
    _firstNameController=TextEditingController();
    _lastNameController=TextEditingController();
    _mobileController=TextEditingController();
    _emailController=TextEditingController(); 
    _serviceController=TextEditingController();
    
   
    final dataCity= Provider.of<CityListProvider>(context,listen: false);
   
    dataCity.fetchCity();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _serviceController.dispose();

  }

  @override
  Widget build(BuildContext context) {

    final dataCity= Provider.of<CityListProvider>(context);//GET
    final data = Provider.of<RequestAServiceProvider>(context);//POST

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        title: const Text("Request Service"),
        backgroundColor: themColor,
        backwardsCompatibility: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light
        ),

        leading:  Padding(
          padding: const EdgeInsets.only(left: 5),
          child: IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.white),
            onPressed: (){
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
              Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> BottomNavigationBarPage()));
            },
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

      body: 

        NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return false;
        },
          child: Padding(
            padding: const EdgeInsets.only(left: 5,right: 5,top: 20,bottom: 10),
            child: Container(
              width: width,
              height: height,
              child: Form(
                key: _formkey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
        
                      SizedBox(height: 10,),
        
                      
                        
                      TextFormField(
                        controller: _firstNameController,
                        keyboardType: TextInputType.text,
                        // maxLines: 10,
                        decoration: InputDecoration(
                          // labelText: "First Name",
                          // floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: Colors.black45,
                          ),
                          helperText: "Please Enter First Name",
                          counterText: 'First',
                          //prefix: Icon(Icons.person,color: themColor),
                          // suffix: Image.asset("assets/Logo/india.jpg",width: 20,height: 20,),
                          prefixIcon: Icon(
                            Icons.account_box,
                            color: Colors.black45,
                          ),
                          // suffixIcon: Icon(
                          //   Icons.account_box,
                          //   color: Colors.black45,
                          // ),
                          // enabledBorder: UnderlineInputBorder(      
                          //   borderSide: BorderSide(color: themColor),   
                          // ),
                      
                          // focusedBorder: UnderlineInputBorder(      
                          //   borderSide: BorderSide(color: themBlueColor)
                          // ),  
        
                          focusedBorder: focusborder(),
                          enabledBorder: enableborder(),
                          errorBorder: errorborder(),
                          disabledBorder: dissableborder(),
                          border: border(),
                          focusedErrorBorder: errorborder(),
                          
                  
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          //   borderSide: BorderSide(
                          //     width: 3,
                          //     color: themColor,
                          //   ),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          //   borderSide: BorderSide(
                          //     color:Colors.green,
                          //     width: 3
                          //   ),
                          // ),
                          hintText: "Enter First Name.", 
                          hintStyle: TextStyle(color: themColor), 
                        ),
                        validator: (String ? value){
                          if(value!.isEmpty){
                            return 'First Name is required!';
                          }
                          return null;
                        },
                            
                      ),
                      
                      SizedBox(height: 5,),
                      
                      TextFormField(
                        controller: _lastNameController,
                        keyboardType: TextInputType.text,
                        // maxLines: 10,
                        decoration: InputDecoration(
                          // labelText: "First Name",
                          // floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: Colors.black45,
                          ),
                          helperText: "Please Enter Last Name",
                          counterText: 'Last',
                          //prefix: Icon(Icons.person,color: themColor),
                          // suffix: Image.asset("assets/Logo/india.jpg",width: 20,height: 20,),
                          prefixIcon: Icon(
                            Icons.account_box,
                            color: Colors.black45,
                          ),
                          // suffixIcon: Icon(
                          //   Icons.account_box,
                          //   color: Colors.black45,
                          // ),
        
                          // enabledBorder: UnderlineInputBorder(      
                          //   borderSide: BorderSide(color: themColor),   
                          // ),
                      
                          // focusedBorder: UnderlineInputBorder(      
                          //   borderSide: BorderSide(color: themBlueColor)
                          // ),  
        
                          focusedBorder: focusborder(),
                          enabledBorder: enableborder(),
                          errorBorder: errorborder(),
                          disabledBorder: dissableborder(),
                          border: border(),
                          focusedErrorBorder: errorborder(),
                          
                  
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          //   borderSide: BorderSide(
                          //     width: 3,
                          //     color: themColor,
                          //   ),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          //   borderSide: BorderSide(
                          //     color:Colors.green,
                          //     width: 3
                          //   ),
                          // ),
                          hintText: "Enter Last Name.", 
                          hintStyle: TextStyle(color: themColor), 
                        ),
                        validator: (String ? value){
                          if(value!.isEmpty){
                            return 'Last Name is required!';
                          }
                          return null;
                        },
                          
                      ),
        
                      SizedBox(height: 5,),
                      
                      TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.text,
                        maxLength: 10,
                        decoration: InputDecoration(
                          // labelText: "First Name",
                          // floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: Colors.black45,
                          ),
                          helperText: "Please Enter Mobile No.",
                          // counterText: 'Mobile',
                          //prefix: Icon(Icons.person,color: themColor),
                          // suffix: Image.asset("assets/Logo/india.jpg",width: 20,height: 20,),
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.black45,
                          ),
                          // suffixIcon: Icon(
                          //   Icons.account_box,
                          //   color: Colors.black45,
                          // ),
        
                          // enabledBorder: UnderlineInputBorder(      
                          //   borderSide: BorderSide(color: themColor),   
                          // ),
                      
                          // focusedBorder: UnderlineInputBorder(      
                          //   borderSide: BorderSide(color: themBlueColor)
                          // ),  
                          
                           focusedBorder: focusborder(),
                          enabledBorder: enableborder(),
                          errorBorder: errorborder(),
                          disabledBorder: dissableborder(),
                          border: border(),
                          focusedErrorBorder: errorborder(),
                  
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          //   borderSide: BorderSide(
                          //     width: 3,
                          //     color: themColor,
                          //   ),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          //   borderSide: BorderSide(
                          //     color:Colors.green,
                          //     width: 3
                          //   ),
                          // ),
                          hintText: "Enter Mobile No.", 
                          hintStyle: TextStyle(color: themColor), 
                        ),
                        validator: (String ? value){
                          if(value!.isEmpty){
                            return 'Mobile is required!';
                          }
                          return null;
                        },
                          
                      ),
        
                      SizedBox(height: 5,),
        
                      
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.text,
                        // maxLines: 10,
                        decoration: InputDecoration(
                        
                          // labelText: "First Name",
                          // floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: Colors.black45,
                          ),
                          helperText: "Please Enter Email Address",
                          counterText: 'Email',
                          //prefix: Icon(Icons.person,color: themColor),
                          // suffix: Image.asset("assets/Logo/india.jpg",width: 20,height: 20,),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.black45,
                          ),
                          // suffixIcon: Icon(
                          //   Icons.account_box,
                          //   color: Colors.black45,
                          // ),
        
                          // enabledBorder: UnderlineInputBorder(      
                          //   borderSide: BorderSide(color: themColor),   
                          // ),
                      
                          // focusedBorder: UnderlineInputBorder(      
                          //   borderSide: BorderSide(color: themBlueColor)
                          // ), 
                          
                          focusedBorder: focusborder(),
                          enabledBorder: enableborder(),
                          errorBorder: errorborder(),
                          disabledBorder: dissableborder(),
                          border: border(),
                          focusedErrorBorder: errorborder(),
                            
                          
                  
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          //   borderSide: BorderSide(
                          //     width: 3,
                          //     color: themColor,
                          //   ),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          //   borderSide: BorderSide(
                          //     color:Colors.green,
                          //     width: 3
                          //   ),
                          // ),
                          hintText: "Enter Email Address", 
                          hintStyle: TextStyle(color: themColor), 
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
                          
                      ),
        
                      SizedBox(height: 5,),
        
                      TextFormField(
                        controller: _serviceController,
                        keyboardType: TextInputType.text,
                        // maxLines: 10,
                        decoration: InputDecoration(
                          // labelText: "First Name",
                          // floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: Colors.black45,
                          ),
                          helperText: "Please Enter Service ",
                          counterText: 'Service',
                          //prefix: Icon(Icons.person,color: themColor),
                          // suffix: Image.asset("assets/Logo/india.jpg",width: 20,height: 20,),
                          prefixIcon: Icon(
                            Icons.account_box,
                            color: Colors.black45,
                          ),
                          // suffixIcon: Icon(
                          //   Icons.account_box,
                          //   color: Colors.black45,
                          // ),
        
                          // enabledBorder: UnderlineInputBorder(      
                          //   borderSide: BorderSide(color: themColor),   
                          // ),
                      
                          // focusedBorder: UnderlineInputBorder(      
                          //   borderSide: BorderSide(color: themBlueColor)
                          // ),  
        
                          focusedBorder: focusborder(),
                          enabledBorder: enableborder(),
                          errorBorder: errorborder(),
                          disabledBorder: dissableborder(),
                          border: border(),
                          focusedErrorBorder: errorborder(),
                          
                  
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          //   borderSide: BorderSide(
                          //     width: 3,
                          //     color: themColor,
                          //   ),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          //   borderSide: BorderSide(
                          //     color:Colors.green,
                          //     width: 3
                          //   ),
                          // ),
                          hintText: "Enter Service", 
                          hintStyle: TextStyle(color: themColor), 
                        ),
                        validator: (String ? value){
                          if(value!.isEmpty){
                            return 'Service is required!';
                          }
                          return null;
                        },
                          
                      ),

                      SizedBox(height: 5,),
                      
                        
                     
                      Theme(
                        data: Theme.of(context).copyWith(canvasColor: Colors.white,splashColor: themGreenColor,
                        
                        
                        ),
                        child: DropdownButtonFormField<String>(
                                
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down_circle,color: themBlueColor,size: 20,),
                          decoration: InputDecoration(
                      
                            focusedBorder: focusborder(),
                            enabledBorder: enableborder(),
                            errorBorder: errorborder(),
                            disabledBorder: dissableborder(),
                            focusedErrorBorder: errorborder(),
                            // border: border(),
                            border: OutlineInputBorder( 
                             // <--- this line
                              borderRadius: BorderRadius.circular(10), // <--- this line
                            ),
                                             
                            contentPadding:
                              EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //     width: 2,
                            //     color: themGreenColor
                            //   )
                            // ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            
                          ),
                          
                          value: null,
                          hint: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text('Please Choose City',style: TextStyle(fontFamily: 'RaleWay',fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black38)),
                          ),
                          onChanged: (itemid) {
                            setState((){ 
                            
                              city_dropdown_id = itemid!;
                            
                              
                            });
                          
                            // bookCodeProcess();
                          
                            print("city from drop down Id ///////////////////" +city_dropdown_id.toString());
                          },
                              
                          validator: (value) => value == null ? 'City is required' : null,
                          items: dataCity.cityList.map((list) {
                            return DropdownMenuItem(
                              
                              value: list['Id'].toString(),
                              child: FittedBox(
                                
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Text(list['CityName'].toString() ,style: TextStyle(color: themColor, fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 16),),
                                )
                              ),
                            );
                          }).toList(),
                        
                        ),
                      ),
                      
        
        
                      SizedBox(
                        height: 20,
                      ),
        
                      
                      Container(
                        width: width, 
                        height: 40,
                        child: ElevatedButton(
                          child: Text('$buttonText',style: TextStyle(fontSize: 20),),
                          style: ElevatedButton.styleFrom(
                            primary: themColor,
                            onPrimary: Colors.white,
                            side: BorderSide(color: themBlueColor, width: 3),
                          ),
                          onPressed: () async {
        
                            if(_formkey.currentState!.validate()){
                              print("validate...");
        
                              // if(i==null){
                              //   scaffoldKey.currentState!.showSnackBar(
                              //     SnackBar(content:Text("Mobile No. is required"),backgroundColor: Colors.red,)
                              //   ); 
                              // }
        
                              try{
        
                                setState(() {
                                  buttonText="Please wait...";
                                });
                                print('Pressed');
        
                                
                                data.sendDataToRequestAServiceProvider(context, _firstNameController.text.toString(),_lastNameController.text.toString(),_emailController.text.toString(), _serviceController.text.toString(),_mobileController.text.toString(), city_dropdown_id.toString());
                                buttonText="Please wait..";
                                
        
                              }
        
                              catch(err){
        
                                print(err);
                              
                              }
        
                              // else{
        
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
        
                              //     if(res==false){
                              //       setState(() {
                              //         buttonText="Retry !!";
                              //       });
                              //     }
        
                              //   }
        
                              //   catch(err){
        
                              //     print(err);
                                
                              //   }
        
                              // }
                            }
                            _formkey.currentState!.validate();
                            
                          },
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    );
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

Future<RequestAserviceModel> postDataRequestAservice(BuildContext context, String firstname,String lastname,String email,String service,String mobile,String cityid) async {
  
  final response = await http.post(
    Uri.parse(reuestAserviceApi.toString()),
      // headers: {"Content-type": "application/x-www-form-urlencoded"},
      // encoding: convert.Encoding.getByName("utf-8"),

    headers: <String, String>{
      // 'Accept': 'application/json',
      // 'Content-type': 'application/json',
      'Accept': 'application/json'
    },

    body: {
      "FirstName": firstname,
      "LastName" : lastname,
      "Email": email,
      "Service": service,
      "Mobile": mobile,
      "Cityid": cityid,
      
    },
     
  );


  if (response.statusCode == 200) {

    print(response.statusCode);
    print(response.body);

    

    // print("response :"+ json.decode(response.body)['success']);

    bool status=json.decode(response.body)['status'] ?? false;
    var successMessage = json.decode(response.body)['message'].toString();

    if(status){

      Fluttertoast.showToast(
        msg: "$successMessage",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );

      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>BottomNavigationBarPage()));
    }

    
    //SharedPreferences loginPrefs = await SharedPreferences.getInstance();
   // loginPrefs.setString("msg", successMessage);

   
    
    //  Get.to(HomeTable());
    return RequestAserviceModel.fromJson(json.decode(response.body));
  }else{
    throw Exception('Something went wrong');
  }
}