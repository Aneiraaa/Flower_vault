import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_vault/models/akun.dart';
import 'package:flower_vault/pages/dashboard/favourite_page.dart';
import 'package:flower_vault/pages/dashboard/flower_page.dart';
import 'package:flower_vault/pages/dashboard/profile_page.dart';
import 'package:flower_vault/utils/styles.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardFull();
  }
}

class DashboardFull extends StatefulWidget {
  const DashboardFull({super.key});

  @override
  State<DashboardFull> createState() => _DashboardFullState();
}

class _DashboardFullState extends State<DashboardFull> {
  int _selectedIndex = 0;
  List<Widget> pages = [];

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  bool _isLoading = false;

  Akun akun = Akun(
    uid: '',
    nama: '',
    email: '',
    noHp: '',
    docId: '',
  );

  void getAkun() async {
    setState(() {
      _isLoading = true;
    });
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('akun')
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data();

        setState(() {
          akun = Akun(
            uid: userData['uid'],
            nama: userData['nama'],
            noHp: userData['noHP'],
            email: userData['email'],
            docId: userData['docId'],
          );
        });
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAkun();
  }

  @override
  Widget build(BuildContext context) {
    pages = <Widget>[
      FlowerPage(
        akun: akun,
      ),
      FavouritePage(
        akun: akun,
      ),
      ProfilePage(
        akun: akun,
      ),
    ];
    return Scaffold(
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              child: const Icon(
                Icons.add,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/addFlower', arguments: {
                  'akun': akun,
                });
              },
            )
          : null,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Koleksi Bungaku',
          style: headerStyle(level: 3, dark: false),
          selectionColor: Colors.white,
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        selectedFontSize: 16,
        unselectedItemColor: Colors.grey[800],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Semua',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : pages.elementAt(_selectedIndex),
    );
  }
}
