import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Providers/BookAppointmentProvider.dart';
import 'package:healthcare2050/Screens/BookDoctorPage/OfflineBookDoctorPage.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class BookAppointment extends StatelessWidget {
  const BookAppointment({ Key? key }) : super(key: key);

  static String ? cityId,specializationId,doctorId,selectedDoctorImage,selectedDoctorName,
  selectedDoctorDesignation;

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
      home: BookAppointmentScreen()
    );
  }
}

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({ Key? key }) : super(key: key);

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {

  final CarouselController _carouselController = CarouselController();

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  int  _currentPosition=0;
  dynamic _selectedIndex = {};

  var _selected ="";
  var _test = "Full Screen";


  /////City Wise Specialization Start ///////////
  List showCityWiseSpecializationList = [];
  
  fetchSpecializationBasedOnCityList() async {
    var response = await http.post(
      Uri.parse(cityBasedSpecializationApi.toString()),
      headers: <String,String> {

      },
      body: {

        "CityId" : BookAppointment.cityId.toString()
        
      }
    );
    // print(response.body);
    if(response.statusCode == 200){

      
      var items = json.decode(response.body)['SpecializationName'] ?? [];

      bool stateStatus=json.decode(response.body)['status'];    
     
      print('city based specialization body');
      print(items);

      setState(() {
        showCityWiseSpecializationList = items;
        
      });
      
      if(stateStatus==true){
        setState(() {
          showCityWiseSpecializationList = items;
        
        });

        print("Checking "+showCityWiseSpecializationList.toString());
             
      }
      if (stateStatus==false) {
       // scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text(message.toString()))); 
        setState(() {
          showCityWiseSpecializationList = [];
        
        });
      }  
      
      if(showCityWiseSpecializationList.length!=0){

        _openCityBasedSpecializationDialog();

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

      if(showCityWiseSpecializationList.length==0){

        ScaffoldMessenger.of(context).showSnackBar(
          
          SnackBar(content: new Text("No Specializations Available !!!"),backgroundColor: Colors.red,)
          
        );
      

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

    }else{
      showCityWiseSpecializationList = [];
     
    }
  }
  ///// City Wise Specialization Api End ///////////
  

  
  ///// Specialization Wise Doctor Start ///////////
  List showSpecializationWiseDoctorList = [];
  
  fetchDoctorsBasedOnSpecializationList() async {
    var response = await http.post(
      Uri.parse(specializationBasedDoctorsApi.toString()),
      headers: <String,String> {

      },
      body: {

        "specialId" : BookAppointment.specializationId.toString(),  
        "cityId" : BookAppointment.cityId.toString()
        
      }
    );
    // print(response.body);
    if(response.statusCode == 200){

      
      var items = json.decode(response.body) ?? [];

     
     
      print('specialization based doctor body');
      print(items);

      setState(() {
        showSpecializationWiseDoctorList = items;
        
      });
      
     
     
      
      if(showSpecializationWiseDoctorList.length!=0){

         _openSpecializatioBasedDoctorsDialog();

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

      if(showSpecializationWiseDoctorList.length==0){

          ScaffoldMessenger.of(context).showSnackBar(
            
            SnackBar(content: new Text("No Doctors Available !!!"),backgroundColor: Colors.red,)
          );

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

    }else{
      showSpecializationWiseDoctorList = [];
     
    }
  }
  ///// Specialization Wise Doctor Api End ///////////



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final dataCity= Provider.of<BookAppointmentProvider>(context,listen: false);
    dataCity.fetchCity();
    
   
  }

  @override
  Widget build(BuildContext context) {

    final data= Provider.of<BookAppointmentProvider>(context);

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;


    return Scaffold(

      appBar: AppBar(
        title: const Text("Book Appointment"),
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
            width: width,
            height: height,
            child: Center(
              child:  Consumer<BookAppointmentProvider>(
                builder: (context, value, child) => 

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      width: width,
                      child: Text("-: View All Our Cities :-",textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themColor,fontWeight: FontWeight.w800,fontSize: 20),),
                    ),

                    SizedBox(
                      height: 10,
                    ),


                    Container(
                              
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          height: height*0.4,
                          aspectRatio: 16 / 9,
                          initialPage: 0,
                          viewportFraction: 0.60,
                          pauseAutoPlayOnTouch: true,
                          enableInfiniteScroll: true,
                          enlargeCenterPage: true,
                          autoPlayAnimationDuration: const Duration(milliseconds: 1),
                          autoPlay: true,
                          pageSnapping: true,
                          
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentPosition = index;
                              
                            });
                          }
                        ),
                        items: value.cityList.map((itemIndex) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                  
                                  print(itemIndex['Id'].toString());

                                  setState(() {
                                    BookAppointment.cityId=itemIndex['Id'].toString();
                                  });

                                  fetchSpecializationBasedOnCityList();

                                },
                                child: AnimatedContainer(
                                  
                                  duration: const Duration(milliseconds: 300),
                                  width: MediaQuery.of(context).size.width,
                  
                                  decoration: BoxDecoration(
                                    color: themColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(40)
                                    ),
                  
                                    border: Border.all(
                                      color: themGreenColor,
                                      width: 2.0,
                                      style: BorderStyle.solid
                                    ),
                  
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: themGreenColor,
                                    //     blurRadius: 9.0,
                                    //   ),
                                    // ]
                                    
                                  ),
                                
                  
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: height*0.2,
                                          margin: const EdgeInsets.all(10),
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Image.network("http://101.53.150.64/2050Healthcare/public/city/"+itemIndex['Icon'],color: themGreenColor,
                                            fit: BoxFit.contain
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          itemIndex['CityName'].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),

                                       
                                      
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } ).toList()
                     
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: value.cityList.map((url) {
                        int index = value.cityList.indexOf(url);

                      
                        return Container(
                          width: 15.0,
                          height: 10.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPosition == index
                              ? themGreenColor
                              : Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                        );
                      }).toList(),
                    ),

                    Container(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            
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
                                return NotificationListener<OverscrollIndicatorNotification>(
                                  onNotification: (overscroll) {
                                    overscroll.disallowGlow();
                                    return false;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                    
                                          Container(
                                            width: width,
                                            child: Text("View All Our Cities..",textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themColor,fontWeight: FontWeight.w800,fontSize: 15),),
                                          ),
                                          
                                          GridView.builder(
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 2, mainAxisSpacing: 2),
                                            padding: EdgeInsets.all(1),
                                            shrinkWrap: true,
                                            physics: BouncingScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemCount: value.cityList.length,
                                            itemBuilder: (BuildContext context,int index){
                                                
                                              String city_name=value.cityList[index]['CityName'].toString().split('-').join(' ');
                                              city_name.split('-').join('');
                                              return Container(
                                                //child: Text(categoryList![index]['CategoryName'])
                                                
                                                height: height*0.3,
                                                  // width: 80,
                                                  
                                                child: InkWell(
                                                  onTap: ()  async {
                                                                
                                                    //howZoneWiseStateList.clear();
                                                                
                                                    setState(() {
                                                      //showZoneWiseStateList.clear();
                                                      BookAppointment.cityId= value.cityList[index]['Id'].toString();
                                                    });
                                                                
                                                    fetchSpecializationBasedOnCityList();
                                                                
                                                    print(BookAppointment.cityId.toString());
                                                                
                                                  },
                                                  child: Card(
                                                  // color:  Colors.indigoAccent[100 * (index % 45)],
                                                    elevation: 8,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(0.0),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: width,
                                                          decoration: BoxDecoration(
                                                            //color: Colors.grey[100 * (index % 5)],
                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(0))
                                                          ),
                                                          height: height*0.15,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 20),
                                                            child: Image.network("http://101.53.150.64/2050Healthcare/public/city/"+value.cityList[index]['Icon'],color: themGreenColor,)
                                                                
                                                          ),
                                                          
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                    
                                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(0))
                                                          ),
                                                          height: height*0.06,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(bottom: 10),
                                                            child:  Text(city_name,textDirection: TextDirection.ltr,textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: themColor,fontWeight: FontWeight.w500,fontSize: 15),) 
                                                          ),
                                                                
                                                        )
                                                      ],
                                                    ),
                                                
                                                  ),
                                                ),
                                                
                                                
                                              );
                                            }
                                          ),
                                        ]
                                      ),
                                    ),
                                                    
                                  ),
                                );
                              }
                            );
                          },
                          child: Text("View All",textAlign: TextAlign.right,style: TextStyle(color: themGreenColor,fontSize: 15,fontWeight: FontWeight.w700),)
                        ),
                      ),
                    )

                    

                  ]
                ),
        
               
              ),
        
            ),
          ),
        ),
      ),

      
      
    );
  }


  void _openCityBasedSpecializationDialog() async {

    _selected = (await Navigator.of(context).push(new MaterialPageRoute<String>(
        builder: (BuildContext context) {

          double width= MediaQuery.of(context).size.width;
          double height= MediaQuery.of(context).size.height;

          return StatefulBuilder(
            builder: (context, setState) {

            //  print("dialog checking "+showZoneWiseStateList.toString());

            //  showSearchHeaderServiceList = searchBody;
            return new Scaffold(
              appBar: new AppBar(
                backgroundColor: themColor,
                title: const Text('Our Specializations'),
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

                        height: height*0.85,
                        width: width,
                        
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                          
                                Container(
                                  width: width,
                                  child: Text("View All Our Specializations..",textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themColor,fontWeight: FontWeight.w800,fontSize: 15),),
                                ),
                                
                                GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 2, mainAxisSpacing: 2),
                                  padding: EdgeInsets.all(1),
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: showCityWiseSpecializationList.length,
                                  itemBuilder: (BuildContext context,int index){
                                      
                                    String sepcializationName= showCityWiseSpecializationList[index]['SepcializationName'].toString().split('-').join(' ');
                                    sepcializationName.split('-').join('');
                                    return Container(
                                      //child: Text(categoryList![index]['CategoryName'])
                                      
                                     // height: height*0.15,
                                        // width: 80,
                                        
                                      child: InkWell(
                                        onTap: ()  async {
                                                      
                                          //howZoneWiseStateList.clear();
                                                      
                                          setState(() {
                                            //showZoneWiseStateList.clear();
                                            BookAppointment.specializationId= showCityWiseSpecializationList[index]['SpecializationId'].toString();
                                          });

                                          print("Specialization ++++++++++++++++++++>>>>>>>>>>>>>>>>"+ BookAppointment.specializationId.toString());

                                          fetchDoctorsBasedOnSpecializationList();
                                            
                                        // fetchZoneWiseStateList();
                                                      
                                          print("Specialization id ................ "+BookAppointment.specializationId.toString());
                                                      
                                        },
                                        child: Card(
                                        // color:  Colors.indigoAccent[100 * (index % 45)],
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: width,
                                                decoration: BoxDecoration(
                                                  //color: Colors.grey[100 * (index % 5)],
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(0))
                                                ),
                                                height: height*0.1,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 20),
                                                  child: Image.network("http://101.53.150.64/2050Healthcare/public/speciality/"+showCityWiseSpecializationList[index]['Icon'],color: themGreenColor,width: width*0.05,height: height*0.05,)
                                                      
                                                ),
                                                
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                          
                                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(0))
                                                ),
                                                height: height*0.1,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 10),
                                                  child:  Text(sepcializationName,textDirection: TextDirection.ltr,textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: themColor,fontWeight: FontWeight.w500,fontSize: 15),) 
                                                ),
                                                      
                                              )
                                            ],
                                          ),
                                      
                                        ),
                                      ),
                                      
                                      
                                    );
                                  }
                                ),
                              ]
                            ),
                          ),
                                          
                        ),
       
                      ),
                        
                      
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



  void _openSpecializatioBasedDoctorsDialog() async {

    _selected = (await Navigator.of(context).push(new MaterialPageRoute<String>(
        builder: (BuildContext context) {

          double width= MediaQuery.of(context).size.width;
          double height= MediaQuery.of(context).size.height;

         

          return StatefulBuilder(
            builder: (context, setState) {

            //  print("dialog checking "+showZoneWiseStateList.toString());

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

                        height: height*0.8,
                        width: width,
                        
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                          
                                Container(
                                  width: width,
                                  child: Text("View All Our Doctors..",textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themColor,fontWeight: FontWeight.w800,fontSize: 15),),
                                ),
                                
                                GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 2, mainAxisSpacing: 2),
                                  padding: EdgeInsets.all(1),
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: showSpecializationWiseDoctorList.length,
                                  itemBuilder: (BuildContext context,int index){
                                      
                                    String doctorName= showSpecializationWiseDoctorList[index]['FullName'].toString().split('-').join(' ');
                                    doctorName.split('-').join('');
                                    return Container(
                                      //child: Text(categoryList![index]['CategoryName'])
                                      
                                      height: height*0.4,
                                        // width: 80,
                                        
                                      child: InkWell(
                                        onTap: ()  async {
                                                      
                                          //howZoneWiseStateList.clear();

                                          setState(() {
                                            //showZoneWiseStateList.clear();
                                            BookAppointment.doctorId= showSpecializationWiseDoctorList[index]['Id'].toString();
                                            BookAppointment.selectedDoctorName= doctorName.split('-').join('');
                                            BookAppointment.selectedDoctorImage="http://101.53.150.64/2050Healthcare/public/doctor/"+showSpecializationWiseDoctorList[index]['Image'];
                                            BookAppointment.selectedDoctorDesignation=showSpecializationWiseDoctorList[index]['Designation'].toString();
                                          });



                                          print("oooooooooooooooooooo "+BookAppointment.doctorId.toString());

                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OfflineBookDoctorPage()));
                                      
                                         
                                         
                                                      
                                        // fetchZoneWiseStateList();
                                                      
                                         
                                                      
                                        },
                                        child: Card(
                                        // color:  Colors.indigoAccent[100 * (index % 45)],
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: width,
                                                decoration: BoxDecoration(
                                                  //color: Colors.grey[100 * (index % 5)],
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(0))
                                                ),
                                                height: height*0.12,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Image.network("http://101.53.150.64/2050Healthcare/public/doctor/"+showSpecializationWiseDoctorList[index]['Image'],),


                                                      InkWell(
                                                        onTap: (){

                                                          setState(() {
                                                            //showZoneWiseStateList.clear();
                                                            BookAppointment.doctorId= showSpecializationWiseDoctorList[index]['Id'].toString();
                                                            BookAppointment.selectedDoctorName= doctorName.split('-').join('');
                                                            BookAppointment.selectedDoctorImage="http://101.53.150.64/2050Healthcare/public/doctor/"+showSpecializationWiseDoctorList[index]['Image'];
                                                            BookAppointment.selectedDoctorDesignation=showSpecializationWiseDoctorList[index]['Designation'].toString();
                                                          });

                                                          print("oooooooooooooooooooo "+BookAppointment.doctorId.toString());

                                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OfflineBookDoctorPage()));

                                                        },
                                                        child: Container(
                                                          color: themBlueColor,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: RotatedBox(
                                                              
                                                              quarterTurns: 1,
                                                              child: Center(child: new Text("Book Appointment",textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 12),))
                                                            ),
                                                          ),
                                                        ),
                                                      )

                                                    ],
                                                  )
                                                      
                                                ),
                                                
                                              ),
                                              // Transform.rotate(
                                              //   angle: 70,
                                              //   child: Container(
                                              //     color: Colors.red,
                                              //     child: Transform.rotate(
                                              //       angle: -70,
                                              //       child: Text(
                                              //         'SOME TEXT',
                                              //         textScaleFactor: 2.0,
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 4),
                                                  child:  Text(doctorName,textDirection: TextDirection.ltr,textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: themColor,fontWeight: FontWeight.w500,fontSize: 12),) 
                                                ),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 1),
                                                  child:  Text(showSpecializationWiseDoctorList[index]['Education'],textDirection: TextDirection.ltr,textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: themColor,fontWeight: FontWeight.w500,fontSize: 10),) 
                                                ),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 1),
                                                  child:  Text(showSpecializationWiseDoctorList[index]['Designation'],textDirection: TextDirection.ltr,textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: themColor,fontWeight: FontWeight.w500,fontSize: 8),) 
                                                ),
                                              )
                                            ],
                                          ),
                                      
                                        ),
                                      ),
                                      
                                    );
                                  }
                                ),
                              ]
                            ),
                          ),
                                          
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