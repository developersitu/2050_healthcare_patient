import 'dart:convert';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Model/SearchDoctorListModel/SearchDoctorListModel.dart';
import 'package:healthcare2050/Model/SearchHeaderListModel/SearchHeaderListModel.dart';
import 'package:healthcare2050/Screens/Doctors/AllDoctorsList.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';

class SearchHeaderList extends StatelessWidget {
  const SearchHeaderList({ Key? key }) : super(key: key);

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

  final serachController=TextEditingController();
 
  List showSearchList = [];

  Future<SearchHeaderListModel> searchListProcess() async {
   // const searchList_url= doctorSearchApi;
    final http.Response response = await http.post(
      Uri.parse("http://101.53.150.64/2050Healthcare/public/api/auth/headerSearch"),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },

      body: {
        "search": serachController.text.toString()
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

      return SearchHeaderListModel.fromJson(json.decode(response.body));
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

      // appBar: AnimSearchBar(
      //   width: 400,
      //   textController: textController,
      //   onSuffixTap: () {
      //     setState(() {
      //       textController.clear();
      //     });
      //   },
      // ),

      // appBar: AppBar(
      //     toolbarHeight: 0,
      //    // backwardsCompatibility: false,
      //     systemOverlayStyle: const SystemUiOverlayStyle(
      //       statusBarColor: Colors.transparent,
      //       statusBarBrightness: Brightness.light,
      //       statusBarIconBrightness: Brightness.light
      //     ),

      //     elevation: 0,
      //     backgroundColor: themColor,
      //   //  title: Text("Register Here...",style: TextStyle(color: Colors.black45,fontWeight: FontWeight.w200,fontSize: 20,fontFamily: 'Ubuntu')),
      //   ),


      appBar: AppBar(
        backgroundColor: themColor,
          // The search area here
        title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          // child: AnimSearchBar(
          //   width: 400,
          //   textController: serachController,
          //   prefixIcon:Icon(Icons.search,color: Colors.black,),
          //   onSuffixTap: () {
          //     setState(() {
          //       serachController.clear();
          //     });
          //   },
          // ),
          child: TextFormField(
            autofocus: true,
            controller: serachController,                
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              //border: OutlineInputBorder(),
              border: InputBorder.none,
              // enabledBorder: myinputborder(),
              // focusedBorder: myfocusborder(),
               
               // prefixIcon: Icon(Icons.search),
                // helperText: "Search Doctor Names and Departments ",
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
                hintText: 'Search...',
               
              ),
            ),
          ),
        )
      ),
      
      
        
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return false;
        }, 
        child: SingleChildScrollView(
      
          child: Column(
            children: [

              // Padding(
              //   padding: const EdgeInsets.only(left: 10,right: 10),
              //   child: AnimSearchBar(
                  
              //     width: width,
              //     textController: serachController,
              //     onSuffixTap: () {
              //       setState(() {
              //         serachController.clear();
              //       });
              //     },
              //   ),
              // ),
             
      
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   height: MediaQuery.of(context).size.height,
              //   color: themColor,
      
              //   child: Align(
              //     alignment: Alignment.topCenter,
              //     child: Padding(
              //       padding: const EdgeInsets.only(top: 10,left: 10,bottom: 10),
              //       child: Container(
              //         child: Row(
              //           children: [
        
      
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
      
              Padding(
                padding: const EdgeInsets.only(top: 0),
                
                child: Container(
                  width: width,
                  height: height*0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0)),
                    color: Colors.white,
                  ),
      
                  child: 
                  
                  showSearchList.length==0 ?

                  Center(
                    child: Text("Please Wait...."),
                  ) :
                  
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: ListView.builder(
                      itemCount: showSearchList.length,
                      itemBuilder: (context,index){
                        return ListTile(
                          title: 
                  
                          Container(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            color: Colors.white,
                            width: double.infinity,
                          
                            child: Stack(
                              children: <Widget>[
      
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                // child: Positioned(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: themColor,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      constraints: const BoxConstraints(maxHeight: 180,minHeight: 150),
                                    )
                                // ),
                                ),
                              
      
                                Padding(
                                  padding: EdgeInsets.only(top: 25,),
                                  child: Row(
                                    children: [
                                      showSearchList[index]['Image'].toString()=="null" ? 
                                      Container(
                                        width: width*0.3,height: height*0.15,
                                        color: Colors.white,
                                        child: Image.asset("assets/images/no_doctor.png"),
                                      ) :
                                      showSearchList[index]['Image'].toString()==" " ? 
                                      Container(
                                        width: width*0.3,height: height*0.15,
                                        color: Colors.white,
                                        child: Image.asset("assets/images/no_doctor.png"),
                                      ) :
                                      Image.network('http://101.53.150.64/2050Healthcare/public/doctor/'+showSearchList[index]['Image'],width: width*0.3,height: height*0.15,),
                                    ],
                                  )
                                ),
      
                                Padding(
                                  padding: const EdgeInsets.only(top: 25,left: 160),
                                  child: Column(
                                    children: [
      
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
      
                                          showSearchList[index]['FirstName'].toString()=="null"  ? "FirstName Not Available !!" :
                                          showSearchList[index]['FirstName'].toString()==" "  ? "FirstName Not Available !!" :
                                          
                                          '${showSearchList[index]['FirstName']}',
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
      
                                          showSearchList[index]['Education'].toString()=="null"  ? "Education Not Available !!" :
                                          showSearchList[index]['Education'].toString()==" "  ? "Education Not Available !!" :
                                          
                                          '${showSearchList[index]['Education']}',
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
      
                                          showSearchList[index]['Designation'].toString()=="null"  ? "Designation Not Available !!" :
                                          showSearchList[index]['Designation'].toString()==" "  ? "Designation Not Available !!" :
                                          
                                          '${showSearchList[index]['Designation']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,color: Colors.white
                                          ),
                                        ),
                                      ),
                                    
      
                                      const SizedBox(height: 5,),
                                  
                                    
                                    ],
                                  )
                                ),
      
                              ],
                            ),
                          ),
      
                        );
                      }
                    ),
                  ),
                ),
              ),
      
              Container(
                height: height*0.05,
                width: width,
                color: Colors.transparent,
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>BottomNavigationBarPage()));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.home,color: themColor,),
                            Text("Home",style: TextStyle(color: themColor,fontFamily: "WorkSans",fontSize: 16),)
                          ],
                        ),
                      ),
      
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AllDoctorListPage()));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.keyboard_arrow_left,color: themColor,),
                            Text("Back",style: TextStyle(color: themColor,fontFamily: "WorkSans",fontSize: 16),)
                          ],
                        ),
                      ),
                     
                    ],
                   
                  ),
                ),
              )
              
            ],
          ),
        ),
      ),


      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){},
      //   child: Icon(Icons.search),
            
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,


      
    );
  }

  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return const OutlineInputBorder( //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(
          color: Colors.indigo,
          width: 10,
        )
    );
  }

  OutlineInputBorder myfocusborder(){
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(
          color: themColor,
          width: 3,
        )
    );
  }
}