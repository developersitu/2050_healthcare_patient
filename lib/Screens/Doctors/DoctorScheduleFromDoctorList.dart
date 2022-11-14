import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Model/Doctor/AllDoctorScheduleModel.dart';
import 'package:healthcare2050/Screens/Doctors/AllDoctorsList.dart';
import 'package:healthcare2050/Screens/Doctors/DoctorListBasedOnSpecialization.dart';
import 'package:healthcare2050/Screens/Doctors/DoctorScheduleList.dart';
import 'package:healthcare2050/SideNavigationDrawer/navigation_drawer_widget.dart';
import 'package:healthcare2050/Widgets/DoctorSpecializatinCard.dart';
import 'package:healthcare2050/Widgets/DoctorSpecializationListCard.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class DoctorScheduleFromDoctorList extends StatelessWidget {
 
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

      //both Date & Time picker color start
      theme: ThemeData(
        timePickerTheme: TimePickerThemeData(
          backgroundColor: Colors.indigo[10],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          hourMinuteShape: const CircleBorder(),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
            .copyWith(secondary: Colors.greenAccent),
      ),
      //both Date & Time picker color end

      home: Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({ Key? key }) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  String ? currentDate, sendingDateToServer,userid,userMobileNo; // sate
  int ? phoneNoLength;

  String _selectedTime="Select Time",_selectedDate="Select Date",buttonText="Submit",getName="blank",getPhoneNo="blank";

  late bool serverResponse;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<FormState> _formkey =GlobalKey<FormState>(); 
    // global key for form.
  bool _autovalidate = false;

  late TextEditingController _nameController,_phoneController,_ageController;

  DateTime ? date,date2;

  //////////// All Doctor Schedule Start ///////////
  Future<AllDoctorScheduleModel> entryDoctorScheduleProcess() async {

    print("sending to server "+_phoneController.text.toString()+" 18:36");
    print("sending to server /////////////////////////////");

    String entryMobileNo_url= doctorScheduleApi;
    final http.Response response = await http.post(
        Uri.parse(entryMobileNo_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
         // 'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: {
          "DoctorId": DoctorSpecializationListCard.doctorId.toString(),
          "UserId": userid,
          "PatientName": _nameController.text.toString(),
          "MobileNumber": _phoneController.text.toString(),
          "ScheduleDate": sendingDateToServer.toString()+" "+DateFormat("HH:mm").format(date!).toString(),
          "PatientAge": _ageController.text.toString(),
          "SpecializationId": DoctorSpecializatinCard.doctorSpecializationId.toString()
          
        },
        // body: {
        //   'email': email,
        //   'password': password,
        // }
    );
     
    if (response.statusCode == 200) {

      print("schedule Body "+ response.body);
      var mess=json.decode(response.body)['message'];
      bool res=json.decode(response.body)['status'];
      var bookingDetail=json.decode(response.body)['BookingDetail'] ?? {};

      setState(() {
        serverResponse=res;
      });

      print("message Body ////// "+ serverResponse.toString());

      if(serverResponse==false){
        setState(() {
          buttonText="Retry";
        });
      }

      Fluttertoast.showToast(
        msg: "sucess",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );

      return AllDoctorScheduleModel.fromJson(json.decode(response.body));
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
  //////////// All Doctor Schedule End //////////


  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCredentials();

    DateTime now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    var sendingServerDateFormatter= new DateFormat('yyy-mm-dd');
    var timeformatter= new DateFormat('hh:mm:ss').format(DateTime.now());
    currentDate = formatter.format(now);
    sendingDateToServer= sendingServerDateFormatter.format(now);

    
    _nameController=TextEditingController();
    _phoneController=TextEditingController();
   
    _ageController=TextEditingController();

    
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


    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Text("This is a Custom Toast"),
    );

    Widget _buildButton(){
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

          if (_formkey.currentState!.validate()) {



            if(_selectedDate=="Select Date"){
              scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text("Please Choose Date"))); 
            }
            
           else if(_selectedTime=="Select Time"){
              scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text("Please Choose Time"))); 
            }

          //  else if(_nameController.text.toString()==""){
          //     scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text("Please fillup patient name"))); 
          //   }

          //  else if(_ageController.text.toString()==""){
          //     scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text("Please fillup age"))); 
          //   }

          //  else if(_phoneController.text.toString()==""){
          //     scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text("Please fillup Phone No."))); 
          //   }

          //  else if(phoneNoLength!<10){
          //     scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text("phone no. should not be less than 10"))); 
          //   }

            else {

              try{
                setState(() {
                  buttonText="Please wait..";
                });

                var response =await entryDoctorScheduleProcess();
                bool res=response.status;
                if(res==true){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DoctorScheduleList()));
                }
                else{

                }
               // print("response "+response.toString());

                // var res=response.bookingDetail;

                // print("res "+res.toString());

                
  
              }catch(e){

              }

              
            }

            _formkey.currentState!.save();

          }

            
          }, 
          child: Text('$buttonText',style: TextStyle(color: Colors.white,fontSize: 20),) 
        )
      );

    }

    Future<void> _openTimePicker(BuildContext context) async{
      final TimeOfDay ? picktime = await showTimePicker(
        context: context, 
        initialTime: TimeOfDay.now(),
        helpText: "Select Time",
        // builder: (BuildContext context, Widget? child) {
        //   return MediaQuery(
        //     data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        //     child: child!,
            
        //   );
        // },
      ) ;  

     
      if(picktime!=null){
        setState(() {
          _selectedTime= picktime.format(context);
         // DateFormat.Hm().format(_selectedTime);
          print("time >"+ _selectedTime.toString());

        });
      
        date= DateFormat.jm().parse(picktime.format(context));
        date2= DateFormat("hh:mma").parse("6:45PM"); // think this will work better for you
        // format date
        print("checking..... "+DateFormat("HH:mm").format(date!));
        print("checking..... "+DateFormat("HH:mm").format(date!));
        print(DateFormat("HH:mm").format(date2!));

      }
      
    }

    ///////////// Start Date///////////////
    DateTime currentDateOfChooseDate = DateTime.now();
    Future<void> _openDatePicker(BuildContext context) async {
      
      final DateTime pickedDate = (
        await showDatePicker(
          context: context,
          initialDate: currentDateOfChooseDate,
         // firstDate: DateTime(2015),
          firstDate: DateTime.now(), // for disable previous date
          lastDate: DateTime(2050),
          helpText: "Select Date",
          
        )
      )!;
      if (pickedDate != null && pickedDate !=  currentDateOfChooseDate){
        setState(() {
          currentDateOfChooseDate = pickedDate; // change current state value to picked value
          print("start date "+currentDateOfChooseDate.toString());

          var dateTime = DateTime.parse("${currentDateOfChooseDate}");
          print("start date 2 "+dateTime.toString());

          var formate1 = "${dateTime.day}-${dateTime.month}-${dateTime.year}"; //change format to dd-mm-yyyyy

         // var formate2 = "${dateTime.month}/${dateTime.day}/${dateTime.year}";
          var formate2 = "${dateTime.year}-${dateTime.month}-${dateTime.day}";//change format t0 yyy-mm-dd

          _selectedDate=formate1.toString();
          sendingDateToServer=formate2.toString();

          print("serndingDateToServer : "+sendingDateToServer.toString());
        });
      }  
    }


    return Container(
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
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        endDrawer: SizedBox(
          width: MediaQuery.of(context).size.width*0.7,
          
          child: SideDrawer()
        ),

        appBar: AppBar(
          toolbarHeight: 50,
          backwardsCompatibility: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light
          ),
  
          elevation: 0,
          backgroundColor: themColor,

          iconTheme: IconThemeData(color: themColor), // drawer icon color
          actions: <Widget>[

            IconButton(
              tooltip: "Search here",
              onPressed: () {},
              icon: Icon(Icons.search,color: Colors.white,),
            ),

           
            SizedBox(width: 2,), 

            Builder(
              builder: (context) =>  IconButton(
                icon: Icon(Icons.menu,color: Colors.white,),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),


            // Builder(
            //   builder: (context) => Padding(
            //     padding: const EdgeInsets.only(right: 5),
            //     child: Container(
            //       height: 30,
            //       decoration: BoxDecoration(
            //         border: Border.all(
            //           color: themGreenColor,
            //           width: 2
            //         ),
            //         color: themColor,
            //         borderRadius: BorderRadius.all(Radius.circular(30))
            //       ),
            //       child: IconButton(
            //         icon: Icon(Icons.menu,color: Colors.white,),
            //         onPressed: () => Scaffold.of(context).openEndDrawer(),
            //         tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            //       ),
            //     ),
            //   ),
            // ),

          ],

          
          leading:  Padding(
            padding: const EdgeInsets.only(left: 5),
            child: IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorListBasedOnSpecializationPage()));
                //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> BottomNavigationBarPage()));
              },
            ),
          ),
          

          title: const Text("Doctor Schedule",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20,fontFamily: 'WorkSans')),
          
        ), 

        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return false;
          },
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 5,right: 5,bottom: 10),
                child: Column(
                  children: [
                  
                    SizedBox(height: 50),
                  
                    Container(
                      height: 260,
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
                                  margin: EdgeInsets.only(top: 150),
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
                                            NetworkImage(DoctorSpecializationListCard.doctorImage.toString()),
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
                                                Text(DoctorSpecializationListCard.doctorName.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,),
                                                Text(DoctorSpecializationListCard.doctorDesignation.toString(),maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),textAlign: TextAlign.center,),
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
                  
                    SizedBox(height: 20),
                  
                    Text("Please Complete Scheduling Process...",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w800,fontSize: 15)),
                    SizedBox(height: 5),
            
                    Container(
                      width: width,
                     
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                  
                          SizedBox(
                            height: height*0.065,
                            width: width,
                            child: RawMaterialButton(
                              fillColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: themColor,width: 2),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_today),
                                  SizedBox(width: 5,),
                                  Text(_selectedDate.toString(),style: TextStyle(color: themColor,fontWeight: FontWeight.bold,fontSize: 20),)
                                ],
                                
                              ),
                              onPressed: (){
                                _openDatePicker(context);
                              },
                            ),
                          ),
                  
                  
                          SizedBox(height: 10),
                          
                          SizedBox(
                            height: height*0.065,
                            width: width,
                            child: RawMaterialButton(
                              fillColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: themColor,width: 2),
                                borderRadius: BorderRadius.circular(10)
                              ),
                  
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.lock_clock),
                                  SizedBox(width: 5,),
                                  Text(_selectedTime.toString(),style: TextStyle(color: themColor,fontWeight: FontWeight.bold,fontSize: 20),)
                                ],
                                
                              ),
                              //child: Text(_selectedTime!,style: TextStyle(color: themColor,fontWeight: FontWeight.bold,fontSize: 20),),
                              onPressed: (){
                                _openTimePicker(context);
                              },
                            ),
                          )
                          
                        ],
                      ),
                    ),
                  
                  
                    SizedBox(height: 10),
                   
                    TextField( 
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration( 
                          hintText:  "Patient Name",
                         // labelText: "Patient Name",
                         // helperText: "Please enter Patient name",
                          prefixIcon: Icon(Icons.person),
                          border: myinputborder(),
                          enabledBorder: myinputborder(),
                          focusedBorder: myfocusborder(),
                      )
                    ),
                  
                    SizedBox(height: 10),
                  
                    
                  
                    // Container(
                    //   width: width,
                    //   child: AdvanceTextField(
                    //     type: AdvanceTextFieldType.EDIT,
                    //     backgroundColor: themColor,
                    //     color: Colors.white,
                    //     keyboardType: TextInputType.number,
                    //     height: 50,
                    //     controller: _nameController,
                    //     editLabel: Icon(
                    //       Icons.edit,
                    //       color: Colors.white,
                    //     ),
                    //     saveLabel: Icon(
                    //       Icons.check,
                    //       color: Colors.white,
                    //     ),
                    //     textHint: 'Name',
                    //     onEditTap: () {
                    //       String text="ok";
                    //       print(text);
                    //     },
                    //     onSaveTap: (text) {
                    //       print('value is: $text');
                  
                    //       setState(() {
                    //         getName='$text';
                    //       });
                    //     },
                    //   ),
                    // ),
                  
                    
                   
                    // Container(
                    //   width: width,
                    //   child: AdvanceTextField(
                    //     type: AdvanceTextFieldType.EDIT,
                    //     backgroundColor: themColor,
                    //     color: Colors.white,
                    //     keyboardType: TextInputType.number,
                    //     height: 50,
                    //     //controller: _phoneController,
                    //     editLabel: Icon(
                    //       Icons.edit,
                    //       color: Colors.white,
                    //     ),
                    //     saveLabel: Icon(
                    //       Icons.check,
                    //       color: Colors.white,
                    //     ),
                    //     textHint: 'Phone No.',
                    //     onEditTap: () {
                    //       String text="ok";
                    //       print(text);
                          
                    //     },
                    //     onSaveTap: (text) {
                    //       print('value is: $text');
                    //       setState(() {
                    //         phoneNoLength = text.length;
                    //       });
                         
                          
                    //       if(phoneNoLength!=10){
                    //         print(phoneNoLength);
                    //         scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text("Length should npt less than 10"))); 
                    //       }
                  
                    //       else{
                    //         setState(() {
                    //           getPhoneNo='$text';
                    //         });
                           
                    //       }
                         
                    //     },
                    //   ),
                    // ),
                  
                   
                   
                    TextField( 
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration( 
                          //labelText: "Age",
                          hintText: "Age",
                         // helperText: "Please enter Patient age",
                          prefixIcon: Icon(Icons.person_outline),
                          border: myinputborder(),
                          enabledBorder: myinputborder(),
                          focusedBorder: myfocusborder(),
                      )
                    ),
                  
                    SizedBox(height: 10),
                  
                    TextField( 
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration( 
                          prefixIcon: Icon(Icons.phone_android),
                         // labelText: "Phone No.",
                          hintText: "Phone No.",
                         // helperText: "Please enter Patient Phone No.",
                          enabledBorder: myinputborder(),
                          focusedBorder: myfocusborder(),
                      )
                    ),
                  
                  
                    SizedBox(height: 10),
                  
                    _buildButton()
            
                  ],
            
                ),
              ),
            ),
          ),
        ),  
      ),

    );
  }



  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return OutlineInputBorder( //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
          color: themColor,
          width: 2,
        )
    );
  }

  OutlineInputBorder myfocusborder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
          color: themGreenColor,
          width: 2,
        )
    );
  }

  void getCredentials() async{

    SharedPreferences loginPrefs = await SharedPreferences.getInstance();

    setState(() {
      userid=loginPrefs.getString("userid").toString();
      print("user id checking  "+ userid.toString());
      userMobileNo=loginPrefs.getString("mobileno").toString();
       _phoneController=TextEditingController(text: userMobileNo==null ? "please provide" : userMobileNo);
    });
  }

}