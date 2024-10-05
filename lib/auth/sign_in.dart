import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqf_lite_crude/auth/register.dart';
import 'package:sqf_lite_crude/home_page.dart';
import 'package:sqf_lite_crude/model/db_service.dart';



class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var index = 0;
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  var dbServes = DbService();
  List<Map<String, dynamic>> userList = [];

  String? getId;
  String? getName;
  String? getEmail;
  String? getPassword;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    feachData();
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
              padding: EdgeInsets.only(top: 350, left: 20),
              child: Container(
                height: sizes.height * 1,
                width: sizes.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 30),
                    ),
                    SizedBox(height: sizes.height * 0.1 - 50),
                    Card(
                      child: TextField(
                        controller: userEmail,
                        decoration: const InputDecoration(
                          hintText: 'Enter Email',
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                        ),
                      ),
                    ),

                    SizedBox(height: sizes.height * 0.1 - 60),
                    Card(
                      child: TextField(
                        controller: userPassword,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter password',
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text('Forgot password', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),

                    SizedBox(height: sizes.height * 0.1 - 50),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 10,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5)),
                            child: Image.asset('assets/images/google.png', height: 30, width: 30,)),
                        const SizedBox(width: 5),

                        ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 10,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5)),
                            child: Image.asset('assets/images/facebook.png', height: 30, width: 30,)),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          Image.asset('assets/images/Rectangle_3.png', fit: BoxFit.cover,),
          Padding(
            padding: const EdgeInsets.only(top: 100, right: 20, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Register(),),);
                  },
                  child: const Text('New Here? Register', style: TextStyle(color: Colors.white),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    login();
                  },
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                  child: const Text('Login', style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  // getAuthData and store variable
  void feachData() async {
    var data = await dbServes.getAuthData();
    setState(() {
      userList = data;
      if (userList.isNotEmpty) {
        getId = userList[index]['id'];
        getName = userList[index]['userName'];
        getEmail = userList[index]['userEmail'];
        getPassword = userList[index]['userPassword'];
      }
    });
  }


  // Compare data
  void login() {
    var email = userEmail.text;
    var password = userPassword.text;

    if (email == getEmail && password == getPassword) {
      addBool();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      Fluttertoast.showToast(msg: 'Wrong email or password');
    }
  }


  // add true value data in table
  void addBool() async {
    setState(() {
      isLogin = true;
    });

    Map<String, dynamic> updatedUser = {
      // 'userName': getName,
      // 'userEmail': getEmail,
      // 'userPassword': getPassword,
      'isLogin': isLogin
    };

    await dbServes.updateAuthData(getId, updatedUser);
  }
}


