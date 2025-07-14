#!/bin/bash

echo "🚀 เริ่มติดตั้ง VSCodium + Full Dev Setup..."

# 1️⃣ ติดตั้ง VSCodium
echo "📦 ติดตั้ง VSCodium..."
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/vscodium-archive-keyring.gpg > /dev/null
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://packages.vscodium.com/debs vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update && sudo apt install -y codium

# 2️⃣ สร้าง config settings.json
echo "⚙️ ตั้งค่า VSCodium ให้เบาสุด..."
VSCODIUM_CONFIG="$HOME/.config/VSCodium/User/settings.json"
mkdir -p "$(dirname "$VSCODIUM_CONFIG")"

cat > "$VSCODIUM_CONFIG" <<EOL
{
    "workbench.startupEditor": "none",
    "telemetry.enableTelemetry": false,
    "telemetry.enableCrashReporter": false,
    "update.mode": "manual",
    "extensions.autoUpdate": false,
    "extensions.ignoreRecommendations": true,
    "editor.minimap.enabled": false,
    "editor.smoothScrolling": false,
    "editor.renderWhitespace": "selection",
    "files.watcherExclude": {
        "**/node_modules/**": true,
        "**/.git/objects/**": true,
        "**/tmp/**": true
    },
    "search.exclude": {
        "**/node_modules": true,
        "**/bower_components": true
    },
    "workbench.colorTheme": "One Dark Pro",
    "workbench.iconTheme": "vscode-icons",
    "window.titleBarStyle": "custom",
    "window.menuBarVisibility": "toggle",
    "files.autoSave": "afterDelay",
    "files.autoSaveDelay": 1500
}
EOL

# 3️⃣ ติดตั้ง Theme & Icons
echo "🎨 ติดตั้ง Theme & Icons..."
codium --install-extension zhuangtongfa.Material-theme --force
codium --install-extension vscode-icons-team.vscode-icons --force

# 4️⃣ ติดตั้ง Extension Dev ครบ
echo "💻 ติดตั้ง Extension Dev..."
codium --install-extension ms-python.python --force
codium --install-extension ms-toolsai.jupyter --force
codium --install-extension ms-python.vscode-pylance --force
codium --install-extension esbenp.prettier-vscode --force
codium --install-extension dbaeumer.vscode-eslint --force
codium --install-extension ritwickdey.LiveServer --force
codium --install-extension eamodio.gitlens --force
codium --install-extension formulahendry.code-runner --force

echo ""
echo "✅ เสร็จแล้ว! คุณได้:"
echo "  ✔️ VSCodium ไม่มี Telemetry"
echo "  ✔️ Theme: One Dark Pro"
echo "  ✔️ Icons: VSCode Icons"
echo "  ✔️ Extension Dev: Python, Jupyter, Pylance, Prettier, ESLint, Live Server, GitLens, Code Runner"
echo "  ✔️ ปิด Minimap, Smooth Scroll, Auto Update, Welcome"

echo ""
echo "👉 เปิดด้วย: codium --disable-gpu"
echo "   (จะเบาที่สุดบนเครื่องสเปกต่ำ)"
echo ""
echo "🔥 พร้อมลุยโปรเจกต์ Python/JS/Web ครบ จบในตัว!"