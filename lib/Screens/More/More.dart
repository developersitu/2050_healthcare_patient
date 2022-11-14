import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class More extends StatelessWidget {
  const More({ Key? key }) : super(key: key);

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
      home: MoreScreen(),
    );
  }
}

class MoreScreen extends StatefulWidget {
  const MoreScreen({ Key? key }) : super(key: key);

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}