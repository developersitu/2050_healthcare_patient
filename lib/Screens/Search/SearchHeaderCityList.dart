import 'dart:convert';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Model/HeaderSearchModel/HeaderSearchServiceModel.dart';
import 'package:healthcare2050/Model/SearchDoctorListModel/SearchDoctorListModel.dart';
import 'package:healthcare2050/Model/SearchHeaderListModel/SearchHeaderListModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:clay_containers/clay_containers.dart';


class SearchHeaderCityList extends StatelessWidget {
  const SearchHeaderCityList({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchDoctorListScreen(),
    );
  }
}

class SearchDoctorListScreen extends StatefulWidget {
  const SearchDoctorListScreen({ Key? key }) : super(key: key);

  @override
  State<SearchDoctorListScreen> createState() => _SearchDoctorListScreenState();
}

class _SearchDoctorListScreenState extends State<SearchDoctorListScreen> {

  Color baseColor = Color(0xFFf2f2f2);

  final serachController=TextEditingController();
 
  List showSearchList = [];

  Future<HeaderSearchServiceModel> searchListProcess() async {
   // const searchList_url= doctorSearchApi;
    final http.Response response = await http.post(
       Uri.parse("http://101.53.150.64/2050Healthcare/public/api/auth/CityheaderSearch"),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },

      body: {
       "CitySearch": serachController.text.toString()
      },
      // body: {
      //   'email': email,
      //   'password': password,
      // }
    );
    
