// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Model/3DotsPopUpMenuModel/3dotsPopUpModel.dart';
import 'package:healthcare2050/Model/DoctorScheduleListModel/DoctorScheduleListModel.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/Home/HomeNew.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistration.dart';
import 'package:healthcare2050/Screens/VideoTelePhoneCall/Agorapages/AgoraVideoCallSetup.dart';
import 'package:healthcare2050/Widgets/DoctorSpecializatinCard.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';


class DoctorScheduleList extends StatelessWidget {
 // const DoctorScheduleList({ Key? key }) : super(key: key);

  static bool ? serverStaus;
  static String ? serverMessage,channelName,userId,callEndId;



 // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  //static final navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    
    return  MaterialApp(
      
      debugShowCheckedModeBanner: false,
      //onGenerateRoute: generateRoute,
     // navigatorKey: navigatorKey,

      //initialRoute: '/',
      // routes: {
      //   '/': (context) => CallPage(),
      //   //'/cart': (context) => CartPage(),
      // },
     
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


  //Timer1
  late Timer timer;
  int counter = 0;

  late List<ItemModel> menuItems;
  CustomPopupMenuController _controller = CustomPopupMenuController();
 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Timer2
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => addValue());

    menuItems = [
      ItemModel('Home', Icons.home),
      ItemModel('Logout', Icons.logout),
      ItemModel('Exit', Icons.exit_to_app),
    ];


    
    checkingUser();

    
    // _getUserLocation = getUserLocation();
    //  DateTime now = DateTime.now();
    //  String formattedDate = DateFormat('2022-02-24 10:25:36').format(now);
    //  print(formattedDate);

   // testing porpose start
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedTime = DateFormat('kk:mm:a').format(now);
    String formattedDate = formatter.format(now);
    print(formattedTime);
    print(formattedDate);

    DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse("2022-02-24 10:25:36");
    String date1 = DateFormat("yyyy-MM-dd hh:mm:ss").format(tempDate);
    String date2 = DateFormat("dd-MM-yyyy ").format(tempDate);

    print(date1);
    print(date2);

