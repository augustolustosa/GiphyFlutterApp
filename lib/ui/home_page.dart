
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp4/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _seaching;
  int _offSet;


  @override
  void initState() {
    super.initState();
    //_getGifs().then((value) => print(value));
  }

  Future<Map> _getGifs () async{
    String url1="https://api.giphy.com/v1/gifs/trending?api_key=jTrEABbTOiFSJ8FSVRQUt7PJ9VvNwPUZ&limit=20&rating=G";
    String url2="https://api.giphy.com/v1/gifs/search?api_key=jTrEABbTOiFSJ8FSVRQUt7PJ9VvNwPUZ&q=$_seaching&limit=19&offset=$_offSet&rating=G&lang=en";
    http.Response response = (_seaching==null) ? await http.get(url1): await http.get(url2);
    return json.decode(response.body);
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif",),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share, color: Colors.white,), onPressed: (){},),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: "Search",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 22, fontStyle: FontStyle.normal),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 22, fontStyle: FontStyle.normal),
                  textAlign: TextAlign.left,
                  onSubmitted: (text){
                    setState(() {
                      _seaching=text;
                      _offSet=0;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot){
                switch(snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if(snapshot.hasError) return Container(
                      child: Center(
                        child: Text("Error", textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red),),
                      ),
                    );
                    return _createGifTable(context, snapshot);
                }
              },

            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data){
    int result= (_seaching==null)? data.length : data.length+1;
    return result;
  }

  Widget _createGifTable(BuildContext context,AsyncSnapshot snapshot){
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10.0
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index){
          if((_seaching==null || _seaching.isEmpty)|| index<snapshot.data["data"].length ){
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                  height: 300.0,
                  fit: BoxFit.cover,
              ),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=> GifPage(snapshot.data["data"][index]))
                );
              },
              onLongPress: (){
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
            );
          }else{
            return Container(
              child: GestureDetector(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white , size: 70.0,),
                    Text("More gifs...", textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, color: Colors.white),),
                  ],
                ),
                onTap: (){
                  setState(() {
                    _offSet+=20;
                  });
                },
              ),
            );
          }
        });
  }
}
