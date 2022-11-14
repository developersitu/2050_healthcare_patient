import 'dart:convert';
import 'package:animated_horizontal_calendar/animated_horizontal_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Model/DoctotAppointmentModel/DoctorAppointmentModel.dart';
import 'package:healthcare2050/Providers/OnlineDoctorConsultProvider.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistration.dart';
import 'package:healthcare2050/Screens/SplashScreen/SplashScreen.dart';
import 'package:healthcare2050/Screens/VideoTelePhoneCall/PreviewPage/OnlineConsultPreviewPage.dart';
import 'package:healthcare2050/Screens/VideoTelePhoneCall/Specialization/Specialization.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class OnlineBookDoctorPage extends StatelessWidget {

  final String text;
 
  OnlineBookDoctorPage({ Key? key, required this.text}) : super(key: key);

  
  
  static String ? slotDate,slotId,chooseSlotTime,userMobileNo,userId,
  price,patientName,patientAge,patientMobileNo;

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
      home: VideoConsultScreen(),
      
    );
  }
}

class VideoConsultScreen extends StatefulWidget {
  const VideoConsultScreen({ Key? key }) : super(key: key);

  @override
  State<VideoConsultScreen> createState() => _VideoConsultScreenState();
}

class _VideoConsultScreenState extends State<VideoConsultScreen> {

  final GlobalKey<FormState> _formkey =GlobalKey<FormState>(); 
    // global key for form.
  bool _autovalidate = false;

  late TextEditingController nameController,ageController,mobilePhoneController;

  String buttonText="Save";

  var dateTime;

  /////ZoneWiseState Start ///////////
  List showDateWiseSlotList = [];
  
