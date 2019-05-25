import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

final _scaffoldKey = new GlobalKey<ScaffoldState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Redirect config',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(title: 'Config redirect on TV'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    void _clear() {
      controller.clear();
    }

    void _showSuccessSnackBar() {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: const Text(
          'Success!',
          style: TextStyle(color: Colors.lightGreen),
        ),
      ));
    }

    void _showErrorSnackBar() {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: const Text(
          'Error, something went wrong!',
          style: TextStyle(color: Colors.red),
        ),
      ));
    }

    void _submitWithValue(String value) {
      var doc = Firestore.instance.collection('url').document('url');
      doc.setData(<String, String>{'target': value}).then((_) {
        _showSuccessSnackBar();
      }).catchError((error) {
        _showErrorSnackBar();
      });
    }

    void _oneClick() {
      Clipboard.getData('text/plain').then((data){
        controller.text = data.text;
        _submitWithValue(data.text);
      });
    }

    void _submit() {
      _submitWithValue(controller.value.text);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: 'Enter the new URL'),
              textAlign: TextAlign.center,
              controller: controller,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: _clear,
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text('Clear'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                ),
                RaisedButton(
                  onPressed: _submit,
                  textColor: Colors.white,
                  color: Colors.pink,
                  child: Text('Submit'),
                ),
              ],
            ),
            RaisedButton(
              onPressed: _oneClick,
              textColor: Colors.white,
              color: Colors.green,
              child: Text('Submit from clipboard'),
            ),
          ],
        ),
      ),
    );
  }
}
