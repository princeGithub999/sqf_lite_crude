import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqf_lite_crude/model/db_service.dart';
import 'package:sqf_lite_crude/model/user_model.dart';

class Updatedata extends StatefulWidget {
  final String name;
  final String email;
  final UserModel userModel;
  final String image;
  const Updatedata({super.key, required this.name, required this.email, required this.userModel, required this.image,});

  @override
  State<Updatedata> createState() => _UpdatedataState();
}

class _UpdatedataState extends State<Updatedata> {

  var updateName = TextEditingController();
  var updateEmail = TextEditingController();
  var dbService = DbService();
  late UserModel userModel;
  ImagePicker imagePicker = ImagePicker();
  File? imageFile;

  @override
  void initState() {
    super.initState();

    updateName = TextEditingController(text: widget.name);
    updateEmail = TextEditingController(text: widget.email);
    userModel = widget.userModel;


  }

  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        title: const Text('Update data', style: TextStyle(color: Colors.white)),
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
                 CircleAvatar(
                  backgroundColor: Colors.cyanAccent,
                  maxRadius: 40,
                  child: InkWell(
                    onTap: () {
                      imagePickerF();
                    },
                    child: ClipOval(child: imageFile != null ?
                        Image.file(File(imageFile!.path),width: 70,height: 70,fit: BoxFit.cover,)
                        :Image.file(File(widget.image),width: 70,height: 70,fit: BoxFit.cover,),
                    ),
                  ) ,
                ),
                const SizedBox(height: 50),
                Card(
                  elevation: 10,
                  shadowColor: Colors.cyanAccent,

                  child: TextFormField(
                    controller: updateName,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.account_box_outlined),
                      hintText: 'Update Name',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent),),
                      disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Card(
                  elevation: 5,
                  shadowColor: Colors.cyanAccent,
                  child: TextFormField(
                    controller: updateEmail,
                    decoration:  const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'Update Email',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent),),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                  onPressed: () {

                    updateData(userModel);  // Pass the updated userModel
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
                  child: const Text('Update', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Update data function
  void updateData(UserModel data) {
    var updatedData = UserModel(
      id: data.id,
      name: updateName.text,
      email: updateEmail.text,
      image: imageFile!.path

    );
    dbService.updateUserData(updatedData);
    setState(() {});
    Navigator.pop(context);
  }

  void imagePickerF()async{
    var pickImageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickImageFile!=null){

      imageFile = File(pickImageFile.path);
      setState(() {});
    }else{
      Fluttertoast.showToast(msg: "Don't lode imageFile in image");
    }
  }
}
