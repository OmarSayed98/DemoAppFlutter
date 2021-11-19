import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "first app",
      home: Scaffold(
          appBar: AppBar(
            title: Center(child: Text("demo app")),
          ),
          body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                width: 2,
                color: Colors.grey,
                style: BorderStyle.solid,
              ),
            ),
            child: MyForm(),
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(10),
          )),
    );
  }
}

class MyForm extends StatelessWidget {
  final myController = TextEditingController();
  final passwordController = TextEditingController();
  var response;
  var url = 'http://10.0.2.2:8000/foo';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter email';
                    }
                    return null;
                  },
                  controller: myController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                      hintText: "email",
                      label: Text("enter email")),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter password';
                    }
                    return null;
                  },
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                      hintText: "password",
                      label: Text("d5l alpassword")),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(build).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        Map<String, String> ma = {
                          'username': myController.text,
                          'password': passwordController.text
                        };
                        response = await http.post(Uri.parse(url),
                            body: json.encode(ma),
                            headers: {
                              'Content-Type': 'application/json',
                            });
                        if (response.statusCode != 200) {
                          ScaffoldMessenger.of(build).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('incorrect username or password')),
                          );
                        } else {
                          print(response.statusCode);
                          final Map<String, dynamic> data =
                              json.decode(response.body);
                          Navigator.push(
                            build,
                            MaterialPageRoute(
                                builder: (context) => listScreen(data)),
                          );
                        }
                      }
                    },
                    child: Text("submit"))
              ],
            )),
      ),
    );
  }
}

class listScreen extends StatelessWidget {
  Map<String, dynamic> myList;
  listScreen(this.myList);
  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    final passwordController = TextEditingController();
    myController.text = myList["expectation"];
    passwordController.text = myList["reality"];
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("demo app")),
        ),
        body: Form(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextFormField(
                controller: myController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal)),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal)),
                ),
              )
            ]),
          ),
        ));
  }
}
