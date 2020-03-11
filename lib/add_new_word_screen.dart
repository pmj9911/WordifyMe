import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  String url = "http://a7277af2.ngrok.io/wordsApp/addword/";
  bool _autoValidate = false;
  String _word;
  String _meaning;
  bool sent = false;

 Future<String> uploadImage(word,meaning) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['word'] = word;
    request.fields['meaning'] = meaning;
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
            if(arg.length < 3)
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
            if(arg.length < 3)
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
    uploadImage(_word,_meaning);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {
    }
      setState(() {
        sent = true;
      });
    
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return sent? ViewWords(): new Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: formUI(),
            );
    }
}