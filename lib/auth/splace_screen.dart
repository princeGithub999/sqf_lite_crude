import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqf_lite_crude/auth/sign_in.dart';
import 'package:sqf_lite_crude/home_page.dart';
import 'package:sqf_lite_crude/model/db_service.dart';

class SplaceScreen extends StatefulWidget {
  const SplaceScreen({super.key});

  @override
  State<SplaceScreen> createState() => _SplaceScreenState();
}

class _SplaceScreenState extends State<SplaceScreen> {

  var dbServes = DbService();
  List<Map<String, dynamic>> userList =[];
  int? isLogin;
  @override
  void initState() {
    super.initState();
    feachData();
    splace();

  }
  @override
  Widget build(BuildContext context) {

    var sizes = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset('assets/images/Rectangle_2.png'),
            Image.asset('assets/images/Rectangle_1.png'),

            Padding(
              padding: const EdgeInsets.only(top: 350,left: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                            children: [
              Image.asset('assets/images/ls_yapcasialogomark.png'),

              Text('Lorem',style: TextStyle(color: Colors.lightBlueAccent,fontSize: 30),),
              Text('consequat duis\n enim velit ',style: TextStyle(color: Colors.lightBlueAccent,fontSize: 20),)],

              ),
            )

          ],
        ),
      ),
      bottomNavigationBar: Stack(

        children: [

          Image.asset('assets/images/Rectangle_3.png',fit: BoxFit.cover,)
        ],
      ),
    );
  }

  void feachData()async{
       var user = await dbServes.getAuthData();

       setState(() {
         userList = user;
         isLogin = userList[0]['isLogin'];
       });
  }

  void splace(){
    Timer(Duration(seconds: 2),() {

      if(isLogin == 1 && isLogin != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn(),));
      }

    },);
  }
}
