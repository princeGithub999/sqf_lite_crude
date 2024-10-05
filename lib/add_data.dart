import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'model/db_service.dart';
import 'model/user_model.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final dbService = DbService();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        title: const Text('Add data', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Container(
          height: sizes.size.height * 0.5,
          width: sizes.size.width * 0.8,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.cyanAccent,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                 InkWell(
                   onTap: () {
                      imagePickerF();
                   },
                   child: CircleAvatar(
                   backgroundColor: Colors.cyanAccent,
                   maxRadius: 45,
                   child: ClipOval(child: imageFile != null ?
                   Image.file(imageFile!,width: 80,height: 80,fit: BoxFit.cover,):
                   Icon(CupertinoIcons.person, size: 55, color: Colors.white),)
                 ),),


                const SizedBox(height: 50),
                Card(
                  elevation: 10,
                  shadowColor: Colors.cyanAccent,
                  child: TextFormField(
                    controller: name,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.account_box_outlined),
                      hintText: 'Enter Name',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyanAccent),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyanAccent),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Card(
                  elevation: 5,
                  shadowColor: Colors.cyanAccent,
                  child: TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'Enter Email',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyanAccent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                  onPressed: () {
                    addData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 120,
                      vertical: 10,
                    ),
                  ),
                  child: const Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addData() {
    if (name.text.isEmpty && email.text.isEmpty && imageFile != null) {
      Fluttertoast.showToast(msg: 'Please enter all details');
      return;
    }

    var data = UserModel(
      id: const Uuid().v4(),
      name: name.text.toString(),
      email: email.text.toString(),
      image: imageFile!.path
    );

    dbService.insertUser(data);
    setState(() {});
    name.clear();
    email.clear();

    Fluttertoast.showToast(msg: 'Data Added');
    Navigator.pop(context);


  }

  void imagePickerF()async{
       var pickImageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
       if(pickImageFile != null){
         imageFile = File(pickImageFile.path);

         setState(() {

         });

       }else{

         Fluttertoast.showToast(msg:" don't lode image in imageFile");


       }

  }

}
