Pod::Spec.new do |s|
    s.name             = 'LPAPI'
    s.version          = '1.0.0'
    s.summary          = 'LPAPI for generic printer'
    s.description      = <<-DESC
                         Local Pod for LPAPI Printer SDK
                         DESC
    s.homepage         = 'https://example.com'
    s.license          = { :type => 'MIT' }
    s.author           = { 'Your Name' => 'email@example.com' }
    s.source           = { :git => '.', :tag => s.version.to_s }
    
    s.ios.deployment_target = '11.0'
    
    # 這裡設定原始碼位置
    s.source_files = '*.h'
    
    # 這裡設定靜態函式庫 (.a)
    s.vendored_libraries = 'libLPAPI.a'
    
    # 這裡設定需要的系統框架 (根據經驗，藍牙通常需要這些)
    s.frameworks = 'CoreBluetooth', 'ExternalAccessory'
    
    # 這是關鍵，讓 Swift 看得懂
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  end