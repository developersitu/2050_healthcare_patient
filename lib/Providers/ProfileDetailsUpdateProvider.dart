
import 'package:flutter/foundation.dart';
import 'package:healthcare2050/Model/ProfileDetailsUpdateModel/ProfileDetailsUpdateModel.dart';
import 'package:healthcare2050/Screens/Profile/ProfilePage.dart';



class ProfileDetailsUpdateProvider extends ChangeNotifier{

  late ProfileDetailsUpdateModel profileDetailsUpdateModel;
  
  sendDataToProfileDetailsUpdateProvider(context,userId,email,mobileNumber,city,state,pincode,address) async{
    
   
    profileDetailsUpdateModel = await postDataToProfileDetailsUpdateServer(context,userId,email,mobileNumber,city,state,pincode,address);

    
  }
}