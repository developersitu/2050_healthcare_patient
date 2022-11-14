import 'dart:io';

class CheckInternet{
  bool connected=false;
  checkInternet() async{
    try{
      final result =await InternetAddress.lookup("google.com");
      if(result.isNotEmpty && result[0].rawAddress.isEmpty){

        
        connected=true;
          //print("connection "+ connected.toString());
        return connected;
          
      }
    } on SocketException  catch (_) {

      
        connected=false;
       // print("connection "+ connected.toString());
      
      return connected;
      
      
    }
  }
}