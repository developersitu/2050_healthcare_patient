import 'dart:io';
import 'dart:ui';
import 'package:expandable_text/expandable_text.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocode/geocode.dart';
import 'package:healthcare2050/Providers/CategorySubCategoryProvider.dart';
import 'package:healthcare2050/Screens/BookAppointment/BookAppointment.dart';
import 'package:healthcare2050/Screens/Doctors/DoctorSpecializationList.dart';
import 'package:healthcare2050/Screens/SplashScreen/SplashScreen.dart';
import 'package:healthcare2050/Screens/SubCategories.dart/SubCategoriesNew.dart';
import 'package:healthcare2050/Screens/VideoTelePhoneCall/Specialization/Specialization.dart';
import 'package:healthcare2050/SideNavigationDrawer/navigation_drawer_widget.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../Widgets/TextStyle.dart';
//import 'package:carousel_pro/carousel_pro.dart';

class Home extends StatelessWidget {

  static List subCategoryList=[];
  static String ? categoryImage,categoryName,userid,mobileNo,razorpay_OrderId,profileImage;
  

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
      home: Home2Screen(),
    );
  }
}

class Home2Screen extends StatefulWidget {
  const Home2Screen({ Key? key }) : super(key: key);

  @override
  State<Home2Screen> createState() => _Home2ScreenState();
}

class _Home2ScreenState extends State<Home2Screen> {


    final List<String> images = [

    
    'https://media.istockphoto.com/photos/young-woman-snorkeling-with-coral-reef-fishes-picture-id939931682?s=612x612',
    'https://media.istockphoto.com/photos/woman-relaxing-in-sleeping-bag-on-red-mat-camping-travel-vacations-in-picture-id1210134412?s=612x612',
    'https://media.istockphoto.com/photos/green-leaf-with-dew-on-dark-nature-background-picture-id1050634172?s=612x612',
    'https://media.istockphoto.com/photos/mountain-landscape-picture-id517188688?s=612x612',
    // 'https://www.istockphoto.com/en/photo/woman-standing-and-looking-at-lago-di-carezza-in-dolomites-gm1038870630-278083784',
    'https://media.istockphoto.com/photos/picturesque-morning-in-plitvice-national-park-colorful-spring-scene-picture-id1093110112?s=612x612',
    'https://media.istockphoto.com/photos/connection-with-nature-picture-id1174472274?s=612x612',
    'https://media.istockphoto.com/photos/in-the-hands-of-trees-growing-seedlings-bokeh-green-background-female-picture-id1181366400',
    'https://media.istockphoto.com/photos/winding-road-picture-id1173544006?s=612x612',
    'https://media.istockphoto.com/photos/sunset-with-pebbles-on-beach-in-nice-france-picture-id1157205177?s=612x612',
    'https://media.istockphoto.com/photos/waves-of-water-of-the-river-and-the-sea-meet-each-other-during-high-picture-id1166684037?s=612x612',
    'https://media.istockphoto.com/photos/happy-family-mother-father-children-son-and-daughter-on-sunset-picture-id1159094800?s=612x612',
    'https://media.istockphoto.com/photos/butterflies-picture-id1201252148?s=612x612',
    'https://media.istockphoto.com/photos/beautiful-young-woman-blows-dandelion-in-a-wheat-field-in-the-summer-picture-id1203963917?s=612x612',
    'https://media.istockphoto.com/photos/summer-meadow-picture-id1125637203?s=612x612',
  ];



  // for full screen dialog
  var _selected ="";
  var _test = "Full Screen";

  bool isLoadingCategory=false;

  LocationData? currentLocation;
  String address = "";

  void _getLocation() {
    _getLocationData().then((value) {
      
      LocationData? location = value;
      _getAddress(location?.latitude, location?.longitude).then((value) {
        setState(() {
          currentLocation = location;
          address = value;

          // print("value ");

          // print("address "+address);
          // print("value "+value);
        });
      });
    });
  }


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
            //onPressed: () => Navigator.of(context).pop(true),
            onPressed: () => exit(0),
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getLocation();

