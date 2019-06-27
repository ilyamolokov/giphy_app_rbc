import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './src/favourites.dart';
import 'dart:async';

final key = new GlobalKey<HomePageState>();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: HomePage(key : key),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  var gifList = [];
  int _numberOfGifs = 6;
  List favouriteGifsList = [];

  Color yellowColor = Color(0xfffaf4c4);
  Color greenColor = Color(0xff6fcb9f);
  Color blackColor = Color(0xff2b4754);

  _fetchData(String customText,int _numberOfGifs) async {
    String url = "http://api.giphy.com/v1/gifs/search?q=$customText&api_key=ek1WbrYT4BmREGaVRS6YSQKjscqLAbHQ&limit=$_numberOfGifs";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final map = json.decode(response.body);

      if (this.gifList.length >= 6) {
        setState(() {
          var mapData = map['data'];
          List _gifList = [];
          for (int i=0; i < mapData.length; i++) {
            _gifList.add(mapData[i]['images']['fixed_height']['url'].toString());
          }
          _gifList = _gifList.reversed.toList(); // берем четыре последних элемента списка
          List _fourNew = [];
          for (int i=0; i < 2; i++) {  // вместо четырех я взял три, чтобы предотвратить баги (например появление одной и той же гифки несколько раз)
            _fourNew.add(_gifList[i]);
          }
          this.gifList += _fourNew.toSet().toList();

        });
      } else if (this.gifList.length == 0) {
        setState(() {
          var mapData = map['data'];
          List _gifList = [];
          for (int i=0; i < mapData.length; i++) {
            _gifList.add(mapData[i]['images']['fixed_height']['url'].toString());
          }
          this.gifList = _gifList.toSet().toList();
        });
      }
    } else {
      print('Failed to connect');
    }
  }

  final _myController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  Timer _timer;

  _textListener() {
    var customText = _myController.text.replaceAll(' ', '+');
    customText = customText.toLowerCase();
    _timer = Timer(const Duration(milliseconds: 2000), () { // функция setState() срабатывает через 2 секунды после того как изменился _myController.text
      setState(() {
        _numberOfGifs = 6;
        this.gifList = [];
        _fetchData(customText, _numberOfGifs);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _myController.addListener(_textListener);
    _scrollController.addListener(() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      setState(() {
        _numberOfGifs += 4;
        _fetchData(_myController.text, _numberOfGifs);
        this.gifList = gifList.toSet().toList();
      });
    }
    });
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
        appBar: AppBar(
          backgroundColor: greenColor,
          title: Padding(
              padding: EdgeInsets.only(),
              child: TextField(
                controller: _myController,
                style: TextStyle(fontSize: 18.0),
                decoration: InputDecoration(hintText: "Найти гифку"),
              )),
          actions: <Widget>[
             Container(
              color: Color(0xff58a27f),
                width: 70.0,
                height: 55.0,
                child: FlatButton( 
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Icon(Icons.star, color: yellowColor), Text('${favouriteGifsList.length}', style:TextStyle(color: yellowColor, fontSize: 12.0))]),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FavouritesFolder()
                      ));
                    }))
          ],
        ), //
        body: _myController.text.length != 0 ? listOfGifs() : emptyPage());
  }

  Widget emptyPage() {
    return Center(child:Text("Здесь пока ничего нет", style:TextStyle(color:yellowColor)));
  }

  Widget listOfGifs() {
    return GridView.count( // Две колонки с гифками
          controller: _scrollController,
          crossAxisCount: 2,
          children: List.generate(this.gifList != null ? this.gifList.length : 0, 
           (index) {
            String gifUrl = gifList[index];
            return Stack(alignment: AlignmentDirectional.center, children: <Widget>[Container(child:Stack(alignment: AlignmentDirectional.topEnd, children: <Widget>[
              Image.network(gifUrl),
              ClipRRect(borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  child: FlatButton(
                    padding: EdgeInsets.only(),
                      child: (favouriteGifsList.contains(gifUrl) == false) ? Icon(Icons.star, size:30, color: Colors.grey[50]) : Icon(Icons.star, size:30, color: Colors.yellow), // если гифка(а точнее ссылка на гифку) в favouriteGifsList => закрась ее желтым, в проивном случае => не закрашивай
                      onPressed: () {
                        setState(() {
                          if (favouriteGifsList.contains(gifUrl) == true) {
                            favouriteGifsList.remove(gifUrl);
                          } else {
                            favouriteGifsList.add(gifUrl);
                          }
                        });
                      })))]), 
                      decoration:BoxDecoration(border: Border.all(width: 1.0, color:Colors.black))),]);
          }),
        );
  }


}
