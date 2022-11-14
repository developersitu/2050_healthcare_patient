import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare2050/Providers/DoctorsListProvider.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/Search/SearchDoctorList.dart';
import 'package:healthcare2050/Widgets/DoctorCardWidget.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AllDoctorListPage extends StatelessWidget {
  const AllDoctorListPage({ Key? key }) : super(key: key);

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
    
    context.read<DoctorListProvider>().fetchData;
   // context.read<CheckingInternetConnection>().checkRealtimeConnection();


   

    //// checking  connectivity start
    String status = "Waiting...";
    Connectivity _connectivity = Connectivity();
    late StreamSubscription _streamSubscription;
    
    void checkConnectivity() async {
      var connectionResult = await _connectivity.checkConnectivity();

      if (connectionResult == ConnectivityResult.mobile) {
        status = "MobileData";
      
      } else if (connectionResult == ConnectivityResult.wifi) {
        status = "Wifi";
      
      } else {
        status = "Not Connected";
    
      }
      
    }

    void checkRealtimeConnection() {
      _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
        if (event == ConnectivityResult.mobile) {
          status = "MobileData";

        } else if (event == ConnectivityResult.wifi) {
          status = "Wifi";

        } else {
          status = "Not Connected";

          showTopSnackBar(
            context,
            
            CustomSnackBar.error(
            // backgroundColor: Colors.red,
              message:
                  "No Internet \n Please Check Internet Connection !!!",
            ),
          );
      
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     behavior: SnackBarBehavior.floating,
          //     margin: EdgeInsets.only(bottom: 100.0),
          //      duration: const Duration(seconds: 2),
          //     content: new Text("No Internet",style: TextStyle(color: Colors.white),),
          //     backgroundColor: Colors.red,
          //   )
          // );
      

        }
      
      });
    }
    //// checking  connectivity end

    return Container(
      width: width,
      height: height,
        decoration: const BoxDecoration(
        gradient: RadialGradient(
          radius: 0.8,
          colors: [
            Colors.white,
            Color(0xFFb6e5e5),
            
          ],
        )
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Our Doctors"),
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
                  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> BottomNavigationBarPage()));
                },
              ),
            ),
          ),

          actions: [
            // Navigate to the Search Screen
            IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SearchDoctorList())),
              icon: Icon(Icons.search)
            )
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

        body:  NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return false;
          }, 
          child: RefreshIndicator(
            onRefresh: () async{
              //context.read<NewsDataProvider>().fetchData;
              await context.read<DoctorListProvider>().fetchData;
            },
            child: Center(
              child: Consumer<DoctorListProvider>(
                builder: (context,value,child){
                  return  value.list.isEmpty && !value.error ? const CircularProgressIndicator() :
                  value.error ? Text("oops! something error ${value.errorMessage}",textAlign: TextAlign.center,) :
                  ListView.builder(
                    itemCount: value.list.length,
                    itemBuilder: (context,index){
                      return DoctorCard(map: value.list[index]);
        
                    }
                  );
                },
              ),
            ), 
          ),
        ),
        
      ),
    );
  }
}

// class NewsCard extends StatelessWidget {
//   const NewsCard({ Key? key , required this.map}) : super(key: key);

//   final Map<String, dynamic> map;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Card(
//         elevation: 10,
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.network('${map['image']}'),
//               const SizedBox(height: 10,),
//               Text('${map['heading']}',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w800,
//                   fontSize: 20
//                 ),
//               ),
//               const SizedBox(height: 10,),
//               Text('${map['story']}',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 15
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }