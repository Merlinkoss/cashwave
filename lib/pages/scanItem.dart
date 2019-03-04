import 'package:cashwave/data/item.dart';
import 'package:cashwave/data/repository.dart';
import 'package:cashwave/widgets/inputs.dart';
import 'package:cashwave/widgets/page_transformer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:rxdart/rxdart.dart';

class ScanPage extends StatefulWidget {
  ScanPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ScanPage> {
  final idController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final subject = PublishSubject<String>();
  List<Item> items = List();
  bool isSuccesful = false;

  @override
  void dispose() {
    idController.dispose();
    subject.close();

    super.dispose();
  }

  void _onItemScan(String scan) {
    Future<Item> item = Repository.get().getItem("$scan");
    item.then((it) {
      setState(() {
        items.add(it);
      });
    });
  }

  @override
  void initState() {
    subject.stream.listen(_onItemScan);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          margin: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: listItems(items),
              ),
              items.length < 1
                  ? Container()
                  : Card(
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                Text("Итого: "),
                                Text(getSum(items))
                              ]))),
                    ),
              sliderButtons()
            ],
          ),
        ));
  }

  String getSum(List<Item> item) {
    int sum = 0;
    item.forEach((Item item) {
      sum = sum + item.cost;
    });
    return "$sum";
  }

  Widget sliderButtons() {
    return SizedBox.fromSize(
        size: const Size.fromHeight(150.0),
        child: PageTransformer(pageViewBuilder: (context, visibilityResolver) {
          return PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            itemCount: 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Center(
                    child: Container(
                        margin: EdgeInsets.all(6.0),
                        child: ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                                child: Text('Сканировать штрихкод'),
                                elevation: 4.0,
                                textColor: Colors.white,
                                color: Colors.amber,
                                onPressed: () {
                                  isSuccesful = false;
                                  scanItem();
                                }))));
              } else {
                return Center(
                    child: Column(
                  children: <Widget>[
                    Inputs.defaultInput("ID товара", TextInputType.text,
                        idController, null, true),
                    Container(
                        margin: EdgeInsets.all(6.0),
                        child: ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                                child: Text('Добавить по введенному айди'),
                                elevation: 4.0,
                                textColor: Colors.white,
                                color: Colors.amber,
                                onPressed: () {
                                  subject.add(idController.text.toString());
                                  idController.text = "";
                                })))
                  ],
                ));
              }
            },
          );
        }));
  }

  Widget listItems(List<Item> items) {
    return ListView.builder(
        itemCount: items.length,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text("id:" + items[index].idItem),
                      Text("Name:" + items[index].name),
                      Text("cost:" + items[index].cost.toString()),
                      Text("weight:" + items[index].weight.toString()),
                    ],
                  )));
        });
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: "Добавили товар",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1);
  }

  Future<void> scanItem() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Сканировать штрих-код'),
          content: new SizedBox(
            child: new QrCamera(
              onError: (context, error) => Text(
                    error.toString(),
                    style: TextStyle(color: Colors.red),
                  ),
              qrCodeCallback: (code) {
                if (!isSuccesful) {
                  setState(() {
                    isSuccesful = true;
                    subject.add(code);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: new Container(
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                      color: Colors.amber,
                      width: 4.0,
                      style: BorderStyle.solid),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Закончить сканирование'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
