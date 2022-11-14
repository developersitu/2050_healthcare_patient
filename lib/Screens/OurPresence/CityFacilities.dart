import 'dart:convert';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthcare2050/Screens/GoogleMap/current_location.dart';
import 'package:healthcare2050/Screens/OurPresence/StateWiseCityPreference.dart';
import 'package:healthcare2050/Screens/OurPresence/ZonePreference.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/constants/constants.dart';

class CityFacilities extends StatelessWidget {
  const CityFacilities({ Key? key }) : super(key: key);

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
      home: CityFacilitiesScreen(),
      
    );
  }
}

class CityFacilitiesScreen extends StatefulWidget {
  //const ({ Key? key }) : super(key: key);

  @override
  State<CityFacilitiesScreen> createState() => _CityFacilitiesScreenState();
}

class _CityFacilitiesScreenState extends State<CityFacilitiesScreen> {

  ///////// fetch zone Start///////////
  List showServiceList = [];
  List showDoctorList = [];
  String ? cityName,address,address1,address2,backgroundImage;
  int ? pincode;
  fetchCityFacilitiesList() async {
    
    var showCityFacilitiesList_url= cityFacilitiesApi;
    var response = await http.post(
      Uri.parse(showCityFacilitiesList_url),
       headers: <String,String> {

      },
      body: {
        "CityId" : ZonePreference.cityId.toString()
        
      }
    );
    // print(response.body);
    if(response.statusCode == 200){
      var status =json.decode(response.body)['status'] ?? false;
      var cityName =json.decode(response.body)['CityName'] ?? "";
      var backgroundImage =json.decode(response.body)['BackgroundImage'] ?? "";
     
       
       

      var serviceItems = json.decode(response.body)['sevicename'] ?? [] ;
      var doctorItems = json.decode(response.body)['doctorDetail'] ?? [] ;


     
      print('showServiceList body');
      print(serviceItems);

      print(cityName);
      
      setState(() {
        this.cityName=cityName.toString();
        showServiceList = serviceItems;
        this.backgroundImage= backgroundImage;
        showDoctorList=doctorItems;
        address =json.decode(response.body)['contact']['Address'] ?? "";
        address1 =json.decode(response.body)['contact']['Address1'] ?? "";
        address2 =json.decode(response.body)['contact']['Address2'] ?? "";
        pincode =json.decode(response.body)['contact']['Pincode'] as int ;
       
      });
      
      if(showServiceList.length==0){

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

      if(showDoctorList.length==0){

      }

    }else{
      showServiceList = [];
      showDoctorList=[];
     
    }
  }
  ///////// fetch zone End///////////



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCityFacilitiesList();
    
  }


  @override
  Widget build(BuildContext context) {

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

   

    return Scaffold(

      body: CustomScrollView(

        slivers: <Widget>[

          SliverAppBar(
            backgroundColor: themColor,
            //pinned: true,
            snap: false,
            pinned: true,
            floating: false,

            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: themColor,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light
            ),
           
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text( cityName== null ? "":cityName.toString(),textAlign: TextAlign.left,style: TextStyle(color: themColor),),
              //background: Image.network("http://101.53.150.64/2050Healthcare/public/city/${backgroundImage}", fit: BoxFit.cover,),
              background: Image.asset("assets/images/citybanner.png", fit: BoxFit.cover,),
            ),
          ),

          // SliverFixedExtentList(
          //   itemExtent: 50,
          //   delegate: SliverChildListDelegate([
          //     Container(color: Colors.red),
          //     Container(color: Colors.green),
          //     Container(color: Colors.blue),
          //   ]),
          // ),

          SliverFillRemaining(
            hasScrollBody: false,
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
                return false;
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5),
                  child: Column(
                    children: [
                        
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("OverView:",style: TextStyle(color: themColor,fontSize: 17,fontWeight: FontWeight.w500),),
                          //  Text("View All",style: TextStyle(fontFamily: 'WorkSans',color: Colors.black45,fontSize: 12,fontWeight: FontWeight.w900),)
                          ],
                        ),
                      ),
                    

                      Text('2050 Healthcare, ${cityName} provides comprehensive and seamless , state of the art healthcare services.'

                      'High quality and excellent service across the people we serve. Putting the patient at the core of our operations and providing holistic treatment to patients.', style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black87),
                      ),