    if (response.statusCode == 200) {

      final searchBody=json.decode(response.body)  ?? [];
    // print("searchBody >>>>>>>>>>>>>>>>> "+searchBody);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;
      setState(() {
        showSearchList = searchBody;
        
        
      });

      
      
      print('Search list');
      print(showSearchList);

      return HeaderSearchServiceModel.fromJson(json.decode(response.body));
    } else {

      showSearchList= [];
    
      // Fluttertoast.showToast(
      //   msg: "Please Check Mobile No",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      //   fontSize: 16.0
      // );

      throw Exception('Failed to create search body album.');
    }
  }



  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serachController.addListener(searchListProcess);



  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    serachController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    //final data = Provider.of<SearchDoctorListProvider>(context);


    return Scaffold(
      

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: themColor,
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: false,
            title: Text('Search Item'),
            // actions: [
            //   IconButton(
            //     icon: Icon(Icons.shopping_cart),
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //   ),
            // ],
            bottom: AppBar(
              backgroundColor: themColor,
              title: Container(
                
                width: double.infinity,
                height: 40,
                color: Colors.white,
                child: Center(
                  child: TextFormField(
                    controller: serachController,
                    decoration: InputDecoration(
                    hintText: 'Search Our City here..',
                    // border: OutlineInputBorder(),
                    border: InputBorder.none,
                    // enabledBorder: myinputborder(),
                    // focusedBorder: myfocusborder(),
               
                    // prefixIcon: Icon(Icons.search),
                    //helperText: "Search Doctor Names and Departments ",
                    prefixIcon: Icon(Icons.search,color: themColor,),
          
                    suffixIcon: serachController.text.isEmpty
                    ? null
                    : InkWell(
                        onTap: () => serachController.clear(),
                        child: Icon(Icons.clear,color: Colors.red,),
                      ),
                      // suffixIcon: IconButton(
                      //   icon: Icon(Icons.clear),
                      //   onPressed: () {
                      //     /* Clear the search field */
                      //   },
                      // ),
                    // hintText: 'Search...',
                        // prefixIcon: Icon(Icons.search),
                        // suffixIcon: Icon(Icons.camera_alt)
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Other Sliver Widgets
          SliverList(
          
            delegate: SliverChildListDelegate([

              

              showSearchList.length==0 ?

              Container(
                color: Colors.white,
                width: width,
                height: height,
                child: Center(child: Image.asset("assets/images/search.gif"))
              ) :

              
              
                  
            
              Container(

                height: height,
                child: ListView.builder(
                  itemCount: showSearchList.length,
                  itemBuilder: (context,index){

                    
                    return ListTile(
                      title: 

                      Column(
                        children: [
                          // Container( 
                          //   width: width-100,
                          //   height: 50,
                          //   margin: EdgeInsets.all(10),
                          //   decoration: BoxDecoration( //decoration for the outer wrapper
                          //     color: Colors.deepOrangeAccent,
                          //     borderRadius: BorderRadius.circular(30), //border radius exactly to ClipRRect
                          //     boxShadow:[ 
                          //       BoxShadow(
                          //         color: Colors.grey.withOpacity(0.5), //color of shadow
                          //         spreadRadius: 5, //spread radius
                          //         blurRadius: 7, // blur radius
                          //         offset: Offset(0, 2), // changes position of shadow
                          //         //first paramerter of offset is left-right
                          //         //second parameter is top to down
                          //       ),
                          //       //you can set more BoxShadow() here
                          //     ],
                          //   ) ,
                          //   child: ClipRRect( //to clip overflown positioned containers.
                          //     borderRadius: BorderRadius.circular(30),
                          //     //if we set border radius on container, the overflown content get displayed at corner.
                          //     child:Container( 
                    
                          //       child: Stack(
                          //         children: <Widget>[ //Stack helps to overlap widgets
                          //           Positioned( //positioned helps to position widget wherever we want.
                          //             top:-20, left:-50, //position of the widget
                          //             child:Container( 
                          //                 height:250,
                          //                 width:250,
                          //                 decoration:BoxDecoration(
                          //                   shape:BoxShape.circle,
                          //                   color:Colors.orange.withOpacity(0.5) //background color with opacity
                          //                 )
                          //             )
                          //           ),
                    
                          //           Positioned(
                          //             left:-80,top:-50,
                          //             child:Container( 
                          //                 height:180,
                          //                 width:180,
                          //                 decoration:BoxDecoration(
                          //                   shape:BoxShape.circle,
                          //                   color:Colors.redAccent.withOpacity(0.5)
                          //                 )
                          //             )
                          //           ),
                    
                          //           Positioned(  //main content container postition.
                          //             child: Container(
                          //               height:250,
                          //               alignment: Alignment.center,
                          //               child: Text(
                    
                          //                 showSearchList[index]['CityName'].toString()=="null"  ? "City Not Available !!" :
                          //                 showSearchList[index]['CityName'].toString()==" "  ? "City Not Available !!" :
                                                
                          //                 '${showSearchList[index]['CityName']}', textAlign: TextAlign.center,
                          //                 style: const TextStyle(
                          //                   fontWeight: FontWeight.w800,
                          //                   fontSize: 20,color: Colors.white
                          //                 ),
                          //               ),
                          //             ),
                          //           )
                          //         ],
                          //       )
                          //     ),
                          //   ),
                          // ),


                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                            child: Container(
                              height: 50,
                              width: width,
                              decoration: BoxDecoration(
                                color: themColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(50))
                              ),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Spacer(),
                                  Container(
                                   // color: themAmberColor,
                                    width: width*0.7,
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(Icons.location_city,color: Colors.white60,),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Text(
                                                          
                                            showSearchList[index]['CityName'].toString()=="null"  ? "City Not Available !!" :
                                            showSearchList[index]['CityName'].toString()==" "  ? "City Not Available !!" :
                                                  
                                            '${showSearchList[index]['CityName'].split('-').join('')}', textAlign: TextAlign.left,maxLines:2,overflow: TextOverflow.ellipsis,
                                            
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 20,color: themAmberColor
                                            ),
                                          ),
                                        ),
                                      ],
                                      
                                    ),
                                  ),
                                  FloatingActionButton(
                                    backgroundColor: Colors.white30,
                                    onPressed: (){},
                                    child: Icon(Icons.arrow_forward),
                                    shape: RoundedRectangleBorder(),
                                    splashColor: Colors.white,
                                    //shape: CircleBorder(),
                                  )
                                 
                                ],
                                 
                              ),
                            ),
                          ),

                        ],
                        
                      ),
             
                    );
                  }
                ),
              ),
                
                
                  
                
              ]
            ),
          ),
        ],
      ),


      // appBar: AppBar(
      //   backgroundColor: themColor,
      //     // The search area here
      //   title: Container(
      //   width: double.infinity,
      //   height: 40,
      //   decoration: BoxDecoration(
      //     color: Colors.white, borderRadius: BorderRadius.circular(5)
      //   ),
      //   child: Center(
      //     child: TextFormField(
      //       autofocus: true,
      //       controller: serachController,                
      //       keyboardType: TextInputType.text,
      //       decoration: InputDecoration(
      //         border: OutlineInputBorder(),
      //          //border: InputBorder.none
      //         enabledBorder: myinputborder(),
      //         focusedBorder: myfocusborder(),
               
      //          // prefixIcon: Icon(Icons.search),
      //           // helperText: "Search Doctor Names and Departments ",
      //               prefixIcon: Icon(Icons.search,color: themColor,),
          
      //               suffixIcon: serachController.text.isEmpty
      //               ? null
      //               : InkWell(
      //                   onTap: () => serachController.clear(),
      //                   child: Icon(Icons.clear,color: Colors.red,),
      //                 ),
      //           // suffixIcon: IconButton(
      //           //   icon: Icon(Icons.clear),
      //           //   onPressed: () {
      //           //     /* Clear the search field */
      //           //   },
      //           // ),
      //           hintText: 'Search...',
               
      //         ),
      //       ),
      //     ),
      //   )
      // ),
      
      
        
      // body: SingleChildScrollView(
       

      //   child: Column(
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
      //         child: Container(
      //           width: width,
      //          // height: height*0.07,
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(30),
      //             //color: themColor
      //           ),
                
      //           child: TextFormField(
      //             autofocus: true,
      //             controller: serachController,                
      //             keyboardType: TextInputType.text,
                  
      //             autofillHints: [AutofillHints.name],
      //             cursorColor: themColor,
                
          
      //             // validator: (val){
      //             //   if(val.isEmpty){
      //             //     return "field can't be empty";
      //             //   }
      //             //   // else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)){
      //             //   //   return "Enter a valid email address";
      //             //   // }
      //             //   return null;
      //             // },
      //             // validator: (value) {
      //             //   if (value.isEmpty || 
      //             //     !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      //             //     .hasMatch(value))  {
      //             //     return 'This field is required';
      //             //   }
      //             // },
      //             decoration: InputDecoration(
      //               //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      //               border: OutlineInputBorder(),
      //               enabledBorder: myinputborder(),
      //               focusedBorder: myfocusborder(),
      //               hintText: "Search here...",
      //               fillColor: Colors.white,
      //               helperText: "Search Doctor Names and Departments ",
      //               prefixIcon: Icon(Icons.search,color: themColor,),
          
      //               suffixIcon: serachController.text.isEmpty
      //               ? null
      //               : InkWell(
      //                   onTap: () => serachController.clear(),
      //                   child: Icon(Icons.clear,color: Colors.red,),
      //                 ),
      //               // labelText: "Email",
      //             )  
                  
      //           ),
                
      //         ),
      //       ),

      //       // Container(
      //       //   width: MediaQuery.of(context).size.width,
      //       //   height: MediaQuery.of(context).size.height,
      //       //   color: themColor,

      //       //   child: Align(
      //       //     alignment: Alignment.topCenter,
      //       //     child: Padding(
      //       //       padding: const EdgeInsets.only(top: 10,left: 10,bottom: 10),
      //       //       child: Container(
      //       //         child: Row(
      //       //           children: [
      

      //       //           ],
      //       //         ),
      //       //       ),
      //       //     ),
      //       //   ),
      //       // ),

      //       Padding(
      //         padding: const EdgeInsets.only(top: 10),
              
      //         child: Container(
      //           width: MediaQuery.of(context).size.width,
      //           height: MediaQuery.of(context).size.height*0.8,
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0)),
      //             color: Colors.white,
      //           ),

      //           child: Padding(
      //             padding: EdgeInsets.only(top: 20),
      //             child: ListView.builder(
      //               itemCount: showSearchList.length,
      //               itemBuilder: (context,index){
      //                 return ListTile(
      //                   title: 
                
      //                   Container(
      //                     padding: const EdgeInsets.only(left: 5,right: 5),
      //                     color: Colors.white,
      //                     width: double.infinity,
                        
      //                     child: Stack(
      //                       children: <Widget>[

      //                         Padding(
      //                           padding: const EdgeInsets.only(left: 30),
      //                         // child: Positioned(
      //                             child: Container(
      //                               decoration: BoxDecoration(
      //                                 color: themColor,
      //                                 borderRadius: BorderRadius.circular(10.0),
      //                               ),
      //                               constraints: const BoxConstraints(maxHeight: 180,minHeight: 150),
      //                             )
      //                         // ),
      //                         ),
                            

      //                         Padding(
      //                           padding: EdgeInsets.only(top: 25,),
      //                           child: Row(
      //                             children: [
      //                               showSearchList[index]['Image'].toString()=="null" ? 
      //                               Container(
      //                                 width: width*0.3,height: height*0.15,
      //                                 color: Colors.white,
      //                                 child: Image.asset("assets/images/no_doctor.png"),
      //                               ) :
      //                               showSearchList[index]['Image'].toString()==" " ? 
      //                               Container(
      //                                 width: width*0.3,height: height*0.15,
      //                                 color: Colors.white,
      //                                 child: Image.asset("assets/images/no_doctor.png"),
      //                               ) :
      //                               Image.network('http://101.53.150.64/2050Healthcare/public/doctor/'+showSearchList[index]['Image'],width: width*0.3,height: height*0.15,),
      //                             ],
      //                           )
      //                         ),

      //                         Padding(
      //                           padding: const EdgeInsets.only(top: 25,left: 160),
      //                           child: Column(
      //                             children: [

      //                               Align(
      //                                 alignment: Alignment.topLeft,
      //                                 child: Text(

      //                                   showSearchList[index]['FirstName'].toString()=="null"  ? "FirstName Not Available !!" :
      //                                   showSearchList[index]['FirstName'].toString()==" "  ? "FirstName Not Available !!" :
                                        
      //                                   '${showSearchList[index]['FirstName']}',
      //                                   style: const TextStyle(
      //                                     fontWeight: FontWeight.w800,
      //                                     fontSize: 20,color: Colors.white
      //                                   ),
      //                                 ),
      //                               ),

      //                               const SizedBox(height: 5,),
      //                               Align(
      //                                 alignment: Alignment.topLeft,
      //                                 child: Text(

      //                                   showSearchList[index]['Education'].toString()=="null"  ? "Education Not Available !!" :
      //                                   showSearchList[index]['Education'].toString()==" "  ? "Education Not Available !!" :
                                        
      //                                   '${showSearchList[index]['Education']}',
      //                                   style: const TextStyle(
      //                                     fontWeight: FontWeight.w800,
      //                                     fontSize: 15,color: Colors.white
      //                                   ),
      //                                 ),
      //                               ),
                                  

      //                               const SizedBox(height: 5,),
      //                               Align(
      //                                 alignment: Alignment.topLeft,
      //                                 child: Text(

      //                                   showSearchList[index]['Designation'].toString()=="null"  ? "Designation Not Available !!" :
      //                                   showSearchList[index]['Designation'].toString()==" "  ? "Designation Not Available !!" :
                                        
      //                                   '${showSearchList[index]['Designation']}',
      //                                   style: const TextStyle(
      //                                     fontWeight: FontWeight.w400,
      //                                     fontSize: 12,color: Colors.white
      //                                   ),
      //                                 ),
      //                               ),
                                  

      //                               const SizedBox(height: 5,),
                                
                                  
      //                             ],
      //                           )
      //                         ),

      //                       ],
      //                     ),
      //                   ),

      //                 );
      //               }
      //             ),
      //           ),
      //         ),
      //       ),
            
      //     ],
      //   ),
      // ),


      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){},
      //   child: Icon(Icons.search),
            
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,


      
    );
  }

  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return const OutlineInputBorder( //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(2)),
      borderSide: BorderSide(
          color: Colors.indigo,
          width: 1,
        )
    );
  }

  OutlineInputBorder myfocusborder(){
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      borderSide: BorderSide(
          color: themColor,
          width: 2,
        )
    );
  }
}