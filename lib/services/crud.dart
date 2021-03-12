import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods{

  CollectionReference blog = FirebaseFirestore.instance.collection("blogs");  //A reference to access database is created.

  //below method is for adding data to the database.
  Future<void> addData(blogData){
    blog.add(blogData).catchError((e){
      print(e);
    });
  }

}