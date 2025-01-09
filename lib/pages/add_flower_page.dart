import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_vault/models/akun.dart';
import 'package:flower_vault/utils/styles.dart';
import 'package:flower_vault/utils/validator.dart';
import 'package:flower_vault/utils/vars.dart';
import 'package:flower_vault/widgets/input_widget.dart';
import 'package:flutter/material.dart';

class AddFlowerPage extends StatefulWidget {
  const AddFlowerPage({super.key});

  @override
  State<AddFlowerPage> createState() => _AddFlowerPageState();
}

class _AddFlowerPageState extends State<AddFlowerPage> {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  bool _isLoading = false;

  String? nama;
  String? kategori;
  String? deskripsi;

  void addFlower(Akun akun) async {
    setState(() {
      _isLoading = true;
    });

    try {
      CollectionReference flowerCollection = _db.collection('flower');
      Timestamp timestamp = Timestamp.fromDate(DateTime.now());
      final id = flowerCollection.doc().id;

      await flowerCollection.doc(id).set({
        'uid': _auth.currentUser!.uid,
        'nama': nama,
        'kategori': kategori,
        'deskripsi': deskripsi,
        'docId': id,
        'tanggal': timestamp,
      }).catchError((e) {
        throw e;
      });
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (Route<dynamic> route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bunga berhasil ditambahkan')));
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Akun akun = arguments['akun'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Tambah Koleksi Bunga',
            style: headerStyle(level: 3, dark: false)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                  child: Container(
                    margin: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/flower.png',
                          height: 100,
                          width: 100,
                          color: primaryColor,
                        ),
                        const SizedBox(height: 30),
                        InputLayout(
                            'Nama Bunga',
                            TextFormField(
                                onChanged: (String value) => setState(() {
                                      nama = value;
                                    }),
                                validator: notEmptyValidator,
                                decoration:
                                    customInputDecoration("Nama bunga"))),
                        InputLayout(
                          'Kategori Bunga',
                          DropdownButtonFormField<String>(
                            decoration: customInputDecoration('Kategori Bunga'),
                            items: kategoriBunga.map((e) {
                              return DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                            onChanged: (selected) {
                              setState(() {
                                kategori = selected;
                              });
                            },
                          ),
                        ),
                        InputLayout(
                            "Tulis Deskripsi Perawatan",
                            TextFormField(
                              onChanged: (String value) => setState(() {
                                deskripsi = value;
                              }),
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: 5,
                              decoration: customInputDecoration(
                                  'Deskripsikan lengkap perawatan bunga'),
                            )),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                              style: buttonStyle,
                              onPressed: () {
                                addFlower(akun);
                              },
                              child: Text(
                                'Tambah Koleksi',
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
