import 'dart:convert';
import 'package:app01/models/shop.dart';
import 'package:shared_preferences/shared_preferences.dart';

const shopKey = 'shop_list';

class ShopRepository {
  static const shopKey = 'Shop_list';

  Future<SharedPreferences> _prefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<List<Shop>> getShopList() async {
    final prefs = await _prefs();
    final jsonString = prefs.getString(shopKey) ?? '[]';
    final List decoded = json.decode(jsonString);
    return decoded.map((e) => Shop.fromJson(e)).toList();
  }

  Future<void> saveItemList(List<Shop> shopping) async {
    final prefs = await _prefs();
    final jsonString = json.encode(shopping);
    await prefs.setString(shopKey, jsonString);
  }
}

