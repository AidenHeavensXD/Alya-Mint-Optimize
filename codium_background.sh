#!/bin/bash

echo "✨ VSCode/VSCodium Background Image Setup"

# ถาม path รูปแฟน
read -p "👉 พิมพ์ path รูปแฟน (เต็ม เช่น /home/you/Pictures/mygf.jpg): " IMG_PATH

# เช็กว่ามีไฟล์ไหม
if [ ! -f "$IMG_PATH" ]; then
  echo "❌ ไม่พบไฟล์รูป → ลองตรวจสอบ path อีกครั้ง!"
  exit 1
fi

# แปลงเป็น file://
IMG_URI="file://$IMG_PATH"

# หา settings.json
SETTINGS_DIR="$HOME/.config/VSCodium/User"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"

# VSCode ปกติ
if [ ! -d "$SETTINGS_DIR" ]; then
  SETTINGS_DIR="$HOME/.config/Code/User"
  SETTINGS_FILE="$SETTINGS_DIR/settings.json"
fi

# สร้างโฟลเดอร์ถ้ายังไม่มี
mkdir -p "$SETTINGS_DIR"

# สร้าง settings.json ถ้ายังไม่มี
if [ ! -f "$SETTINGS_FILE" ]; then
  echo "{}" > "$SETTINGS_FILE"
fi

# ลบ config เก่า
jq 'del(.background)' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"

# เขียน config ใหม่
jq ". + {
  \"background.enabled\": true,
  \"background.useDefault\": false,
  \"background.customImages\": [\"$IMG_URI\"],
  \"background.style\": {
    \"content\": \"''\",
    \"pointer-events\": \"none\",
    \"position\": \"center\",
    \"repeat\": \"no-repeat\",
    \"size\": \"cover\",
    \"opacity\": 0.15
  }
}" "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"

echo "✅ ตั้งค่ารูปพื้นหลังเรียบร้อย!"
echo "💡 อย่าลืมติดตั้ง Extension background ด้วย:"
echo "   codium --install-extension shalldie.background --force"
echo ""
echo "📌 เสร็จแล้วให้รีโหลดด้วย Developer: Reload Window"