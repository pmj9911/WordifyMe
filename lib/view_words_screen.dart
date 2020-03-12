import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class ViewWords extends StatefulWidget {
  @override
  _ViewWordsState createState() => _ViewWordsState();
}

class _ViewWordsState extends State<ViewWords> {
  List<dynamic> wordsList, wordsListDated;
  bool isSelectedDate = false;
  String newlyAddedWord;
  DateTime selectedDate = DateTime.now();
  String dateSelect = "";

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
      setState(() {});
    } else {
      print('Something went wrong. \nresponse Code : ${response.statusCode}');
    }
  }

  @override
  void initState() {
    fetchJSON();
  }

  Future<Null> _selectDate(BuildContext context) async {
    print("todays date is $selectedDate");
    // print(dateselect);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 8),
        lastDate: DateTime(2101));
    dateSelect = DateFormat('yyyy-MM-dd').format(picked);
    print("todays date is $selectedDate");
    print("selected date is $dateSelect");
    if (picked != null)
      setState(() {
        // selectedDate = picked;
        isSelectedDate = true;
        // fetchJSON();
      });
  }

  @override
  Widget build(BuildContext context) {
    wordsListDated = [];
    if (isSelectedDate) {
      for (int i = 0; i < wordsList.length; i++) {
        print("${wordsList[i]['dateEntered']} \t $dateSelect");
        if (wordsList[i]['dateEntered'] == dateSelect) {
          print("same");
          wordsListDated.add(wordsList[i]);
        }
      }
    } else {
      // dateSelect = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
    return Column(
      children: <Widget>[
        RaisedButton(
          onPressed: () => _selectDate(context),
          child: Text('Select date'),
        ),
        Container(
          height: 580,
          child: isSelectedDate
              ? ListView.builder(
                  itemCount: wordsListDated.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(wordsListDated[index]['word']),
                          Text(" : "),
                          Text(wordsListDated[index]['meaning']),
                        ],
                      ),
                      decoration:
                          this.newlyAddedWord == wordsListDated[index]['word']
                              ? BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.yellow.withOpacity(0.7),
                                      Colors.yellow,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                )
                              : BoxDecoration(),
                    );
                  },
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

// wordsList[index]['word']);
