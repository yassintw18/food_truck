import 'package:flutter/services.dart';

class PrinterService {
  // 這裡的名稱必須跟 AppDelegate.swift 裡的名稱一模一樣
  static const MethodChannel _channel = MethodChannel('com.foodtruck/printer');

  /// 連線到印表機
  /// [printerName] 是印表機的藍牙名稱 (例如 "BTP-F001" 或空字串自動搜尋)
  Future<String> connect(String printerName) async {
    try {
      // 呼叫 iOS 的 connect 方法
      final String result = await _channel.invokeMethod('connect', {'name': printerName});
      return result; // 回傳 "Connected"
    } on PlatformException catch (e) {
      return "錯誤: ${e.message}";
    }
  }

  /// 列印訂單
  Future<String> printOrder({
    required String title, 
    required String price, 
    required String date
  }) async {
    try {
      // 呼叫 iOS 的 printOrder 方法
      final String result = await _channel.invokeMethod('printOrder', {
        'title': title,
        'price': price,
        'date': date,
      });
      return result; // 回傳 "Printed"
    } on PlatformException catch (e) {
      return "列印失敗: ${e.message}";
    }
  }
}