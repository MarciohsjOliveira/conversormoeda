import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=ff6afdc9";

class Convert extends StatefulWidget {
  @override
  _ConvertState createState() => _ConvertState();
}

class _ConvertState extends State<Convert> {
  final reaisControle = TextEditingController();
  final dolarControle = TextEditingController();
  final euroControle = TextEditingController();

  void _clearAll() {
    reaisControle.text = "";
    dolarControle.text = "";
    euroControle.text = "";
  }

  void realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarControle.text = (real / dolar).toStringAsFixed(2);
    euroControle.text = (real / euro).toStringAsFixed(2);
  }

  void dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    reaisControle.text = (dolar * this.dolar).toStringAsFixed(2);
    euroControle.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    reaisControle.text = (euro * this.euro).toStringAsFixed(2);
    dolarControle.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  void _realMuda(String text) {
    double real = double.parse(text);
    dolarControle.text = (real / dolar).toStringAsFixed(2);
    euroControle.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarMuda(String text) {
    double dolar = double.parse(text);
    reaisControle.text = (dolar * this.dolar).toStringAsFixed(2);
    euroControle.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroMuda(String text) {
    double euro = double.parse(text);
    reaisControle.text = (euro * this.euro).toStringAsFixed(2);
    dolarControle.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  double dolar;
  double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Conversor de Moedas",
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getdata(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "carregando ...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20.0,
                  ),
                ),
              );
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "carregando ...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20.0,
                  ),
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "erro ao carregar ...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 20.0,
                    ),
                  ),
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                      Padding(padding: const EdgeInsets.only(bottom: 16)),
                      buildTextField(
                          "Real (R\$)", "R\$", reaisControle, _realMuda),
                      Divider(),
                      buildTextField(
                          "Dolar (\$)", "\$", dolarControle, _dolarMuda),
                      Divider(),
                      buildTextField("Euro (€)", "€", euroControle, _euroMuda)
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Future<Map> getdata() async {
  http.Response response = await http.get(request);
  //http get recebe o resquest da api do site
  //passa para response
  //e joga em um Mapa futuro que é acessado atraves de uma key/value
  return json.decode(response.body);
}

Widget buildTextField(
    String label, String cifra, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.amber,
        ),
        border: OutlineInputBorder(),
        prefixText: cifra),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
