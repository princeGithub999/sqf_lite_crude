import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqf_lite_crude/auth/sign_in.dart';
import 'package:sqf_lite_crude/updateData.dart';
import 'add_data.dart';
import 'model/db_service.dart';
import 'model/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final dbService = DbService();
  List<Map<String,dynamic>>  userList = [];
  bool? isLogin;
  String? getId;

  @override
  void initState() {
    super.initState();
    feachData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        title: const Text('SQF LITE', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(onPressed: () {
              logOut();
            }, icon: Icon(Icons.login,color: Colors.white,)),
          )
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: dbService.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No User Data'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Updatedata(
                        name: snapshot.data![index].name,
                        email: snapshot.data![index].email,
                        userModel: snapshot.data![index],
                        image:snapshot.data![index].image
                      ),
                    ),
                  ).then((value) {
                    dbService.getUserData();
                    setState(() {

                    });
                  },);
                },
                child: Card(
                  child:ListTile(
                    leading:  CircleAvatar(

                      maxRadius: 30,
                      backgroundColor: Colors.cyanAccent,
                      child: InkWell(
                        child: ClipOval(child: Image.file(File(snapshot.data![index].image),width: 50,height: 50,fit: BoxFit.cover,),),
                      )),
                    
                    title: Text(snapshot.data![index].name,style: const TextStyle(fontSize: 23,color: Colors.cyanAccent),),
                    subtitle: Text(snapshot.data![index].email,style: TextStyle(color: Colors.cyanAccent.withOpacity(0.5)),),

                    trailing:  IconButton(onPressed: () {
                      deleteData(snapshot.data![index].id);
                    },
                      icon: const Icon(Icons.delete,color: Colors.cyanAccent,),),
                  ),

                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.cyanAccent,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddData()),).then((value) {
            setState(() {
              dbService.getUserData();
            });
          },);
        },
        label: const Text('Add Page', style: TextStyle(color: Colors.white)),
        icon: const Icon(CupertinoIcons.add, color: Colors.white),
      ),
    );
  }

  void deleteData(String id){
        dbService.deleteUserData(id);
        setState(() {});
  }

  void feachData()async{
       var data = await dbService.getAuthData();
       setState(() {
         userList = data;
          getId = userList[0]['id'];

       });
  }

  void logOut() {
    setState(() {
      isLogin = false;
    });
    Map<String, dynamic> updateData = {'isLogin': isLogin};

    dbService.updateAuthData(getId, updateData);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignIn(),
        ));
    Fluttertoast.showToast(msg: 'LogOut success');
  }
}