    // checkRealtimeConnection();
    // if(Splash.internetConnection=="Not Connected"){
    //   showTopSnackBar(
    //       context,
          
    //       CustomSnackBar.error(
    //        // backgroundColor: Colors.red,
    //         message:
    //             "No Internet \n Please Check Internet Connection !!!",
    //       ),
    //     );
    // }
   
    getCredentials();
    // greetingMessage();
    // upDateGreetingMessageAccordingToTime();
    //_checkInternetConnection();
    //checkRealtimeConnection();
   
    // _getUserLocation = getUserLocation(); // by situ

    final data= Provider.of<CategorySubCategoryProvider>(context,listen: false);
    data.fetchCategory();
  }



  @override
  Widget build(BuildContext context) {

    final data= Provider.of<CategorySubCategoryProvider>(context);

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
     
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width*0.7,
        child: SideDrawer()
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
        
        
        CustomScrollView(

          slivers: <Widget>[
          
            SliverAppBar(
              elevation: 20,
              backwardsCompatibility: false,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: themColor,
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.light
              ),
          
              iconTheme: IconThemeData(color: Colors.green),
              backgroundColor: Colors.white70,
              //pinned: true,
              snap: false,
              pinned: true,
              floating: false,
          
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications,color: themColor),
                ),
              ],
          
              // bottom: PreferredSize(
              //   preferredSize: Size.fromHeight(0),
              //   child: AppBar( 
              //      backgroundColor: themColor,
              //   toolbarHeight: height*0.05,
              //   elevation: 0.0,
              //   title: Align(
              //     alignment: Alignment.topLeft,
              //     child: FittedBox(
                    
              //       child: Padding(
              //         padding: const EdgeInsets.only(left: 0,top: 0),
              //         child: Column(
              //           children: [
              //             Container(
              //               width: width,
              //               alignment: Alignment.topLeft,
              //               child: const Text("Book Now",style: TextStyle(fontFamily: 'WorkSans',fontSize: 25,fontWeight: FontWeight.w700,color: Colors.white),)
              //             ),
              //             const SizedBox(height: 10,),
              //             Container(
              //               height: 20,
              //               width: MediaQuery.of(context).size.width/1,
              //               decoration: const BoxDecoration(
              //                 color: Colors.white,
              //                 borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
              //                 boxShadow: [
              //                   BoxShadow(color: Colors.black45, spreadRadius: 1),
              //                 ],
              //               ),
              //               child: Padding(
              //                 padding: const EdgeInsets.only(left:10),
              //                 child: Row(
              //                   children: [
              //                     const Icon(Icons.search,color: Colors.black45, size: 30,),
              //                     SizedBox(
              //                       width: width*0.8,
              //                       height: 20,
              //                       child: const FittedBox(child: Text("Search to find healing experience..", style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black38,fontFamily: 'RaleWay'),))
              //                     ),
              //                   ]  
              //                 ),
              //               ),
              //             ),
              //           ],
                        
              //         ),
              //       ),
              //     ),
              //   ),
              //   )
              // ),
              expandedHeight: height*0.1,
             
              flexibleSpace: Container(
                padding: EdgeInsets.all(10),
                //height: 230,
                height: 150,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    
                      // Container(
                      //   width: width,
                      //   color: themGreenColor,
                      //   height: 40,
                      //   child: Expanded(child: Text("Welcome",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.white,fontSize: 10),)), //decreas the size
                      // ),
                    
                    Padding(
                      padding: const EdgeInsets.only(left: 50,right: 50),
                      child: Container(
                        color: Colors.transparent,
                        height: 50,
                        
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset("assets/images/location.png",width: 20,height: 20),
                           // Text("$address", style: TextStyle(color: Colors.white,fontFamily: "WorkSans",fontSize: 30)),
                            
                            Expanded(child: Text("$address", style: TextStyle(color: Colors.black45,fontFamily: "WorkSans"),)),
                            
                          ],
                        ), //decrease the size
                      ),
                    ),
                    // Expanded(child: Padding(
                    //   padding: const EdgeInsets.only(top: 20),
                    //   child: Row(
                    //     children: [
                    //       Row(
                    //         children: [
                    //           Text('2050',style: TextStyle(color: Colors.white,fontSize: 35),),
                    //           SizedBox(width: 5),
                    //           Text('Health Care',style: TextStyle(color: Colors.white,fontSize: 25),),
                    //         ],
                    //       ),
                    //       Spacer(),
                    //       Text('Wallet',style: TextStyle(color: Colors.white,fontSize: 15),),
                          
                    //     ],
                       
                    //   ),
                    // )),
                    
                  ],
                ),
              )  
              // flexibleSpace: FlexibleSpaceBar(
              
              //   centerTitle: true,
              //   title: Text("data")
              
              // ), //FlexibleSpaceBar
              
            ),
          
            SliverFixedExtentList(
              itemExtent: 200,
              delegate: SliverChildListDelegate(
                [
                   
                  Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    child: GestureDetector(
                      onTap: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>Screen2()));
        
                      },
                      child: Container(
                        height: height*0.35,
                        //margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: themColor,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                                      //boxShadow: shadowList,
                                    ),
                                    margin: EdgeInsets.only(top: 30),
                                  ),
                                  Align(
                                    child: Hero(
                                      tag:1,child: Image.asset("assets/images/doctorwhite.png",height: height*0.35,)
                                    ),
                                  )
        
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 30,),
                                decoration: BoxDecoration(
                                  // color: Colors.indigo[100],
                                  color: themColor,
        
                                  // boxShadow: shadowList,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                    
                                  )
                                ),
        
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5,top: 10,right: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Bridging the Gap",maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,style: TextStyle(decoration: TextDecoration.none,color: Colors.white,fontFamily: 'WorkSans',fontWeight: FontWeight.w700,fontSize: 18),),
                                      SizedBox(height: 10,),
                                      Text("We are India’s largest Transitional Care facility looking after all your healthcare needs",textAlign: TextAlign.start,maxLines: 5,overflow: TextOverflow.ellipsis,
                                        style: TextStyle(decoration: TextDecoration.none,color: Colors.white60,fontFamily: 'WorkSans',fontWeight: FontWeight.w600,fontSize: 12),),
                                      // SizedBox(height: 10,),
                                      // SizedBox(
                                      //   width: width,
                                      //   height: 30,
                                      //   child: Center(
                                      //     child: ElevatedButton(
                                      //       child: Text(
                                      //         "Book Appointment".toUpperCase(),
                                      //         style: TextStyle(fontSize: 10)
                                      //       ),
                                      //       style: ButtonStyle(
                                      //         foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                      //         backgroundColor: MaterialStateProperty.all<Color>(themColor),
                                      //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      //           RoundedRectangleBorder(
                                      //             borderRadius: BorderRadius.circular(18.0),
                                                  
                                      //             side: BorderSide(color: themColor)
                                      //           )
                                      //         )
                                      //       ),
                                      //       onPressed: () => null
                                      //     ),
                                      //   ),
                                      // )
        
                                    ],
                                    
                                  ),
                                ),
        
                              )
                            ) 
        
                          ],
                        ),
        
                      ),
                    ),
                  ),
          
                  
                ]
                // Container(color: Colors.red),
                // Container(color: Colors.green),
                // Container(color: Colors.blue),
              ),
            ),

            

            SliverFixedExtentList(
              itemExtent: height*0.35,
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        InkWell(
                          onTap: (){
                            if( Splash.internetConnection == "Not Connected"){
                              showTopSnackBar(
                                context,
                                
                                CustomSnackBar.success(
                                  // backgroundColor: Colors.red,
                                  message:
                                    "No Internet \n Please Check Internet Connection !!!",
                                ),
                              );
                            }

                            else{
                              
                              Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> BookAppointment()));
                              //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> DoctorSpecializationListPage()));              
                            }
                          },
                          child: Container(
                            color: Colors.transparent,
                            width: width*0.5,
                            height: height*0.3,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Card(
                                elevation: 2,
                                color: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                                      ),
                                      height: height*0.2,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Image.asset("assets/images/finddoctor.png",),
                                      ),
                                     
                                    ),
                                    Container(
                                      height: height*0.08,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                                      ),
                                     
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 5,top: 5,left: 5,right: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("Book Appointment",textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black87,fontFamily: "WorkSans",fontWeight: FontWeight.w500,fontSize: 15),),
                                            Text("You can Confirm appointments here", textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black45,fontFamily: "WorkSans",fontWeight: FontWeight.w400,fontSize: 10)),
                                            SizedBox(height: 5,)
                                          ],
                                        ),
                                      ),
                        
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        

                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Specialization()));
                          },
                          child: Container(
                            color: Colors.transparent,
                            width: width*0.5,
                            height: height*0.3,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Card(
                                elevation: 2,
                                color: Colors.blueGrey,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.blueGrey, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                                      ),
                                      height: height*0.2,
                                       child: Padding(
                                         padding: EdgeInsets.only(top: 20),
                                         child: Image.asset("assets/images/videoconsult.png")
                                        ),
                                    ),
                                    Container(
                                      height: height*0.08,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                                      ),
                                      
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 5,top: 5,left: 5,right: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("Online Consultation",textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black87,fontFamily: "WorkSans",fontWeight: FontWeight.w500,fontSize: 15),),
                                            Text("You can start video consult here",textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black45,fontFamily: "WorkSans",fontWeight: FontWeight.w400,fontSize: 10),),
                                            SizedBox(height: 5,)
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]
                // Container(color: Colors.red),
                // Container(color: Colors.green),
                // Container(color: Colors.blue),
              ),
            ),

            SliverGrid(
              
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    child: InkWell(
                      onTap: (){
                        if( Splash.internetConnection == "Not Connected"){
                          showTopSnackBar(
                            context,
                            
                            CustomSnackBar.error(
                            // backgroundColor: Colors.red,
                              message:
                                  "No Internet \n Please Check Internet Connection !!!",
                            ),
                          );
                        }

                        if(Splash.internetConnection!="Not Connected"){
                          Home.subCategoryList.clear();
                          Home.subCategoryList.addAll(data.categoryList[index]['subcategory']);
                          Home.categoryImage=data.categoryList[index]['BackgroundImage'].toString();
                          Home.categoryName=data.categoryList[index]['CategoryName'].toString();
          
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SubCategoriesNew()));
                          print("sub category "+Home.subCategoryList.length.toString() );
                        }

                      },
                      child: Container(
                        // decoration: BoxDecoration(
                        //   //border: Border.all(width: 2, color: themColor),
                        //  // side: BorderSide(color: Colors.blueGrey, width: 2),
                        //   color: Colors.grey[100 * (index % 5)],
                        //   borderRadius: BorderRadius.circular(20)
                        // ),
                        //alignment: Alignment.center,
                        child: Card(
                          elevation: 10,
                          //shape: Border(right: BorderSide(color: Colors.red, width: 5)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(
                              width: 1,
                              color: Colors.black38
                            )
                          ),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.network("http://101.53.150.64/2050Healthcare/public/home/"+data.categoryList[index]['BackgroundImage'],width: 20,height: 40),
                                   // child: SvgPicture.network("http://101.53.150.64/2050Healthcare/public/category/"+data.categoryList[index]['Icon'],width: 20,height: 40,allowDrawingOutsideViewBox: true,color: Colors.white,),
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(data.categoryList[index]['CategoryName'].toString().split('-').join(' '),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style: TextStyle(fontSize: 10,fontFamily: "WorkSans",fontWeight: FontWeight.w600),),
                                )
                              ],
                              
                            )
                          )
                        )
                      ),
                    ),
                  );
                },
                childCount: data.categoryList.length,
                
              ),
              // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              //   maxCrossAxisExtent: 200.0,
              //   mainAxisSpacing: 10.0,
              //   crossAxisSpacing: 10.0,
              //   childAspectRatio: 4.0,
              // ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
            ),

            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: SingleChildScrollView                              
