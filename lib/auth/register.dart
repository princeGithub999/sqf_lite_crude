import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqf_lite_crude/auth/sign_in.dart';
import 'package:sqf_lite_crude/model/db_service.dart';
import 'package:uuid/uuid.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  var dbServec = DbService();

  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context).size;
    return   Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset('assets/images/Rectangle_2.png'),
            Image.asset('assets/images/Rectangle_1.png'),

            Padding(
              padding:  EdgeInsets.only(top: 300,left: 20),
              child: Container(
                height: sizes.height * 1,
                width: sizes.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text('Register',style: TextStyle(color: Colors.blueAccent,fontSize: 30),),

                    SizedBox(height: sizes.height * 0.1-50,),
                    Card(
                      child:  TextField(
                         controller: userName,
                        decoration:const InputDecoration(
                          hintText: 'Enter Full Name',
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                          focusedBorder: OutlineInputBorder(borderSide:BorderSide(color: Colors.blueAccent) ),
                          enabledBorder: OutlineInputBorder(borderSide:BorderSide(color: Colors.blueAccent) ),
                        ),
                      ),
                    ),
                    SizedBox(height: sizes.height * 0.1-70,),

                    Card(
                      child:  TextField(
                        controller: userEmail,
                        decoration:const InputDecoration(
                          hintText: 'Enter Email',
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                          focusedBorder: OutlineInputBorder(borderSide:BorderSide(color: Colors.blueAccent) ),
                          enabledBorder: OutlineInputBorder(borderSide:BorderSide(color: Colors.blueAccent) ),
                        ),
                      ),
                    ),

                    SizedBox(height: sizes.height * 0.1-70,),
                    Card(
                      child: TextField(
                        controller: userPassword,
                        decoration:const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Password',
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text('forgot password?',style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.w500),),
                      ),
                    ),
                    SizedBox(height: sizes.height * 0.1-50,),
                    Row(
                      children: [
                        ElevatedButton(onPressed: () {

                        },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 10,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(horizontal: 0,vertical: 5)
                            ),
                            child: Image.asset('assets/images/google.png',height: 30,width: 30,)),

                        const SizedBox(width: 5,),
                        ElevatedButton(onPressed: () {

                        },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 10,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(horizontal: 0,vertical: 5)
                            ),
                            child: Image.asset('assets/images/facebook.png',height: 30,width: 30,)),
                      ],
                    )
                  ],),
              ),
            )

          ],
        ),
      ),
      bottomNavigationBar: Stack(

        children: [
          Image.asset('assets/images/Rectangle_3.png',fit: BoxFit.cover,),
          Padding(
            padding: const EdgeInsets.only(top: 100,right: 20,left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn(),));
                },
                  child: const Text('Already Member? Login',style: TextStyle(color: Colors.white),),
                ),
                OutlinedButton(onPressed: () {
                       register();
                },
                  style: OutlinedButton.styleFrom(

                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),side: BorderSide(color: Colors.white),
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10)
                  ),
                  child: Text('Register',style: TextStyle(color: Colors.white),),)
              ],
            ),
          )
        ],

      ),
    );
  }

  void register() async {
    var name = userName.text;
    var email = userEmail.text;
    var password = userPassword.text;

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      var uuid = const Uuid().v4();
      Map<String, dynamic> user = {
        'id': uuid,
        'userName' :name,
        'userEmail' :email,
        'userPassword' :password,
      };

      await dbServec.insertAuthData(user);
      Fluttertoast.showToast(msg: 'User Registered Successfully');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
    } else {
      Fluttertoast.showToast(msg: 'Please fill all fields');
    }
  }


}
