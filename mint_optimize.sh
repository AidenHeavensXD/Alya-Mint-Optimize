#!/bin/bash

echo "🔧 เริ่มปรับแต่ง Linux Mint Cinnamon (Full Setup)..."

# 1️⃣ ปิดบริการที่ไม่จำเป็น
echo "🚫 ปิด Bluetooth..."
sudo systemctl disable bluetooth

echo "🚫 ปิด Printer Service (CUPS)..."
sudo systemctl disable cups

# 2️⃣ ปรับ Swappiness
echo "🔧 ตั้งค่า Swappiness = 10..."
sudo sed -i '/vm.swappiness/d' /etc/sysctl.conf
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# 3️⃣ ปิด Mint Welcome Screen
echo "🚫 ปิด Mint Welcome Screen..."
if [ -f "$HOME/.config/autostart/mintwelcome.desktop" ]; then
    rm "$HOME/.config/autostart/mintwelcome.desktop"
fi

# 4️⃣ ตั้ง CPU governor เป็น performance
echo "⚡ ตั้ง CPU governor เป็น performance..."
sudo apt install -y cpufrequtils
echo 'GOVERNOR="performance"' | sudo tee /etc/default/cpufrequtils
sudo systemctl restart cpufrequtils

# 5️⃣ ติดตั้ง ZRAM (optional)
read -p "❓ ติดตั้ง ZRAM ด้วยไหม? (y/n): " zram_answer
if [[ "$zram_answer" == "y" ]]; then
    echo "💾 ติดตั้ง ZRAM..."
    sudo apt install -y zram-config
fi

# 6️⃣ ทำความสะอาดระบบ
echo "🧹 ทำความสะอาดระบบ..."
sudo apt autoremove -y
sudo apt clean

# 7️⃣ ปรับ VS Code ให้เบาสุด
echo "💻 ตั้งค่า VS Code Auto..."

# ถ้า VS Code ยังไม่ได้ติดตั้ง
if ! command -v code &> /dev/null; then
    echo "📥 VS Code ยังไม่ได้ติดตั้ง → ติดตั้ง VS Code..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code
    rm -f packages.microsoft.gpg
fi

# สร้าง settings.json ถ้าไม่มี
VSCODE_CONFIG="$HOME/.config/Code/User/settings.json"
mkdir -p "$(dirname "$VSCODE_CONFIG")"

# เขียน settings.json แบบ Optimize
cat > "$VSCODE_CONFIG" <<EOL
{
    "workbench.startupEditor": "none",
    "workbench.enableExperiments": false,
    "workbench.enableWelcomePage": false,
    "workbench.iconTheme": "vs-seti",
    "update.mode": "manual",
    "telemetry.enableTelemetry": false,
    "telemetry.enableCrashReporter": false,
    "editor.minimap.enabled": false,
    "editor.smoothScrolling": false,
    "editor.renderWhitespace": "none",
    "extensions.autoUpdate": false,
    "extensions.ignoreRecommendations": true,
    "window.titleBarStyle": "custom",
    "window.menuBarVisibility": "toggle",
    "files.autoSave": "afterDelay",
    "files.autoSaveDelay": 1000
}
EOL

echo "✅ VS Code ตั้งค่าเรียบร้อย (Optimize Settings)"

# 8️⃣ แนะนำเปลี่ยน Theme Cinnamon → Classic
echo "🎨 แนะนำ: เปลี่ยน Theme Cinnamon เป็น Mint-Y หรือ Mint-X Flat (Classic) เพื่อลดโหลดกราฟิก"

echo ""
echo "🚀 เสร็จสิ้น! รีสตาร์ทเครื่องหรือล็อกเอาต์เพื่อให้ทุกอย่างทำงานเต็มที่!"
echo "💻 เปิด VS Code ด้วย: code --disable-gpu"
echo "✨ เขียนโค้ดลื่นแน่นอน!"
