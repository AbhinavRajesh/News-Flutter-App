import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/views/article_view.dart';

class CategoryNews extends StatefulWidget {

  final String category;
  CategoryNews({this.category});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {

  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryNews();
  }

  getCategoryNews() async  {
    CategoryNewsClass news = CategoryNewsClass();
    await news.getNews(widget.category);
    articles = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('AR'),
            Text('News', style: TextStyle(
              color: Colors.blue,
            ))
          ],
        ),
        actions: [
          Opacity(
            opacity: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.save)),
          )
        ],
        elevation: 0,
      ),
      body: _loading ?
        Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ) :
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: EdgeInsets.only(top: 16),
            child: ListView.builder(
                itemCount: articles.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return NewsTile(imageUrl: articles[index].urlToImage, title: articles[index].title, desc: articles[index].description, url: articles[index].url,);
                }
            ),
          ),
        ),
    );
  }
}

class NewsTile extends StatelessWidget {

  final String imageUrl, title, desc, url;
  NewsTile({@required this.imageUrl, @required this.title, @required this.desc, @required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ArticleView(
              newsUrl: url,
            )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl)),
            Text(title, style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w600
            ),),
            SizedBox(height: 8,),
            Text(desc, style: TextStyle(
                color: Colors.black54
            ),)
          ],
        ),
      ),
    );
  }
}
