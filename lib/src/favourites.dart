import 'package:flutter/material.dart';
import '../main.dart';

class FavouritesFolder extends StatefulWidget {
  final _favouriteGifsList;
  final yellowColor;
  final greenColor;
  final blackColor;

  FavouritesFolder(this._favouriteGifsList, this.yellowColor, this.greenColor, this.blackColor);
  @override
    State<StatefulWidget> createState() {
      return FavouritesFolderState();
    }
}

class FavouritesFolderState extends State<FavouritesFolder> {
  List _favouriteGifsList;
  Color yellowColor;
  Color greenColor;
  Color blackColor;

  @override
  void initState() {
    _favouriteGifsList = widget._favouriteGifsList;
    yellowColor = widget.yellowColor;
    greenColor = widget.greenColor;
    blackColor = widget.blackColor;
    super.initState();
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
          backgroundColor: blackColor,
          appBar: AppBar(
            iconTheme: IconThemeData(color:blackColor),
            backgroundColor: greenColor,
            title:Text("Избранные гифки: ${_favouriteGifsList.length}", style: TextStyle(color: yellowColor),)),
            body: _favouriteGifsList.length == 0 ? Center(child:Text("В этой папке пусто", style:TextStyle(color:yellowColor))) : favouritesBody() );
    }

    Widget favouritesBody() {
      return GridView.count(
          crossAxisCount: 2,
          children: List.generate(_favouriteGifsList != null ? _favouriteGifsList.length : 0, // Две колонки с "Избранными гифками"
           (index) {
            return Stack(alignment: AlignmentDirectional.center, children: <Widget>[Container(child:Stack(alignment: AlignmentDirectional.topEnd, children: <Widget>[
              Image.network(_favouriteGifsList[index]),
              ClipRRect(borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  child: FlatButton(
                    padding: EdgeInsets.only(),
                      child: Icon(Icons.clear,size:35.0, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          key.currentState.favouriteGifsList.remove(_favouriteGifsList[index]);
                        });
                      })))]), 
                      decoration:BoxDecoration(border: Border.all(width: 1.0, color:Colors.black))),]);
          }),
        );
    }
}