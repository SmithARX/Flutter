import 'package:app01/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ShoppingListItem extends StatelessWidget {
  const ShoppingListItem({
    super.key,
    required this.shop,
    required this.onDelete
  });

  final Shop shop;
  final Function(Shop) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        key: ValueKey(shop),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Excluir',
              onPressed: (context) {
                _confirmDelete(context);
              },
            ),


          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color.fromARGB(157, 238, 238, 238),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(shop.dateTime),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text('R\$ '),
                  Text(
                    shop.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'de saudo do ${shop.banco}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ' foi usado por : ${shop.pessoa}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }
  void _confirmDelete(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Remover gasto?'),
      content: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            const TextSpan(text: 'Você está prestes a remover o gasto de '),
            TextSpan(
              text: 'R\$ ${shop.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: '\n\nDo banco '),
            TextSpan(
              text: shop.banco,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: ', utilizado por '),
            TextSpan(
              text: shop.pessoa,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: '.\n\nDeseja continuar?'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDelete(shop);
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.redAccent,
          ),
          child: const Text('Excluir'),
        ),
      ],
    ),
  );
}
}

