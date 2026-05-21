import 'package:flutter/material.dart';

// Desain Struk Kasir Minimalis (Kertas Putih)
Widget buildKertasStruk({
  required String namaPelanggan,
  required String nomorHp,
  required String detailData,
}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Column(
      children: [
        const Text(
          'NADIELLA SHOP',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        const Text('Nota Kasir Offline', style: TextStyle(color: Colors.grey, fontSize: 11)),
        const Divider(color: Colors.black54, thickness: 1),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kasir/Pel: $namaPelanggan', style: const TextStyle(color: Colors.black87, fontSize: 13)),
            Text('HP: $nomorHp', style: const TextStyle(color: Colors.black87, fontSize: 13)),
          ],
        ),
        const Divider(color: Colors.black38),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(detailData, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            const Text('LUNAS', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(color: Colors.black54, thickness: 1),
        const SizedBox(height: 10),
        const Text(
          '--- Simpan sebagai bukti pembayaran sah ---',
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 11),
        )
      ],
    ),
  );
}

// Desain Label Pengiriman (Tema BlueGrey & Orange)
Widget buildKertasLabelPengiriman({
  required String namaPelanggan,
  required String nomorHp,
  required String detailData,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blueGrey[900],
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.blueAccent, width: 2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('📦 LABEL PENGIRIMAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)),
              child: const Text('BLUEPRINT-REG', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
            )
          ],
        ),
        const Divider(color: Colors.white30),
        const SizedBox(height: 6),
        const Text('PENERIMA:', style: TextStyle(color: Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.bold)),
        Text(namaPelanggan, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        Text(nomorHp, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(detailData, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 14),
        const Divider(color: Colors.white30),
        const Text('PENGIRIM:', style: TextStyle(color: Colors.orangeAccent, fontSize: 11, fontWeight: FontWeight.bold)),
        const Text('NADIELLA SHOP (Samarinda)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}