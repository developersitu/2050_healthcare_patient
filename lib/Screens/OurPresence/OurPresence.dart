import 'dart:convert';
import 'package:healthcare2050/Screens/OurPresence/CityFacilities.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/constants/constants.dart';

class OurPresence extends StatelessWidget {
  const OurPresence({ Key? key }) : super(key: key);

 static String ? cityName;

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
      home: OurPresenceScreen(),
      
    );
  }
}

class OurPresenceScreen extends StatefulWidget {
  //const ({ Key? key }) : super(key: key);

  @override
  State<OurPresenceScreen> createState() => _OurPresenceScreenState();
}

class _OurPresenceScreenState extends State<OurPresenceScreen> {

//r final _dropdownFormKey = GlobalKey<FormState>();


  String ? zoneType_dropdown_id;
  String ? stateType_dropdown_id;
  String ? cityType_dropdown_id;


  ///////// fetch zone Start///////////
  List showZoneTypeList = [];
  fetchZoneList() async {
    
    var showZoneList_url= zoneApi;
    var response = await http.get(
      Uri.parse(showZoneList_url),
    );
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body) ?? [] ;
     
      print('Zone body');
      print(items);
      
      setState(() {
        showZoneTypeList = items;
       
      });
      
      if(showZoneTypeList.length==0){

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

    }else{
      showZoneTypeList = [];
     
    }
  }
  ///////// fetch zone End///////////

  /////ZoneWiseState Start ///////////
  List showZoneWiseStateList = [];
  
  fetchZoneWiseStateList() async {

    print("chicking state id "+stateType_dropdown_id.toString());
    
    var showZoneWiseStateList_url= zoneWiseStateApi;
    var response = await http.post(
      Uri.parse(showZoneWiseStateList_url),
      headers: <String,String> {

      },
      body: {
        "zoneStateId" : zoneType_dropdown_id.toString()
        
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
        "zoneCityId" : stateType_dropdown_id.toString()
        
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
    fetchZoneList();
  }


  @override
  Widget build(BuildContext context) {

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    Widget _zoneDropDown(){
      return  Padding(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: Container(
          height: 70.0,
          width: MediaQuery.of(context).size.width-10,
         
          child: DropdownButtonFormField<String>(
            
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down_circle,color: Colors.black54,size: 30,),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
               border: OutlineInputBorder(
                  borderSide: BorderSide(color: themColor, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white70,

              contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 15),
             // labelText: "Zone",
              floatingLabelBehavior: FloatingLabelBehavior.always,
             
              // enabledBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.red)
              // )
            ),
            dropdownColor: Colors.white,
            
            value: zoneType_dropdown_id,
            hint: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Text('Please Choose Our Zone',style: TextStyle(fontFamily: 'RaleWay',fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black38)),
            ),
            
            validator: (value) => value == null ? 'Zone is required' : null,
            // onChanged: (itemid) =>
            //     setState(() => callStatus_dropdown_item = itemid),
            onChanged: (itemid) =>
              setState(() {
                zoneType_dropdown_id = itemid;
                stateType_dropdown_id=null;
                cityType_dropdown_id=null;
                print("zone id "+ zoneType_dropdown_id.toString());
                //showZoneWiseStateList.clear();
                //showStateWiseCityList.clear();

                
                fetchZoneWiseStateList();
              }),
                
            
            items: showZoneTypeList.map((list) {
              return DropdownMenuItem(
                value: list['ZoneId'].toString(),
                child: FittedBox(child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(list['ZoneName'].toString() ,style: TextStyle(color: themColor, fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 16),),
                )),
              );
            }).toList(),
            // items:
            //   ['common', 'Bank',].map<DropdownMenuItem<String>>((String value) {
            //   return DropdownMenuItem<String>(
            
            //     value: value,
            //     child: FittedBox(child: Padding(
            //       padding: EdgeInsets.only(left: 0),
            //       child: Text(value,style: TextStyle(fontFamily: 'RaleWay',fontSize: 18,fontWeight: FontWeight.w800,color: Colors.black54),))
            //     ),
            //   );
            // }).toList(),
          ),
        ),
      );
    }


    Widget _zoneWiseStateDropDown(){
      return  Padding(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: Container(
          height: 70.0,
          width: MediaQuery.of(context).size.width-10,
         
          child: DropdownButtonFormField<String>(
            
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down_circle,color: Colors.black54,size: 30,),
            decoration: InputDecoration(

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: themColor, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white70,


              contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 15),
              //labelText: "State",
              floatingLabelBehavior: FloatingLabelBehavior.always,
             

              // enabledBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.black54)
              // )
            ),

            dropdownColor: Colors.white,
            
            value: stateType_dropdown_id,
            hint: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Text('Please Choose State',style: TextStyle(fontFamily: 'RaleWay',fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black38)),
            ),
            // onChanged: (itemid) =>
            //     setState(() => callStatus_dropdown_item = itemid),
            onChanged: (itemid) =>
              setState(() {
                stateType_dropdown_id = itemid;
               // zoneType_dropdown_id=null;
                cityType_dropdown_id=null;
              //  stateType_dropdown_id=null;
                //showZoneWiseStateList.clear();
                //showStateWiseCityList.clear();
                fetchStateWiseCityList();
                print("STATE id "+ stateType_dropdown_id.toString());
              }),
                
                
            validator: (value) => value == null ? 'State is required' : null,
            items: showZoneWiseStateList.map((list) {
              return DropdownMenuItem(
                value: list['Id'].toString(),
                child: FittedBox(child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(list['StateName'].toString() ,style: TextStyle(color: Color(0xff454f63), fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 16),),
                )),
              );
            }).toList(),
            // items:
            //   ['common', 'Bank',].map<DropdownMenuItem<String>>((String value) {
            //   return DropdownMenuItem<String>(
            
            //     value: value,
            //     child: FittedBox(child: Padding(
            //       padding: EdgeInsets.only(left: 0),
            //       child: Text(value,style: TextStyle(fontFamily: 'RaleWay',fontSize: 18,fontWeight: FontWeight.w800,color: Colors.black54),))
            //     ),
            //   );
            // }).toList(),
          ),
        ),
      );
    }

    Widget _stateWiseCityDropDown(){
      return  Padding(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: Container(
          height: 70.0,
          width: MediaQuery.of(context).size.width-10,
         
          child: DropdownButtonFormField<String>(
            
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down_circle,color: Colors.black54,size: 30,),
            decoration: InputDecoration(

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: themColor, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white70,

              contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 15),
            //  labelText: "City",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              
              // enabledBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.black54)
              // )
            ),
            
            value: cityType_dropdown_id,
            hint: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Text('Please Choose City',style: TextStyle(fontFamily: 'RaleWay',fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black38)),
            ),
            // onChanged: (itemid) =>
            //     setState(() => callStatus_dropdown_item = itemid),
            onChanged: (itemid) =>
              setState(() {
                cityType_dropdown_id = itemid;

               // OurPresence.cityName=list['CityName'].toString()
               
                Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => CityFacilities()));
              
                print("city id "+ cityType_dropdown_id.toString());
              }),
                


            dropdownColor: Colors.white,
                
            validator: (value) => value == null ? 'City is required' : null,
            items: showStateWiseCityList.map((list) {
              return DropdownMenuItem(
                value: list['Id'].toString(),
                child: FittedBox(child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(list['CityName'].toString() ,style: TextStyle(color: Color(0xff454f63), fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 16),),
                )),
              );
            }).toList(),
            // items:
            //   ['common', 'Bank',].map<DropdownMenuItem<String>>((String value) {
            //   return DropdownMenuItem<String>(
            
            //     value: value,
            //     child: FittedBox(child: Padding(
            //       padding: EdgeInsets.only(left: 0),
            //       child: Text(value,style: TextStyle(fontFamily: 'RaleWay',fontSize: 18,fontWeight: FontWeight.w800,color: Colors.black54),))
            //     ),
            //   );
            // }).toList(),
          ),
        ),
      );
    }

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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Column(
            children: [

              Align(
                alignment: Alignment.topLeft,
                child: Text("Please Select Zone",style: TextStyle(fontFamily: "WorkSans", fontSize: 18,fontWeight: FontWeight.w700,color: themColor),)
              ),

              SizedBox(height: 10,),

              
              _zoneDropDown(),
              Align(
                alignment: Alignment.topLeft,
                child: Text("Please Select State",style: TextStyle(fontFamily: "WorkSans", fontSize: 18,fontWeight: FontWeight.w700,color: themColor),)
              ),

              SizedBox(height: 10,),


              
              _zoneWiseStateDropDown(),

              Align(
                alignment: Alignment.topLeft,
                child: Text("Please Select City",style: TextStyle(fontFamily: "WorkSans", fontSize: 18,fontWeight: FontWeight.w700,color: themColor),)
              ),

              SizedBox(height: 10,),

              _stateWiseCityDropDown(),

              // ElevatedButton(
              //   onPressed: () {
              //     if (_dropdownFormKey.currentState!.validate()) {
              //       //valid flow
              //     }
              //   },
              //   child: Text("Submit")
              // )
       



            ],
          ),
        ),
      ),


      
    );

  
      
    
  }
}