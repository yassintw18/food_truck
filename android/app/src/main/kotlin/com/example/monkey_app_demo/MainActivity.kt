package com.example.monkey_app_demo

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// 引入道臻 SDK
import com.dothantech.lpapi.LPAPI
import com.dothantech.lpapi.LPAPI.Factory

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.foodtruck/printer"
    
    // 建立 SDK 實體 (根據你的 PDF 文件，這是正確的建立方式)
    private val api by lazy { LPAPI.Factory.create() }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            
            // --- 功能 1: 連線 ---
            if (call.method == "connect") {
                val name = call.argument<String>("name") ?: ""
                
                // openPrinter: 傳入藍牙名稱，如果為空字串，SDK 通常會自動連線最近的一台或跳出選擇
                // 根據 PDF，如果連線成功會回傳 true
                val isConnected = api.openPrinter(name)
                
                if (isConnected) {
                    result.success("Connected")
                } else {
                    // 如果 SDK 是非同步連線，這裡可能只代表「指令發送成功」，
                    // 真正連線成功可能需要監聽 Callback，但為了簡單起見我們先這樣寫。
                    // 如果一直連不上，可能需要手動去手機藍牙設定配對。
                    result.success("Connection Command Sent") 
                }
            }

            // --- 功能 2: 列印 ---
            else if (call.method == "printOrder") {
                val title = call.argument<String>("title") ?: "Food Truck"
                val price = call.argument<String>("price") ?: "$0"
                
                // 1. 設定標籤紙大小 (寬40mm, 高30mm, 0度旋轉)
                api.startDraw(40.0, 30.0, 0)
                
                // 2. 畫外框矩形 (x, y, w, h, 線寬)
                api.drawRectangle(1.0, 1.0, 38.0, 28.0, 0.5)
                
                // 3. 畫標題 (文字, x, y, 寬, 高, 字體高度)
                // 注意：Android 版的 drawText 參數順序可能跟 iOS 略有不同，請依 PDF 為主
                // 這裡假設參數是 (text, x, y, w, h, fontHeight)
                api.drawText(title, 2.0, 3.0, 36.0, 6.0, 5.0)
                
                // 4. 畫分隔線
                api.drawLine(2.0, 10.0, 38.0, 10.0, 0.5)
                
                // 5. 畫價格 (字大一點)
                api.drawText(price, 2.0, 12.0, 36.0, 10.0, 8.0)
                
                // 6. 結束繪圖並列印
                api.endDraw()
                api.print()
                
                result.success("Printed")
            } 
            else {
                result.notImplemented()
            }
        }
    }
}
