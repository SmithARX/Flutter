import 'package:app01/models/Shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ShoppingListItem extends StatelessWidget {
  const ShoppingListItem({super.key, required this.shop});

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return Slidable(child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[200], 
        ),
        margin: EdgeInsetsGeometry.symmetric(vertical: 2),
        padding: const EdgeInsetsGeometry.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
            DateFormat('dd/MM/yyyy - HH:mm').format(shop.dateTime),
            style:TextStyle(
                fontSize: 12,
              ),
            ),
            Row(

              children: [
                Text("R\$ "),
                Text(shop.title,
              style: 
                TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                  
                ),
              ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}