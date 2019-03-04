import 'package:cashwave/data/item.dart';
import 'package:cashwave/data/repository.dart';
import 'package:cashwave/widgets/inputs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class AddEditItem extends StatefulWidget {
  AddEditItem({Key key, this.title, this.item}) : super(key: key);

  final String title;
  final Item item;

  @override
  _AddPageState createState() => _AddPageState(item);
}

class _AddPageState extends State<AddEditItem> {
  _AddPageState(this.oldItem) : super();
  final Item oldItem;

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final weightController = TextEditingController();
  final costController = TextEditingController();

  bool isSuccesful = false;

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    weightController.dispose();
    costController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    if (oldItem != null) {
      idController.text = oldItem.idItem;
      nameController.text = oldItem.name;
      weightController.text = oldItem.weight.toString();
      costController.text = oldItem.cost.toString();
    }
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
          children: <Widget>[
            Inputs.defaultInput(
                "ID товара",
                TextInputType.text,
                idController,
                IconButton(
                    icon: Icon(Icons.subject),
                    onPressed: () {
                      scanItem();
                    }),
                widget.item == null),
            Inputs.defaultInput("Название товара", TextInputType.text,
                nameController, null, true),
            Inputs.defaultInput("Вес товара", TextInputType.number,
                weightController, null, true),
            Inputs.defaultInput("Цена товара", TextInputType.number,
                costController, null, true),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                  margin: EdgeInsets.all(6.0),
                  child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                          child: Text('Добавить товар'),
                          elevation: 4.0,
                          textColor: Colors.white,
                          color: Colors.amber,
                          onPressed: () {
                            Repository.get()
                                .updateItem(Item(
                                    idItem: idController.text.toString(),
                                    name: nameController.text.toString(),
                                    weight: int.tryParse(
                                        weightController.text.toString()),
                                    cost: int.tryParse(
                                        costController.text.toString())))
                                .then((it) {
                              showToast();
                              Navigator.of(context).pop();
                            });
                          }))),
            ),
          ],
        ),
      ),
    );
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
                    idController.text = code;
                    isSuccesful = true;
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

  void showToast() {
    Fluttertoast.showToast(
        msg: "${widget.item == null ? "Добавили" : "Изменили"} товар",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1);
  }
}
