import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:untitled1/detals.dart';
import 'package:untitled1/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CryptoModel> posts = [];

  Future<List<CryptoModel>> getAllCrypto() async {
    final response = await http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var a in data) {
        posts.add(CryptoModel.fromJson(a));
      }
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.black, Colors.black]),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Crypto Check",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Colors.black, Colors.blue]),
        ),
        child: FutureBuilder(
          future: getAllCrypto(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                var crypto = posts[index];
                return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return DetailsPage(
                              crypto: crypto,
                              duration: 365,
                            );
                          }));
                    },
                    child: ListTile(
                      leading: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50)),
                        child: CachedNetworkImage(
                          imageUrl: posts[index].image,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      title: Text(
                        posts[index].name,
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(posts[index].symbol,style: TextStyle(color: Colors.white60),),
                      trailing: Text(
                        posts[index].currentPrice.toString() + "\$",
                        style: TextStyle(
                            color: Colors.white60,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,),
                      ),
                    ));
              },
            );
          },
        ),
      ),
    );
  }
}