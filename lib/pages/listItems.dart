import 'package:cashwave/data/item.dart';
import 'package:cashwave/data/repository.dart';
import 'package:cashwave/pages/addItem.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyListStage createState() => _MyListStage();
}

class _MyListStage extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          margin: EdgeInsets.all(16.0),
          child: new FutureBuilder<List<Item>>(
            future: Repository.get().getItems(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
              List<Item> items = [];
              if (snapshot.data != null) items = snapshot.data;
              if (items.isEmpty)
                return Center(
                    child: Row(
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.deepOrange,
                    ),
                    Text("Товары в кассе не найдены :(")
                  ],
                ));
              else
                return listItems(items);
            },
          )),
    );
  }

  Widget listItems(List<Item> items) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditItem(
                        title: "Изменить ${items[index].idItem}",
                        item: items[index]),
                  ));
            },
            onLongPress: () {
              deleteDialog(items[index]);
            },
            child: Card(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text("id: " + items[index].idItem),
                        Text("Name: " + items[index].name),
                        Text("cost: " + items[index].cost.toString()),
                        Text("weight: " + items[index].weight.toString()),
                      ],
                    ))),
          );
        });
  }

  Future<void> deleteDialog(Item item) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Удаление ${item.name}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Вы точно хотите удалить товар из списка?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Удалить'),
              onPressed: () {
                Repository.get().removeItem(item.idItem).then((list) {
                  setState(() {});
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Оставить'),
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
