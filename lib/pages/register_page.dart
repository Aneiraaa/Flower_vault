import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_vault/utils/styles.dart';
import 'package:flower_vault/utils/validator.dart';
import 'package:flower_vault/widgets/input_widget.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? nama;
  String? email;
  String? noHP;

  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void register() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Validasi data input
      if (nama == null ||
          email == null ||
          noHP == null ||
          _password.text.isEmpty) {
        throw Exception('Semua field harus diisi.');
      }

      CollectionReference akunCollection = _db.collection('akun');

      final password = _password.text;
      // Buat user di Firebase Auth
      await _auth.createUserWithEmailAndPassword(
          email: email!, password: password);

      final docId = akunCollection.doc().id;
      // Simpan data ke Firestore
      await akunCollection.doc(docId).set({
        'uid': _auth.currentUser!.uid,
        'nama': nama,
        'email': email,
        'noHP': noHP,
        'docId': docId,
      });

      Navigator.of(context).pushReplacementNamed('/');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Registrasi berhasil')));
    } catch (e) {
      // Tampilkan error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Register',
                      style: headerStyle(level: 1),
                    ),
                    const Text(
                      'Create your profile to start your journey',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              InputLayout(
                                  'Nama',
                                  TextFormField(
                                      onChanged: (String value) => setState(() {
                                            nama = value;
                                          }),
                                      validator: notEmptyValidator,
                                      decoration: customInputDecoration(
                                          "Nama Lengkap"))),
                              InputLayout(
                                  'Email',
                                  TextFormField(
                                      onChanged: (String value) => setState(() {
                                            email = value;
                                          }),
                                      validator: notEmptyValidator,
                                      decoration: customInputDecoration(
                                          "email@email.com"))),
                              InputLayout(
                                  'No. Handphone',
                                  TextFormField(
                                      onChanged: (String value) => setState(() {
                                            noHP = value;
                                          }),
                                      validator: notEmptyValidator,
                                      decoration: customInputDecoration(
                                          "08xxxxxxxxxx"))),
                              InputLayout(
                                  'Password',
                                  TextFormField(
                                      controller: _password,
                                      validator: notEmptyValidator,
                                      obscureText: !_isPasswordVisible,
                                      decoration:
                                          customInputDecoration("Password",
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  _isPasswordVisible
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _isPasswordVisible =
                                                        !_isPasswordVisible;
                                                  });
                                                },
                                              )))),
                              InputLayout(
                                  'Konfirmasi Password',
                                  TextFormField(
                                      controller: _confirmPassword,
                                      validator: (value) =>
                                          passConfirmationValidator(
                                              value, _password),
                                      obscureText: !_isConfirmPasswordVisible,
                                      decoration: customInputDecoration(
                                          "Konfirmasi Password",
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isConfirmPasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isConfirmPasswordVisible =
                                                    !_isConfirmPasswordVisible;
                                              });
                                            },
                                          )))),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: double.infinity,
                                child: FilledButton(
                                    style: buttonStyle,
                                    child: Text('Register',
                                        style:
                                            headerStyle(level: 3, dark: false)),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        register();
                                      }
                                    }),
                              )
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Sudah punya akun? '),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', ModalRoute.withName('/'));
                          },
                          child: const Text('Login di sini',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
