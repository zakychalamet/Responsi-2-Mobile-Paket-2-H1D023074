import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;
  const ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "Tambah Inventaris Zakymart";
  String tombolSubmit = "SIMPAN";
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();
  final _jumlahTextboxController = TextEditingController();
  final _tanggalMasukTextboxController = TextEditingController();
  final _tanggalKedaluarsaTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.produk != null) {
      setState(() {
        judul = "Ubah Inventaris Zakymart";
        tombolSubmit = "UBAH";
        _namaProdukTextboxController.text = widget.produk!.namaProduk!;
        _hargaProdukTextboxController.text =
            widget.produk!.hargaProduk.toString();
        _jumlahTextboxController.text = widget.produk!.jumlah.toString();
        _tanggalMasukTextboxController.text = widget.produk!.tanggalMasuk!;
        _tanggalKedaluarsaTextboxController.text = widget.produk!.tanggalKedaluwarsa!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _namaProdukTextField(),
                const SizedBox(height: 16),
                _hargaProdukTextField(),
                const SizedBox(height: 16),
                _jumlahTextField(),
                const SizedBox(height: 16),
                _tanggalMasukTextField(),
                const SizedBox(height: 16),
                _tanggalKedaluarsaTextField(),
                const SizedBox(height: 24),
                _buttonSubmit()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      TextInputType keyboardType, String validator) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        prefixIcon: Icon(Icons.edit, color: Colors.green.shade700),
      ),
      keyboardType: keyboardType,
      controller: controller,
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        if (value!.isEmpty) {
          return "$label harus diisi";
        }
        return null;
      },
    );
  }

  Widget _namaProdukTextField() {
    return _buildTextField(
        "Nama Produk", _namaProdukTextboxController, TextInputType.text, "");
  }

  Widget _hargaProdukTextField() {
    return _buildTextField(
        "Harga", _hargaProdukTextboxController, TextInputType.number, "");
  }

  Widget _jumlahTextField() {
    return _buildTextField(
        "Jumlah", _jumlahTextboxController, TextInputType.number, "");
  }

  Widget _tanggalMasukTextField() {
    return _buildTextField("Tanggal Masuk (YYYY-MM-DD)",
        _tanggalMasukTextboxController, TextInputType.datetime, "");
  }

  Widget _tanggalKedaluarsaTextField() {
    return _buildTextField("Tanggal Kedaluwarsa (YYYY-MM-DD)",
        _tanggalKedaluarsaTextboxController, TextInputType.datetime, "");
  }

  Widget _buttonSubmit() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              if (widget.produk != null) {
                ubah();
              } else {
                simpan();
              }
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade700,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                tombolSubmit,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  simpan() {
    setState(() {
      _isLoading = true;
    });
    Produk createProduk = Produk(id: null);
    createProduk.namaProduk = _namaProdukTextboxController.text;
    createProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);
    createProduk.jumlah = int.parse(_jumlahTextboxController.text);
    createProduk.tanggalMasuk = _tanggalMasukTextboxController.text;
    createProduk.tanggalKedaluwarsa = _tanggalKedaluarsaTextboxController.text;

    ProdukBloc.addProduk(produk: createProduk).then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value == true) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => const ProdukPage()),
            (route) => false);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) => const WarningDialog(
                  description: "Simpan gagal, silahkan coba lagi",
                ));
      }
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Simpan gagal, silahkan coba lagi",
              ));
    });
  }

  ubah() {
    setState(() {
      _isLoading = true;
    });
    Produk updateProduk = Produk(id: widget.produk!.id!);
    updateProduk.namaProduk = _namaProdukTextboxController.text;
    updateProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);
    updateProduk.jumlah = int.parse(_jumlahTextboxController.text);
    updateProduk.tanggalMasuk = _tanggalMasukTextboxController.text;
    updateProduk.tanggalKedaluwarsa = _tanggalKedaluarsaTextboxController.text;

    ProdukBloc.updateProduk(produk: updateProduk).then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value == true) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => const ProdukPage()),
            (route) => false);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) => const WarningDialog(
                  description: "Permintaan ubah data gagal, silahkan coba lagi",
                ));
      }
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Permintaan ubah data gagal, silahkan coba lagi",
              ));
    });
  }
}