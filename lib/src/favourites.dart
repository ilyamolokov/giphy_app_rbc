import 'package:flutter/material.dart';
import '../main.dart';

class FavouritesFolder extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      return FavouritesFolderState();
    }
}

class FavouritesFolderState extends State<FavouritesFolder> {
  @override
    Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: () async => true,
        child:Scaffold(
          backgroundColor: key.currentState.blackColor,
          appBar: AppBar(
            backgroundColor: key.currentState.greenColor,
            title:Text("Избранные гифки: ${key.currentState.favouriteGifsList.length}", style: TextStyle(color: key.currentState.yellowColor),)),
            body: key.currentState.favouriteGifsList.length == 0 ? Center(child:Text("В этой папке пока пусто", style:TextStyle(color:key.currentState.yellowColor))) : favouritesBody() ));
    }

    Widget favouritesBody() {
      return GridView.count(
          crossAxisCount: 2,
          children: List.generate(key.currentState.favouriteGifsList != null ? key.currentState.favouriteGifsList.length : 0, // Две колонки с "Избранными гифками"
           (index) {
            return Stack(alignment: AlignmentDirectional.center, children: <Widget>[Container(child:Stack(alignment: AlignmentDirectional.topEnd, children: <Widget>[
              Image.network(key.currentState.favouriteGifsList[index]),
              ClipRRect(borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  child: FlatButton(
                    padding: EdgeInsets.only(),
                      child: Icon(Icons.clear,size:35.0, color: Colors.red), // если гифка(а точнее ссылка на гифку) в favouriteGifsList => закрась ее желтым, в проивном случае => не закрашивай
                      onPressed: () {
                        setState(() {
                          key.currentState.favouriteGifsList.remove(key.currentState.favouriteGifsList[index]);
                        });
                      })))]), 
                      decoration:BoxDecoration(border: Border.all(width: 1.0, color:Colors.black))),]);
          }),
        );
    }
}