    // testing porpose end
  }

  //Timer3
  void addValue() {
    setState(() {
       counter++; 
    });

    print(" add timer "+ counter.toString());
  }


  @override
  void dispose() {

    //Timer4
    timer.cancel();

    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    double width= MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    // void SelectedItem(BuildContext context, item) {
    //   switch (item) {
    //     case 0:
    //       LogoutProcess();
    //       break;
    //     case 1:
    //       exit(0);
    //       break;
        
    //   }
    // }
   
    
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
        ),

        // shape: BeveledRectangleBorder(
        //   borderRadius: BorderRadius.circular(20)
        // ),
        backwardsCompatibility: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: themColor,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light
        ),
  
        backgroundColor: themColor,
        toolbarHeight: height*0.1,
        elevation: 0.0,
        title: Align(
          alignment: Alignment.topLeft,
          child: FittedBox(
            
            child: Padding(
              padding: const EdgeInsets.only(left: 0,top: 0),
              child: Text("Doctor Schedule History",style: TextStyle(fontFamily: 'WorkSans',fontSize: 18,fontWeight: FontWeight.w700,color: Colors.white),),
              
            ),
          ),
        ),

        actions: <Widget>[

          IconButton(
            tooltip: "Refresh here",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorScheduleList()));
            },
            icon: Icon(Icons.refresh,color: Colors.white,),
          ),
          SizedBox(width: 2,), 

          CustomPopupMenu(
            child: Container(
              child: Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 24.0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 20.0,
              ),
            ),
            menuBuilder: () => ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: Colors.white,
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: menuItems
                        .map(
                          (item) => GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){

                              print("Do" +item.title);

                              item.title=="Home" ? Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>BottomNavigationBarPage()))
                              : item.title=="Logout" ? 
                              LogoutProcess() : exit(0);

                              _controller.hideMenu;

                            },
                            
                           
                            child: Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    item.icon,
                                    size: 15,
                                    color: themColor,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        item.title,
                                        style: TextStyle(
                                          color: themColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            pressType: PressType.singleClick,
            verticalMargin: -10,
            controller: _controller,
            barrierColor: Colors.black54,
            horizontalMargin: 0.0,
            arrowColor: Colors.white,
            showArrow: true,
          ),
        ],

        // actions: <Widget>[

        //   IconButton(
        //     tooltip: "Refresh here",
        //     onPressed: () {
        //       getProductDataSource();
        //     },
        //     icon: Icon(Icons.refresh,color: Colors.white,),
        //   ),
        //   SizedBox(width: 2,), 

        //   // IconButton(
        //   //   tooltip: "Search here",
        //   //   onPressed: () {},
        //   //   icon: Icon(Icons.search,color: Colors.white,),
        //   // ),
        //   // SizedBox(width: 2,), 

        //   // IconButton(
        //   //   icon: Icon(Icons.menu,color: Colors.white,),
        //   //   onPressed: () => Scaffold.of(context).openEndDrawer(),
        //   //   tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        //   // ),

        //   // Builder(
        //   //   builder: (context) => Container(
        //   //     height: 30,
        //   //     decoration: BoxDecoration(
        //   //       border: Border.all(
        //   //         color: themGreenColor,
        //   //         width: 2
        //   //       ),
        //   //       color: themColor,
        //   //       borderRadius: BorderRadius.all(Radius.circular(30))
        //   //     ),
        //   //     child: IconButton(
        //   //       icon: Icon(Icons.menu,color: Colors.white,),
        //   //       onPressed: () => Scaffold.of(context).openEndDrawer(),
        //   //       tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        //   //     ),
        //   //   ),
        //   // ),

        //   // Builder(
        //   //   builder: (context) =>  IconButton(
        //   //     icon: Icon(Icons.menu,color: Colors.white,),
        //   //     onPressed: () => Scaffold.of(context).openEndDrawer(),
        //   //     tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        //   //   ),
        //   // ),

        //   SizedBox(width: 2,), 

        //     Padding(
        //       padding: EdgeInsets.only(right: 5),
        //       child: Container(
        //         //height: 30,
        //         // decoration: BoxDecoration(
        //         //   border: Border.all(
        //         //     color: themGreenColor,
        //         //     width: 2
        //         //   ),
        //         //   color: themColor,
        //         //   borderRadius: BorderRadius.all(Radius.circular(30))
        //         // ),

        //         child: PopupMenuButton<int>(
        //           tooltip: "Option Menu",
        //           icon: Icon(Icons.more_vert, color: Colors.white,),
        //           color: Colors.white,
        //           itemBuilder: (context) => [
        //             // PopupMenuItem<int>(
        //             //   value: 0, 
        //             //   child: Text("Logout",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themGreenColor,fontWeight: FontWeight.w800),)
        //             // ),
        //             PopupMenuDivider(),
        //             PopupMenuItem<int>(
        //               value: 0,
        //               child: Row(
        //                 // ignore: prefer_const_literals_to_create_immutables
        //                 children: [
        //                   Icon(
        //                     Icons.logout,
        //                     color: Colors.red,
        //                   ),
        //                   const SizedBox(
        //                     width: 1,
        //                   ),
        //                   Text("Logout",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black45,fontWeight: FontWeight.w800))
        //                 ],
        //               )
        //             ),
        //             PopupMenuDivider(),
        //             PopupMenuItem<int>(
        //               value: 1,
        //               child: Row(
        //                 // ignore: prefer_const_literals_to_create_immutables
        //                 children: [
        //                   Icon(
        //                     Icons.exit_to_app,
        //                     color: Colors.red,
        //                   ),
        //                   const SizedBox(
        //                     width: 1,
        //                   ),
        //                   Text("Exit",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black45,fontWeight: FontWeight.w800))
        //                 ],
        //               )
        //             ),
        //           ],
        //           onSelected: (item) => SelectedItem(context, item),
        //         ),
        //         // child: IconButton(
        //         //   tooltip: "Search here",
        //         //   onPressed: () {},
        //         //   icon: Icon(Icons.search,color: Colors.white,),
        //         // ),
        //       ), 


          
        //      ),

        //     // PopupMenuButton<String>(
        //     //   color: Colors.white,
        //     //   icon: Icon(Icons.more_vert, color: themColor,),
        //     //   onSelected: onSelect,
        //     //   itemBuilder: (BuildContext context) {
        //     //     return myMenuItems.map((String choice) {
        //     //       return PopupMenuItem<String>(
        //     //         child: Text(choice),
        //     //         value: choice,
        //     //       );
        //     //     }).toList();
        //     //   }
        //     // )
        // ],


        
        // leading: IconButton(
        //   icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
        //   onPressed: (){
        //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Service()));
        //    // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Service()));
        //   },
        // ),
      ),

        // endDrawer: SizedBox(
        //   width: MediaQuery.of(context).size.width*0.7,
        //   child: SideDrawer()
        // ),

      body:  NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return false;
        }, 
        child: RefreshIndicator(
          onRefresh: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> DoctorScheduleList())),
          child: FutureBuilder(
            future: getProductDataSource(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              
              return snapshot.hasData
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                
                // child:

                //  DoctorScheduleList.serverStaus==false ?
                //   Center(child: Text(DoctorScheduleList.serverMessage.toString(),style: TextStyle(color: themColor,fontFamily: "WorkSans"),)) :
                
                child: SfDataGrid(source: snapshot.data, columns: getColumns()),
              )
              : const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              );
            },
          ),
        ),
      ),

    );
  }

  Future<ProductDataGridSource> getProductDataSource() async {
    var productList = await generateProductList();
    print("Checking "+productList.toString());
    return ProductDataGridSource(productList);
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
     
      // GridTextColumn(
      //   columnName: 'Lead Id',
      //   width: 70,
      //   label: Container(
      //     padding: const EdgeInsets.all(8),
      //     alignment: Alignment.center,
      //     child: const Text('Lead Id',
      //       overflow: TextOverflow.clip, softWrap: true,style: TextStyle(color: themGreenColor,fontFamily: "Righteous"),)
      //   )
      // ),

      GridTextColumn(
        columnName: 'Doctor Name',
        width: 150,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Icon(Icons.person,color: themBlueColor,),
              Text('Doctor Name',
                overflow: TextOverflow.clip, softWrap: true,
                style: TextStyle(color: themGreenColor,fontFamily: "Righteous")
              ),
            ],
          )
        )
      ),

      GridTextColumn(
        columnName: 'Patient Name',
        width: 180,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Icon(Icons.person,color: themBlueColor,),
              Text('Patient Name',
                overflow: TextOverflow.clip, softWrap: true,style: TextStyle(color: themGreenColor,fontFamily: "Righteous")
              ),
            ],
          ) 
        )
      ),
      

      GridTextColumn(
        columnName: 'Mobile',
        width: 180,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Icon(Icons.phone_android,color: themBlueColor,),
              Text('Mobile',
                overflow: TextOverflow.clip, softWrap: true,
                maxLines: 1,
                style: TextStyle(color: themGreenColor,fontFamily: "Righteous")
              ),
            ],
          ) 
        )
      ),

      GridTextColumn(
        columnName: 'Schedule Date',
        width: 180,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Icon(Icons.calendar_today,color: themBlueColor,),
              Text('Schedule Date',
                overflow: TextOverflow.clip, softWrap: true,style: TextStyle(color: themGreenColor,fontFamily: "Righteous")
              ),
            ],
          ) 
        )
      ),

      GridTextColumn(
        columnName: 'Status',
        width: 150,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Icon(Icons.medical_services,color: themBlueColor,),
              Text('Status',
                overflow: TextOverflow.clip, softWrap: true,style: TextStyle(color: themGreenColor,fontFamily: "Righteous")
              ),
            ],
          ) 
        )
      ),

      GridTextColumn(
        columnName: 'Reject Reason',
        width: 150,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Icon(Icons.no_accounts,color: themBlueColor,),
              Text('Reject Reason',
                overflow: TextOverflow.clip, softWrap: true,style: TextStyle(color: themRedColor,fontFamily: "Righteous")
              ),
            ],
          ) 
        )
      ),

      GridTextColumn(
        columnName: 'Consult',
        width: 120,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Icon(Icons.no_accounts,color: themBlueColor,),
              Text('Consult',maxLines: 2,
                overflow: TextOverflow.clip, softWrap: true,style: TextStyle(color: themGreenColor,fontFamily: "Righteous")
              ),
            ],
          ) 
        )
      ),

    ];
  }

  Map<String, String> queryParams = {
    "Id": Home.userid.toString(),
 
  };

  Future<List<DoctorScheduleListModel>> generateProductList() async {

    String doctorScheduleList_url=doctorAppointmentScheduleListApi;
    var response = await http.get(
      Uri.parse(doctorScheduleList_url).replace(queryParameters: queryParams),
      headers: <String, String>{
        // 'Accept': 'application/json',
        //'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );

    bool res=json.decode(response.body)['status'];
    // // if(res==false){
    //    setState(() {
    //       DoctorScheduleList.serverStaus=res;
    //       DoctorScheduleList.serverMessage=json.decode(response.body)['message'].toString();
    //    });
    // // }

   

    var decodedProducts =
      json.decode(response.body)['docSchedule'].cast<Map<String, dynamic>>();
   
    List<DoctorScheduleListModel> productList = await decodedProducts
      .map<DoctorScheduleListModel>((json) => DoctorScheduleListModel.fromJson(json))
      .toList();
    return productList;
    
  }

  void LogoutProcess() async{
    SharedPreferences loginPrefs = await SharedPreferences.getInstance();
    loginPrefs.clear();
    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>LoginRegistration()));
  }

  void checkingUser() async{

    SharedPreferences loginPrefs = await SharedPreferences.getInstance();
    bool  loginStatus=loginPrefs.getBool("islogedin") ?? false;
    print("userid   >>>>>>>>>>>>>>>>>"+loginStatus.toString());

   
    
    if(loginStatus){

      setState(() {
        Home.userid =loginPrefs.getString("userid").toString();
     
      });

      print("checking .....mmmmmmmmmmmmmmmmmmm "+DoctorScheduleList.userId.toString());
    
      //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DoctorScheduleFromDoctorList()));
      
    }

    else{

      _showDialog(context); 
    
    }

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
            child: Text("Cancel",style: TextStyle(color: Colors.red) ,),
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

class ProductDataGridSource extends DataGridSource {
  ProductDataGridSource(this.productList) {
    buildDataGridRow();
  }
  late List<DataGridRow> dataGridRows;
  late List<DoctorScheduleListModel> productList;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {

   
    return DataGridRowAdapter(cells: [


      // Container(
      //   child: Text(
      //     row.getCells()[0].value.toString(),
      //     overflow: TextOverflow.ellipsis,
      //   ),
      //   alignment: Alignment.center,
      //   padding: const EdgeInsets.all(8.0),
      // ),

      Padding(
        padding: const EdgeInsets.only(left: 1,top: 1,right: 1),
        child: Container(
          color: Colors.indigo[300],
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[0].value,textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,maxLines: 2,
            style: TextStyle(color: Colors.white)
          ),
        ),
      ),

      // Card(
      //   color: themAmberColor,
      //   elevation: 3,
        Padding(
          padding: const EdgeInsets.only(left: 1,top: 1,right: 1),
          child: Container(
            color: Colors.indigo[300],
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 5,right: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(row.getCells()[1].value.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white,fontSize: 18),
                ),
                
              ],
            
            ),
          ),
      //  ),
      ),

      Padding(
        padding: const EdgeInsets.only(left: 1,top: 1,right: 1),
        child: Container(
          color: Colors.indigo[300],
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[2].value.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),


      Padding(
        padding: const EdgeInsets.only(left: 1,top: 1,right: 1),
        child: Container(
          color: Colors.indigo[300],
          alignment: Alignment.center,
          padding: const EdgeInsets.all(2.0),
          child:  Text(DateFormat.yMMMd().add_jm().format(row.getCells()[3].value),maxLines: 1,overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white)),
        ),
      ),

      Padding(
        padding: const EdgeInsets.only(left: 1,top: 1,right: 1),
        child: Container(
          color: Colors.white60,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: 
          row.getCells()[4].value.toString()=="0" 
          ? Text("Processing", maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: themColor,fontWeight: FontWeight.w600))
          : row.getCells()[4].value.toString()=="1"
          ?  Text("Accepted", maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: themGreenColor,fontWeight: FontWeight.w600))
          : row.getCells()[4].value.toString()=="2"
          ?  Text("Rejected", maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600))
          : row.getCells()[4].value.toString()=="3"
          ?  Text("Completed", maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: themBlueColor,fontWeight: FontWeight.w600))
          :  Text("Prescription", maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: themAmberColor,fontWeight: FontWeight.w600))
        )
      ),

      Padding(
        padding: const EdgeInsets.only(left: 1,top: 1,right: 1),
        child: Container(
          color: Colors.indigo[300],
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[5].value.toString()=="null"
            ? ""
            : row.getCells()[5].value.toString()==""
            ? ""
            : row.getCells()[5].value.toString(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white)
          ),
        ),
      ),

      Padding(
        padding: const EdgeInsets.only(left: 1,top: 1,right: 1),
        child: Container(
          color: Colors.white70,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: 
            row.getCells()[4].value.toString()=="0" 
            ?  Icon(Icons.video_call,color: Colors.grey)
            : row.getCells()[4].value.toString()=="1"
            ? InkWell(
              onTap: (){

               
                DoctorScheduleList.channelName = row.getCells()[6].value.toString();
                DoctorScheduleList.callEndId =row.getCells()[7].value.toString();
                print(DoctorScheduleList.channelName.toString());
                Get.to(CallPage());
                //Get.toNamed("/videoCall");
               
              },
              child: Icon(Icons.video_call,color: themBlueColor)
            )
            : row.getCells()[4].value.toString()=="2"
            ?  Icon(Icons.video_call,color: Colors.grey)
            : row.getCells()[4].value.toString()=="3"
            ?  Icon(Icons.video_call,color: Colors.grey)
            :  Icon(Icons.video_call,color: Colors.grey),
           
          ),         
          
          
          
        ),

      ]
      
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = productList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        //DataGridCell(columnName: 'Lead Id', value: dataGridRow.Id),
        DataGridCell<String>(
          columnName: 'Doctor Name', value: dataGridRow.fullName.toString()),
        DataGridCell<String>(
          columnName: 'Patient Name', value: dataGridRow.patientName),
        DataGridCell<String>(
          columnName: 'Mobile', value: dataGridRow.mobileNumber),
        
        DataGridCell<DateTime>(
          columnName: 'Schedule Date', value: dataGridRow.scheduleDate),
        DataGridCell<String>(
          columnName: 'Status', value: dataGridRow.status),
        DataGridCell<String>(
          columnName: 'Reason', value: dataGridRow.rejectionReason),
        DataGridCell<String>(
          columnName: 'Consult', value: dataGridRow.channelName),
        
        DataGridCell<String>(
          columnName: 'Callend', value: dataGridRow.id.toString()),
        
      ]);
    }).toList(growable: false);
  }
}


