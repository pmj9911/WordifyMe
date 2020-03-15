import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'view_words_screen.dart';

class AddNewWord extends StatefulWidget {
  @override
  AddNewWordState createState() {
    return AddNewWordState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class AddNewWordState extends State<AddNewWord> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<AddNewWordState>.
  List<dynamic> wordsList, wordsListDated;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String url = "https://pmj9911.pythonanywhere.com/wordsApp/addword/";
  bool _autoValidate = false;
  String _word, _meaning, _example;
  bool sent = false, fetched = false;

  fetchJSON() async {
    var response = await http.get(
      "https://pmj9911.pythonanywhere.com/wordsApp/viewwords/",
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      String responseBody = response.body;
      var responseJSON = json.decode(responseBody);
      wordsList = responseJSON;
      print(wordsList);
    } else {
      print('Something went wrong. \nresponse Code : ${response.statusCode}');
    }
    setState(() {
      fetched = true;
    });
  }

  @override
  void initState() {
    fetchJSON();
    setState(() {
      print("fetched");
      sent = false;
    });
  }

  Future<String> sendWord(word, meaning, example) async {
    print("INSIDE POST");

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['word'] = word;
    request.fields['meaning'] = meaning;
    request.fields['example'] = example;
    DateTime selectedDate = DateTime.now();
    String dateSelect = DateFormat('yyyy-MM-dd').format(selectedDate);
    request.fields['date'] = dateSelect;
    print(word);
    print(meaning);
    print("sending reuqest");
    var res = await request.send();
    print(res.statusCode);
    print(res.reasonPhrase);
    return res.reasonPhrase;
  }

  Widget formUI() {
    return new Column(
      children: <Widget>[
        new TextFormField(
          decoration: const InputDecoration(labelText: 'Word'),
          keyboardType: TextInputType.text,
          validator: (String arg) {
            if (arg.length < 3)
              return 'Word must be more than 2 charater';
            else
              return null;
          },
          onSaved: (String val) {
            _word = val;
          },
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
            _meaning = val;
          },
        ),
        new TextFormField(
          decoration: const InputDecoration(labelText: 'Example'),
          keyboardType: TextInputType.text,
          validator: (String arg) {
            if (arg.length < 3)
              return 'meaning must be more than 2 charater';
            else
              return null;
          },
          onSaved: (String val) {
            _example = val;
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

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {}
    sendWord(_word, _meaning, _example);
    _formKey.currentState.reset();
    fetchJSON();
    setState(() {
      sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    wordsListDated = [];
    if (fetched) {
      for (int i = 0; i < wordsList.length; i++) {
        if (wordsList[i]['example'] == "") {
          print("same");
          wordsListDated.add(wordsList[i]);
        }
      }
    }
    return Column(children: <Widget>[
      Container(
        padding: EdgeInsets.all(10),
        child: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: formUI(),
        ),
      ),
      Container(
        height: 380,
        child: wordsListDated.length != 0
            ? ListView.builder(
                itemCount: wordsList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(wordsListDated[index]['word']),
                        Text(" : "),
                        Column(
                          children: <Widget>[
                            Text(
                              wordsListDated[index]['meaning'],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )
            : Container(
                child: Text(
                  "Fetching Words!",
                ),
              ),
      ),
    ]);
  }
}