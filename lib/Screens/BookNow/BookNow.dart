import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:healthcare2050/Providers/CategorySubCategoryProvider.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarService.dart';
import 'package:healthcare2050/Screens/Home/Home.dart';
import 'package:healthcare2050/Screens/Service/Service.dart';
import 'package:healthcare2050/SideNavigationDrawer/SideNavigationDrawerPrevious.dart';
import 'package:healthcare2050/SideNavigationDrawer/navigation_drawer_widget.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';

class BookNow extends StatelessWidget {
  const BookNow({Key? key}) : super(key: key);

 

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookNowScreen(),
    );
  }
}

class BookNowScreen extends StatefulWidget {
  const BookNowScreen({Key? key}) : super(key: key);

 

  @override
  _BookNowScreenState createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {

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
      Container(
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
          
          appBar: AppBar(
            toolbarHeight: 50,
            backwardsCompatibility: false,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light
            ),
  
            elevation: 0,
            backgroundColor: themColor,

            iconTheme: IconThemeData(color: themColor), // drawer icon color
            actions: <Widget>[

              IconButton(
                tooltip: "Search here",
                onPressed: () {},
                icon: Icon(Icons.search,color: Colors.white,),
              ),
              SizedBox(width: 2,), 

            
              Builder(
                builder: (context) =>  IconButton(
                  icon: Icon(Icons.menu,color: Colors.white,),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),

            // Builder(
            //   builder: (context) => Container(
            //     height: 30,
            //     decoration: BoxDecoration(
            //       border: Border.all(
            //         color: themGreenColor,
            //         width: 2
            //       ),
            //       color: themColor,
            //       borderRadius: BorderRadius.all(Radius.circular(30))
            //     ),
            //     child: IconButton(
            //       icon: Icon(Icons.menu,color: Colors.white,),
            //       onPressed: () => Scaffold.of(context).openEndDrawer(),
            //       tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            //     ),
            //   ),
            // ),

              SizedBox(width: 2,), 

            // Padding(
            //   padding: EdgeInsets.only(right: 5),
            //   child: Container(
            //     height: 30,
            //     decoration: BoxDecoration(
            //       border: Border.all(
            //         color: themGreenColor,
            //         width: 2
            //       ),
            //       color: themColor,
            //       borderRadius: BorderRadius.all(Radius.circular(30))
            //     ),

            //     child: PopupMenuButton<int>(
            //       tooltip: "Option Menu",
            //       icon: Icon(Icons.more_vert, color: Colors.white,),
            //       color: Colors.white,
            //       itemBuilder: (context) => [
            //         PopupMenuItem<int>(
            //           value: 0, 
            //           child: Text("More Services",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themGreenColor,fontWeight: FontWeight.w800),)
            //         ),
            //         PopupMenuItem<int>(
            //           value: 1, 
            //           child: Text("Book Now",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themRedColor,fontWeight: FontWeight.w800),)
            //         ),
            //         PopupMenuDivider(),
            //         PopupMenuItem<int>(
            //           value: 2,
            //           child: Row(
            //             children: [
            //               Icon(
            //                 Icons.logout,
            //                 color: Colors.red,
            //               ),
            //               const SizedBox(
            //                 width: 1,
            //               ),
            //               Text("Logout",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black45,fontWeight: FontWeight.w800))
            //             ],
            //           )
            //         ),
            //       ],
            //       onSelected: (item) => SelectedItem(context, item),
            //     ),
            //     // child: IconButton(
            //     //   tooltip: "Search here",
            //     //   onPressed: () {},
            //     //   icon: Icon(Icons.search,color: Colors.white,),
            //     // ),
            //   ), 


            //   // child: ClipRRect(
            //   //   borderRadius: BorderRadius.circular(30),
            //   //   child: Material(
            //   //     color: themColor,
            //   //     child: PopupMenuButton<int>(
            //   //       tooltip: "Option Menu",
            //   //       icon: Icon(Icons.more_vert, color: Colors.white,),
            //   //       color: Colors.white,
            //   //       itemBuilder: (context) => [
            //   //         PopupMenuItem<int>(
            //   //           value: 0, 
            //   //           child: Text("More Services",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themGreenColor,fontWeight: FontWeight.w800),)
            //   //         ),
            //   //         PopupMenuItem<int>(
            //   //           value: 1, 
            //   //           child: Text("Book Now",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: themRedColor,fontWeight: FontWeight.w800),)
            //   //         ),
            //   //         PopupMenuDivider(),
            //   //         PopupMenuItem<int>(
            //   //           value: 2,
            //   //           child: Row(
            //   //             children: [
            //   //               Icon(
            //   //                 Icons.logout,
            //   //                 color: Colors.red,
            //   //               ),
            //   //               const SizedBox(
            //   //                 width: 1,
            //   //               ),
            //   //               Text("Logout",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black45,fontWeight: FontWeight.w800))
            //   //             ],
            //   //           )
            //   //         ),
            //   //       ],
            //   //       onSelected: (item) => SelectedItem(context, item),
            //   //     ),
            //   //   ),
            //   // ),
            // ),

            // PopupMenuButton<String>(
            //   color: Colors.white,
            //   icon: Icon(Icons.more_vert, color: themColor,),
            //   onSelected: onSelect,
            //   itemBuilder: (BuildContext context) {
            //     return myMenuItems.map((String choice) {
            //       return PopupMenuItem<String>(
            //         child: Text(choice),
            //         value: choice,
            //       );
            //     }).toList();
            //   }
            // )
          ],

          // leading: IconButton(
          //   icon: Icon(Icons.menu, size: 40), // change this size and style
          //   onPressed: () => SideDrawer(),
          // ),

          // leading: Builder(
          //   builder: (context) => IconButton(
          //     icon: Icon(Icons.menu_rounded),
          //     onPressed: () => SideDrawer(),
          //   ),
          // ),

          leading:  Padding(
            padding: const EdgeInsets.only(left: 5),
            child: IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white),
              onPressed: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
               // Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavigationBarService()));
                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> BottomNavigationBarService()));
              },
            ),
          ),

          title: const Text("Book Now",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20,fontFamily: 'WorkSans')),
          
        ),
          
          endDrawer: SizedBox(
            width: MediaQuery.of(context).size.width*0.7,
            child: SideDrawer()
          ),

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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

           



          
          
        
          ),
      );
  }
}