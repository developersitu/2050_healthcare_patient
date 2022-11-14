import 'dart:io';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/Providers/CategorySubCategoryProvider.dart';
import 'package:healthcare2050/Providers/CityListProvider.dart';
import 'package:healthcare2050/SideNavigationDrawer/SideNavigationDrawerPrevious.dart';
import 'package:healthcare2050/SideNavigationDrawer/navigation_drawer_widget.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

class Service extends StatelessWidget {
  const Service({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /// screen Orientation end///////////

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    context.read<CategorySubCategoryProvider>().fetchCategory();
    context.read<CityListProvider>().fetchCity();

    String ? subCategories_dropdown_id;
    List showSubCategoriesList=[];


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(secondary: Colors.greenAccent),
      ),
      home: Container(
        width: width,
        height: height,
          decoration: const BoxDecoration(
          gradient: RadialGradient(
            radius: 0.8,
            colors: [
              Colors.white,
             // Color(0xFFb6e5e5),
              Colors.white,
            ],
          )
        ),
    
        child: Scaffold(
          backgroundColor: Colors.white,
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
                        child: const Text("Services",style: TextStyle(fontFamily: 'WorkSans',fontSize: 25,fontWeight: FontWeight.w700,color: Colors.white),)
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width*0.9,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(color: Colors.black45, spreadRadius: 1),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left:0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.search,color: Colors.black45, size: 30,),
                                  SizedBox(
                                    width: width*0.7,
                                    height: 50,
                                    child: const FittedBox(child: Text("Search to find healing experience..", style: TextStyle(fontSize: 8,fontWeight: FontWeight.w600,color: Colors.black38,fontFamily: 'RaleWay'),textAlign: TextAlign.left,))
                                  ),
                                ]  
                              ),
                            ),
                          ),

                          SizedBox(width: 10,),

                          InkWell(
                            onTap: (){
                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)
                                  )
                                ),
                                elevation: 4,
                                context: context,
                                builder: (context) {
                                  return  Consumer<CityListProvider>(
                                    builder: (context,value,child){
                                      return value.cityList.isEmpty ? const CircularProgressIndicator() :
                                    
                                      NotificationListener<OverscrollIndicatorNotification>(
                                        onNotification: (overscroll) {
                                          overscroll.disallowGlow();
                                          return false;
                                        }, 
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView.builder(
                                            itemCount: value.cityList.length,
                                            itemBuilder: (context, index) {
                                                                      
                                              String category_name=value.cityList[index]['CityName'].toString().split('-').join(' ');
                                              category_name.split('-').join('');
                                              return 
                                                                      
                                              ExpansionTileCard(
                                                baseColor: Colors.white,
                                                expandedColor: themColor,
                                                                      
                                                leading: CircleAvatar(
                                                  //backgroundColor: Colors.transparent,
                                                  child: Image.network("http://101.53.150.64/2050Healthcare/public/city/"+value.cityList[index]['Icon'].toString()),
                                                 // child: Image.network("http://101.53.150.64/2050Healthcare/public/city/3533170881641806124.png",)
                                                ),
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
                                                        value.cityList[index]['StateName'].toString(),style: TextStyle(color: Colors.white),
                                                      
                                                            
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                                                        
                                                                      
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              );

                            },
                            child: Card(
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(150),
                              ),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  // The child of a round Card should be in round shape 
                                  shape: BoxShape.circle, 
                                  color: Colors.blue
                                ),
                          
                                child: Icon(Icons.location_city,color: Colors.white),
                                
                              )
                            ),
                          ),

                        ]  
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
    
          body:  NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return false;
          }, 
            child: RefreshIndicator(
              onRefresh: () async{
                //context.read<NewsDataProvider>().fetchData;
                await context.read<CategorySubCategoryProvider>().fetchCategory();
                await context.read<CityListProvider>().fetchCity();
                
              },
              child: Center(
                child: Consumer<CategorySubCategoryProvider>(
                  builder: (context,value,child){
                    return value.categoryList.isEmpty ? const CircularProgressIndicator() :
                   
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: value.categoryList.length,
                        itemBuilder: (context, index) {
              
                          String category_name=value.categoryList[index]['CategoryName'].toString().split('-').join(' ');
                          showSubCategoriesList=value.categoryList[index]['subcategory'];

                          print("SubCategory list >>>>>>>>>>>>>>>>>> got "+ showSubCategoriesList.toString());
                          
                          category_name.split('-').join('');
                          return 
              
                          ExpansionTileCard(
                            baseColor: Colors.white,
                            expandedColor: themColor,
              
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Image.network("http://101.53.150.64/2050Healthcare/public/category/"+value.categoryList[index]['Icon'],color: themGreenColor,)
                            ),
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
                                    value.categoryList[index]['Description'].toString(),style: TextStyle(color: Colors.white),
                                  
                                      
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
                                  child: OutlinedButton(
                                    child: Text('Book Now'),
                                    style: OutlinedButton.styleFrom(
                                      primary: Colors.white,
                                      backgroundColor: themColor,
                                      side: BorderSide(color: Colors.blue, width: 2),
                                    ),
                                    onPressed: () {
                                      print('Pressed');
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Are you sure?'),
                                          content: Column(
                                            children: [

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
                                                  child: Text('Please Choose Service',style: TextStyle(fontFamily: 'RaleWay',fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black38)),
                                                ),
                                                onChanged: (itemid) {
                                                  subCategories_dropdown_id = itemid;
                                                },
                                                    
                                                    
                                              // validator: (value) => value == null ? 'Service is required' : null,
                                                items: showSubCategoriesList.map((list) {
                                                  return DropdownMenuItem(
                                                    value: list['Id'].toString(),
                                                    child: FittedBox(child: Padding(
                                                      padding: const EdgeInsets.only(left: 0),
                                                      child: Text(list['SubcategoryName'].toString() ,style: TextStyle(color: Color(0xff454f63), fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 16),),
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

                                            ],
                                          ),
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
                                        )
                                      );  
            

                                     // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BookNow()));
                                    },
                                  )
                                    
                                  
                                        
                                  
                                ),
                              ),
                            ],
                          );
                
              
                        },
                      ),
                    );
                  },
                ),
              ), 
            ),
          ),

          // floatingActionButton: DraggableFab(
          //   child: 
          //   FloatingActionButton(
          

          //     backgroundColor: themAmberColor,
          //     onPressed: () {


                
          //       //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Whatsup()));

          //       //FlutterOpenWhatsapp.sendSingleMessage(whatsapp, "hy");
          //       // whatsAppOpen();
          //     // openwhatsapp();
          //     // FlutterOpenWhatsapp.sendSingleMessage("919438353325", "Hello");
          //     },
          //     child:const  Icon(Icons.location_city,color: Colors.black45,),
          //   ),
          // ),
    

        ),
    
      ),

       
    );
  }

  
}