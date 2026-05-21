import 'package:flutter/material.dart';
import 'print_preview_screen.dart'; // Import halaman tujuan data mengalir

class FormInputScreen extends StatefulWidget {
  final bool isKasir;
  const FormInputScreen({super.key, required this.isKasir});

  @override
  State<FormInputScreen> createState() => _FormInputScreenState();
}

class _FormInputScreenState extends State<FormInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _kontakController = TextEditingController();
  final _detailController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _kontakController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isKasir ? 'Form Kasir Nadiella' : 'Form Alamat Nadiella'),
        backgroundColor: widget.isKasir ? Colors.green[900] : Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.isKasir ? '📝 Input Penjualan Offline' : '📝 Input Detail Label Kurir',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Pelanggan / Pembeli',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Nama tidak boleh kosong!';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _kontakController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Nomor WhatsApp / HP',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Nomor HP wajib diisi!';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _detailController,
                  maxLines: widget.isKasir ? 1 : 3,
                  decoration: InputDecoration(
                    labelText: widget.isKasir ? 'Nama Barang & Harga (Contoh: Flanel - 150k)' : 'Alamat Lengkap Penerima',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(widget.isKasir ? Icons.shopping_bag : Icons.home),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return widget.isKasir ? 'Isi nama barang belanjaan!' : 'Alamat jangan kosong!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isKasir ? Colors.green : Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrintPreviewScreen(
                            isKasir: widget.isKasir,
                            namaPelanggan: _namaController.text,
                            nomorHp: _kontakController.text,
                            detailData: _detailController.text,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('LIHAT PREVIEW CETAKAN', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}