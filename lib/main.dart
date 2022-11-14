import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthcare2050/Providers/BookAppointmentProvider.dart';
import 'package:healthcare2050/Providers/BookNowHistoryProvider.dart';
import 'package:healthcare2050/Providers/CategorySubCategoryProvider.dart';
import 'package:healthcare2050/Providers/CityListProvider.dart';
import 'package:healthcare2050/Providers/OfflineDoctorConsultProvider.dart';
import 'package:healthcare2050/Providers/DoctorSpecialtyListProvider.dart';
import 'package:healthcare2050/Providers/DoctorsListProvider.dart';
import 'package:healthcare2050/Providers/OnlineDoctorConsultProvider.dart';
import 'package:healthcare2050/Providers/ProfileDetailsUpdateProvider.dart';
import 'package:healthcare2050/Providers/RequestAserviceProvider.dart';
import 'package:healthcare2050/Providers/SpecializationProvider.dart';
import 'package:healthcare2050/Providers/ZoneFetchProvider.dart';
import 'package:healthcare2050/Screens/SplashScreen/SplashScreen.dart';
import 'package:provider/provider.dart';

void main() {
 // runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CategorySubCategoryProvider>.value(value: CategorySubCategoryProvider()),
        ChangeNotifierProvider<DoctorListProvider>.value(value: DoctorListProvider()),
        ChangeNotifierProvider<CityListProvider>.value(value: CityListProvider()),
        ChangeNotifierProvider<BookNowHistoryListProvider>.value(value: BookNowHistoryListProvider()),
        ChangeNotifierProvider<DoctorSpecialtyListProvider>.value(value: DoctorSpecialtyListProvider()),
        ChangeNotifierProvider<ZoneFetchProvider>.value(value: ZoneFetchProvider()),
        ChangeNotifierProvider<SpecializationProvider>.value(value: SpecializationProvider()),
        ChangeNotifierProvider<OnlineDoctorConsultProvider>.value(value: OnlineDoctorConsultProvider()),
        ChangeNotifierProvider<OfflineDoctorConsultProvider>.value(value: OfflineDoctorConsultProvider()),
        ChangeNotifierProvider<RequestAServiceProvider>.value(value: RequestAServiceProvider()),
        ChangeNotifierProvider<BookAppointmentProvider>.value(value: BookAppointmentProvider()),
        ChangeNotifierProvider<ProfileDetailsUpdateProvider>.value(value: ProfileDetailsUpdateProvider()),
      
        //ChangeNotifierProvider(create: (_) => User())
      
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    //return GetMaterialApp(
    return GetMaterialApp(
      defaultTransition: Transition.zoom,
      initialRoute: '/',
      // getPages: [
      //   GetPage(name: 'videoCall/', page: () => CallPage()),
      //   // GetPage(name: '/second', page: () => Second()),
      //   // GetPage(
      //   //   name: '/third',
      //   //   page: () => Third(),
      //   //   transition: Transition.zoom  
      //   // ),
      // ],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: Splash(),
    );
  }
}

