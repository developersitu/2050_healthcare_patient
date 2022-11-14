import 'dart:convert';
import 'dart:io';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare2050/Model/HeaderSearchModel/HeaderSearchServiceModel.dart';
import 'package:healthcare2050/Providers/DoctorsListProvider.dart';
import 'package:healthcare2050/Screens/BookNow/BookNow.dart';
import 'package:healthcare2050/Screens/Bookings/BookingHistory.dart';
import 'package:healthcare2050/Screens/Doctors/AllDoctorsList.dart';
import 'package:healthcare2050/Screens/Doctors/DoctorScheduleList.dart';
import 'package:healthcare2050/Screens/Home/HomeNew.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistration.dart';
import 'package:healthcare2050/Screens/OurPresence/OurPresence.dart';
import 'package:healthcare2050/Screens/OurPresence/ZonePreference.dart';
import 'package:healthcare2050/Screens/Profile/ProfilePage.dart';
import 'package:healthcare2050/Screens/RequestAService/RequestAservice.dart';
import 'package:healthcare2050/Screens/Search/SearchHeaderCityList.dart';
import 'package:healthcare2050/Screens/Search/SearchHeaderServiceList.dart';
import 'package:healthcare2050/Screens/Service/Service.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../GoogleMap/current_location.dart';




