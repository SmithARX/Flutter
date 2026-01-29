import 'package:app01/models/shop.dart';
import 'package:app01/repositories/shop_repository.dart';
import 'package:app01/utils/pdf_extrato.dart';
import 'package:app01/utils/resumo_por_pessoa_page.dart';
import 'package:app01/widgets/shopping_list_item.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage ({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final Map<String, IconData> bancoIcons = {
  'Nubank': Icons.account_balance_wallet,
  'Itau': Icons.account_balance,
  'C6Bank': Icons.credit_card,
  'Sicob': Icons.savings,
}; 
  final TextEditingController shopController = TextEditingController();
  List<Shop> shopping = [];
  final ShopRepository shopRepository = ShopRepository();

  Shop? deletedShop;
  int? deletedShopPos;
  String? pessoaSelecionada;
  String? pessoaFiltro;


  List<String> bancos = <String>['Nubank', 'Itau', 'C6Bank', 'Sicob'];
  List<String> pessoas = <String>['Elaine', 'Rita', 'Jose', 'Eduardo'];
  String? valorSelecionado;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
      shopRepository.getShopList().then((value){
        setState(() {
        shopping = value;  
        });
      }
      );
  }

  @override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 219, 223, 167),
        title: const Text('Extrato'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ResumoPorPessoaPage(shopping: shopping),
                ),
              );
            },
          ),
        ],
      ),

      drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 129, 206, 84),
                ),
                accountName: const Text('Controle Financeiro'),
                accountEmail: const Text('Seu extrato pessoal'),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.account_balance_wallet, size: 32),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Extrato'),
                onTap: () {
                  Navigator.pop(context); 
                },
              ),

              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Resumo por Pessoa'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Exportar PDF'),
                onTap: () async {
                  Navigator.pop(context);
                  await gerarExtratoPDF(
                    shoppingFiltrado,
                    pessoaFiltro,
                  );
                },
              ),


              const Divider(),

              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),

      backgroundColor: const Color.fromARGB(255, 219, 223, 167),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    //Expanded que mostra os valores dos textFild
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: shopController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Saldo Utilizado',
                          hintText: 'Ex. R\$100',
                        
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe um valor';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        initialValue: valorSelecionado,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Banco',
                        ),
                        hint: const Text('Banco'),

                        items: bancoIcons.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Row(
                              children: [
                                Icon(entry.value, size: 22),
                                const SizedBox(width: 8),
                                Text(entry.key),
                              ],
                            ),
                          );
                        }).toList(),

                      
                        selectedItemBuilder: (context) {
                          return bancoIcons.entries.map((entry) {
                            return Row(
                              children: [
                                Icon(entry.value, size: 22),
                                const SizedBox(width: 8),
                                Text(entry.key),
                              ],
                            );
                          }).toList();
                        },

                        onChanged: (value) {
                          setState(() {
                            valorSelecionado = value;
                          });
                        },

                        validator: (value) {
                          if (value == null) {
                            return 'Selecione um banco';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),

                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            shopping.add(
                              Shop(
                                title: shopController.text,
                                dateTime: DateTime.now(),
                                banco: valorSelecionado!,
                                pessoa: pessoaSelecionada!,
                              ),
                            );
                          });

                          shopController.clear();
                          valorSelecionado = null;
                          pessoaSelecionada = null;
                          shopRepository.saveItemList(shopping);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 129, 206, 84),
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                // ignore: deprecated_member_use
                value: pessoaFiltro,
                decoration: InputDecoration(
                  labelText: 'Filtrar por pessoa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('Todas'),
                  ),
                  ...pessoas.map((pessoa) {
                    return DropdownMenuItem<String>(
                      value: pessoa,
                      child: Text(pessoa),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    pessoaFiltro = value;
                  });
                },
              ),
                if (pessoaFiltro != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total de ${pessoaFiltro!}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'R\$ ${totalPorPessoa(pessoaFiltro!).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: shoppingFiltrado
                      .map(
                        (shop) => ShoppingListItem(
                          shop: shop,
                          onDelete: onDelete,
                        ),
                      )
                      .toList(),
                  ),
                  
                ),
                  DropdownButtonFormField<String>(
                    // ignore: deprecated_member_use
                    value: pessoaSelecionada,
                    decoration: InputDecoration(
                      labelText: 'Pessoa',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: pessoas.map((pessoa) {
                      return DropdownMenuItem<String>(
                        value: pessoa,
                        child: Text(pessoa),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        pessoaSelecionada = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione uma pessoa';
                      }
                      return null;
                    },
                  ),


                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Você possui ${shopping.length} compras efetuadas!",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: confirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 129, 206, 84),
                        padding: EdgeInsets.all(16),
                      ),
                      child: Text("Limpar Extrato"),
                    ),
                  ],
                ),
                SizedBox(height: 4,),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
  List<Shop> get shoppingFiltrado {
  if (pessoaFiltro == null) {
    return shopping;
  }
  return shopping.where((shop) => shop.pessoa == pessoaFiltro).toList();
  }


  void onDelete(Shop shop){
    deletedShop = shop;
    deletedShopPos = shopping.indexOf(shop);

    setState(() {
      shopping.remove(shop);  
    });
    shopRepository.saveItemList(shopping);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gasto de ${shop.title} do cartão ${shop.banco} foi removida com sucesso!'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed : () {
            setState(() {
              shopping.insert(deletedShopPos!, deletedShop!);  
            });
            shopRepository.saveItemList(shopping);
          }
        ),
        duration: const Duration(seconds: 5),
      )
    );   
  }

  void confirmationDialog(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Remover Tudo?'),
        content: Text('Essa ação ira excluir toda a lista. Voce tem certeza'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Color.fromARGB(255, 0, 166, 243)),
            child: Text('Cancelar')
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllItens();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: Text('Limpar Tudo')
          ),
        ],
      ),
    );
  }
  void deleteAllItens () {
    setState(() {
      shopping.clear();
    });
    shopRepository.saveItemList(shopping);
  }
  double totalPorPessoa(String pessoa) {
  return shopping
      .where((shop) => shop.pessoa == pessoa)
      .map((shop) => double.tryParse(shop.title) ?? 0)
      .fold(0.0, (a, b) => a + b);
}

}
