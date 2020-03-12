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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String url = "http://pmj9911.pythonanywhere.com//wordsApp/addword/";
  bool _autoValidate = false;
  String _word;
  String _meaning;
  bool sent = false;

  @override
  void initState() {
    sent = false;
  }

  Future<String> sendWord(word, meaning) async {
    print("INSIDE POST");

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['word'] = word;
    request.fields['meaning'] = meaning;
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
    sendWord(_word, _meaning);
    _formKey.currentState.reset();

    setState(() {
      sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    DateTime selectedDate = DateTime.now();
    String dateSelect = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Container(
      padding: EdgeInsets.all(10),
      child: new Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: formUI(),
        
      ),
    );
  }
}
