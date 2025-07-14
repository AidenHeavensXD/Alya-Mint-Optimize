#!/bin/bash

echo "💻 เริ่ม Optimize VS Code แบบขั้นสุด สำหรับเขียนโค้ดอย่างเดียว..."

# 🔍 ตรวจสอบว่ามี VS Code หรือยัง
if ! command -v code &> /dev/null; then
  echo "📥 VS Code ยังไม่ได้ติดตั้ง → ติดตั้งให้เลย..."
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
  sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt update
  sudo apt install -y code
  rm -f packages.microsoft.gpg
fi

# 📂 สร้างโฟลเดอร์ Config ถ้ายังไม่มี
VSCODE_CONFIG="$HOME/.config/Code/User/settings.json"
mkdir -p "$(dirname "$VSCODE_CONFIG")"

# 🎨 ตั้ง Theme สวยๆ + Icon เบา → ใช้ One Dark Pro + VSCode Icons
echo "💡 กำหนด Settings VS Code..."
cat > "$VSCODE_CONFIG" <<EOL
{
    "workbench.startupEditor": "none",
    "workbench.enableExperiments": false,
    "workbench.enableWelcomePage": false,
    "update.mode": "manual",
    "telemetry.enableTelemetry": false,
    "telemetry.enableCrashReporter": false,
    "extensions.autoUpdate": false,
    "extensions.ignoreRecommendations": true,
    "editor.minimap.enabled": false,
    "editor.smoothScrolling": false,
    "editor.renderWhitespace": "selection",
    "editor.cursorBlinking": "solid",
    "files.autoSave": "afterDelay",
    "files.autoSaveDelay": 1000,
    "workbench.colorTheme": "One Dark Pro",
    "workbench.iconTheme": "vscode-icons",
    "window.titleBarStyle": "custom",
    "window.menuBarVisibility": "toggle",
    "workbench.activityBar.visible": true,
    "workbench.statusBar.visible": true
}
EOL

# ✅ ติดตั้ง Extension พื้นฐาน
echo "🔌 ติดตั้ง Theme และ Icon..."
code --install-extension zhuangtongfa.Material-theme --force
code --install-extension vscode-icons-team.vscode-icons --force

# ✅ ติดตั้ง Extension Dev ที่แนะนำ
echo "📦 ติดตั้ง Extension Dev พื้นฐาน..."
code --install-extension ms-python.python --force
code --install-extension esbenp.prettier-vscode --force
code --install-extension dbaeumer.vscode-eslint --force

echo ""
echo "🎉 VS Code Optimize เสร็จแล้ว!"
echo "✅ Theme: One Dark Pro"
echo "✅ Icons: VSCode Icons"
echo "✨ เปิด VS Code ด้วย: code --disable-gpu"
echo "🚀 พร้อมเขียนโค้ดได้ลื่นสุด!"