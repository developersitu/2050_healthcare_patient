import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Providers/SpecializationProvider.dart';
import 'package:healthcare2050/Screens/BookDoctorPage/OnlineBookDoctorPage.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Specialization extends StatelessWidget {

  static String ? SpecializationId,SpecializationDoctorId,selectedDoctorImage,selectedDoctorName,
  selectedDoctorDesignation,consultType;
  

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
      home: SpecializationScreen(),
    );
  }
}

class SpecializationScreen extends StatefulWidget {
  const SpecializationScreen({ Key? key }) : super(key: key);

  @override
  State<SpecializationScreen> createState() => _SpecializationScreenState();
}

class _SpecializationScreenState extends State<SpecializationScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  var _selected ="";
  var _test = "Full Screen";


  /////ZoneWiseState Start ///////////
  List showSpecializationWiseDoctorList = [];
  
  fetchSpecializationDoctorList() async {

    var showSpecializationDoctorLis_url= specializationWiseDoctorApi;
    var response = await http.post(
      Uri.parse(showSpecializationDoctorLis_url),
      headers: <String,String> {

      },
      body: {
        "SpecializationId" : Specialization.SpecializationId.toString()
        
      }
    );
    // print(response.body);
    if(response.statusCode == 200){

      
      var items = json.decode(response.body) ?? [];

       
     
      print('specialization body ...........................................');
      print(items);

      
      
      if(items!=[]){
        setState(() {
          showSpecializationWiseDoctorList = items;
        
        });

        _openDoctorDialog();

        print("Checking "+showSpecializationWiseDoctorList.toString());

             
      }
      if (items==[]) {
       // scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text(message.toString()))); 
        setState(() {
          showSpecializationWiseDoctorList = [];
        
        });

        scaffoldKey.currentState!.showSnackBar(
          SnackBar(content:Text("No Doctors are Available !!!"),backgroundColor: Colors.red,)
        ); 
      }  
      
      if(showSpecializationWiseDoctorList.length==0){

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

    }else{
      showSpecializationWiseDoctorList = [];
     
    }
  }
  ///// ZoneWiseState Api End ///////////
  
     
     
  // /////StateWiseCity Start ///////////
  // List showStateWiseCityList = [];
  
  // fetchStateWiseCityList() async {

  //  // print("chicking state id "+stateType_dropdown_id.toString());
    
  //   var showStateWiseCityList_url= stateWiseCityApi;
  //   var response = await http.post(
  //     Uri.parse(showStateWiseCityList_url),
  //     headers: <String,String> {

  //     },
  //     body: {
  //       "zoneCityId" : ZonePreference.stateId.toString()
        
  //     }
  //   );
  //   // print(response.body);
  //   if(response.statusCode == 200){
  //     var items = json.decode(response.body)['cityDetails'] ?? [];

  //     bool cityStatus=json.decode(response.body)['status'];
     
  //     print('city body');
  //     print(items);
      
  //     if(cityStatus==true){
  //       setState(() {
  //         showStateWiseCityList = items;

  //         print("checking "+showStateWiseCityList.toString());
        
  //       });

  //       showModalBottomSheet(
  //         backgroundColor: Colors.white,
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(20),
  //             topRight: Radius.circular(20)
  //           )
  //         ),
  //         elevation: 4,
  //         context: context,
  //         builder: (context) {
  //           return Padding(
  //             padding: const EdgeInsets.only(top: 20),
  //             child: ListView.builder(
  //               itemCount: showStateWiseCityList.length,
  //               itemBuilder: (context,index){
  //                 return InkWell(
  //                   onTap: (){
  //                     setState(() {
  //                       ZonePreference.cityId=showStateWiseCityList[index]['Id'].toString();
  //                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CityFacilities()));
  //                     });
  //                   },
  //                   child: Container(
  //                     height: 50,
  //                     color:  Colors.grey[100 * (index % 45)],
  //                     // decoration: BoxDecoration(
  //                     //   // gradient: LinearGradient(
  //                     //   //   begin: Alignment.topRight,
  //                     //   //   end: Alignment.bottomLeft,
  //                     //   //   colors: [
  //                     //   //     Colors.white,
  //                     //   //     Colors.grey,
  //                     //   //   ],
  //                     //   // )
  //                     // ),
  //                     child: Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(left: 10),
  //                         child: Text(showStateWiseCityList[index]['CityName'],textAlign: TextAlign.start,
  //                         style: const TextStyle(
  //                           fontWeight: FontWeight.w800,
  //                           fontSize: 20,color: Colors.black87
  //                         ),),
  //                       ),
  //                     ),
  //                   ),
  //                 );
                    
  //                  // Text( showStateWiseCityList[index]['CityName']);
  //               }
  //             ),
  //           );
  //         }
  //       );
  //     }
  //     if (cityStatus== false) {
  //      // scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text(message.toString()))); 
  //       setState(() {
  //         showStateWiseCityList = [];
        
  //       });
  //     }  
      
  //     if(showStateWiseCityList.length==0){

  //      // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

  //     }

  //   }else{
  //     showStateWiseCityList = [];
     
  //   }
  // }
  // ///// StateWiseCity Api End ///////////


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     final data= Provider.of<SpecializationProvider>(context,listen: false);
    data.fetchSpecialization();
  }


  @override
  Widget build(BuildContext context) {

    final data= Provider.of<SpecializationProvider>(context);

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Our Specializations"),
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

      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return false;
        },
        child: 

         data.isloading==true ? 
        //Center(child: Text("Please Wait...")) :
        Container(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/Logo/logo_gif.gif",width: width*0.2,height: height*0.2,),
              Text("Please Wait...")

            ],
          ),
        ) :
        
        
        SingleChildScrollView(
          
          child: Container(
            height: height,
            width: width,
            //height: height,
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
             // crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Container(
                //   width: width,
                //   height: height*0.3,
                //   //child: Image.asset("assets/images/specialization.jpg"),
                //   decoration: BoxDecoration(
                //     image: DecorationImage(
                //       fit: BoxFit.fill,
                //       image: AssetImage("assets/images/specialization.jpg")
                //     ),
                //   ),

                // ),

                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: FittedBox(
                    
                    child: Text("Please Choose One Of Our Specialization...",textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: themGreenColor,fontWeight: FontWeight.w700,fontSize: 18),)
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Consumer<SpecializationProvider>(
                builder: (context, value, child) => 
        
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 5, mainAxisSpacing: 5),
                  padding: EdgeInsets.all(5),
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: value.specializationList.length,
                  itemBuilder: (BuildContext context,int index){
                      
                    String specialization_name=value.specializationList[index]['SepcializationName'].toString().split('-').join(' ');
                    specialization_name.split('-').join('');
                    return InkWell(
                      onTap: (){
                       //  howZoneWiseStateList.clear();
        
                          setState(() {
                            //showZoneWiseStateList.clear();
                            Specialization.SpecializationId=value.specializationList[index]['SpecializationId'].toString();

                            print(" Specialization.SpecializationId >>>>>>>>>>>>>>>>>>>>>>>>>>>> "+ Specialization.SpecializationId.toString() );
                          });


        
                          fetchSpecializationDoctorList();
        
                          print(Specialization.SpecializationId.toString());
                      },
                      child: Card(
                        color:  Colors.transparent,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                                ),
                              ) ,

                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  width: width,
                                //color: themAmberColor,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(0),
                                    bottomRight: Radius.circular(10))
                                  ),
                            
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    
                                      CircleAvatar(
                                        radius:25.0,
                                        backgroundColor: Colors.transparent,
                                        child: CircleAvatar(
                                          radius: 20.0,
                                          backgroundImage:
                                            NetworkImage("http://101.53.150.64/2050Healthcare/public/speciality/"+value.specializationList[index]['Icon'],),
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                
                                      SizedBox(
                                        height: 10,
                                      ),
                                
                                      Text(specialization_name,textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: themColor,fontWeight: FontWeight.w500,fontSize: 12),)
                                
                                      // Container(
                                      //   width: width,
                                      //   height: height*0.05,
                                      //   color: Colors.white,
                                
                                      // )
                                
                                    ],
                                    
                                  ),
                                
                                ),
                              ), 

                            
                            ],
                            
                          ),
                        ),
                          
                      ),
                    );
                    
                    
                    
                    
                   // Container(
                    //   //child: Text(categoryList![index]['CategoryName'])
                    //   color: Colors.green,
                    //   height: height*0.6,
                    //     // width: 80,
                         
                    //   child: InkWell(
                    //     onTap: ()  async {
        
                    //       //howZoneWiseStateList.clear();
        
                    //       setState(() {
                    //         //showZoneWiseStateList.clear();
                    //         Specialization.SpecializationId=value.specializationList[index]['SpecializationId'].toString();
                    //       });
        
                    //       fetchSpecializationDoctorList();
        
                    //       print(ZonePreference.zoneId.toString());
        
                         
            
        
                    //      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ZoneWiseStatePreference()));
                          
                    //     },
                    //     child: Card(
                    //       color:  Colors.black54,
                    //       elevation: 5,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20.0),
                    //       ),
                    //       child: Column(
                    //         children: [
                    //           Container(
                    //             width: width,
                    //             height: height*0.3,
                    //             decoration: BoxDecoration(
                    //               color: themBlueColor,
                    //               //color: Colors.grey[100 * (index % 5)],
                    //               borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                    //             ),
                               
                    //             child: Padding(
                    //               padding: const EdgeInsets.only(top: 10),
      
      
                    //               child: CircleAvatar(
                    //                       radius:120.0,
                    //                       backgroundColor: Colors.white,
                    //                       // child: CircleAvatar(
                    //                       //   radius: 90.0,
                    //                       //   backgroundImage:
                    //                       //     NetworkImage("http://101.53.150.64/2050Healthcare/public/speciality/"+value.specializationList[index]['Icon']),
                    //                       //   backgroundColor: Colors.transparent,
                    //                       // ),
                    //                     ),
      
      
                    //              // child: Image.network("http://101.53.150.64/2050Healthcare/public/speciality/"+value.specializationList[index]['Icon'],width: 50,height: 50,)
                                  
                                  
        
        
        
                    //             ),
                                
                    //           ),
                    //           Container(
                    //             decoration: BoxDecoration(
                    //               color: themBlueColor,
                    //               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                    //             ),
                    //             height: height*0.06,
                    //             width: width,
                    //             child: Padding(
                    //               padding: const EdgeInsets.only(bottom: 10),
                    //               child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.end,
                    //                 children: [
        
                    //                   // zone_name=="East Zone" ?
                    //                   Text(specialization_name,textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 12),)
                                      
        
                    //                 ]
        
                    //               ),
                    //             ),
        
                    //           )
                    //         ],
                    //       ),
                    //       // child: Column(
                    //       //   mainAxisAlignment: MainAxisAlignment.center,
                    //       //   children: [
                              
                              
                    //       //     SizedBox(
                    //       //       // height: 20,
                    //       //       child: Padding(
                    //       //         padding: const EdgeInsets.only(left: 8,right: 8,top: 2),
                    //       //         //child: FittedBox(
                    //       //           child: Text(zone_name,style: TextStyle(color: Colors.white,fontFamily: 'WorkSans',fontWeight: FontWeight.w900),textAlign: TextAlign.center,)
                    //       //         //),
                    //       //         //child: FittedBox(child: Text(categoryList[index]['CategoryName'].toString(),style: TextStyle(color: Colors.black45,fontFamily: 'WorkSans',fontWeight: FontWeight.w600),)),
                    //       //       ),
                    //       //     )
                              
                    //       //   ],
                    //       // ),
                    //     ),
                    //   ),
                      
                      
                    // );
                  }
                ),
              ),

              ],
              
        
            ),
          ),
        ),
      ),

    
    );
  }

  void _openDoctorDialog() async {

    _selected = (await Navigator.of(context).push(new MaterialPageRoute<String>(
      builder: (BuildContext context) {

        double width= MediaQuery.of(context).size.width;
        double height= MediaQuery.of(context).size.height;

          return StatefulBuilder(
            builder: (context, setState) {

              print("dialog checking "+showSpecializationWiseDoctorList.toString());

              

            //  showSearchHeaderServiceList = searchBody;
            return new Scaffold(
              appBar: new AppBar(
                backgroundColor: themColor,
                title: const Text('Our Doctors'),
                actions: [

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
                child: Container(
                  height: height,
                  width: width,
                  padding: EdgeInsets.only(left: 5,right: 5,top: 20),
                  
                  child: Column(
                    children: [
              
                      
                      Container(

                        height: height*0.77,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          
                        ),
                        
                      
                        child: ListView.builder(
                          itemCount: showSpecializationWiseDoctorList.length,
                          itemBuilder: (context,index){
                            return InkWell(
                              onTap: (){
                                
                              
                              //   ZonePreference.stateId=showSpecializationWiseDoctorList[index]['Id'].toString();
                              //  // fetchStateWiseCityList();
                              //   print(ZonePreference.stateId);
                                
                              //   print("cheking image ");
                              //   print("cheking image "+showSpecializationWiseDoctorList[index]['Image'].toString());
                      
                              },
                              child: ListTile(
                                title: Container(
                                padding: const EdgeInsets.only(left: 5,right: 5),
                                color: Colors.white,
                                width: double.infinity,
                              
                                child: Stack(
                                  children: <Widget>[

                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                    // child: Positioned(
                                        child: Stack(
                                          children: [

                                            Container(
                                              decoration: BoxDecoration(
                                                color: themBlueColor,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              constraints: const BoxConstraints(maxHeight: 180,minHeight: 150),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.all(2.0),
                                              child: Container(
                                              decoration: BoxDecoration(
                                                color: themColor,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              constraints: const BoxConstraints(maxHeight: 180,minHeight: 150),
                                            ),
                                            )

                                          ],
                                          
                                        )
                                    // ),
                                    ),
                                  

                                    Padding(
                                      padding: EdgeInsets.only(top: 25,),
                                      child: Row(
                                        children: [
                                          showSpecializationWiseDoctorList[index]['Image'].toString()=="null" ? 
                                          Container(
                                            width: width*0.3,height: height*0.15,
                                            color: Colors.white,
                                            child: Image.asset("assets/images/no_doctor.png"),
                                          ) :
                                          showSpecializationWiseDoctorList[index]['Image'].toString()==" " ? 
                                          Container(
                                            width: width*0.3,height: height*0.15,
                                            color: Colors.white,
                                            child: Image.asset("assets/images/no_doctor.png"),
                                          ) :

                                          Container(
                                            width: width*0.3,height: height*0.15,
                                            color: themColor,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 1,bottom: 1,left: 2),
                                              child: Container(
                                                child: Image.network('http://101.53.150.64/2050Healthcare/public/doctor/'+showSpecializationWiseDoctorList[index]['Image'],width: width*0.3,height: height*0.15,)
                                              ),
                                            )
                                          )
                                          // Container(
                                          //   child: Stack(
                                          //     children: [
                                          //       Container(
                                          //         width: width,
                                          //         color: Colors.black45,
                                          //       ),

                                          //       Padding(
                                          //         padding: const EdgeInsets.all(1.0),
                                          //         child: Container(
                                          //           width: width,
                                          //           child: Image.network('http://101.53.150.64/2050Healthcare/public/doctor/'+showSpecializationWiseDoctorList[index]['Image'],width: width*0.3,height: height*0.15,)

                                          //         ),
                                          //       )
                                          //     ],

                                          //   ),
                                            
                                          //  // child: Image.network('http://101.53.150.64/2050Healthcare/public/doctor/'+showSpecializationWiseDoctorList[index]['Image'],width: width*0.3,height: height*0.15,)
                                          // ),
                                        ],
                                      )
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 25,left: 150),
                                      child: Column(
                                        children: [

                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(

                                              showSpecializationWiseDoctorList[index]['FullName'].toString()=="null"  ? "FullName Not Available !!" :
                                              showSpecializationWiseDoctorList[index]['FullName'].toString()==" "  ? "FullName Not Available !!" :
                                              
                                              '${showSpecializationWiseDoctorList[index]['FullName']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 20,color: Colors.white
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 5,),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(

                                              showSpecializationWiseDoctorList[index]['Education'].toString()=="null"  ? "Education Not Available !!" :
                                              showSpecializationWiseDoctorList[index]['Education'].toString()==" "  ? "Education Not Available !!" :
                                              
                                              '${showSpecializationWiseDoctorList[index]['Education']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15,color: Colors.white
                                              ),
                                            ),
                                          ),
                                        

                                          const SizedBox(height: 5,),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(

                                              showSpecializationWiseDoctorList[index]['Designation'].toString()=="null"  ? "Designation Not Available !!" :
                                              showSpecializationWiseDoctorList[index]['Designation'].toString()==" "  ? "Designation Not Available !!" :
                                              
                                              '${showSpecializationWiseDoctorList[index]['Designation']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,color: Colors.white
                                              ),
                                            ),
                                          ),
                                        

                                          const SizedBox(height: 5,),

                                          Padding(
                                            padding: EdgeInsets.only(right: 5,left: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [

                                                showSpecializationWiseDoctorList[index]['TeleConsult']==0 ? Container() :
                                                showSpecializationWiseDoctorList[index]['TeleConsult']=="null" ? Container() :
                                                showSpecializationWiseDoctorList[index]['TeleConsult']==1 ?

                                                CircleAvatar(
                                                  backgroundColor: themBlueColor,
                                                  radius: 20,
                                                  child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(Icons.phone_android),
                                                    color: Colors.white,
                                                    onPressed: () async{

                                                      Specialization.consultType="2";
                                                      Specialization.SpecializationDoctorId=showSpecializationWiseDoctorList[index]['Id'].toString();
                                                      Specialization.selectedDoctorImage='http://101.53.150.64/2050Healthcare/public/doctor/'+showSpecializationWiseDoctorList[index]['Image'].toString();
                                                      Specialization.selectedDoctorName=showSpecializationWiseDoctorList[index]['FullName'].toString();
                                                      Specialization.selectedDoctorDesignation=showSpecializationWiseDoctorList[index]['Designation'].toString();
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>OnlineBookDoctorPage(text: "online_consult")));
                                                      //Specialization.SpecializationDoctorId=showSpecializationWiseDoctorList[index]['Id'].toString();
                                                    },
                                                  ),
                                                ):Container(),

                                                showSpecializationWiseDoctorList[index]['VideoConsult']=="0" ? Container() :
                                                showSpecializationWiseDoctorList[index]['VideoConsult']=="null" ? Container() :

                                                showSpecializationWiseDoctorList[index]['VideoConsult']==1 ?

                                                CircleAvatar(
                                                  backgroundColor: themGreenColor,
                                                  radius: 20,
                                                  child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(Icons.video_call),
                                                    color: Colors.white,
                                                    onPressed: () async{

                                                      Specialization.consultType="1";
                                                      Specialization.SpecializationDoctorId=showSpecializationWiseDoctorList[index]['Id'].toString();
                                                      Specialization.selectedDoctorImage='http://101.53.150.64/2050Healthcare/public/doctor/'+showSpecializationWiseDoctorList[index]['Image'].toString();
                                                      Specialization.selectedDoctorName=showSpecializationWiseDoctorList[index]['FullName'].toString();
                                                      Specialization.selectedDoctorDesignation=showSpecializationWiseDoctorList[index]['Designation'].toString();
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>OnlineBookDoctorPage(text: "online_consult")));
                                                     
                                                    },
                                                  ),
                                                ): Container()
                                          
                                                // SizedBox(
                                                //   width: width*0.1,
                                                //   height: height*0.1,
                                                //   child: Center(
                                                //     child: ElevatedButton(
                                                //       onPressed: () {},
                                                //       child: Icon(Icons.phone_android, color: Colors.white),
                                                //       style: ElevatedButton.styleFrom(
                                                //         shape: CircleBorder(),
                                                //         padding: EdgeInsets.all(20),
                                                //         primary: Colors.blue,
                                                //         onPrimary: Colors.black,
                                                //       ),
                                                //     ),
                                                //   ),
                                                // ),
                                          
                                              ],
                                            ),
                                          )

                                         
                                          // InkWell(
                                          //   onTap: () async{

                                          //     SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                                          //     bool  loginStatus=loginPrefs.getBool("islogedin") ?? false;
                                          //     print("userid   >>>>>>>>>>>>>>>>>"+loginStatus.toString());
                                              
                                          //     if(loginStatus){

                                          //       // DoctorSpecializationListCard.doctorId='${map['Id']}';
                                          //       // DoctorSpecializationListCard.doctorName='${map['FullName']}';
                                          //       // DoctorSpecializationListCard.doctorDesignation='${map['Designation']}';
                                          //       // DoctorSpecializationListCard.doctorImage='http://101.53.150.64/2050Healthcare/public/doctor/'+map['Image'];
                                          //       // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DoctorScheduleFromDoctorList()));
                                                
                                          //     }

                                          //     else{

                                          //     //  _showDialog(context); 
                                              
                                          //     }
                                          //   // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>IndexPage()));
                                              
                                            

                                          //   // 



                                            
                                          //   },
                                          //   child: Container(
                                          //     color: Colors.transparent,
                                          //     child: const Align(
                                          //       alignment: Alignment.bottomRight,
                                          //       child: Icon(Icons.video_call_sharp,size: 30,color: themBlueColor,),
                                          //     ),
                                          //   ),
                                          // )
                                        
                                        ],
                                      )
                                    ),

                                  ],
                                ),
                              ),
                                
                                
                               
                                            
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