                      Card(
                        color: themColor,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Contact:",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500)),
                                  InkWell(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CurrentLocationScreen()));
                                    },
                                    child: Row(
                                      children: [
                                        Text("Search on Google Map",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500)),
                                        Image.asset("assets/images/location.png",width: 20,height: 20),
                                      ],
                                    ),
                                  )
                                //  Text("View All",style: TextStyle(fontFamily: 'WorkSans',color: Colors.black45,fontSize: 12,fontWeight: FontWeight.w900),)
                                ],
                              ),
                            ),

                            Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 2,),
                                    Icon(Icons.business,color: Colors.white70,size: 15,),
                                    SizedBox(width: 2,),
                                    Expanded(child: Text(address.toString()=="null" ? "":address.toString(),maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: themAmberColor,fontSize: 12,fontWeight: FontWeight.w500)))
                                  ],
                                ),

                                Row(
                                  children: [
                                    SizedBox(width: 2,),
                                    Icon(Icons.business,color: Colors.white70,size: 15,),
                                    SizedBox(width: 2,),
                                    Expanded(child: Text(address1.toString()=="null" ? "":address1.toString(),style: TextStyle(color: themAmberColor,fontSize: 12,fontWeight: FontWeight.w800)))
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 2,),
                                    Icon(Icons.location_city_rounded,color: Colors.white70,size: 15,),
                                    SizedBox(width: 2,),
                                    Expanded(child: Text(address2.toString()=="null" ? "":address2.toString(),style: TextStyle(color: themAmberColor,fontSize: 12,fontWeight: FontWeight.w500)))
                                  ],
                                ),

                                Row(
                                  children: [
                                    SizedBox(width: 2,),
                                    Icon(Icons.maps_home_work,color: Colors.white70,size: 15,),
                                    SizedBox(width: 2,),
                                    Expanded(child: Text(pincode.toString()=="null" ? "":pincode.toString(),style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500)))
                                  ],
                                ),

                                SizedBox(height: 10,)
                                
                              ],

                            ),

                          ],
                        ),

                      ),

                     
                    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Services",style: TextStyle(color: themGreenColor,fontSize: 17,fontWeight: FontWeight.w900),),
                        //  Text("View All",style: TextStyle(fontFamily: 'WorkSans',color: Colors.black45,fontSize: 12,fontWeight: FontWeight.w900),)
                        ],
                      ),
                    
                  
                                            
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          height: height*0.15,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: showServiceList.length,
                            itemBuilder: (BuildContext context,int index){

                              
                            
                              return Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),

                                child: Container(
                                  width: width*0.25,
                                  decoration: BoxDecoration(
                                    color: themColor,
                                  //  border: Border.all(width: 1, color: themColor),
                                  // side: BorderSide(color: Colors.blueGrey, width: 2),
                                    //color: Colors.indigo[100 * (index % 5)],
                                    borderRadius: BorderRadius.circular(20),
                                    ),

                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(

                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      //  border: Border.all(width: 1, color: themColor),
                                      // side: BorderSide(color: Colors.blueGrey, width: 2),
                                        //color: Colors.indigo[100 * (index % 5)],
                                        borderRadius: BorderRadius.circular(20),
                                        ),

                                      
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(1.0),
                                              child: SvgPicture.network("http://101.53.150.64/2050Healthcare/public/category/"+showServiceList[index]['Icon'],width: 20,height: 40,allowDrawingOutsideViewBox: true,color: themColor,),
                                            // child: SvgPicture.network("http://101.53.150.64/2050Healthcare/public/category/"+data.categoryList[index]['Icon'],width: 20,height: 40,allowDrawingOutsideViewBox: true,color: Colors.white,),
                                            )
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child:  Text(showServiceList[index]['CategoryName'].toString().split('-').join(' '),textAlign: TextAlign.center,style: TextStyle(fontSize: 10,fontFamily: "WorkSans",fontWeight: FontWeight.w600),)
                                          )
                                        ],
                                        
                                      )
                                    ),
                                  ),
                                )
                              );

                            }  
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Our Doctors",style: TextStyle(fontFamily: 'WorkSans',color: Colors.black87,fontSize: 17,fontWeight: FontWeight.w900),),
                        //  Text("View All",style: TextStyle(fontFamily: 'WorkSans',color: Colors.black45,fontSize: 12,fontWeight: FontWeight.w900),)
                        ],
                      ),


                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          height: height*0.15,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: showServiceList.length,
                            itemBuilder: (BuildContext context,int index)=>
                            
                              Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),

                                child: Container(
                                  width: width*0.25,
                                  decoration: BoxDecoration(
                                    color: themColor,
                                  //  border: Border.all(width: 1, color: themColor),
                                  // side: BorderSide(color: Colors.blueGrey, width: 2),
                                    //color: Colors.indigo[100 * (index % 5)],
                                    borderRadius: BorderRadius.circular(20),
                                    ),

                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(

                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      //  border: Border.all(width: 1, color: themColor),
                                      // side: BorderSide(color: Colors.blueGrey, width: 2),
                                        //color: Colors.indigo[100 * (index % 5)],
                                        borderRadius: BorderRadius.circular(20),
                                        ),

                                      
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(1.0),
                                              child: Image.network("http://101.53.150.64/2050HealthcareNew/public/doctor/"+showServiceList[index]['Icon'],width: 20,height: 40),
                                            // child: SvgPicture.network("http://101.53.150.64/2050Healthcare/public/category/"+data.categoryList[index]['Icon'],width: 20,height: 40,allowDrawingOutsideViewBox: true,color: Colors.white,),
                                            )
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child:   Text(showDoctorList[index]['FullName'].toString().split('-').join(' '),textAlign: TextAlign.center,style: TextStyle(fontSize: 10,fontFamily: "WorkSans",fontWeight: FontWeight.w600),)
                                          )
                                        ],
                                        
                                      )
                                    ),
                                  ),
                                )
                            ),
                          ),
                        ),
                      ),
                
                    ] 
                  ),
                )   
              ),
            ),
          )

          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (context, index) {
          //       return Container(
          //         height: 50,
          //         alignment: Alignment.center,
          //         color: Colors.orange[100 * (index % 9)],
          //         child: Text(showZoneTypeList[index]['ZoneName']),
          //       );
          //     },
          //     childCount: showZoneTypeList.length,
          //   ),
          // ),

          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (context, index) {
          //       return Container(
          //         height: 50,
          //         alignment: Alignment.center,
          //         color: Colors.orange[100 * (index % 9)],
          //         child: Text(showZoneTypeList[index]['ZoneName']),
          //       );
          //     },
          //     childCount: showZoneTypeList.length,
          //   ),
          // ),

          // SliverGrid(
            
          //   delegate: SliverChildBuilderDelegate(
          //     (context, index) {
          //       return Container(
          //         alignment: Alignment.center,
          //         color: Colors.teal[100 * (index % 5)],
          //         child: Text(showZoneTypeList[index]['ZoneName']),
          //       );
          //     },
          //     childCount: showZoneTypeList.length,
              
          //   ),
          //   // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //   //   maxCrossAxisExtent: 200.0,
          //   //   mainAxisSpacing: 10.0,
          //   //   crossAxisSpacing: 10.0,
          //   //   childAspectRatio: 4.0,
          //   // ),
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     mainAxisSpacing: 10,
          //     crossAxisSpacing: 10,
          //     childAspectRatio: 1.0,
          //   ),
          // ),

        ],

      ),
      
    );
    
  }
}