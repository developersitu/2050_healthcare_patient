import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:http/http.dart' as http;

class ZoneFetchProvider with ChangeNotifier{

  List zoneList=[];
  bool isloading=true;

  Future fetchZone() async {
     
    var fetchUrl= zoneApi;
    var response = await http.get(Uri.parse(fetchUrl),
      headers:<String, String>
      {
        
      },
    
    );
    // print(response.body);

    if(response.statusCode == 200){
      isloading=false;
      var zoneItems = json.decode(response.body);
      print("CateGory body//////////////////////////////////////////////////////////////////////////////////////////");
      print(zoneItems.toString());

      zoneList = zoneItems;
      
      notifyListeners();

      print("CateGory lIST//////////////////////////////////////////////////////////////////////////////////////////");
      print(zoneList.toString());
    }else{
      zoneList = [];
      isloading=true;
      notifyListeners();
    }
  }


}