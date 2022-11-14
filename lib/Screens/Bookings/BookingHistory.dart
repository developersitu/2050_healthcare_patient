import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:healthcare2050/Providers/CategorySubCategoryProvider.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/Home/Home.dart';
import 'package:healthcare2050/Screens/Service/Service.dart';
import 'package:healthcare2050/SideNavigationDrawer/SideNavigationDrawerPrevious.dart';
import 'package:healthcare2050/SideNavigationDrawer/navigation_drawer_widget.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';

class BookingHistory extends StatelessWidget {
  const BookingHistory({Key? key}) : super(key: key);

 

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

 

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  String ? categories_dropdown_id,subCategories_dropdown_id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final data = Provider.of<CategorySubCategoryProvider>(context,listen: false);
    data.fetchCategory();
  }

  
  // Future<bool> _onWillPop() async {
  //   return (await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Are you sure?'),
  //       content: const Text('Do you want to exit an App'),
  //       actions: <Widget>[
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(false),
  //           child: const Text('No'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(true),
  //           child: const Text('Yes'),
  //         ),
  //       ],
  //     ),
  //   )) ?? false;
  // }

  

  @override
  Widget build(BuildContext context) {

    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /// screen Orientation end///////////
    
    final data= Provider.of<CategorySubCategoryProvider>(context);

    List showCategoriesList =data.categoryList;

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return 
      WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: Scaffold(
          
          appBar: AppBar(
            
            backwardsCompatibility: false,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: themColor,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light
            ),
          
            backgroundColor: themColor,
            toolbarHeight: height*0.12,
            elevation: 0.0,
            title: Align(
              alignment: Alignment.topLeft,
              child: FittedBox(
                
                child: Padding(
                  padding: const EdgeInsets.only(left: 0,top: 0),
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        alignment: Alignment.topLeft,
                        child: const Text("Book Now",style: TextStyle(fontFamily: 'WorkSans',fontSize: 25,fontWeight: FontWeight.w700,color: Colors.white),)
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width/1,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(color: Colors.black45, spreadRadius: 1),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left:10),
                          child: Row(
                            children: [
                              const Icon(Icons.search,color: Colors.black45, size: 30,),
                              SizedBox(
                                width: width*0.8,
                                height: 50,
                                child: const FittedBox(child: Text("Search to find healing experience..", style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black38,fontFamily: 'RaleWay'),))
                              ),
                            ]  
                          ),
                        ),
                      ),
                    ],
                    
                  ),
                ),
              ),
            ),
            
            // leading: IconButton(
            //   icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
            //   onPressed: (){
            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Service()));
            //    // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Service()));
            //   },
            // ),
          ),
          
          endDrawer: SizedBox(
            width: MediaQuery.of(context).size.width*0.7,
            child: SideDrawer()
          ),

          body: SingleChildScrollView(
            child: Column(
              children: [

                DropdownButtonFormField<String>(
                                  
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down_circle,color: Colors.black54,size: 30,),
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black54)
                                    )
                                  ),
                                  
                                  value: categories_dropdown_id,
                                  hint: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Text('Please Choose Service',style: TextStyle(fontFamily: 'RaleWay',fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black38)),
                                  ),
                                  onChanged: (itemid) =>
                                      setState(() => categories_dropdown_id = itemid),
                                      
                                  validator: (value) => value == null ? 'Service is required' : null,
                                  items: showCategoriesList.map((list) {
                                    return DropdownMenuItem(
                                      value: list['Id'].toString(),
                                      child: FittedBox(child: Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: Text(list['CategoryName'].toString() ,style: TextStyle(color: Color(0xff454f63), fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 16),),
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


                                DropdownButtonFormField<String>(
                                  
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down_circle,color: Colors.black54,size: 30,),
                                  decoration: InputDecoration(
                                    
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black54)
                                    )
                                  ),
                                  
                                  value: subCategories_dropdown_id,
                                  hint: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Text('Please Choose SubCategories',style: TextStyle(fontFamily: 'RaleWay',fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black38)),
                                  ),
                                  onChanged: (itemid) {
                                    setState((){ 
                                      subCategories_dropdown_id = itemid;
                                      categories_dropdown_id=null;
                                      
                                    });

                                   print("State Id ///////////////////" +subCategories_dropdown_id.toString());
                                  },
                                  validator: (value) => value == null ? 'State is required' : null,
                                  items: showCategoriesList.map((list) {
                                    return DropdownMenuItem(
                                      value: list['id'].toString(),
                                      child: FittedBox(child: Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: Text(list['subcategory'].toString() ,style: TextStyle(color: Color(0xff454f63), fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 16),),
                                      )),
                                    );
                                  }).toList(),

                                ),

              ],
            ),
          ), 

           



          
          
        
          ),
      );
  }
}