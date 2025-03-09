import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/shop_view_model.dart';


class ShopWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ShopViewModel>(
      builder: (context, shopViewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Boutique',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade200, Colors.green.shade200],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: shopViewModel.items.length,
                  itemBuilder: (context, index) {
                    final item = shopViewModel.items[index];
                    bool canAfford = shopViewModel.canAfford(item.price);
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: Icon(Icons.shopping_cart, color: Colors.blue.shade700),
                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.price} coins',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            Text(
                              '+ ${item.attack} attacks',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: canAfford
                              ? () {
                            shopViewModel.purchaseItem(item.price, item.attack);
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: canAfford ? Colors.blue.shade700 : Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(canAfford ? "Acheter" : "Pas assez de coins"),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}