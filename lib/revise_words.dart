import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviseWords extends StatefulWidget {
  @override
  _ReviseWordsState createState() => _ReviseWordsState();
}

class _ReviseWordsState extends State<ReviseWords> {
  String url = "http://64cf6767.ngrok.io/wordsApp/addword/";
  bool _autoValidate = false;
  List<dynamic> wordsList;
  bool gotWords = false, isCorrect = false, isIncorrect = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int current = 0;
  String currentWord = "TEst";
  String currentMeaning = "Test";
  String inputMeaning = "";

  fetchJSON() async {
    var response = await http.get(
      "http://64cf6767.ngrok.io/wordsApp/viewwords/",
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      String responseBody = response.body;
      var responseJSON = json.decode(responseBody);
      // username = responseJSON['login'];
      // name = responseJSON['name'];
      // avatar = responseJSON['avatar_url'];
      print(responseJSON);
      wordsList = responseJSON;
      print("words");
      print(wordsList);
      currentWord = wordsList[0]['word'];
      currentMeaning = wordsList[0]['meaning'];
      setState(() {
        gotWords = true;
      });
    } else {
      print('Something went wrong. \nresponse Code : ${response.statusCode}');
    }
  }

  void _validateInputs() {
    _formKey.currentState.save();
    print(inputMeaning);
    print(currentMeaning);
    current++;
    _formKey.currentState.reset();
    inputMeaning = inputMeaning.trim();
    if (inputMeaning == currentMeaning) {
      setState(() {
        isCorrect = true;
        isIncorrect = false;
        currentWord = wordsList[current]['word'];
        currentMeaning = wordsList[current]['meaning'];
      });
    } else {
      setState(() {
        isIncorrect = true;
        isCorrect = false;
        currentWord = wordsList[current]['word'];
        currentMeaning = wordsList[current]['meaning'];
      });
    }
  }

  @override
  void initState() {
    fetchJSON();
  }

  Widget formUI() {
    return new Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text(currentWord)],
        ),
        new TextFormField(
          decoration: const InputDecoration(labelText: 'Meaning'),
          keyboardType: TextInputType.text,
          validator: (String arg) {
            if (arg.length < 3)
              return 'meaning must be more than 2 charater';
            else
              return null;
          },
          onSaved: (String val) {
            inputMeaning = val;
          },
        ),
        new SizedBox(
          height: 10.0,
        ),
        new RaisedButton(
          onPressed: _validateInputs,
          child: new Text('Submit'),
        )
      ],
    );
  }

  Widget result(title, color, icon) {
    final makeListTile = ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
          border: new Border(
            right: new BorderSide(
              width: 1.0,
              color: color,
            ),
          ),
        ),
        child: Icon(
          icon,
          color: Colors.black,
          size: 50,
        ),
      ),
      title: Text(
        wordsList[current - 1]['word'],
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Icon(Icons.linear_scale, color: Colors.yellowAccent),
          Text(
            wordsList[current - 1]['meaning'],
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: color),
        width: 300,
        height: 100,
        child: makeListTile,
      ),
    );

    // InkWell(
    //   onTap: () {
    //     // selectCatgory(context);
    //   },
    //   splashColor: Theme.of(context).primaryColor,
    //   borderRadius: BorderRadius.circular(15),
    //   child: Container(
    //     padding: EdgeInsets.all(15),
    //     child: Column(
    //       children: <Widget>[
    //         Text(title),
    //         ,
    //         Text(),
    //       ],
    //     ),
    //     decoration: BoxDecoration(
    //       gradient: LinearGradient(
    //         colors: [
    //           color.withOpacity(0.7),
    //           color,
    //         ],
    //         begin: Alignment.topLeft,
    //         end: Alignment.bottomRight,
    //       ),
    //       borderRadius: BorderRadius.circular(15),
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return gotWords
        ? Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: formUI(),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    if (isCorrect)
                      result(
                          "CORRECT!", Colors.green, Icons.airplanemode_active),
                    if (isIncorrect)
                      result("INCORRECT!", Colors.red,
                          Icons.airplanemode_inactive),
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
              )
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
  }
}