  fetchSlotDetails() async {
    
    var showZoneWiseStateList_url= DoctorSlotApi;
    var response = await http.post(
      Uri.parse(showZoneWiseStateList_url),
      headers: <String,String> {

      },
      body: {
        "date" : OnlineBookDoctorPage.slotDate.toString(),
        "docid" : Specialization.SpecializationDoctorId.toString(),
        "ConsultType": Specialization.consultType.toString()
        
      }
    );
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['available_slot'] ?? [];

      // setState(() {
      //   OnlineBookDoctorPage.slotId = json.decode(response.body)['available_slot']['DoctorAvailableId'].toString();
      // });
      
      var price = json.decode(response.body)['Price'] ?? "";

     // bool stateStatus=json.decode(response.body)['status'];
     
     
      print('slot body');
      print(items);

      
      
      if(items!=[]){
        setState(() {
          showDateWiseSlotList = items;
          OnlineBookDoctorPage.price=price.toString();


          print("yes");
        });

  
      }
      if (items==[]) {
       // scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text(message.toString()))); 
        setState(() {
          showDateWiseSlotList = [];
        
        });

         print("yes 1");
      }  
      
      if(showDateWiseSlotList.length==0){

         print("yes 2");

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

      if(showDateWiseSlotList.length!=0){

         print("yes 3");

        
       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

    }else{
      showDateWiseSlotList = [];
     
    }
  }
  ///// ZoneWiseState Api End ///////////

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

    DateTime now = new DateTime.now();
     var formatter = new DateFormat('yyyy-MM-dd');
    // var sendingServerDateFormatter= new DateFormat('dd-mm-yyy');
    // var timeformatter= new DateFormat('hh:mm:ss').format(DateTime.now());
    OnlineBookDoctorPage.slotDate = formatter.format(now);
    dateTime==now;


    fetchSlotDetails();

    print(DateFormat.jm().format(DateFormat("hh:mm:ss").parse("14:15:00")));

    nameController= new TextEditingController();
    ageController = new TextEditingController();
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    ageController.dispose();
    mobilePhoneController.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final data = Provider.of<OnlineDoctorConsultProvider>(context);

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Book Appointment"),
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Specialization()));
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

        //   IconButton(Navigator
        //     onPressed: (){
        //       .push(context, MaterialPageRoute(builder: (context)=> SearchDoctorList()));
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
                 
                  height: height*0.35,
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
                                    radius:100.0,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 90.0,
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
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                            )
                                           
                                            
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
          
                Container(
                  height: 100,
                  child: AnimatedHorizontalCalendar(
                    tableCalenderIcon: Icon(Icons.calendar_today, color: Colors.white,),
                    date: DateTime.now(),
                    textColor: Colors.black45,
                    backgroundColor: Colors.white,
                    tableCalenderThemeData:  ThemeData.light().copyWith(
                      primaryColor: themColor,
                      accentColor: Colors.red,
                      colorScheme: ColorScheme.light(primary: themColor),
                      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                    ),
                    selectedColor: Colors.redAccent,
                    onDateSelected: (date){
                      OnlineBookDoctorPage.slotDate = date;
                      dateTime = DateTime.parse("${ OnlineBookDoctorPage.slotDate}");
                      var formatYMD = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
          
                      print("Date "+ formatYMD.toString());
                      print(OnlineBookDoctorPage.slotDate.toString());

                      print("Date Time");

                      print(DateTime.now().isBefore(dateTime));

                      fetchSlotDetails();

                      if(dateTime.isBefore(DateTime.now())){

                        if(dateTime.difference(DateTime.now()).inDays != 0 ){
                           
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OnlineBookDoctorPage(text: '',)));

                        }

                        
                        //fetchSlotDetails();

                      }
          
                      
          
                    } 
                  ),
                ),
          
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    
                    height: height,
                    child: 
          
                    showDateWiseSlotList.length==0 ?
                    Text("Sorry No slot !!!",textAlign: TextAlign.start, style: const TextStyle( fontWeight: FontWeight.w800, fontSize: 20,color: Colors.black87)):

                   // dateTime().isAfter(DateTime.now())==true ?

                    Container(
                     // height: height*0.6,
                      child: GridView.builder(
                        //shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          mainAxisExtent: 100,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20
                        ),
                        itemCount: showDateWiseSlotList.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return OutlinedButton.icon(
                               // label: Text('Woolha.com'),
                            icon: Icon(Icons.lock_clock,color: themColor,),
                            label: Text("${showDateWiseSlotList[index]['StartTime'].toString()}"+"-"+"${showDateWiseSlotList[index]['EndTime'].toString()}",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontSize: 20),),
                            onPressed: () async{

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


                                SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                                bool  loginStatus=loginPrefs.getBool("islogedin") ?? false;
                                bool  bookNowStatus=loginPrefs.getBool("isBookNow") ?? false;

                                print("userid   >>>>>>>>>>>>>>>>>"+loginStatus.toString());
                                
                                if(loginStatus){
                                  

                                  setState(() {

                                    OnlineBookDoctorPage.userMobileNo=loginPrefs.getString("mobileno");
                                    OnlineBookDoctorPage.chooseSlotTime=showDateWiseSlotList[index]['StartTime'].toString()+"-"+showDateWiseSlotList[index]['EndTime'].toString();
                                    showDateWiseSlotList[index]['DoctorId'].toString();
                                    OnlineBookDoctorPage.slotId=showDateWiseSlotList[index]['DoctorAvailableId'].toString();

                                    print("VideoSchedulePage.chooseSlotTime"+ OnlineBookDoctorPage.chooseSlotTime.toString());
                                  
                                      print("doctor slot id ++++++++++++++++++++++++++++++"+OnlineBookDoctorPage.slotId.toString());

                                  });

                                  showModalBottomSheet(
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)
                                      )
                                    ),
                                    elevation: 4,
                                    context: context,
                                    builder: (context) {
                                      return  StatefulBuilder(

                                        builder: (context, setState) {
                                          return Form(
                                            key: _formkey,
                                            child: SingleChildScrollView(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 5,right: 5,top: 10),
                                                child: Column(
                                                                              
                                                  children: [
                                                                              
                                                    FittedBox(child: Padding(
                                                      padding: const EdgeInsets.only(left: 10,right:10),
                                                      child: Text("Please Fll Up Patient Details...",style: TextStyle(color: Colors.black54,fontFamily: 'WorkSans',fontWeight: FontWeight.w900,fontSize:16)),
                                                    )),
                                                    SizedBox(height: 10,),
                                                                              
                                                    Container(
                                                      width: width,
                                                      alignment: Alignment.topLeft,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10,bottom: 5),
                                                        child: Text("Patient Name",textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themColor,fontFamily: 'WorkSans',fontWeight: FontWeight.w400)),
                                                      )
                                                    ),
                                                                              
                                                    TextFormField(
                                                      keyboardType: TextInputType.text,
                                                      controller: nameController,
                                                        validator: (String ? value){
                                                          if(value!.isEmpty){
                                                            return 'Patient Name is required!';
                                                          }
                                                          return null;
                                                        },
                                                      decoration: InputDecoration(
                                                        hintText: 'enter patient Name',
                                                        hintStyle: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.black26,
                                                        ),

                                                        border: myinputborder(),
                                                        enabledBorder: myinputborder(),
                                                        focusedBorder: myfocusborder(),
                                                        // border: OutlineInputBorder(
                                                        //   borderSide: BorderSide(
                                                        //     color: Colors.black12,
                                                        //   ),
                                                        //   borderRadius: BorderRadius.all(
                                                        //     Radius.circular(15.0),
                                                        //   ),
                                                        // ),
                                                      ),
                                                    ),
                                                                              
                                                    SizedBox(height: 5,),
                                                                              
                                                    Container(
                                                      width: width,
                                                      alignment: Alignment.topLeft,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10,bottom: 5),
                                                        child: Text("Patient Age",textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themColor,fontFamily: 'WorkSans',fontWeight: FontWeight.w400)),
                                                      )
                                                    ),
                                                                              
                                                    TextFormField(
                                                      keyboardType: TextInputType.number,
                                                      controller: ageController,
                                                      validator: (String ? value){
                                                        if(value!.isEmpty){
                                                          return 'Patient Age is required!';
                                                        }
                                                        return null;
                                                      },
                                                      decoration: InputDecoration(
                                                        hintText: 'enter patient age',
                                                        hintStyle: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.black26,
                                                        ),

                                                        border: myinputborder(),
                                                        enabledBorder: myinputborder(),
                                                        focusedBorder: myfocusborder(),
                                                        // border: OutlineInputBorder(
                                                        //   borderSide: BorderSide(
                                                        //     color: Colors.black12,
                                                        //   ),
                                                        //   borderRadius: BorderRadius.all(
                                                        //     Radius.circular(15.0),
                                                        //   ),
                                                      // ),
                                                      ),
                                                    ),
                                                                              
                                                    SizedBox(height: 5,),
                                                                              
                                                    Container(
                                                      width: width,
                                                      alignment: Alignment.topLeft,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10,bottom: 5),
                                                        child: Text("Patient Mobile No.",textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themColor,fontFamily: 'WorkSans',fontWeight: FontWeight.w400)),
                                                      )
                                                    ),
                                                                              
                                                    TextFormField(
                                                      keyboardType: TextInputType.number,
                                                      controller: mobilePhoneController,
                                                      validator: (String ? value){
                                                        if(value!.isEmpty){
                                                          return 'Patient MobileNo. is required!';
                                                        }
                                                        return null;
                                                      },
                                                      decoration: InputDecoration(
                                                        suffixIcon: Icon(Icons.phone_android),
                                                        hintText: 'enter mobile number',
                                                        hintStyle: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.black26,
                                                        ),

                                                        border: myinputborder(),
                                                        enabledBorder: myinputborder(),
                                                        focusedBorder: myfocusborder(),
                                                        // border: OutlineInputBorder(
                                                        //   borderSide: BorderSide(
                                                        //     color: Colors.black12,
                                                        //   ),
                                                        //   borderRadius: BorderRadius.all(
                                                        //     Radius.circular(15.0),
                                                        //   ),
                                                        // ),
                                                      ),
                                                    ),
                                                                              
                                                    SizedBox(height: 5,),
                                                                              
                                                    Container(
                                                      width: width,
                                                      child: ElevatedButton.icon(
                                                        
                                                        onPressed: () async{
                                                          print("You pressed Icon Elevated Button");

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


                                                                try{
                                                                  
                                                                    print("doctor slot id 2++++++++++++++++++++++++++++++"+OnlineBookDoctorPage.slotId.toString());
                                                                 
                                                                  data.sendDataToOnlineDoctorConsultProvider(context, Specialization.SpecializationDoctorId.toString(),OnlineBookDoctorPage.userId.toString(),Specialization.SpecializationId, nameController.text.toString(), ageController.text.toString(), mobilePhoneController.text.toString(), OnlineBookDoctorPage.slotDate.toString(), OnlineBookDoctorPage.slotId.toString());
                                                                  buttonText="Please wait..";

                                                                  OnlineBookDoctorPage.patientName= nameController.text.toString();
                                                                  OnlineBookDoctorPage.patientAge= ageController.text.toString();
                                                                  OnlineBookDoctorPage.patientMobileNo= mobilePhoneController.text.toString();

                                                                 

                                                                }

                                                                catch(err){

                                                                  print(err);
                                                                
                                                                }

                                                              }
                                                            
                                                              _formkey.currentState!.validate();
                                                            }
                                                           
                                                        }, 
                                                        icon: Icon(Icons.save),  //icon data for elevated button
                                                        label: Text("${buttonText}"),
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all(themColor),
                                                          padding: MaterialStateProperty.all(EdgeInsets.all(2)),
                                                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 10))
                                                        ), //label text 
                                                      ),
                                                    ),
                                                                              
                                                    SizedBox(height: 5,),
                                                                              
                                                  ],
                                                                              
                                                ),
                                              ),
                                            ),
                                          );

                                        }
                                      
                                      );
                                    }
                                  );
                        
                                }

                                else {

                                  _showDialog(context); 
                                
                                }
                                
                              }
                     
                            },

                            style: OutlinedButton.styleFrom(
                              side: BorderSide(width: 2.0, color: themColor),
                            ),
                          );
                        }
                      ),
                      
                      
                    ) //:  Text("Sorry Slot is finished !!!",textAlign: TextAlign.start, style: const TextStyle( fontWeight: FontWeight.w800, fontSize: 20,color: Colors.black87))
                  ),
                ),

              ],
            ),
          )
          
                     
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
  
  void _showDialog(BuildContext context) {
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


  void getCredentials() async{

    SharedPreferences loginPrefs = await SharedPreferences.getInstance();

    setState(() {
      OnlineBookDoctorPage.userMobileNo=loginPrefs.getString("mobileno").toString();
      OnlineBookDoctorPage.userId=loginPrefs.getString("userid").toString();
     
    });

    mobilePhoneController= new TextEditingController(text: OnlineBookDoctorPage.userMobileNo );

  }
}


Future<DoctorConsultModel> postDataToOnlineDoctorConsult(BuildContext context, String doctorId,String userId,String specializationId,String patientName,String patientAge,String mobileNumber,String scheduleDate,String slotId) async {
  //var dataInput = {"title": title, "userId": userId};

   print("slotId ????????????????????????????????????? "+ slotId);
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
      "SlotId": slotId,
      "ConsultationType": Specialization.consultType.toString(),
    },
     
  );


  if (response.statusCode == 200) {

    print(response.statusCode);
    print(response.body);

    Navigator.push(context, MaterialPageRoute(builder: (context)=>OnlineConsultPreviewPage()));

    // print("response :"+ json.decode(response.body)['success']);

    // CallStatusUpdatePage.message=json.decode(response.body)['consultInsert'][];
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