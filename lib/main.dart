import 'package:cashwave/data/repository.dart';
import 'package:cashwave/pages/addItem.dart';
import 'package:cashwave/pages/listItems.dart';
import 'package:cashwave/pages/scanItem.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CashWave',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Главная'),
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
  bool init = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                button('Добавить товар', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddEditItem(title: "Добавить товар")),
                  );
                }),
                button('Список товаров', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListPage(
                              title: "Список товаров",
                            )),
                  );
                }),
              ],
            ),
            button('Сканировать товар', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScanPage(
                          title: "Сканировать товар",
                        )),
              );
            })
          ]),
        ));
  }

  void _showToast() {
    Fluttertoast.showToast(
        msg: "Приложение загрузило БД",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1);
  }

  Widget button(String text, VoidCallback where) {
    return Container(
        margin: EdgeInsets.all(8.0),
        child: ButtonTheme(
            minWidth: 100,
            height: 100,
            child: RaisedButton(
                child: Text(text),
                elevation: 4.0,
                textColor: Colors.white,
                color: Colors.amber,
                onPressed: where)));
  }

  @override
  void initState() {
    Repository.get().init().then((it) {
      _showToast();
    });
    super.initState();
  }
}
