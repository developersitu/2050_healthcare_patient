import 'dart:convert';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Model/BookNowModel/BookNowHistoryModel.dart';
import 'package:healthcare2050/Providers/BookNowHistoryProvider.dart';
import 'package:healthcare2050/Screens/Bookings/BookingHistory.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/Home/Home.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BookNowHistory extends StatelessWidget {

  static String ? userid;

  static String ? status,message;

  static List bookNowHistoryList=[];

  const BookNowHistory({ Key? key }) : super(key: key);

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
      home: Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  

  List bookNowHistoryList=[];

  bool isLoading = true;

  Map<String, String> queryParams = {
  "Id": Home.userid.toString(),
 
  };
  Future<BookNowHistoryModel> bookNowHistoryProcess() async {
   
    String bookNowHistory_url=doctorScheduleListApi;
    final  response = await http.get(
      Uri.parse(bookNowHistory_url).replace(queryParameters: queryParams),
      headers: <String, String>{
        // 'Accept': 'application/json',
        //'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    
    if (response.statusCode == 200) {
      

      final responseBody=json.decode(response.body);

      print('get Post body response');
      print(response.body);

      setState(() {
        bookNowHistoryList = json.decode(response.body)['BookingDetail'] ?? [];
        isLoading=false;
      });

      print("History ..."+ bookNowHistoryList.toString());

     
      setState(() {
        
        
        //print("Booknow body >>>>>> "+HistoryList.toString());
        //BookNowHistory.bookNowHistoryList=HistoryList;
        BookNowHistory.status = json.decode(response.body)['status'];
        BookNowHistory.message = json.decode(response.body)['message'];
      });

      print("Booknow body list length ............. >>>>>> ");
      
      print("Booknow body list length ............. >>>>>> "+BookNowHistory.bookNowHistoryList.length.toString());
      
      print("Booknow body list >>>>>> "+BookNowHistory.bookNowHistoryList.toString());
      
      //ProfileDetailsProcess();
      return BookNowHistoryModel.fromJson(json.decode(response.body));
    } else {
      
      throw Exception('Failed to create album.');
    }
  }


  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCredentials();
   // bookNowHistoryProcess();
    // final data= Provider.of<BookNowHistoryListProvider>(context,listen: false);
   
    // data.fetcBookingNowHistory();
    
    

    // print("List >>>>>>>>>> 2"+data.bookNowHistoryList.toString());
    // print("status >>>>>>>>>> "+data.serverStatus.toString());
  
    // isLoading=true;
  }
  

  @override
  Widget build(BuildContext context) {
   
    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

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
                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>BottomNavigationBarPage()));
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
          title: const Text("Booked History",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20,fontFamily: 'Ubuntu')),
        ),

        body: 
        isLoading==true ?
        
        Center(
          child: const CircularProgressIndicator(),
        ) :


        bookNowHistoryList.length== 0 ?

        Center(
          child: Text("No Records"),
        ) :
        
        
        Padding(
          padding: EdgeInsets.only(top: 20,left: 10),
          child: ListView.builder(
            itemCount: bookNowHistoryList.length,
            itemBuilder: (context,index){
              return ListTile(
                title: Card(
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Booking Code:", style: TextStyle(fontFamily: "WorkSans",color: themRedColor),),
                            SizedBox(width: width*0.2,),
                            Expanded(child: Text(bookNowHistoryList[index]['BookingCode'].toString()== "null" ? "Not Available" : bookNowHistoryList[index]['BookingCode'].toString(),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,style: TextStyle(fontFamily: "WorkSans",color: themColor),))
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person,size: 10,),
                                Text("Patient:",style: TextStyle(fontFamily: "WorkSans",fontSize: 10))
                              ],
                            ),
                            SizedBox(width: width*0.2,),
                            Expanded(child: Text(bookNowHistoryList[index]['FullName'].toString()== "null" ? "Not Available" : bookNowHistoryList[index]['FullName'].toString(),textAlign: TextAlign.end,maxLines: 1,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12),))
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_city,size: 10,),
                                Text("City:",style: TextStyle(fontFamily: "WorkSans",fontSize: 10)),
                              ],
                            ),
                            SizedBox(width: width*0.2,),
                            Expanded(child: Text(bookNowHistoryList[index]['CityName'].toString()== "null" ? "Not Available" : bookNowHistoryList[index]['CityName'].toString(),textAlign: TextAlign.end,maxLines: 1,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12),))
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.medical_services,size: 10,),
                                Text("Service:",style: TextStyle(fontFamily: "WorkSans",fontSize: 10)),
                              ],
                            ),

                            SizedBox(width: width*0.2,),
                            Expanded(child: Text(bookNowHistoryList[index]['SubcategoryName'].toString()== "null" ? "Not Available" : bookNowHistoryList[index]['SubcategoryName'].toString(),textAlign: TextAlign.end,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12)))
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.date_range_sharp,size: 10,),
                                Text("Date:",style: TextStyle(fontFamily: "WorkSans",fontSize: 10)),
                              ],
                            ),
                            SizedBox(width: width*0.2,),
                            Expanded(child: Text(bookNowHistoryList[index]['SubcategoryName'].toString()== "null" ? "Not Available" :bookNowHistoryList[index]['CreatedAt'].toString(),textAlign: TextAlign.end,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12)))
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Booking Status:",style: TextStyle(fontFamily: "WorkSans",fontSize: 10)),

                            bookNowHistoryList[index]['BookingStatus'].toString() == "null" ?
                            Text("Not Available",style: TextStyle(fontFamily: "WorkSans",fontSize: 10,color: Colors.red)) :
                            bookNowHistoryList[index]['BookingStatus'].toString() == "" ?
                            Text("Not Available",style: TextStyle(fontFamily: "WorkSans",fontSize: 10,color: Colors.red)) :
                            bookNowHistoryList[index]['BookingStatus'].toString() == "0" ?
                            Text("Booked",style: TextStyle(fontFamily: "WorkSans",fontSize: 10,color: Colors.green)) :
                            bookNowHistoryList[index]['BookingStatus'].toString() == "1" ?
                            Text("Processing",style: TextStyle(fontFamily: "WorkSans",fontSize: 10,color: Colors.amber)) :
                            bookNowHistoryList[index]['BookingStatus'].toString() == "2" ?
                            Text("Conform",style: TextStyle(fontFamily: "WorkSans",fontSize: 10,color: Colors.green[900])) : 
                            Text("Canceled",style: TextStyle(fontFamily: "WorkSans",fontSize: 10,color: Colors.red[900]))
                          ],
                        ),
                        
                      ],
                    
                    ),
                ),
                elevation: 8,
                shadowColor: themColor,
                margin: EdgeInsets.only(top: 10,left: 5,right: 5),
                shape:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: themAmberColor, width: 1)
                ),
              ),
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
      BookNowHistory.userid=loginPrefs.getString("userid").toString();
      
    });

    bookNowHistoryProcess();
   
    
  }

}

