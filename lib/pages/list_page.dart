import 'package:app01/models/Shop.dart';
import 'package:app01/widgets/shopping_list_item.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage ({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> { 
  final TextEditingController shopController = TextEditingController();
  List<Shop> shopping = [];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child : Scaffold(
        body: Center(
          child: Padding(
          padding:const EdgeInsets.all(16), 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: shopController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Saldo Utilizado',
                      hintText: 'Ex. R\$100',
                    ),
                  ),
                ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  String text = shopController.text;
                  setState(() {
                    Shop newShop = Shop(
                    title:text,
                    dateTime:DateTime.now(),);
                    shopping.add(newShop);
                  });
                  shopController.clear();
                  

                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 129, 206, 84),
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(5))              
                ),
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.white ,
                ),
              ),
              ],
          ),
          SizedBox(height: 16),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for(Shop shop in shopping )
                  ShoppingListItem(
                    shop: shop,
                  )
              ],
            ),
          ), 
          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
              child: Text(
                "Voce possui ${shopping.length} compras efetuadas!!"
              ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 129, 206, 84),
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(5)),
                  ),
                  child: Text("Limpar Extrato"),                
              ),
                        ],
          )
          ],
          )
        ),
        ),
        backgroundColor: Color.fromARGB(255, 219, 223, 167),
      ),
    );
  }
}
