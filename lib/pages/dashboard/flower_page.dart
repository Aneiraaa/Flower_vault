import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_vault/models/akun.dart';
import 'package:flower_vault/models/flower.dart';
import 'package:flower_vault/widgets/list_item.dart';
import 'package:flutter/material.dart';

class FlowerPage extends StatefulWidget {
  final Akun akun;
  const FlowerPage({super.key, required this.akun});

  @override
  State<FlowerPage> createState() => _FlowerPageState();
}

class _FlowerPageState extends State<FlowerPage> {
  final _db = FirebaseFirestore.instance;

  List<Flower> listFlower = [];

  @override
  void initState() {
    super.initState();
    getFlower();
  }

  void getFlower() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('flower')
          .where('uid', isEqualTo: widget.akun.uid)
          .get();

      if (!mounted) return;
      setState(() {
        listFlower.clear();
        for (var documents in querySnapshot.docs) {
          listFlower.add(Flower(
            uid: documents.data()['uid'],
            nama: documents.data()['nama'],
            kategori: documents.data()['kategori'],
            deskripsi: documents.data()['deskripsi'],
            docId: documents.data()['docId'],
            tanggal: documents.data()['tanggal'].toDate(),
          ));
        }
      });
    } catch (e) {
      if (!mounted) return;

      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listFlower.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada Koleksi Bunga',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listFlower.length,
              itemBuilder: (context, index) {
                return ListItem(flower: listFlower[index], akun: widget.akun);
              },
            ),
    );
  }
}
