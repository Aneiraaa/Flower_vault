import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_vault/models/akun.dart';
import 'package:flower_vault/models/flower.dart';
import 'package:flower_vault/utils/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListItem extends StatelessWidget {
  final Akun akun;
  final Flower flower;
  bool isFavourite = false;
  ListItem({
    super.key,
    required this.akun,
    required this.flower,
    this.isFavourite = false,
  });

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    void deleteFlower() async {
      try {
        await db.collection('flower').doc(flower.docId).delete();
        Navigator.pushNamedAndRemoveUntil(
            context, '/dashboard', (Route<dynamic> route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bunga berhasil dihapus')));
      } catch (e) {
        final snackbar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: primaryColor!, width: 1),
      ),
      elevation: 5,
      shadowColor: primaryColor,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.asset(
            'assets/flower.png',
            width: 30,
            height: 30,
            color: primaryColor,
          ),
        ),
        title: Text(
          flower.nama,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              'Kategori: ${flower.kategori}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              'Tanggal: ${flower.tanggal.day}/${flower.tanggal.month}/${flower.tanggal.year}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_vert, color: primaryColor),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Wrap(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.info,
                        color: primaryColor,
                      ),
                      title: const Text('Detail'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/detail',
                            arguments: {'flower': flower, 'akun': akun});
                      },
                    ),
                    if (!isFavourite)
                      ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: primaryColor,
                        ),
                        title: const Text('Delete'),
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext buildContext) {
                              return AlertDialog(
                                title: Text('Delete ${flower.nama}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(buildContext);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteFlower();
                                      Navigator.pop(buildContext);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
