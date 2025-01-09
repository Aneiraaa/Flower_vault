import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_vault/models/flower.dart';
import 'package:flower_vault/utils/styles.dart';
import 'package:flower_vault/utils/validator.dart';
import 'package:flower_vault/utils/vars.dart';
import 'package:flower_vault/widgets/input_widget.dart';
import 'package:flutter/material.dart';

class UpdateFlowerPage extends StatefulWidget {
  const UpdateFlowerPage({super.key});

  @override
  State<UpdateFlowerPage> createState() => _UpdateFlowerPageState();
}

class _UpdateFlowerPageState extends State<UpdateFlowerPage> {
  final _db = FirebaseFirestore.instance;

  bool _isLoading = false;

  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  String? kategori;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _deskripsiController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final Flower flower = arguments['flower'];

      setState(() {
        _namaController.text = flower.nama;
        _deskripsiController.text = flower.deskripsi ?? '';
        kategori = flower.kategori;
      });
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void updateFlower(Flower flower) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _db.collection('flower').doc(flower.docId).update({
        'nama': _namaController.text,
        'kategori': kategori,
        'deskripsi': _deskripsiController.text,
        'tanggal': Timestamp.now(),
      }).catchError((e) {
        throw e;
      });

      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (Route<dynamic> route) => false);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bunga berhasil diperbarui')));
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
    final Flower flower = arguments['flower'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Update Bunga', style: headerStyle(level: 3, dark: false)),
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
                        InputLayout(
                            'Nama Bunga',
                            TextFormField(
                                controller: _namaController,
                                onChanged: (String value) => setState(() {
                                      // Judul diperbarui melalui controller
                                    }),
                                validator: notEmptyValidator,
                                decoration:
                                    customInputDecoration("Nama bunga"))),
                        InputLayout(
                          'Kategori Bunga',
                          DropdownButtonFormField<String>(
                            value: kategori,
                            decoration: customInputDecoration('Kategori Bunga'),
                            items: kategoriBunga.map((e) {
                              return DropdownMenuItem<String>(
                                  value: e, child: Text(e));
                            }).toList(),
                            onChanged: (selected) {
                              setState(() {
                                kategori = selected;
                              });
                            },
                          ),
                        ),
                        InputLayout(
                            "Deskripsi laporan",
                            TextFormField(
                              controller: _deskripsiController,
                              onChanged: (String value) => setState(() {}),
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: 5,
                              decoration: customInputDecoration(
                                  'Deskripsikan semua di sini'),
                            )),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                              style: buttonStyle,
                              onPressed: () {
                                updateFlower(flower);
                              },
                              child: Text(
                                'Update Bunga Saya',
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
