import UIKit
import Flutter
import CoreBluetooth
import LPAPI // 這裡直接引用我們剛剛設定的 Local Pod

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    // 建立一個通道，名稱要跟 Flutter 端一樣
    let printerChannel = FlutterMethodChannel(name: "com.foodtruck/printer",
                                              binaryMessenger: controller.binaryMessenger)
    
    printerChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      
      // --- 功能 1: 連線印表機 ---
      if call.method == "connect" {
        let args = call.arguments as? [String: Any]
        let printerName = args?["name"] as? String ?? ""
        
        // 呼叫 SDK 連線
        LPAPI.openPrinter(printerName) { (success) in
            if success {
                result("Connected")
            } else {
                result(FlutterError(code: "CONN_FAIL", message: "無法連線到印表機，請確認已開機且藍牙已開啟", details: nil))
            }
        }
      }
      
      // --- 功能 2: 列印訂單 (畫標籤) ---
      else if call.method == "printOrder" {
          // 從 Flutter 接收參數
          let args = call.arguments as? [String: Any]
          let title = args?["title"] as? String ?? "Food Truck"
          let price = args?["price"] as? String ?? "$0"
          let date = args?["date"] as? String ?? "2023-01-01"

          // 1. 設定標籤紙大小 (寬40mm, 高30mm，請依你的貼紙調整)
          LPAPI.startDraw(40, height: 30, orientation: 0)
          
          // 2. 畫框框 (x, y, w, h, 線寬, 填充)
          LPAPI.drawRectangle(withX: 1, y: 1, width: 38, height: 28, lineWidth: 0.5, isFilled: 0)
          
          // 3. 畫店名 (字體高度 5mm)
          LPAPI.drawText(title, x: 2, y: 3, width: 36, height: 6, fontHeight: 5)
          
          // 4. 畫分隔線
          LPAPI.drawLine(withX: 2, y: 10, endX: 38, endY: 10, lineWidth: 0.5)
          
          // 5. 畫價格 (字體高度 8mm，大一點)
          LPAPI.drawText(price, x: 2, y: 12, width: 36, height: 10, fontHeight: 8)
          
          // 6. 畫日期 (小字)
          LPAPI.drawText(date, x: 2, y: 24, width: 36, height: 4, fontHeight: 2.5)
          
          // 7. 結束繪圖並送出列印
          LPAPI.endDraw()
          LPAPI.print()
          
          result("Printed")
      }
      else {
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}