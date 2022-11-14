import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:http/http.dart';

class DoctorListProvider with ChangeNotifier{
  List _list= [];
  bool _error = false;
  String _errorMessage="";

  List get list =>_list;
  bool get error => _error;
  String get errorMessage => _errorMessage;

  Future<void> get fetchData async{
    final response = await get(
      Uri.parse(allDoctorsListApi)
    );

    if(response.statusCode==200){
      try{
        _list=jsonDecode(response.body);
        _error=false;
      }
      catch(e){
        _error=true;
        _errorMessage=e.toString();
        _list=[];
      }
    }
    else{
      _error=true;
      _errorMessage="Error: It could be your Internet error";
      _list=[];
    }

    notifyListeners();
  }

  void intialvalues(){
    _list=[];
    _error=false;
    _errorMessage='';
    notifyListeners();
  }

}