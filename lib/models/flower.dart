class Flower {
  final String uid;
  final String docId;
  final String nama;
  final String kategori;
  String? deskripsi;
  final DateTime tanggal;

  Flower({
    required this.uid,
    required this.docId,
    required this.nama,
    required this.kategori,
    required this.deskripsi,
    required this.tanggal,
  });
}
