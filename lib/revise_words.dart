import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class ReviseWords extends StatefulWidget {
  @override
  _ReviseWordsState createState() => _ReviseWordsState();
}

class _ReviseWordsState extends State<ReviseWords> {
  String url = "https://pmj9911.pythonanywhere.com/wordsApp/viewwords/";
  bool _autoValidate = false;
  List<dynamic> wordsList, wordsListDated;
  bool gotWords = false,
      isCorrect = false,
      isIncorrect = false,
      isSelectedDate = false,
      isShowAll = false,
      doOnce = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int current = 0, wordCount = 0;
  String currentWord = "TEst", currentMeaning = "Test", currentExample = "";
  String inputMeaning = "";
  bool _showExample = false;

  DateTime selectedDate = DateTime.now();
  DateTime dateStart = DateTime.now();
  DateTime dateEnd = DateTime.now();

  fetchJSON() async {
    var response = await http.get(
      "https://pmj9911.pythonanywhere.com/wordsApp/viewwords/",
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
    } else {
      print('Something went wrong. \nresponse Code : ${response.statusCode}');
    }
    setState(() {
      gotWords = true;
    });
  }

  Future<Null> fetchWords() async {
    //   print("INSIDE POST");

    //   var request = http.MultipartRequest('POST', Uri.parse(url));
    //   request.fields['dateStart'] = dateStart;
    //   request.fields['dateEnd'] = dateEnd;
    //   print("sending request");
    //   var res = await request.send();
    //   print(res.stream.toString());
    //   print(res.reasonPhrase);
    //   // String responseBody = res.body;
    //   // var responseJSON = json.decode(responseBody);
    //   // print(responseJSON);
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    print("todays date is $selectedDate");
    // print(dateselect);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.subtract(new Duration(days: 2)),
        firstDate: DateTime(2019, 8),
        lastDate: DateTime(2101));
    dateStart = picked; //DateFormat('yyyy-MM-dd').format(picked);
    print(picked);
    print("start date is $dateStart");
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    print("todays date is $selectedDate");
    // print(dateselect);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.add(new Duration(days: 1)),
        firstDate: DateTime(2019, 8),
        lastDate: DateTime(2101));
    dateEnd = picked; //DateFormat('yyyy-MM-dd').format(picked);
    print("end date is $dateEnd");
    print(picked);
    setState(() {
      gotWords = true;
      doOnce = true;
      isSelectedDate = true;
    });
  }

  void _selectAll(BuildContext context) async {
    print("todays date is $selectedDate");
    // print(dateselect);
    dateStart = new DateTime(2020, 03, 01);
    dateEnd = selectedDate.add(new Duration(days: 1));
    setState(() {
      gotWords = true;
      doOnce = true;
      isSelectedDate = true;
    });
  }

  void _validateInputs() {
    _formKey.currentState.save();
    print(inputMeaning);
    print(currentMeaning);
    current++;

    _formKey.currentState.reset();
    inputMeaning = inputMeaning.trim();
    if (inputMeaning == currentMeaning) {
      isCorrect = true;
      isIncorrect = false;
    } else {
      isIncorrect = true;
      isCorrect = false;
    }
    setState(() {
      currentWord = wordsListDated[current]['word'];
      currentMeaning = wordsListDated[current]['meaning'];
      currentExample = wordsListDated[current]['example'];
    });
  }

  @override
  void initState() {
    if (!gotWords) fetchJSON();
  }

  Widget formUI() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                currentWord,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            )
          ],
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
        wordsListDated[current - 1]['word'],
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.linear_scale, color: Colors.yellowAccent),
          Text(
            wordsListDated[current - 1]['meaning'],
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
  }

  @override
  Widget build(BuildContext context) {
    if (doOnce && wordsList != null && isSelectedDate) {
      print(doOnce);
      wordsListDated = [];

      for (int i = 0; i < wordsList.length; i++) {
        print(
            "${DateTime.parse(wordsList[i]['dateEntered'])} \t $dateStart \t $dateEnd");
        if (DateTime.parse(wordsList[i]['dateEntered']).isAfter(dateStart) &
            DateTime.parse(wordsList[i]['dateEntered']).isBefore(dateEnd)) {
          print("same");
          wordsListDated.add(wordsList[i]);

          currentWord = wordsListDated[current]['word'];
          currentMeaning = wordsListDated[current]['meaning'];
          currentExample = wordsListDated[current]['example'];
        }

        wordCount = wordsListDated.length;
      }
      doOnce = false;
    }
    print(doOnce);

    var wordCard = Column(
      children: <Widget>[
        Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text("$wordCount words"),
              ),
            ]),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: formUI(),
          ),
        ),
        RaisedButton(
          onPressed: () {
            setState(() {
              _showExample = !_showExample;
            });
          },
          child: Text('Show Example!'),
        ),
        _showExample
            ? Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      currentExample,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            : Text(""),
        Container(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              if (isCorrect)
                result("CORRECT!", Colors.green, Icons.airplanemode_active),
              if (isIncorrect)
                result("INCORRECT!", Colors.red, Icons.airplanemode_inactive),
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
    );
    var chooseDate = Container(
      height: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                // height: 600,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () => _selectStartDate(context),
                        child: Text('Select Start date'),
                      ),
                      // Text(dateStart),
                    ],
                  ),
                ),
              ),
              Container(
                // height: 600,
                child: Center(
                  child: Column(children: <Widget>[
                    RaisedButton(
                      onPressed: () => _selectEndDate(context),
                      child: Text('Select End date'),
                    ),
                    // Text(dateEnd),
                  ]),
                ),
              ),
            ],
          ),
          Text(
            "OR",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          Container(
            // height: 600,
            child: Center(
              child: RaisedButton(
                onPressed: () => _selectAll(context),
                child: Text('Show All'),
              ),
            ),
          ),
        ],
      ),
    );
    var waitingSpinner = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          height: 600,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: gotWords
            ? (isSelectedDate ? wordCard : chooseDate)
            : waitingSpinner,
      ),
    );
  }
}
