import 'dart:io';
import 'package:blogs/services/crud.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:path_provider/path_provider.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String authorName, title, desc;
  bool isLoading = false; //for creating a loading effect while uploading
  CrudMethods crudMethods = new CrudMethods(); //instance of crud methods

  File _image; // variable for storing image location
  File file;

  //method to get image from gallery
  Future getImage() async {
    final pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  ///method to upload blog to flutter storage
  uploadBlog() async {
    if (_image != null) {
      setState(() {
        ///for making the isLoading true
        isLoading = true;
      });

      firebase_storage.Reference firebaseStorageRef = firebase_storage

          ///creating storage reference
          .FirebaseStorage
          .instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");
      print("s");

      firebase_storage.UploadTask uploadTask =
          firebaseStorageRef.putFile(_image);

      ///uploading image to storage

      var downloadURL = await (await uploadTask).ref.getDownloadURL();

      ///downloading URL of the uploaded image so that we can download it again to show on main feed
      print(downloadURL);

      Map<String, String> blogMap = {
        "imageURL": downloadURL,
        "authorName": authorName,
        "title": title,
        "desc": desc,
      };
      crudMethods.addData(blogMap);
      Navigator.pop(context);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'New',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Blog',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            )
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Container(
              child: Icon(Icons.file_upload),
              padding: EdgeInsets.symmetric(horizontal: 18),
            ),
          )
        ],
      ),
      body: isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: _image != null
                        ? Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                _image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: 18,
                            ),
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 18,
                            ),
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white70,
                            ),
                            child: Icon(Icons.add_a_photo),
                          ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 18,
                    ),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(hintText: "Author Name"),
                          onChanged: (val) {
                            authorName = val;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Title"),
                          onChanged: (val) {
                            title = val;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Description"),
                          onChanged: (val) {
                            desc = val;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
