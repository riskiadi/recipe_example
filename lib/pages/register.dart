import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe_example/pages/login.dart';
import 'package:toast/toast.dart';
import 'package:recipe_example/models/loginModel.dart';
import 'package:recipe_example/pages/home.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_example/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  var formKeyRegister = GlobalKey<FormState>();
  var cEmail = TextEditingController();
  var cUsername = TextEditingController();
  var cPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(40),
              child: Form(
                key: formKeyRegister,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Register', style: TextStyle(fontSize: 30),),
                    TextFormField(
                      controller: cEmail,
                      decoration: InputDecoration(
                          hintText: "Email"
                      ),
                      validator: (value) {
                        return value.isEmpty ? "Email harus di isi" : null;
                      },
                    ),
                    TextFormField(
                      controller: cUsername,
                      decoration: InputDecoration(
                          hintText: "Username"
                      ),
                      validator: (value) {
                        return value.isEmpty ? "Username harus di isi" : null;
                      },
                    ),
                    TextFormField(
                      controller: cPassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                      ),
                      obscureText: true,
                      validator: (value) {
                        return value.isEmpty ? "Password harus di isi" : null;
                      },
                    ),
                    MaterialButton(
                      child: Text('Register'),
                      color: Colors.lightBlueAccent,
                      onPressed: () {
                        if(formKeyRegister.currentState.validate()){

                          _registerFunction().then((value){
                            if(value==1){
                              Toast.show("Berhasil Mendaftar", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                              Navigator.pop(context);
                            }else{
                              Toast.show("Gagal Mendaftar", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                            }

                          });

                        }
                      },
                    ),

                    MaterialButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text('Back to Login'),
                      color: Colors.greenAccent,
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<int> _registerFunction() async {
    var input = {
      "email" : cEmail.text,
      "username" : cUsername.text,
      "password" : cUsername.text
    };
    var response = await http.post(ApiUrl.urlRegister, body: input);
    return jsonDecode(response.body)["value"];
  }



}
