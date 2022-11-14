import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:http/http.dart' as http;

class BookAppointmentProvider with ChangeNotifier{

  List cityList=[];
  bool isloading=true;

  Future fetchCity() async {
    
     
    var cityUrl= CityNameApi;
    var response = await http.get(Uri.parse(cityUrl),
      headers:<String, String>
      {
        
      },
    
    );
    // print(response.body);
    if(response.statusCode == 200){
      isloading=false;
      var cityItems = json.decode(response.body)['cityname'];
      print("City body//////////////////////////////////////////////////////////////////////////////////////////");
      print(cityItems.toString());

      cityList = cityItems;
      
      notifyListeners();

      print("City lIST//////////////////////////////////////////////////////////////////////////////////////////");
      print(cityList.toString());
    }else{
      cityList = [];
      isloading=true;
      notifyListeners();
    }
  }


}