(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                
                      SizedBox(
                        height: 5,
                      ),
                
                     
                        // CarouselSlider(
                         
                        //   items: [
                           
                        //     Padding(
                        //       padding: const EdgeInsets.all(2.0),
                        //       child: Image.asset("assets/images/banner1.jpg",height: height*0.3,width: width,),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.all(2.0),
                        //       child: Image.asset("assets/images/banner2.jpg",height: height*0.3,width: width,),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.all(2.0),
                        //       child: Image.asset("assets/images/banner3.jpg",height: height*0.3,width: width,),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.all(2.0),
                        //       child: Image.asset("assets/images/banner4.jpg",height: height*0.3,width: width,),
                        //     )
                        //   ],
                        //   //Slider Container properties
                        //   options: CarouselOptions(
                        //     autoPlay: true,
                        //     autoPlayInterval: const Duration(seconds: 2),
                        //     autoPlayAnimationDuration: const Duration(milliseconds: 400),
                              
                        //   ),
                        // ),
                
                      // SizedBox(
                      //   height: 200.0,
                      //   width: double.infinity,
                      //   child: Carousel(
                      //     boxFit: BoxFit.contain,
                      //     images: [
                      //       AssetImage("assets/images/banner1.jpg"),
                      //       AssetImage("assets/images/banner2.jpg"),
                      //       AssetImage("assets/images/banner3.jpg"),
                      //       AssetImage("assets/images/banner4.jpg"),
                      //
                      //     ],
                      //     dotSpacing: 15.0,
                      //     dotSize: 6.0,
                      //     dotIncreasedColor: Colors.red,
                      //     dotBgColor: Colors.transparent,
                      //     indicatorBgPadding: 10.0,
                      //     dotPosition: DotPosition.bottomRight,
                      //     // images: images
                      //     //     .map((item) => Container(
                      //     //           child: Image.network(
                      //     //             item,
                      //     //             fit: BoxFit.cover,
                      //     //           ),
                      //     //         ))
                      //     //     .toList(),
                      //   ),
                      // ),
                    
                
                      Container(
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                          //elevation: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 10,top: 5,left: 5),
                                child: FittedBox(child: Text("2050 HealthCare",textAlign: TextAlign.left,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontFamily: "WorkSans",fontWeight: FontWeight.w800),))
                              ),
                              Container(
                                width: width,
                               // height: height*0.25,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage("assets/images/satisfiedCustomer.png",),
                                  ),
                                ),
                              ),
                
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  //height: height/5,
                                  child: TextWrapper(
                                    text:
                                    "2050 Healthcare is a one-stop solution for all your health care needs. We provide a complete range of healthcare services through: "
                                    "A wide panel of experienced doctors across multiple specialities."
                                    "24*7 nursing services with competent, trained nurses and caregivers."
                                    "Continued cutting-edge supportive services like physiotherapy, nutritional support and diagnostic services."
                                    "An entire range of expert homecare services."
                                    "Holistic care spanning across specialities and systems of medicine."
                                    "Together, we can make the shift from hospital to home comfortable for you and your loved ones.",
                                   
                                  ),
                                ),
                                
                              )
                
                            ],
                          )
                         
                        ),
                      ),
                
                      SizedBox(height: 10,),
                
                      // Align(
                      //   alignment: Alignment.bottomRight,
                      //   child: TextButton(
                      //     onPressed: () async{
                      //       _openDialogOne();
                      //     }, 
                      //     child: Text("Read more",textAlign: TextAlign.left,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15,fontFamily: "WorkSans",fontWeight: FontWeight.w600,color: themColor),)
                      //   ),
                      // ),
                
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 10,top: 10),
                      //   child: FittedBox(child: Text("With you in Every Step of Healing",textAlign: TextAlign.left,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontFamily: "WorkSans",fontWeight: FontWeight.w800),)),
                      // ),
                
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                        //elevation: 10,
                      
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10,top: 5,left: 5),
                                child: FittedBox(child: Text("With you in Every Step of Healing",textAlign: TextAlign.left,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontFamily: "WorkSans",fontWeight: FontWeight.w800),)),
                              ),
                              Container(
                                width: width,
                                height: height*0.25,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage("assets/images/everystep.png",),
                                  ),
                                ),
                              ),
                        
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                        
                              
                                child: Container(
                                  // height: height*0.25,
                                  child: TextWrapper(
                                    text:
                                    "The period of transition post surgery or while recovering from injuries, chronic illnesses or going through the pain of cancer is when you need extra care and supervision. We at 2050 Healthcare BRIDGE THIS GAP from hospital to home by providing comprehensive and empathetic healthcare in our transitional care facilities like a halfway home. We also extend the same care at the comfort of your home through a team of home nurses, caregivers, physiotherapists and medical equipment."
                                
                                    "With a presence in multiple locations across India, we are the largest Transitional Care facility bringing qualified and personalized rehabilitative and homecare to you at your ease and convenience ."
                                      
                                  ),
                                ),
                              ),
                                
                        
                        
                                // child: Text(
                                //"The period of transition post surgery or while recovering from injuries, chronic illnesses or going through the pain of cancer is when you need extra care and supervision. We at 2050 Healthcare BRIDGE THIS GAP from hospital to home by providing comprehensive and empathetic healthcare in our transitional care facilities like a halfway home. We also extend the same care at the comfort of your home through a team of home nurses, caregivers, physiotherapists and medical equipment."
                        
                                //   "With a presence in multiple locations across India, we are the largest Transitional Care facility bringing qualified and personalized rehabilitative and homecare to you at your ease and convenience .",textDirection: TextDirection.ltr,
                                //   style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.black45),
                                // ),
                            
                        
                            ],
                          )
                        ),
                       
                      
                
                      
                
                      // Align(
                      //   alignment: Alignment.bottomRight,
                      //   child: TextButton(
                      //     onPressed: () async{
                      //       _openDialogTwo();
                      //     }, 
                      //     child: Text("Read more",textAlign: TextAlign.left,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15,fontFamily: "WorkSans",fontWeight: FontWeight.w600,color: themColor),)
                      //   ),
                      // ),
                
                
                       
                
                      SizedBox(
                        height: 10,
                      )
                
                    ],
                  ),
                ),
              ),
             
                

            ),
            


          
          
          
            // SliverList(
            //   delegate: SliverChildBuilderDelegate(
            //     (context, index) {
            //       return Container(
            //         height: 50,
            //         alignment: Alignment.center,
            //         color: Colors.orange[100 * (index % 9)],
            //         child: Text("qbv"),
            //       );
            //     },
            //     childCount: 40,
            //   ),
            // ),
          
            // SliverList(
            //   delegate: SliverChildBuilderDelegate(
            //     (context, index) {
            //       return Container(
            //         height: 50,
            //         alignment: Alignment.center,
            //         color: Colors.orange[100 * (index % 9)],
            //         child: Text("qbv"),
            //       );
            //     },
            //     childCount: 40,
            //   ),
            // ),
          
            // SliverList(
            //   delegate: SliverChildBuilderDelegate(
            //     (context, index) {
            //       return Container(
            //         height: 50,
            //         alignment: Alignment.center,
            //         color: Colors.orange[100 * (index % 9)],
            //         child: Text("qbv"),
            //       );
            //     },
            //     childCount: 40,
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

        
      ),
    );
  }

  void getCredentials() async{

    SharedPreferences loginPrefs = await SharedPreferences.getInstance();

    setState(() {
      Home.userid=loginPrefs.getString("userid").toString();
      Home.profileImage=loginPrefs.getString("profileImage").toString();
    });

    print("User id ////////////////////////// ");

    print("User id ////////////////////////// "+ Home.userid.toString());
  }

  void _openDialogOne() async {

    _selected = (await Navigator.of(context).push(new MaterialPageRoute<String>(
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {

             // showSearchHeaderServiceList = searchBody;
            return new Scaffold(
              appBar: new AppBar(
                backgroundColor: themColor,
                title: const Text('Our Satisfied Customer'),
                actions: [
                  new ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: themRedColor
                    ),
                    onPressed: () {
                      Navigator.of(context).pop("hai");
                    },
                    child: new Text('Back',
                        style: TextStyle(color: Colors.white),
                    )
                  ),
                ],
              ),
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  children: [

                    Card(
                      elevation: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.indigo, 
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                        ),
                        padding: EdgeInsets.all(15),
                        child: ReadMoreText(
                          "2050 Healthcare is a one-stop solution for all your health care needs. We provide a complete range of healthcare services through: "
                          "A wide panel of experienced doctors across multiple specialities."
                          "24*7 nursing services with competent, trained nurses and caregivers."
                          "Continued cutting-edge supportive services like physiotherapy, nutritional support and diagnostic services."
                          "An entire range of expert homecare services."
                          "Holistic care spanning across specialities and systems of medicine."
                          "Together, we can make the shift from hospital to home comfortable for you and your loved ones.",textDirection: TextDirection.ltr,
                          trimLines: 3,
                          textAlign: TextAlign.justify,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: " Show More ",
                          trimExpandedText: " Show Less ",
                          lessStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themAmberColor,
                          ),
                          moreStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themAmberColor,
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            height: 2,color: Colors.white
                          ),
                        ),
                      ),
                    ),
          
                   
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


  void _openDialogTwo() async {

    _selected = (await Navigator.of(context).push(new MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {

             // showSearchHeaderServiceList = searchBody;
            return new Scaffold(
              appBar: new AppBar(
                backgroundColor: themColor,
                title: const Text('Our Satisfied Customer'),
                actions: [
                  new ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: themRedColor
                    ),
                    
                    onPressed: () {
                      Navigator.of(context).pop("hai");
                    },
                    child: new Text('Back',
                        style: TextStyle(color: Colors.white),
                    )
                  ),
                ],
              ),
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  children: [

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.indigo, 
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                      ),
                      padding: EdgeInsets.all(15),
                      child: ReadMoreText(
                        "The period of transition post surgery or while recovering from injuries, chronic illnesses or going through the pain of cancer is when you need extra care and supervision. We at 2050 Healthcare BRIDGE THIS GAP from hospital to home by providing comprehensive and empathetic healthcare in our transitional care facilities like a halfway home. We also extend the same care at the comfort of your home through a team of home nurses, caregivers, physiotherapists and medical equipment."

                        "With a presence in multiple locations across India, we are the largest Transitional Care facility bringing qualified and personalized rehabilitative and homecare to you at your ease and convenience .",textDirection: TextDirection.ltr,
                        trimLines: 3,
                        textAlign: TextAlign.justify,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: " Show More ",
                        trimExpandedText: " Show Less ",
                        lessStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: themAmberColor,
                        ),
                        moreStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: themAmberColor,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          height: 2,color: Colors.white
                        ),
                      ),
                    ),
          
                   
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

}


