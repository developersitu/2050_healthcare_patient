import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Providers/ZoneFetchProvider.dart';
import 'package:healthcare2050/Screens/OurPresence/StateWiseCityPreference.dart';
import 'package:healthcare2050/Screens/OurPresence/ZonePreference.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ZoneWiseStatePreference extends StatelessWidget {

  static String ? stateId;
  

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
      home: StateScreen(),
    );
  }
}

class StateScreen extends StatefulWidget {
  const StateScreen({ Key? key }) : super(key: key);

  @override
  State<StateScreen> createState() => _StateScreenState();
}

class _StateScreenState extends State<StateScreen> {

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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchZoneWiseStateList();
  }


  @override
  Widget build(BuildContext context) {

   
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
            decoration: BoxDecoration(
              border: Border.all(
                color: themColor,
              ),
              color: themColor,
              borderRadius: BorderRadius.all(Radius.circular(40))
            ),

            child: IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white),
              onPressed: (){
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

      body: Container(
        width: width,
        height: height,
        child: Center(
          child:  GridView.builder(
           
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 1, mainAxisSpacing: 1),
            padding: EdgeInsets.all(1),
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: showZoneWiseStateList.length,
            itemBuilder: (BuildContext context,int index){
                
              String state_name=showZoneWiseStateList[index]['StateName'].toString().split('-').join(' ');
              state_name.split('-').join('');

              print("array checking...."); 
              List temp=[];
                temp.add(showZoneWiseStateList[index]['StateName'].toString());

                print("array checking....");
                print(temp);

             
                
              return Container(
                //child: Text(categoryList![index]['CategoryName'])
                
                height: height*0.3,
                  // width: 80,
                    
                child: InkWell(
                  onTap: () {

                    setState(() {
                      ZoneWiseStatePreference.stateId=showZoneWiseStateList[index]['Id'].toString();
                    });

                    print(ZoneWiseStatePreference.stateId.toString());

                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StateWiseCityPreference()));
                    
                  },
                  child: Card(
                    color:  Colors.indigo[100 * (index % 45)],
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
                            child: Image.asset("assets/images/finddoctor.png",),
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
                                Text(state_name,textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),),
                                
                              ],
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
    
      
    );
  }
}