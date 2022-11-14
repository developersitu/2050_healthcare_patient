import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Providers/ZoneFetchProvider.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/OurPresence/CityFacilities.dart';
import 'package:healthcare2050/Screens/OurPresence/ZoneWiseStatePreference.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ZonePreference extends StatelessWidget {

  static String ? zoneId,stateId,cityId;
  

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
      home: ZoneScreen(),
    );
  }
}

class ZoneScreen extends StatefulWidget {
  const ZoneScreen({ Key? key }) : super(key: key);

  @override
  State<ZoneScreen> createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<ZoneScreen> {

   int count=0;
   List<String> temp=[];

  var _selected ="";
  var _test = "Full Screen";


  /////ZoneWiseState Start ///////////
  List showZoneWiseStateList = [];
  
  fetchZoneWiseStateList() async {

    var showZoneWiseStateList_url= zoneWiseStateApi;
    var response = await http.post(
      Uri.parse(showZoneWiseStateList_url),
      headers: <String,String> {

      },
      body: {
        "zoneStateId" : ZonePreference.zoneId.toString()
        
      }
    );
    // print(response.body);
    if(response.statusCode == 200){

      
      var items = json.decode(response.body)['stateDetails'] ?? [];

      bool stateStatus=json.decode(response.body)['status'];    
     
      print('state body');
      print(items);
      
      if(stateStatus==true){
        setState(() {
          showZoneWiseStateList = items;
        
        });

         _openDialog();

        print("Checking "+showZoneWiseStateList.toString());
             
      }
      if (stateStatus==false) {
       // scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text(message.toString()))); 
        setState(() {
          showZoneWiseStateList = [];
        
        });
      }  
      
      if(showZoneWiseStateList.length==0){

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

    }else{
      showZoneWiseStateList = [];
     
    }
  }
  ///// ZoneWiseState Api End ///////////
  
     
     
  /////StateWiseCity Start ///////////
  List showStateWiseCityList = [];
  
  fetchStateWiseCityList() async {

   // print("chicking state id "+stateType_dropdown_id.toString());
    
    var showStateWiseCityList_url= stateWiseCityApi;
    var response = await http.post(
      Uri.parse(showStateWiseCityList_url),
      headers: <String,String> {

      },
      body: {
        "zoneCityId" : ZonePreference.stateId.toString()
        
      }
    );
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['cityDetails'] ?? [];

      bool cityStatus=json.decode(response.body)['status'];
     
      print('city body');
      print(items);
      
      if(cityStatus==true){
        setState(() {
          showStateWiseCityList = items;

          print("checking "+showStateWiseCityList.toString());
        
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
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                itemCount: showStateWiseCityList.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      setState(() {
                        ZonePreference.cityId=showStateWiseCityList[index]['Id'].toString();
                         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CityFacilities()));
                      });
                    },
                    child: Container(
                      height: 50,
                      color:  Colors.grey[100 * (index % 45)],
                      // decoration: BoxDecoration(
                      //   // gradient: LinearGradient(
                      //   //   begin: Alignment.topRight,
                      //   //   end: Alignment.bottomLeft,
                      //   //   colors: [
                      //   //     Colors.white,
                      //   //     Colors.grey,
                      //   //   ],
                      //   // )
                      // ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(showStateWiseCityList[index]['CityName'],textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,color: Colors.black87
                          ),),
                        ),
                      ),
                    ),
                  );
                    
                   // Text( showStateWiseCityList[index]['CityName']);
                }
              ),
            );
          }
        );
      }
      if (cityStatus== false) {
       // scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text(message.toString()))); 
        setState(() {
          showStateWiseCityList = [];
        
        });
      }  
      
      if(showStateWiseCityList.length==0){

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

    }else{
      showStateWiseCityList = [];
     
    }
  }
  ///// StateWiseCity Api End ///////////


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     final data= Provider.of<ZoneFetchProvider>(context,listen: false);
    data.fetchZone();
  }


  @override
  Widget build(BuildContext context) {

    final data= Provider.of<ZoneFetchProvider>(context);

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Our Presences"),
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
                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>BottomNavigationBarPage()));
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
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

      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          child: Center(
            child:  Consumer<ZoneFetchProvider>(
              builder: (context, value, child) => 
      
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 2, mainAxisSpacing: 2),
                padding: EdgeInsets.all(1),
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: value.zoneList.length,
                itemBuilder: (BuildContext context,int index){
                    
                  String zone_name=value.zoneList[index]['ZoneName'].toString().split('-').join(' ');
                  zone_name.split('-').join('');

                  
                    temp.insert(count, zone_name);

                    count=count+1;


                    print("array cneck");

                    print(temp);

                 
             
                  return Container(
                    //child: Text(categoryList![index]['CategoryName'])
                    
                    height: height*0.3,
                      // width: 80,
                       
                    child: InkWell(
                      onTap: ()  async {
      
                        //howZoneWiseStateList.clear();
      
                        setState(() {
                          //showZoneWiseStateList.clear();
                          ZonePreference.zoneId=value.zoneList[index]['ZoneId'].toString();
                        });
      
                        fetchZoneWiseStateList();
      
                        print(ZonePreference.zoneId.toString());
      
                       
          
      
                       // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ZoneWiseStatePreference()));
                        
                      },
                      child: Card(
                        color:  Colors.indigoAccent[100 * (index % 45)],
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.grey[100 * (index % 5)],
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                              ),
                              height: height*0.15,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: 
                                zone_name=="East Zone" ?
                                Image.asset("assets/images/east_transparent.png",) :
                                zone_name=="West Zone" ?
                                Image.asset("assets/images/west_transparent.png",) :
                                zone_name=="North Zone" ?
                                Image.asset("assets/images/north_transparent.png",) :
                                Image.asset("assets/images/south_transparent.png",)
                                
      
      
      
                              ),
                              
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                              ),
                              height: height*0.07,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
      
                                    // zone_name=="East Zone" ?
                                    // Text(zone_name,textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),) :
                                    zone_name=="West Zone" ?
                                    Text(zone_name,textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15),) :
                                
                                    zone_name=="North Zone" ?
                                    Text(zone_name,textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15),) :
                                    Text(zone_name,textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),) 
      
                                  ]
      
                                ),
                              ),
      
                            )
                          ],
                        ),
                        // child: Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                            
                            
                        //     SizedBox(
                        //       // height: 20,
                        //       child: Padding(
                        //         padding: const EdgeInsets.only(left: 8,right: 8,top: 2),
                        //         //child: FittedBox(
                        //           child: Text(zone_name,style: TextStyle(color: Colors.white,fontFamily: 'WorkSans',fontWeight: FontWeight.w900),textAlign: TextAlign.center,)
                        //         //),
                        //         //child: FittedBox(child: Text(categoryList[index]['CategoryName'].toString(),style: TextStyle(color: Colors.black45,fontFamily: 'WorkSans',fontWeight: FontWeight.w600),)),
                        //       ),
                        //     )
                            
                        //   ],
                        // ),
                      ),
                    ),
                    
                    
                  );
                }
              ),
            ),
      
          ),
        ),
      ),

    
    );
  }

  void _openDialog() async {

    _selected = (await Navigator.of(context).push(new MaterialPageRoute<String>(
        builder: (BuildContext context) {

          double width= MediaQuery.of(context).size.width;
          double height= MediaQuery.of(context).size.height;

          return StatefulBuilder(
            builder: (context, setState) {

              print("dialog checking "+showZoneWiseStateList.toString());

            //  showSearchHeaderServiceList = searchBody;
            return new Scaffold(
              appBar: new AppBar(
                backgroundColor: themColor,
                title: const Text('Our States'),
                actions: [
                  new ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop("hai");
                      },
                      child: new Text('Back',
                          style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
              body: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return false;
                }, 
                child: Container(
                  height: height,
                  width: width,
                  padding: EdgeInsets.only(left: 5,right: 5,top: 20),
                  
                  child: Column(
                    children: [
              
                      
                      Container(

                        height: height*0.8,
                        width: width,
                        
                      
                        child: ListView.builder(
                          itemCount: showZoneWiseStateList.length,
                          itemBuilder: (context,index){
                            return InkWell(
                              onTap: (){
                                
                              
                                ZonePreference.stateId=showZoneWiseStateList[index]['Id'].toString();
                                fetchStateWiseCityList();
                                print(ZonePreference.stateId);
                      
                              },
                              child: ListTile(
                                title: Container(
                                  height: height*0.05,
                                  color:  Colors.grey[100 * (index % 45)],
                                  // decoration: BoxDecoration(
                                  //   // gradient: LinearGradient(
                                  //   //   begin: Alignment.topRight,
                                  //   //   end: Alignment.bottomLeft,
                                  //   //   colors: [
                                  //   //     Colors.white,
                                  //   //     Colors.grey,
                                  //   //   ],
                                  //   // )
                                  // ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(showZoneWiseStateList[index]['StateName'],textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,color: Colors.black87
                                      ),),
                                    ),
                                  ),
                                )
                                
                                
                               
                                            
                              // Container(
                              //   padding: const EdgeInsets.only(left: 5,right: 5),
                              //   color: Colors.white,
                              //   width: double.infinity,
                              
                              //   child: Stack(
                              //     children: <Widget>[
                                        
                              //       Padding(
                              //         padding: const EdgeInsets.only(left: 30),
                              //       // child: Positioned(
                              //           child: Container(
                              //             decoration: BoxDecoration(
                              //               color: themColor,
                              //               borderRadius: BorderRadius.circular(10.0),
                              //             ),
                              //             constraints: const BoxConstraints(maxHeight: 180,minHeight: 150),
                              //           )
                              //       // ),
                              //       ),
                                  
                                        
                                  
                                        
                              //       Padding(
                              //         padding: const EdgeInsets.only(top: 25,left: 160),
                              //         child: Column(
                              //           children: [
                                        
                              //             Align(
                              //               alignment: Alignment.topLeft,
                              //               child: Text(
                                        
                              //                 showZoneWiseStateList[index]['StateName'],
                              //                 style: const TextStyle(
                              //                   fontWeight: FontWeight.w800,
                              //                   fontSize: 20,color: Colors.white
                              //                 ),
                              //               ),
                              //             ),
                                        
                              //             const SizedBox(height: 5,),
                              //             // Align(
                              //             //   alignment: Alignment.topLeft,
                              //             //   child: Text(
                                        
                              //             //     showSearchList[index]['Education'].toString()=="null"  ? "Education Not Available !!" :
                              //             //     showSearchList[index]['Education'].toString()==" "  ? "Education Not Available !!" :
                                              
                              //             //     '${showSearchList[index]['Education']}',
                              //             //     style: const TextStyle(
                              //             //       fontWeight: FontWeight.w800,
                              //             //       fontSize: 15,color: Colors.white
                              //             //     ),
                              //             //   ),
                              //             // ),
                                        
                                        
                                        
                                      
                                        
                              //           ],
                              //         )
                              //       ),
                                        
                              //     ],
                              //   ),
                              // ),
                                        
                            ),
                        );
                        }
                    ),
                  ),
                        
                      // DropdownSearch<String>(
                      //   //mode of dropdown
                      //   mode: Mode.DIALOG,
                      //   //to show search box
                      //   showSearchBox: true,
                      //  // showSelectedItem: true,
                      //   //list of dropdown items
                      //   items: [
                      //     "India",
                      //     "USA",
                      //     "Brazil",
                      //     "Canada",
                      //     "Australia",
                      //     "Singapore"
              
                      //   ],
                      //   label: "Country",
                      //   onChanged: print,
                      //   //show selected item
                      //   selectedItem: "India",
                      // )
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.of(context).pop();
                      //   },
                      //   child: Text('Full Screen',
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      // )
                    ],
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
}