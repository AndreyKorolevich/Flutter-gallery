import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String client_id = 'cf49c08b444ff4cb9e4d126b7e9f7513ba1ee58de7906e4360afc1a33d1bf4c0';
class NewsBox extends StatelessWidget{
  final String _title;
  final String _text;
  final String _img;

  NewsBox(this._title, this._text, this._img);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      height: 100.0,
      margin: EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: <Widget>[
          Image.network(_img, width: 100.0, height: 100.0, fit: BoxFit.cover),
          Expanded(
              child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        _title,
                        style: TextStyle(fontSize: 20.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Expanded(
                          child: Text(
                        _text,
                        softWrap: true,
                        textAlign: TextAlign.justify,
                      ))
                    ],
                  )))
        ],
      ),
    );
  }
}
void main() => runApp(PhotoGalleryApp());

class PhotoGalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Photo gallery')),
        body: Gallery(),
      ),
    );
  }
}

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool loading;
  List<String> imgThum;
  List<String> imgSmall;
  List<String> iAuthor;
  List<String> iName;

  @override
  void initState() {
    loading = true;
    imgThum = [];
    imgSmall = [];
    iAuthor = [];
    iName = [];

    _loadImg();
    super.initState();
  }

  void _loadImg() async {
    final response = await http.get('https://api.unsplash.com/photos?page=2&per_page=30&client_id=$client_id');
    final json = jsonDecode(response.body);
    List<String> _imgThum = [];
    List<String> _imgSmall = [];
    List<String> _iAuthor = [];
    List<String> _iName = [];
    for (var image in json) {
      _imgThum.add(image['urls']['thumb']);
      _imgSmall.add(image['urls']['small']);
      _iAuthor.add(image['user']['username']);
      _iName.add(image['user']['name']);
    }
    setState(() {
      loading = false;
      imgThum = _imgThum;
      imgSmall = _imgSmall;
      iAuthor = _iAuthor;
      iName = _iName;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
        body: ListView.builder(
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ImagePage(imgSmall[index]),
                    ));
                  },
                  child: NewsBox(iAuthor[index], iName[index], imgThum[index]),
                ),
            itemCount: imgThum.length)
        ); // Scaffold
   }
}

class ImagePage extends StatelessWidget {
  final String id;

  ImagePage(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(
          id,
        ),
      ),
    );
  }
}
