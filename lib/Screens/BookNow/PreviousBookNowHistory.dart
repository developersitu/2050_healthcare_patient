import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/Providers/BookNowHistoryProvider.dart';
import 'package:healthcare2050/Screens/Bookings/BookingHistory.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviousBookNowHistory extends StatelessWidget {

  static String ? userid;

  static String ? servicemessage;

  const PreviousBookNowHistory({ Key? key }) : super(key: key);

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
      home: Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  bool ? status;
  bool isLoading = true;

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCredentials();
    final data= Provider.of<BookNowHistoryListProvider>(context,listen: false);
   
    data.fetchBookingNowHistory();
    
    

    print("List >>>>>>>>>> 2"+data.bookNowHistoryList.toString());
    print("status >>>>>>>>>> "+data.serverStatus.toString());
  
    isLoading=true;
  }
  

  @override
  Widget build(BuildContext context) {

    final data= Provider.of<BookNowHistoryListProvider>(context);
   
    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        gradient:  RadialGradient(
          radius: 0.8,
          colors: [
            Colors.white,
           // Color(0xFFb6e5e5),
           Colors.white
           
          ],
        )
      ),
      
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light
          ),
  
          elevation: 0,
          backgroundColor: themColor,
          leading:  Padding(
            padding: const EdgeInsets.only(left: 5),
            child: IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white),
              onPressed: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>BottomNavigationBarPage()));
              },
            ),
          ),
          // leading:  Padding(
          //   padding: const EdgeInsets.only(left: 5),
          //   child: Container(
              
          //     decoration: BoxDecoration(
          //       border: Border.all(
          //         color: themColor,
          //       ),
          //       color: themColor,
          //       borderRadius: BorderRadius.all(Radius.circular(30))
          //     ),
              
          //     child: IconButton(
          //       icon: const Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 30,),
          //       onPressed: (){
          //         //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
          //         Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> LoginRegistration()));
          //       },
          //     ),
          //   ),
          // ),
          title: const Text("Booked History",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20,fontFamily: 'Ubuntu')),
        ),

        body: 
          
          // isLoading==true ?
          // const CircularProgressIndicator() :
          
          data.bookNowHistoryList.length!=0 ? 

          
          
        //  data.serverStatus=="true" ?
          
            Consumer<BookNowHistoryListProvider>(
              builder: (context,value,child){
               return  value.bookNowHistoryList.isEmpty ? const CircularProgressIndicator() :
                ListView.builder(
                  itemCount: value.bookNowHistoryList.length,
                  itemBuilder: (context,index){
              
                    
                    String category_name=value.bookNowHistoryList[index]['SubcategoryName'].toString().split('-').join(' ');
              
                    category_name.split('-').join('');
                    return  ExpansionTileCard(
                      baseColor: Colors.white,
                      expandedColor: themColor,
                
                    
                      title: Text(category_name),
                      //subtitle: Text("FLUTTER DEVELOPMENT COMPANY"),
                      children: <Widget>[
                        Divider(
                          thickness: 1.0,
                          height: 1.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              value.bookNowHistoryList[index]['FirstName'].toString(),style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
              
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
              
                              
                            
                                  
                            
                          ),
                        ),
                      ],
                    );
                  }
                ) ;
              }   
              
                      
           )     
            
          : Center(
               child: Text("no record"),
          )





      ),
      
    );
  }

  void getCredentials() async{

    SharedPreferences loginPrefs = await SharedPreferences.getInstance();

    setState(() {
      PreviousBookNowHistory.userid=loginPrefs.getString("userid").toString();
      
    });
    
  }

}

