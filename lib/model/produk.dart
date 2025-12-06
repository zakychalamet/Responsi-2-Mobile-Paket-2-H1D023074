class Produk {
  String? id;
  String? namaProduk;
  var hargaProduk;
  var jumlah;
  String? tanggalMasuk;
  String? tanggalKedaluwarsa;

  Produk({
    this.id,
    this.namaProduk,
    this.hargaProduk,
    this.jumlah,
    this.tanggalMasuk,
    this.tanggalKedaluwarsa,
  });

  factory Produk.fromJson(Map<String, dynamic> obj) {
    return Produk(
      id: obj['id']?.toString(),
      namaProduk: obj['nama']?.toString() ?? '',
      hargaProduk: obj['harga'] ?? 0,
      jumlah: obj['jumlah'] ?? 0,
      tanggalMasuk: obj['tanggal_masuk']?.toString() ?? '',
      tanggalKedaluwarsa: obj['tanggal_kedaluwarsa']?.toString() ?? '',
    );
  }
}