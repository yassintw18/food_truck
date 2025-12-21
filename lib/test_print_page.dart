import 'package:flutter/material.dart';
import 'printer_service.dart'; // 確保引用我們之前寫好的 Service

class TestPrintPage extends StatefulWidget {
  const TestPrintPage({super.key});

  @override
  State<TestPrintPage> createState() => _TestPrintPageState();
}

class _TestPrintPageState extends State<TestPrintPage> {
  final PrinterService _printer = PrinterService();
  String _status = "等待連線...";
  final TextEditingController _nameController = TextEditingController();

  // 模擬一筆 Supabase 訂單資料
  final Map<String, dynamic> _mockOrder = {
    "title": "招牌牛肉漢堡 x 2",
    "price": "\$ 300",
    "date": DateTime.now().toString().substring(0, 16),
  };

  void _connect() async {
    setState(() => _status = "正在搜尋/連線中...");
    // 傳入空字串 "" 通常會讓 SDK 自動搜尋或連接第一台
    // 如果你有特定的印表機名稱 (如 "BTP-F001")，也可以填入
    String result = await _printer.connect(_nameController.text);
    setState(() => _status = result);
  }

  void _print() async {
    if (!_status.contains("Connected") && !_status.contains("Success")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("請先連線印表機！")),
      );
      return;
    }

    String result = await _printer.printOrder(
      title: _mockOrder['title'],
      price: _mockOrder['price'],
      date: _mockOrder['date'],
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("藍牙印表機測試")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.print, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Text("狀態: $_status", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "印表機藍牙名稱 (可留空)",
                border: OutlineInputBorder(),
                hintText: "例如: GP-2120TU",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _connect,
              icon: const Icon(Icons.bluetooth_searching),
              label: const Text("1. 連線印表機"),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _print,
              icon: const Icon(Icons.receipt_long),
              label: const Text("2. 列印測試收據"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