class BottomNavigationBarPage extends StatelessWidget {
  const BottomNavigationBarPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigationBarScreen(),
    );
  }
}

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({ Key? key }) : super(key: key);

  @override
  _BottomNavigationBarScreenState createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {

 

  int _currentIndex = 0;
  late PageController _pageController;
  var searchBody;
 
  


  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => exit(0),
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  //////////// Search Service Header Start///////////
  var _selected ="";
  var _test = "Full Screen";
  final serachHeaderServiceController=TextEditingController();
 
  List showSearchHeaderServiceList = [];

  Future<HeaderSearchServiceModel> searchListHeaderServiceListProcess() async {
   // const searchList_url= doctorSearchApi;
    final http.Response response = await http.post(
      Uri.parse("http://101.53.150.64/2050Healthcare/public/api/auth/headerSearch"),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },

      body: {
        "search": serachHeaderServiceController.text.toString()
      },
      // body: {
      //   'email': email,
      //   'password': password,
      // }
    );
    
    if (response.statusCode == 200) {

       
    // print("searchBody >>>>>>>>>>>>>>>>> "+searchBody);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;
      setState(() {
        searchBody=json.decode(response.body)  ?? [];
        showSearchHeaderServiceList = searchBody;
        
      });
      
      print('Search list');
      print(showSearchHeaderServiceList);

      return HeaderSearchServiceModel.fromJson(json.decode(response.body));
    } else {

      showSearchHeaderServiceList= [];
    
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
  ////////////Search Service Header End///////////

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
    serachHeaderServiceController.addListener(searchListHeaderServiceListProcess);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
     _pageController.dispose();
     serachHeaderServiceController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
    
        floatingActionButton: FloatingActionButton(
          onPressed: () {
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
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: new Icon(Icons.person),
                        title: new Text('Our Doctors'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangeNotifierProvider(
                            create: (context)=> DoctorListProvider(),
                            child: AllDoctorListPage())));
                        },
                      ),
                
                      ListTile(
                        leading: new Icon(Icons.person),
                        title: new Text('Profile'),
                        onTap: () async{

                          SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                          bool  loginStatus=loginPrefs.getBool("islogedin") ?? false;
                          bool  bookNowStatus=loginPrefs.getBool("isBookNow") ?? false;
                          print("userid   >>>>>>>>>>>>>>>>>"+loginStatus.toString());
                          
                          if(loginStatus){

                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfilePage(name: '',)));
                            // if(bookNowStatus){
                            //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BookNowHistory()));
                            // }

                            // else{
                            //    _showDialogNoRecords(context); 
                            // }
                          }

                          else {

                            _showLoginDialog(context); 
                          
                          }
                        },
                      ),
                
                      ListTile(
                        leading: new Icon(Icons.location_city_rounded),
                        title: new Text('Our Presence'),
                        onTap: () {
                         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ZonePreference()));
                            
                        },
                      ),
                
                      ListTile(
                        leading: new Icon(Icons.location_city_rounded),
                        title: new Text('Search Us'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CurrentLocationScreen()));
                            
                        },
                      ),
                      ListTile(
                        leading: new Icon(Icons.medical_services),
                        title: new Text('Search by Service'),
                        subtitle: new Text('Search here by service'),
                        onTap: () {
                
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchHeaderServiceList()));
                
                         // SearchHeaderServiceList
                
                          //_openDialog();
                         // Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: new Icon(Icons.medical_services),
                        title: new Text('Request Service'),
                        subtitle: new Text('request service here.'),
                        onTap: () async{


                          SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                          bool  loginStatus=loginPrefs.getBool("islogedin") ?? false;
                          bool  bookNowStatus=loginPrefs.getBool("isBookNow") ?? false;
                          print("userid   >>>>>>>>>>>>>>>>>"+loginStatus.toString());
                          
                          if(loginStatus){

                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RequestAservice()));
                            // if(bookNowStatus){
                            //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BookNowHistory()));
                            // }

                            // else{
                            //    _showDialogNoRecords(context); 
                            // }
                          }

                          else {

                            _showLoginDialog(context); 
                          
                          }
                
                          
                
                         // SearchHeaderServiceList
                
                          //_openDialog();
                         // Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: new Icon(Icons.location_city),
                        title: new Text('Search by City'),
                        subtitle: new Text('Search here by city'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchHeaderCityList()));
                        },
                      ),
                      // ListTile(
                      //   leading: new Icon(Icons.share),
                      //   title: new Text('Share'),
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      // ),
                    ],
                  ),
                );
              }
            );
          },
          tooltip: "Get More Options",
          child: Icon(Icons.more_vert, color: themColor,size: 30),
          elevation: 4.0,
          backgroundColor: Colors.white,
        ),


        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
       
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              Home(),
              Service(),

              DoctorScheduleList(),
              
              // Container(color: Colors.red,),
              // Container(color: Colors.green,),
              // Container(color: Colors.blue,),
            ],
          ),
    
          
        ),
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: Colors.white,
          selectedIndex: _currentIndex,
          
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              activeColor: Colors.indigo,
              title: Text('Home'),
              icon: Icon(Icons.home,color: themColor,)
            ),
            BottomNavyBarItem(
              activeColor: Colors.indigo,
              title: Text('Services'),
              icon: Icon(Icons.medical_services,color: themColor,)
            ),
            BottomNavyBarItem(
              activeColor: Colors.indigo,
              title: Text('Bookings'),
              icon: Icon(Icons.history,color: themColor,)
            ),
            BottomNavyBarItem(
              activeColor: Colors.white,
              title: Text(''),
              icon: Icon(Icons.more_vert,color: Colors.white),
            ),
          ],
        )
        
      ),
    );
  }

  void _openDialog() async {

    _selected = (await Navigator.of(context).push(new MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {

              showSearchHeaderServiceList = searchBody;
            return new Scaffold(
              appBar: new AppBar(
                title: const Text('Full Screen Dialog'),
                actions: [
                  new ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop("hai");
                      },
                      child: new Text('ADD',
                          style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  children: [

                    TextFormField(
                    controller: serachHeaderServiceController,
                    decoration: InputDecoration(
                    hintText: 'Search Doctor Names and Departments',
                    // border: OutlineInputBorder(),
                    border: InputBorder.none,
                    // enabledBorder: myinputborder(),
                    // focusedBorder: myfocusborder(),
               
                    // prefixIcon: Icon(Icons.search),
                    //helperText: "Search Doctor Names and Departments ",
                    prefixIcon: Icon(Icons.search,color: themColor,),
          
                    suffixIcon: serachHeaderServiceController.text.isEmpty
                    ? null
                    : InkWell(
                        onTap: () => serachHeaderServiceController.clear(),
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

                Container(
                height: 600,
                child: ListView.builder(
                  itemCount: showSearchHeaderServiceList.length,
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
                                padding: const EdgeInsets.only(top: 25,left: 160),
                                child: Column(
                                  children: [

                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(

                                        showSearchHeaderServiceList[index]['SubcategoryName'].toString()=="null"  ? "Item Not Available !!" :
                                        showSearchHeaderServiceList[index]['SubcategoryName'].toString()==" "  ? "FirstName Not Available !!" :
                                        
                                        '${showSearchHeaderServiceList[index]['SubcategoryName']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20,color: Colors.white
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 5,),
                                    // Align(
                                    //   alignment: Alignment.topLeft,
                                    //   child: Text(

                                    //     showSearchList[index]['Education'].toString()=="null"  ? "Education Not Available !!" :
                                    //     showSearchList[index]['Education'].toString()==" "  ? "Education Not Available !!" :
                                        
                                    //     '${showSearchList[index]['Education']}',
                                    //     style: const TextStyle(
                                    //       fontWeight: FontWeight.w800,
                                    //       fontSize: 15,color: Colors.white
                                    //     ),
                                    //   ),
                                    // ),
                                  

                                    const SizedBox(height: 5,),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(

                                        showSearchHeaderServiceList[index]['SubcategoryName'].toString()=="null"  ? "Designation Not Available !!" :
                                        showSearchHeaderServiceList[index]['SubcategoryName'].toString()==" "  ? "Designation Not Available !!" :
                                        
                                        '${showSearchHeaderServiceList[index]['SubcategoryName']}',
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


  void _showLoginDialog(BuildContext context) {
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
            child: Text("Cancel",style: TextStyle(color: Colors.red),),
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



  


  

  
  