Future<LocationData?> _getLocationData() async {
  Location location = new Location();
  LocationData _locationData;

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  _locationData = await location.getLocation();

  return _locationData;
}

Future<String> _getAddress(double? lat, double? lang) async {
  if (lat == null || lang == null) return "";
  GeoCode geoCode = GeoCode();
  Address address =
      await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
  return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
}

// Create a expandable/ collapsable text widget
class TextWrapper extends StatefulWidget {
  const TextWrapper({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  _TextWrapperState createState() => _TextWrapperState();
}

class _TextWrapperState extends State<TextWrapper>
    with TickerProviderStateMixin {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: ConstrainedBox(
              constraints: isExpanded
                  ? const BoxConstraints()
                  : const BoxConstraints(maxHeight: 70),
              child: Text(
                widget.text,
                style: const TextStyle(fontSize: 16),
                softWrap: true,
                overflow: TextOverflow.fade,
              ))),
          isExpanded
          ? OutlinedButton.icon(
              icon: const Icon(Icons.arrow_upward,color: themRedColor,),
              label: const Text('Read less',style: CustomTextStyle.normalTextStyle,),
              onPressed: () => setState(() => isExpanded = false))
          : TextButton.icon(
              icon: const Icon(Icons.arrow_downward,color: themColor,),
              label: const Text('Read more', style: CustomTextStyle.normalTextStyle,),
              onPressed: () => setState(() => isExpanded = true))
    ]);
  }
}

