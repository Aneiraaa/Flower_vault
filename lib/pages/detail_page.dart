import 'package:flower_vault/models/flower.dart';
import 'package:flower_vault/utils/db_helper.dart';
import 'package:flower_vault/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final DBHelper dbHelper = DBHelper();
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkIfFavourite();
    });
  }

  void checkIfFavourite() async {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Flower flower = arguments['flower'];
    final favouriteStatus = await dbHelper.isFavourite(flower.docId);
    setState(() {
      isFavourite = favouriteStatus;
    });
  }

  void toggleFavourite(Flower flower) async {
    if (isFavourite) {
      await dbHelper.removeFavourite(flower.docId);
    } else {
      await dbHelper.addFavourite(flower);
    }
    setState(() {
      isFavourite = !isFavourite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Flower flower = arguments['flower'];

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, '/dashboard', (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Detail Bunga',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: primaryColor,
          actions: [
            IconButton(
              onPressed: () {
                toggleFavourite(flower);
              },
              icon: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(30),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    flower.nama,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/flower.png',
                    height: 100,
                    width: 100,
                    color: primaryColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: ListTile(
                      title: const Text('Tanggal Tambah Bunga'),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy')
                            .format(flower.tanggal)
                            .toString(),
                      ),
                      leading: Icon(
                        Icons.date_range,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: ListTile(
                      title: const Text('Kategori Bunga'),
                      subtitle: Text(flower.kategori),
                      leading: Icon(
                        Icons.category,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Deskripsi Perawatan Bunga',
                    style: headerStyle(level: 2),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(flower.deskripsi ?? ''),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        style: buttonStyle,
                        onPressed: () {
                          Navigator.pushNamed(context, '/update',
                              arguments: {'flower': flower});
                        },
                        child: Text(
                          'Edit Bunga Saya',
                          style: headerStyle(level: 3, dark: false),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
