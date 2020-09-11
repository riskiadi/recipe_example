import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_example/pages/home.dart';
import 'package:recipe_example/utils/api.dart';
import 'package:toast/toast.dart';

class CreatePage extends StatefulWidget {

  final String creatorID;

  const CreatePage({Key key, @required this.creatorID}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {

  var _formPostKey = GlobalKey<FormState>();

  final cTitle = TextEditingController();
  final cDescription = TextEditingController();
  final cIngredient = TextEditingController();
  final cStep = TextEditingController();

  File _image ;
  var _base64Image;
  final picker = ImagePicker();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F5F3),
      appBar: AppBar(
        title: Text('Create Recipe'),
        actions: [
          FlatButton(
            child: Row(
              children: [
                Icon(Icons.send, color: Colors.white,),
                SizedBox(width: 10,),
                Text('POST', style: TextStyle(color: Colors.white),),
              ],
            ),
            onPressed: () {
              _postData().then((value){
                value ? Toast.show("Post Successful", context) : Toast.show("Post Failed", context);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(),), (route) => false);
              });
            },
          ),
        ],
      ),
      body: Form(
        key: _formPostKey,
        child: ListView(
          children: [
            _image==null?addImageButton() : imageShow(),
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Title: Chicken Soup',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.2), fontWeight: FontWeight.bold, fontSize: 19),
                      filled: true,
                      fillColor: Color(0xffF6F5F3),
                      border: InputBorder.none,
                    ),
                    validator: (value){
                      return value.isEmpty ? "Please fill title" : null ;
                    },
                    controller: cTitle,
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: cDescription,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Story behind this your recipe (Ex: whats your inspiration, what make this recipe unique).',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.2), fontSize: 15),
                      filled: true,
                      fillColor: Color(0xffF6F5F3),
                      border: InputBorder.none,
                    ),
                    validator: (value){
                      return value.isEmpty ? "Please fill recipe description" : null ;
                    },
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ingredient', style: TextStyle(color: Color(0XFF4A4A4A), fontSize: 20, fontWeight: FontWeight.bold,),),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: cIngredient,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: '1 teaspoon sugar\n2 teaspoons salt\n3/4 cups (490 g) bread flour\nExtra virgin olive oil',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.2), fontSize: 15),
                      filled: true,
                      fillColor: Color(0xffF6F5F3),
                      border: InputBorder.none,
                    ),
                    validator: (value){
                      return value.isEmpty ? "Please fill Ingredient" : null ;
                    },
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Step', style: TextStyle(color: Color(0XFF4A4A4A), fontSize: 20, fontWeight: FontWeight.bold,),),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: cStep,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: '1. Place the warm water in the large bowl of a heavy duty stand mixer.\n2. Sprinkle the yeast over the warm water and let it sit for 5 minutes until the yeast is dissolved.',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.2), fontSize: 15),
                      filled: true,
                      fillColor: Color(0xffF6F5F3),
                      border: InputBorder.none,
                    ),
                    validator: (value){
                      return value.isEmpty ? "Please fill step" : null ;
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget addImageButton(){
    return Material(
      color: Color(0XFFECEBE9),
      child: InkWell(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
          child: Column(
            children: [
              Icon(Icons.camera_enhance, size: 40,),
              Text('Add Image Recipe')
            ],
          ),
        ),
        onTap:() {
        showDialog(context: context, builder: (context) => _imagePickerDialog(),);
        },
      ),
    );
  }

  Widget imageShow(){
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.file(
          _image,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Material(
          color: Colors.white.withOpacity(0.5),
          child: InkWell(
            child: Container(
                padding: const EdgeInsets.all(9),
                child: Text("Change Picture")
            ),
            onTap: (){
              showDialog(context: context, builder: (context) => _imagePickerDialog(),);
            },
          ),
        ),
      ],
    );
  }

  Future getImage(ImageSource source) async{
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      _image = File(pickedFile.path);
      _base64Image = base64Encode(_image.readAsBytesSync());
    });
  }

  Future<bool> _postData() async {
    if(_formPostKey.currentState.validate() && _image!=null){

      var input = {
        "image": _base64Image,
        "imageExtension": _image.path.split('.').last,
        "title": cTitle.text,
        "about": cDescription.text,
        "ingredient": cIngredient.text,
        "step": cStep.text,
        "creator": widget.creatorID,
      };

      var response = await http.post(ApiUrl.urlPostRecipes, body: input);
      if(response.statusCode==200){
        return jsonDecode(response.body)["value"]==1 ? true : false;
      }else{
        return false;
      }
    }
  }

  AlertDialog _imagePickerDialog(){
    return AlertDialog(
      title: Text("Choose image picker"),
      actions: [
        FlatButton(
          child: Text('Gallery'),
          onPressed:() => getImage(ImageSource.gallery),
        ),
        FlatButton(
          child: Text('Camera'),
          onPressed:() => getImage(ImageSource.camera),
        ),
      ],
    );
  }

}
