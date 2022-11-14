import 'package:flutter/material.dart';
import 'package:healthcare2050/constants/constants.dart';

class CategoryCard extends StatelessWidget {
  

  const CategoryCard({ Key? key , required this.map}) : super(key: key);

  final Map<String, dynamic> map;
  static List sublist=[];

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          sublist.clear();
          sublist.addAll(map['subcategory']);
         // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SubList()));
          print("sub category "+sublist.length.toString() );
        },
                      child: SizedBox(
                                    width: 120,
                                    height: 50,
                                    child: Card(
                                      color: themAmberColor,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 40,
                                           // child: Image.asset("assets/Home/rehabilation.png",width: 100,height: 60,)
                                           child: Image.network("http://101.53.150.64/2050Healthcare/public/category/"+map['Icon']),
                                          ),
                                         
                                          SizedBox(
                                            height: 20,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8,right: 8,top: 2),
                                              child: FittedBox(child: Text(map['CategoryName'].toString().split('_').join(' '),style: TextStyle(color: Colors.black45,fontFamily: 'WorkSans',fontWeight: FontWeight.w600),)),
                                              //child: FittedBox(child: Text(categoryList[index]['CategoryName'].toString(),style: TextStyle(color: Colors.black45,fontFamily: 'WorkSans',fontWeight: FontWeight.w600),)),
                                            ),
                                          )
                                          
                                        ],
                                      ),
                                    ),
                                  ),
      ),
    );
  }
}