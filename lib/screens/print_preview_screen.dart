import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/receipt_widgets.dart';

class PrintPreviewScreen extends StatefulWidget {
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
  State<PrintPreviewScreen> createState() => _PrintPreviewScreenState();
}

class _PrintPreviewScreenState extends State<PrintPreviewScreen> {
  // Menginisialisasi instance utama printer bluetooth
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  // Fungsi mengaktifkan Bluetooth & meminta izin sistem Android
  void _initBluetooth() async {
    // Meminta izin scan & connect Bluetooth di Android 12 ke atas
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    if (statuses[Permission.bluetoothConnect]!.isGranted) {
      bool? isConnected = await bluetooth.isConnected;
      List<BluetoothDevice> devices = [];
      try {
        devices = await bluetooth.getBondedDevices();
      } catch (e) {
        debugPrint("Error mengambil perangkat: $e");
      }

      if (mounted) {
        setState(() {
          _devices = devices;
          if (isConnected ?? false) {
            _connected = true;
          }
        });
      }
    }
  }

  // Fungsi menyambungkan koneksi ke printer Blueprint
  void _connect() {
    if (_selectedDevice == null) {
      _showSnackbar("Pilih perangkat printer Blueprint terlebih dahulu!", Colors.orange);
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!(isConnected ?? false)) {
          bluetooth.connect(_selectedDevice!).then((value) {
            setState(() => _connected = true);
            _showSnackbar("🖨️ Terhubung dengan ${_selectedDevice!.name}!", Colors.green);
          }).catchError((error) {
            setState(() => _connected = false);
            _showSnackbar("Gagal menyambungkan: $error", Colors.red);
          });
        }
      });
    }
  }

  // Fungsi memutuskan koneksi printer
  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
    _showSnackbar("Koneksi printer diputuskan.", Colors.grey);
  }

  // =========================================================
  // LOGIKA UTAMA: MENEMBAK PERINTAH TEKS KE PRINTER FISIK
  // =========================================================
  void _printAction() async {
    bool? isConnected = await bluetooth.isConnected;
    if (isConnected ?? false) {
      // 1. TATA LETAK CETAK KASIR OFFLINE
      if (widget.isKasir) {
        bluetooth.printCustom("NADIELLA SHOP", 3, 1); // Teks ukuran besar (3), Rata tengah (1)
        bluetooth.printCustom("Nota Kasir Offline", 1, 1); // Teks ukuran normal (1), Rata tengah (1)
        bluetooth.printNewLine();
        bluetooth.printLeftRight("Pel: ${widget.namaPelanggan}", "HP: ${widget.nomorHp}", 1);
        bluetooth.printCustom("--------------------------------", 1, 1);
        bluetooth.printLeftRight(widget.detailData, "LUNAS", 1);
        bluetooth.printCustom("--------------------------------", 1, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("Terima Kasih Atas Kunjungannya", 1, 1);
      } 
      // 2. TATA LETAK CETAK LABEL PENGIRIMAN SHIPPING
      else {
        bluetooth.printCustom("================================", 1, 1);
        bluetooth.printCustom("📦 LABEL PENGIRIMAN", 2, 1);
        bluetooth.printCustom("BLUEPRINT-REGULAR", 1, 1);
        bluetooth.printCustom("================================", 1, 1);
        bluetooth.printCustom("PENERIMA:", 1, 0); // Rata kiri (0)
        bluetooth.printCustom(widget.namaPelanggan, 2, 0);
        bluetooth.printCustom("HP: ${widget.nomorHp}", 1, 0);
        bluetooth.printCustom("Alamat: ${widget.detailData}", 1, 0);
        bluetooth.printCustom("--------------------------------", 1, 1);
        bluetooth.printCustom("PENGIRIM: NADIELLA SHOP (SMD)", 1, 0);
      }

      // Perintah enter kertas agar hasil cetakan keluar dari mulut printer sebelum dirobek
      bluetooth.printNewLine();
      bluetooth.printNewLine();
      bluetooth.printNewLine();
      _showSnackbar("🚀 Data berhasil dikirim ke printer!", Colors.green);
    } else {
      _showSnackbar("Printer tidak terhubung! Klik Hubungkan dulu.", Colors.red);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 Preview & Hardware Print'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // PANEL CONFIG HARDWARE BLUETOOTH PRINTER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<BluetoothDevice>(
                      isExpanded: true,
                      hint: const Text("Pilih Printer Blueprint"),
                      value: _selectedDevice,
                      items: _devices.map((device) {
                        return DropdownMenuItem(
                          value: device,
                          child: Text(device.name ?? "Unknown Device"),
                        );
                      }).toList(),
                      onChanged: (device) => setState(() => _selectedDevice = device),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _connected ? Colors.red[800] : Colors.green[800],
                    ),
                    onPressed: _connected ? _disconnect : _connect,
                    child: Text(_connected ? 'Disconnect' : 'Connect'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tampilan Visual Kertas Struk di Layar
            widget.isKasir 
                ? buildKertasStruk(namaPelanggan: widget.namaPelanggan, nomorHp: widget.nomorHp, detailData: widget.detailData) 
                : buildKertasLabelPengiriman(namaPelanggan: widget.namaPelanggan, nomorHp: widget.nomorHp, detailData: widget.detailData),

            const SizedBox(height: 20),

            // TOMBOL TEMBAK PRINTER FISIK REAL
            ElevatedButton.icon(
              icon: const Icon(Icons.print),
              label: const Text('CETAK STRUK FISIK SEKARANG', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _printAction,
            ),
          ],
        ),
      ),
    );
  }
}