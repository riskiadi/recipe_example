import 'package:flutter/material.dart';
import 'package:recipe_example/pages/register.dart';
import 'package:toast/toast.dart';
import 'package:recipe_example/models/loginModel.dart';
import 'package:recipe_example/pages/home.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_example/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var formKeyLogin = GlobalKey<FormState>();
  var cUsername = TextEditingController();
  var cPassword = TextEditingController();

  @override
  void initState() {
    _isLogin().then((loggedIn){
      print(loggedIn);
      if(loggedIn){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(40),
              child: Form(
                key: formKeyLogin,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Login', style: TextStyle(fontSize: 30),),
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
                      child: Text('Login'),
                      color: Colors.lightBlueAccent,
                      onPressed: () {
                        if(formKeyLogin.currentState.validate()){

                          _loginFunction().then((value){
                            Toast.show(value.message, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                            if(value.value==1){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
                              _saveData(value.userId,value.username, value.email);
                            }
                          });

                        }
                      },
                    ),
                    
                    MaterialButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(),));
                      },
                      child: Text('Register'),
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

  Future<LoginModel> _loginFunction() async {
    var input = {
      "username" : cUsername.text,
      "password" : cUsername.text
    };
    var response = await http.post(ApiUrl.urlLogin, body: input);
    return loginModelFromJson(response.body);
  }

  _saveData(String userId,String username, String email) async{
    var sp = await SharedPreferences.getInstance();
    sp.setString('userid' ,userId);
    sp.setString('username' ,username);
    sp.setString('email' ,email);
  }

  Future<bool> _isLogin() async {
    var sp = await SharedPreferences.getInstance();
    print(sp.getString('username'));
    return sp.getString('username')!=null;
  }


}
