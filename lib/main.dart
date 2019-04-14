import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

String _currentUser, name, email, phone;

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _State createState() => new _State();
}

class _State extends State<MyApp> {

  final String url = 'https://jsonplaceholder.typicode.com/users/';


  Future<List<Map>> getUser() async{
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      return items;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  Future getData(String username) async{
    String profile = url+username;
    var response = await http.get(profile);

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      setState(() {
        name = responseBody['name'];
        email = responseBody['email'];
        phone = responseBody['phone'];
      });
    }else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de usuario'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: FutureBuilder<List<Map>>(
                future: getUser(),
                builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    if(snapshot.hasError) {
                      return ErrorWidget(snapshot.error);
                    }
                    return DropdownButton<String>(
                      hint: Text('Seleccione un usuario',
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                      value: _currentUser,
                      onChanged: (user) {
                        setState(() {
                          _currentUser = user;
                        });
                        getData(_currentUser);
                      },
                      items: snapshot.data.map((Map user) => DropdownMenuItem<String>(
                        child: Text(user['username'],
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        value: user['id'].toString(),
                      )).toList(),
                    );
                  }else
                    return CircularProgressIndicator();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Nombre:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(name ?? '',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Correo:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(email ?? '',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Teléfono:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(phone ?? '',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}



