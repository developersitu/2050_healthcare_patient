import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:http/http.dart' as http;

class SpecializationProvider with ChangeNotifier{

  List specializationList=[];
  bool isloading=true;

  Future fetchSpecialization() async {
     
    var fetchUrl= specializationApi;
    var response = await http.get(Uri.parse(fetchUrl),
      headers:<String, String>
      {
        
      },
    
    );
    // print(response.body);

    if(response.statusCode == 200){
      isloading=false;
      var specializationItems = json.decode(response.body);
      print("specializationList body//////////////////////////////////////////////////////////////////////////////////////////");
      print(specializationItems.toString());

      specializationList = specializationItems;
      
      notifyListeners();

      print("specializationList lIST//////////////////////////////////////////////////////////////////////////////////////////");
      print(specializationList.toString());
    }else{
      specializationList = [];
      isloading=true;
      notifyListeners();
    }
  }


}