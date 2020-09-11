import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_example/models/recipesModel.dart';
import 'package:recipe_example/pages/create.dart';
import 'package:recipe_example/pages/detail.dart';
import 'package:recipe_example/pages/login.dart';
import 'package:recipe_example/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<RecipesModel> _content;
  int _bottomNavbarIndex = 0;
  SharedPreferences sharedPref;

  String _userid;
  String _username;
  String _email;

  @override
  void initState() {
    _getContent().then((value){
      setState(() {
        _content = value;
      });
    });
    _getPreference().then((value){
      setState(() {
        sharedPref = value;
        _userid = value.getString('userid');
        _username = value.getString('username');
        _email = value.getString('email');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Recipe App'),
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        currentIndex: _bottomNavbarIndex,
        onTap: (value){
          setState(() {
            _bottomNavbarIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.create), title: Text("Create")),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text("Account")),
        ],
      ),
      body: _pageViews(_bottomNavbarIndex),
    );
  }
  


  _pageViews(int page){
    switch(page){
      case 1 : {
        return createView();
      }break;
      case 2 : {
        return accountView();
      }break;
      default:{
        return homeView();
      }
    }
  }

  Widget homeView() {
    return RefreshIndicator(
      onRefresh: _refreshContent,
      child: ListView.builder(
        itemCount: _content==null ? 0 : _content.length,
        itemBuilder: (context, index) {
          RecipesModel recipesModel = _content[index];
          return Container(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 15),
            child: Material(
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(content: _content[index],),)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset('assets/profile.jpg',width: 50, height: 50, fit: BoxFit.cover,),
                          SizedBox(width: 8,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(recipesModel.info.creatorUsername, style: TextStyle(fontSize: 20),),
                              Text(recipesModel.info.creatorEmail, style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.4)),),
                            ],
                          )
                        ],
                      ),
                    ),
                    Image.network(
                      "http://192.168.100.2/recipe_example/images/${recipesModel.recipe.image}",
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(recipesModel.recipe.title,
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.w500
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5,),
                          Text(recipesModel.recipe.about,
                            style: TextStyle(fontSize: 17, color: Colors.black.withOpacity(0.4)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget createView(){
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 15)]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/recipe.png', width: 100,),
            SizedBox(height: 20,),
            Text('Write Your Recipe'),
            SizedBox(height: 40,),
            MaterialButton(
              child: Text('Write', style: TextStyle(color: Colors.white),),
              color: Colors.blue,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePage(creatorID: _userid,),));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget accountView(){
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 15)]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/profile.jpg', width: 100, height: 100, fit: BoxFit.cover,),
            SizedBox(height: 20,),
            Text( _username ),
            Text( _email ),
            SizedBox(height: 20,),
            FlatButton(
              child: Text('Logout', style: TextStyle(color: Colors.red),),
              onPressed: (){
                sharedPref.clear();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Future<List<RecipesModel>>_getContent() async {
    var response = await http.get(ApiUrl.urlGetRecipes);
    return recipesModelFromJson(response.body);
  }

  Future<Null> _refreshContent() async{
    _getContent().then((value){
      setState(() {
        _content = value;
        Toast.show("Refreshed", context);
      });
    });
  }

  Future<SharedPreferences> _getPreference()async{
    var sp = await SharedPreferences.getInstance();
    return sp;
  }

}
