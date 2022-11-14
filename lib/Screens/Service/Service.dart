import 'dart:convert';
import 'dart:io';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Model/BookCodeModel/BookCodeModel.dart';
import 'package:healthcare2050/Model/BookNowModel/BookNowModel.dart';
import 'package:healthcare2050/Providers/CategorySubCategoryProvider.dart';
import 'package:healthcare2050/Providers/CityListProvider.dart';
import 'package:healthcare2050/Providers/DoctorsListProvider.dart';
import 'package:healthcare2050/Screens/BookNow/BookNow.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistration.dart';
import 'package:healthcare2050/SideNavigationDrawer/SideNavigationDrawerPrevious.dart';
import 'package:healthcare2050/SideNavigationDrawer/navigation_drawer_widget.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:hybrid_image/hybrid_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Service extends StatelessWidget {
  const Service({ Key? key }) : super(key: key);

  static  String ? bookCode,userId;

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(secondary: Colors.greenAccent),
      ),
      home: ServiceScreen(),
    );
  }
}

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({ Key? key }) : super(key: key);

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {

  bool enableList = false;
  int ? _selectedIndex;
    _onhandleTap() {
    setState(() {
      enableList = !enableList;
    });
  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formkey =GlobalKey<FormState>(); 
    // global key for form.
  bool _autovalidate = false;


  List showSubCategoriesList=[];
  List showCityList=[];

  String ? subCategories_dropdown_id,city_dropdown_id,userid,userMobileNo, bookingDate;
  String bookNowButtonText="Submit";
  
  late TextEditingController _firstNameController,_lastNameController,_mobileController,_emailController;
  
  bool connected=false;

  void checkInternet() async{
    try{
      final result =await InternetAddress.lookup("google.com");
      if(result.isNotEmpty && result[0].rawAddress.isEmpty){

        setState(() {
          connected=true;
          print("connection "+ connected.toString());
        });
       
      }
    } on SocketException  catch (_) {

      setState(() {
        connected=false;
        print("connection "+ connected.toString());
      });

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

  //////////// Book Code Start///////////
  Future<BookCodeModel> bookCodeProcess() async {
    String bookCode_url= bookCodeApi;
    final http.Response response = await http.post(
        Uri.parse(bookCode_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
         // 'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: {
          "subcategoryId": subCategories_dropdown_id.toString() == null ? "0" : subCategories_dropdown_id
          
        },
        // body: {
        //   'email': email,
        //   'password': password,
        // }
    );
     
    if (response.statusCode == 200) {

      print("book code Body "+ response.body);
      Service.bookCode=json.decode(response.body)['BookingCode'];
      print("book code  Body "+ Service.bookCode.toString());

      return BookCodeModel.fromJson(json.decode(response.body));
    } else {
     
      Fluttertoast.showToast(
        msg: "Please Check Internet Connection",
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
  ////////////Book Code End///////////
  
  //////////// Book Now Start///////////
  Future<BookNowModel> bookNowProcess() async {
    String bookNow_url= bookNowApi;
    final http.Response response = await http.post(
        Uri.parse(bookNow_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
         // 'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: {
          "bcode": Service.bookCode.toString(),
          'bcity': city_dropdown_id.toString(),
          'stype': subCategories_dropdown_id.toString(),
          'bfirstname': _firstNameController.text.toString(),
          'blastname' : _lastNameController.text.toString(),
          'bphone': _mobileController.text.toString(),
          'bmail' : _emailController.text.toString(),
          'CreatedBy': userid.toString(),
          'CreatedAt': bookingDate.toString()
          
        },
        // body: {
        //   'email': email,
        //   'password': password,
        // }
    );
     
    if (response.statusCode == 200) {

      print("book Now Body "+ response.body);
      // Service.bookCode=json.decode(response.body)['BookingCode'];
      // print("book Now  Body "+ Service.bookCode.toString());

      return BookNowModel.fromJson(json.decode(response.body));
    } else {
     
      Fluttertoast.showToast(
        msg: "Please Check Internet Connection",
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
  ////////////Book Now End///////////

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    DateTime now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    bookingDate = formatter.format(now);


    checkInternet();
    getCredentials();
    final dataCategory= Provider.of<CategorySubCategoryProvider>(context,listen: false);
    final dataCity= Provider.of<CityListProvider>(context,listen: false);
    dataCategory.fetchCategory();
    dataCity.fetchCity();

    _firstNameController=TextEditingController();
    _lastNameController=TextEditingController();
    _mobileController=TextEditingController();
    _emailController=TextEditingController();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();

  }

  @override
  Widget build(BuildContext context) {

    final dataCategory= Provider.of<CategorySubCategoryProvider>(context);
    final dataCity= Provider.of<CityListProvider>(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    void _showBottomSheet(){
      showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10)
          )
        ),
        elevation: 4,
        context: context,
        builder: (context) {
          return  Consumer<CityListProvider>(
            builder: (context,value,child){
              return value.cityList.isEmpty ? const CircularProgressIndicator() :
            
              NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return false;
                }, 
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: value.cityList.length,
                    itemBuilder: (context, index) {
                                              
                      String city_name=value.cityList[index]['CityName'].toString().split('-').join(' ');
                      city_name.split('-').join('');
                      return 
                                              
                      ExpansionTileCard(
                        baseColor: Colors.white,
                        expandedColor: themColor,
                                              
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.network("http://101.53.150.64/2050Healthcare/public/city/"+value.cityList[index]['Icon'].toString()),
                          // child: Image.network("http://101.53.150.64/2050Healthcare/public/city/3533170881641806124.png",)
                        ),
                        title: Text(city_name),
                        //subtitle: Text("FLUTTER DEVELOPMENT COMPANY"),
                        children: <Widget>[
                          Divider(
                            thickness: 1.0,
                            height: 1.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Text(
                                dataCity.cityList[index]['StateName'].toString(),style: TextStyle(color: Colors.white),
                              
                                    
                              ),
                            ),
                          ),
                        ],
                      );
                                                
                                              
                    },
                  ),
                ),
              );
            },
          );
        }
      );
    }

    void _showBookNowDialog(){
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return 
           
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(10),
            //   boxShadow: [

            //     BoxShadow(
            //       color: Colors.grey.withOpacity(0.5),
            //       spreadRadius: 5,
            //       blurRadius: 7,
            //       offset: Offset(0, 5), // changes position of shadow
            //     ),
            //   ]
            // ),
            
          
            StatefulBuilder(
              builder: (context, setState) {

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                ),
                content: Stack(
                  clipBehavior: Clip.none, //replace overflow
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                         // Navigator.pop(context);
                         // Navigator.of(context).pop();
                         // Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: themRedColor,
                        ),
                      ),
                    ),
                    Form(
                      key: _formkey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
            
                            Container(
                              color: themColor,
                              width: width,
                              height: 40,
                              child: Center(
                                child: Text('Book Now',style: TextStyle(color: Colors.white),),
                              ),
                            ),
                            SizedBox(height: 10,),
                              
                            DropdownButtonFormField<String>(
                                  
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down_circle,color: Colors.black54,size: 30,),
                              decoration: const InputDecoration(
                                contentPadding:
                                  EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: themGreenColor
                                    )
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: themRedColor
                                    )
                                  ),

                                  // focusedBorder:  OutlineInputBorder(
                                  //   borderSide: BorderSide(
                                  //     color: themAmberColor
                                  //   )
                                  // ),

                   
                    
                                // enabledBorder: OutlineInputBorder(
                                //     borderSide: BorderSide(color: Colors.purple[800])),
                                // border: OutlineInputBorder(
                                //     borderSide: BorderSide(color: Colors.purple[800])
                                //   ),
                                // focusedBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(color: Colors.purple[800], width: 2.0),
                                // )
                                ),
                              // decoration: InputDecoration(
                              //   enabledBorder: UnderlineInputBorder(
                              //     borderSide: BorderSide(color: Colors.black54)
                              //   )
                              // ),
                              
                              value: null,
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Text('Please Choose Service',style: TextStyle(fontFamily: 'RaleWay',fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black38)),
                              ),
                              onChanged: (itemid) {
                                setState((){ 
                                
                                  subCategories_dropdown_id = itemid!;
                                
                                  
                                });
                              
                                bookCodeProcess();
                              
                                print("Sub categories Id ///////////////////" +subCategories_dropdown_id.toString());
                              },
                                  
                              validator: (value) => value == null ? 'Service is required' : null,
                              items: showSubCategoriesList.map((list) {
                                return DropdownMenuItem(
                                  value: list['Id'].toString(),
                                  child: FittedBox(child: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Text(list['SubcategoryName'].toString() ,style: TextStyle(color: Color(0xff454f63), fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 16),),
                                  )),
                                );
                              }).toList(),
                            
                            ),

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

                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),
                                errorBorder: myerrorborder(),
                                
                        
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

                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),
                                errorBorder: myerrorborder(),
                                
                        
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
                                
                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),
                                errorBorder: myerrorborder(),
                        
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
                                
                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),
                                errorBorder: myerrorborder(),
                                 
                                
                        
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
                            
                              
                            DropdownButtonFormField<String>(
                                  
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down_circle,color: Colors.black54,size: 30,),
                              decoration: InputDecoration(
                                // enabledBorder: UnderlineInputBorder(
                                //   borderSide: BorderSide(color: Colors.black54)
                                // )
                                contentPadding:
                                  EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: themGreenColor
                                  )
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: themRedColor
                                  )
                                ),
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
                              
                                bookCodeProcess();
                              
                                print("city from drop down Id ///////////////////" +city_dropdown_id.toString());
                              },
                                  
                              validator: (value) => value == null ? 'City is required' : null,
                              items: showCityList.map((list) {
                                return DropdownMenuItem(
                                  value: list['Id'].toString(),
                                  child: FittedBox(child: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Text(list['CityName'].toString() ,style: TextStyle(color: Color(0xff454f63), fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 16),),
                                  )),
                                );
                              }).toList(),
                            
                            ),


                            SizedBox(
                              height: 20,
                            ),
            
                           
                            Container(
                              width: width, 
                              height: 40,
                              child: ElevatedButton(
                                child: Text('$bookNowButtonText',style: TextStyle(fontSize: 20),),
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
                                        bookNowButtonText="Please wait...";
                                      });
                                      print('Pressed');
                                      var response =await bookNowProcess();
                                      String msg=response.message;
                                      print("book now message  "+ msg.toString());
                                      bool res=response.status;
                                      if(res==true){

                                        SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                                        loginPrefs.setBool("isBookNow", true);


                                        Navigator.pop(context);

                                        
                                        setState(() {
                                          bookNowButtonText="Submit";
                                        });

                                        Fluttertoast.showToast(
                                          msg: msg.toString(),
                                          toastLength: Toast.LENGTH_LONG,
                                          fontSize: 20,
                                          backgroundColor: Colors.green
                                        );
                                      }
          
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
                  ],
                ),
              
              
              );

            },
          );
        }
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
        backgroundColor: Colors.white,
          appBar: AppBar(
            
            backwardsCompatibility: false,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: themColor,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light
            ),
      
            backgroundColor: themColor,
            toolbarHeight: height*0.12,
            elevation: 0.0,
            title: Align(
              alignment: Alignment.topLeft,
              child: FittedBox(
                
                child: Padding(
                  padding: const EdgeInsets.only(left: 0,top: 0),
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        alignment: Alignment.topLeft,
                        child: const Text("Services",style: TextStyle(fontFamily: 'WorkSans',fontSize: 25,fontWeight: FontWeight.w700,color: Colors.white),)
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width*0.9,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(color: Colors.black45, spreadRadius: 1),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left:0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.search,color: Colors.black45, size: 30,),
                                  SizedBox(
                                    width: width*0.7,
                                    height: 50,
                                    child: const FittedBox(child: Text("Search to find healing experience..", style: TextStyle(fontSize: 8,fontWeight: FontWeight.w600,color: Colors.black38,fontFamily: 'RaleWay'),textAlign: TextAlign.left,))
                                  ),
                                ]  
                              ),
                            ),
                          ),

                          SizedBox(width: 10,),

                          InkWell(
                            onTap: (){
                              _showBottomSheet();

                            },
                            child: Card(
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(150),
                              ),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  // The child of a round Card should be in round shape 
                                  shape: BoxShape.circle, 
                                  color: themBlueColor
                                ),
                          
                                child: Icon(Icons.location_city,color: Colors.white),
                                
                              )
                            ),
                          ),

                        ]  
                      ),
                    ],
                    
                  ),
                ),
              ),
            ),
            
            // leading: IconButton(
            //   icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
            //   onPressed: (){
            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Service()));
            //    // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Service()));
            //   },
            // ),
          ),

          endDrawer: SizedBox(
            width: MediaQuery.of(context).size.width*0.7,
            child: SideDrawer()
          ),

          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: dataCategory.categoryList.length,
              itemBuilder: (context,index){

                
                String category_name=dataCategory.categoryList[index]['CategoryName'].toString().split('-').join(' ');

                category_name.split('-').join('');
                return  ExpansionTileCard(
                  baseColor: Colors.white,
                  expandedColor: themColor,
  
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: SvgPicture.network("http://101.53.150.64/2050Healthcare/public/category/"+dataCategory.categoryList[index]['Icon'],color: themGreenColor,)
                  ),
                  title: Text(category_name),
                  //subtitle: Text("FLUTTER DEVELOPMENT COMPANY"),
                  children: <Widget>[
                    Divider(
                      thickness: 1.0,
                      height: 1.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          dataCategory.categoryList[index]['Description'].toString(),style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: OutlinedButton(
                          child: Text('Book Now'),
                          style: OutlinedButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: themColor,
                            side: BorderSide(color: themBlueColor, width: 2),
                          ),
                          onPressed: () async{
                             
                            
                            SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                            bool loginStatus=loginPrefs.getBool("islogedin") ?? false;
                            print("userid   >>>>>>>>>>>>>>>>>"+loginStatus.toString());
                      
                            if(loginStatus){

                              print('Pressed');

                              showSubCategoriesList=dataCategory.categoryList[index]['subcategory'];
                              showCityList=dataCity.cityList;

                              print("showCityList list >>>>>>>>>>>>>>>>>> got "+ showCityList.toString());

                              _showBookNowDialog();
                            
                              
                            }

                            else{

                              _showCheckUserDialog(context); 
                            
                            }
                            

                       
                          },
                        )
                          
                        
                              
                        
                      ),
                    ),
                  ],
                );
              }
            ),
          ),

      ),
    );
  }

  void getCredentials() async{

    SharedPreferences loginPrefs = await SharedPreferences.getInstance();

    setState(() {
      userid=loginPrefs.getString("userid").toString();
      Service.userId=userid;
      print("user id checking ?????????????????????????????????????? "+ userid.toString());
      userMobileNo=loginPrefs.getString("mobileno").toString();
       _mobileController=TextEditingController(text: userMobileNo==null ? "please provide" : userMobileNo);
    });

  }


  void _showCheckUserDialog(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context)=>CupertinoAlertDialog(
        title: Column(
          children: [
            Text("Not Registered User"),
            Icon(
              Icons.person,
              color: themRedColor,
            ),

          ],
          
        ),
        content: Text("Please Login to get the facilities"), 
        actions: [
          CupertinoDialogAction(
            child: Text("Cancel",style: TextStyle(color: themRedColor),),
            onPressed: (){
              Navigator.of(context).pop();
            }
          ),

          CupertinoDialogAction(
            child: Text("Login",style: TextStyle(color: themGreenColor),),
            onPressed: ()
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginRegistration()));
              }
          ),
        ],
      )     
    );
    
  }


  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return const OutlineInputBorder( //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(3)),
      borderSide: BorderSide(
          color:Colors.indigo,
          width: 2,
        )
    );
  }

  OutlineInputBorder myfocusborder(){
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(3)),
      borderSide: BorderSide(
          color:Colors.green,
          width: 2,
        )
    );
  }

  OutlineInputBorder myerrorborder(){
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(3)),
      borderSide: BorderSide(
          color:Colors.red,
          width: 2,
        )
    );
  }

  
}