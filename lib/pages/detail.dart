import 'package:flutter/material.dart';
import 'package:recipe_example/models/recipesModel.dart';
import 'package:full_screen_image/full_screen_image.dart';

class DetailPage extends StatefulWidget {
  final RecipesModel content;

  const DetailPage({Key key, @required this.content}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FullScreenWidget(
              child: Hero(
                tag: "fullImage",
                child: Image.network(
                  "http://192.168.100.2/recipe_example/images/${widget.content.recipe.image}",
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),),
            ),
            Container(
                padding: const EdgeInsets.all(15),
                child: Text(
                  widget.content.recipe.title,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  ClipOval(
                      child: Image.asset('assets/profile.jpg', width: 60, height: 60, fit: BoxFit.cover,)
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.content.info.creatorUsername, style: TextStyle(fontSize: 19),),
                      Text(widget.content.info.creatorEmail, style: TextStyle(fontSize: 15),),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(widget.content.recipe.about, style: TextStyle(fontSize: 19),),
            ),

            Divider(height: 50, thickness: 1,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text("Ingredient", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,),),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(widget.content.recipe.ingredient, style: TextStyle(fontSize: 19),),
            ),

            Divider(height: 50, thickness: 1,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text("Step", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,),),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(widget.content.recipe.step, style: TextStyle(fontSize: 19),),
            ),
            SizedBox(height: 20,)

          ],
        ),
      ),
    );
  }
}
