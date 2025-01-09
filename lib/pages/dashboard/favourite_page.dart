import 'package:flower_vault/models/akun.dart';
import 'package:flower_vault/models/flower.dart';
import 'package:flower_vault/utils/db_helper.dart';
import 'package:flower_vault/widgets/list_item.dart';
import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  final Akun akun;
  const FavouritePage({
    super.key,
    required this.akun,
  });

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final DBHelper dbHelper = DBHelper();
  List<Flower> favourites = [];

  @override
  void initState() {
    super.initState();
    loadFavourites();
  }

  void loadFavourites() async {
    final favs = await dbHelper.getFavourites();
    setState(() {
      favourites = favs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: favourites.isEmpty
          ? const Center(child: Text('Belum Ada Bunga Favourite'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favourites.length,
              itemBuilder: (context, index) {
                return ListItem(
                  flower: favourites[index],
                  akun: widget.akun,
                  isFavourite: true,
                );
              },
            ),
    );
  }
}
