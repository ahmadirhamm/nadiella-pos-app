import 'package:flutter/material.dart';
// Mengimpor komponen visual struk/label
import '../widgets/receipt_widgets.dart';

class PrintPreviewScreen extends StatelessWidget {
  final bool isKasir;
  final String namaPelanggan;
  final String nomorHp;
  final String detailData;

  const PrintPreviewScreen({
    super.key,
    required this.isKasir,
    required this.namaPelanggan,
    required this.nomorHp,
    required this.detailData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 Preview Struk / Label'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tampilan visual sebelum ditembak ke Printer Blueprint:',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),

            // Menggunakan fungsi eksternal widget dengan melempar datanya
            isKasir 
                ? buildKertasStruk(namaPelanggan: namaPelanggan, nomorHp: nomorHp, detailData: detailData) 
                : buildKertasLabelPengiriman(namaPelanggan: namaPelanggan, nomorHp: nomorHp, detailData: detailData),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.print),
              label: const Text('CETAK FISIK VIA BLUETOOTH', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('🖨️ Mengirim data perintah ESC/POS ke Printer Blueprint...'),
                    backgroundColor: Colors.green[700],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}