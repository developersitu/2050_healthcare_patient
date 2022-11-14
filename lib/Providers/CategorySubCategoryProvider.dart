import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:http/http.dart' as http;

class CategorySubCategoryProvider with ChangeNotifier{

  List categoryList=[];
  bool isloading=true;

  Future fetchCategory() async {
    
     
    var categoryUrl= categoryApi;
    var response = await http.get(Uri.parse(categoryUrl),
      headers:<String, String>
      {
        
      },
    
    );
    // print(response.body);
    if(response.statusCode == 200){
      isloading=false;
      var categoryItems = json.decode(response.body);
      print("CateGory body//////////////////////////////////////////////////////////////////////////////////////////");
      print(categoryItems.toString());

      categoryList = categoryItems;
      
      notifyListeners();

      print("CateGory lIST//////////////////////////////////////////////////////////////////////////////////////////");
      print(categoryList.toString());
    }else{
      categoryList = [];
      isloading=true;
      notifyListeners();
    }
  }


}