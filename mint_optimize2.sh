#!/bin/bash

echo "🚀 Linux Mint Ultra-Optimize Script by ChatGPT"

# --------------------------
# 1️⃣ ปิด Cinnamon Effects
# --------------------------
disable_cinnamon_effects() {
  echo "⚙️ ปิด Cinnamon Animations..."
  gsettings set org.cinnamon.muffin use-animations false
  gsettings set org.cinnamon desktop-effects false
  echo "✅ Cinnamon Animations ถูกปิดแล้ว"
}

# --------------------------
# 2️⃣ ปิด Services ไม่จำเป็น
# --------------------------
disable_unneeded_services() {
  echo "⚙️ ปิด Bluetooth (ถ้าไม่ได้ใช้)..."
  sudo systemctl disable bluetooth.service --now

  echo "⚙️ ปิด ModemManager (ถ้าไม่ได้ใช้มือถือเป็นโมเด็ม)..."
  sudo systemctl disable ModemManager.service --now

  echo "⚙️ ปิด Printing (ถ้าไม่มีเครื่องพิมพ์)..."
  sudo systemctl disable cups.service --now

  echo "✅ ปิด Services ไม่จำเป็นเรียบร้อย"
}

# --------------------------
# 3️⃣ ตั้ง Swappiness
# --------------------------
set_swappiness() {
  echo "⚙️ ตั้ง Swappiness..."
  echo "vm.swappiness = 10" | sudo tee /etc/sysctl.d/99-swappiness.conf
  sudo sysctl -p /etc/sysctl.d/99-swappiness.conf
  echo "✅ Swappiness ตั้งเป็น 10 (เน้น RAM ก่อน Swap)"
}

# --------------------------
# 4️⃣ ติดตั้งและตั้งค่า ZRAM
# --------------------------
setup_zram() {
  echo "⚙️ ติดตั้ง ZRAM..."
  sudo apt update
  sudo apt install -y zram-tools

  echo "ALGO=lz4
PERCENT=50" | sudo tee /etc/default/zramswap

  sudo systemctl restart zramswap
  echo "✅ ZRAM เปิดใช้แล้ว (50% RAM)"
}

# --------------------------
# 5️⃣ ปรับ I/O Scheduler
# --------------------------
set_io_scheduler() {
  echo "⚙️ ตั้ง I/O Scheduler เป็น deadline..."
  echo 'deadline' | sudo tee /sys/block/sda/queue/scheduler
  echo "✅ I/O Scheduler ถูกตั้งแล้ว"
}

# --------------------------
# 6️⃣ ตั้ง CPU Governor
# --------------------------
set_cpu_governor() {
  echo "⚙️ ตั้ง CPU Governor เป็น powersave..."
  for CPUFREQ in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo powersave | sudo tee $CPUFREQ
  done
  echo "✅ CPU Governor = powersave"
}

# --------------------------
# 7️⃣ เปิด TRIM (ถ้ามี SSD)
# --------------------------
enable_trim() {
  echo "⚙️ เปิด TRIM..."
  sudo systemctl enable fstrim.timer
  sudo systemctl start fstrim.timer
  echo "✅ SSD TRIM เปิดแล้ว (Weekly)"
}

# --------------------------
# 8️⃣ Clean Cache
# --------------------------
clean_cache() {
  echo "⚙️ ล้าง PageCache, dentries, inodes..."
  sudo sh -c "sync; echo 3 > /proc/sys/vm/drop_caches"
  echo "✅ Cache ถูกเคลียร์แล้ว"
}

# --------------------------
# 9️⃣ Run All
# --------------------------
run_all() {
  disable_cinnamon_effects
  disable_unneeded_services
  set_swappiness
  setup_zram
  set_io_scheduler
  set_cpu_governor
  enable_trim
  clean_cache
  echo "🎉 ปรับแต่งทุกอย่างเสร็จสิ้น!"
}

# --------------------------
# Run All
# --------------------------
run_all