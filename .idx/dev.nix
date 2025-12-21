{ pkgs, ... }: {
  # 使用穩定的 Nix 頻道
  channel = "stable-23.11"; 

  # 這裡列出需要安裝的軟體包
  packages = [
    pkgs.nodePackages.firebase-tools
    pkgs.jdk17      # ⚠️ 這是編譯 Android 必備的 Java 環境
    pkgs.unzip      # 解壓縮工具
    pkgs.flutter    # Flutter SDK
    pkgs.gradle     # 建置工具
  ];

  # 設定環境變數
  env = {};

  idx = {
    # 安裝 VS Code 擴充套件
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];

    # 設定預覽視窗 (這很重要，它會觸發 Android SDK 下載)
    previews = {
      enable = true;
      previews = {
        android = {
          command = ["flutter" "run" "--machine" "-d" "android" "-d" "localhost:5555"];
          manager = "flutter";
        };
      };
    };
  };
}