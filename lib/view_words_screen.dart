import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class ViewWords extends StatefulWidget {
  @override
  _ViewWordsState createState() => _ViewWordsState();
}

class _ViewWordsState extends State<ViewWords> {
  List<dynamic> wordsList;
  bool gotWords = false;

  fetchJSON() async {
    var response = await http.get(
      "http://a7277af2.ngrok.io/wordsApp/viewwords/",
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      String responseBody = response.body;
      var responseJSON = json.decode(responseBody);
      // username = responseJSON['login'];
      // name = responseJSON['name'];
      // avatar = responseJSON['avatar_url'];
      gotWords = true;
      print(responseJSON);
      wordsList = responseJSON;
      print("words");
      print(wordsList);
      setState(() {
      });
    } else {
      print('Something went wrong. \nresponse Code : ${response.statusCode}');
    }
  }

  @override
  void initState() {
    fetchJSON();
  }
  @override
  Widget build(BuildContext context) {
    return 
    gotWords ?
      ListView.builder
        (
          itemCount: wordsList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return  Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(wordsList[index]['word']),
                        Text(" : "),
                        Text(wordsList[index]['meaning']),
                      ],
                    ),
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(
                        // colors: [
                        //   Colors.yellow.withOpacity(0.7),
                        //   Colors.yellow,
                        // ],
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      // ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                );
          }
        )
    : Container(
      child: Text("HEllo"),
      
    );
  }
}



// wordsList[index]['word']);