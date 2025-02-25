#!/bin/bash

# Funkcia na zobrazenie údajov o disku
disk_info() {
  echo "📊 Informácie o disku:"
  df -h | awk 'NR==1 || /^\/dev\// {print $1, "Použité:", $3, "Voľné:", $4, "Celkom:", $2, "Použitie:", $5}'
}

# Funkcia na generovanie reportu o CPU a RAM + TOP 10 procesov podľa CPU
cpu_ram_report() {
  echo "🖥️  Využitie CPU a RAM:"
  echo "-----------------------------------"
  top -b -n 1 | grep "Cpu(s)" | awk '{print "CPU: " $2 "% používané, " $4 "% voľné"}'
  free -h | awk 'NR==2{print "RAM: Celkom: " $2 ", Použité: " $3 ", Voľné: " $4}'
  echo "-----------------------------------"
  echo "🔥 TOP 10 procesov podľa CPU:"
  ps -eo pid,user,%cpu,%mem,cmd --sort=-%cpu | head -n 11
}

# Funkcia na vytvorenie .tar.gz archívu z priečinka
create_backup() {
  read -p "📂 Zadaj cestu k priečinku na archiváciu: " folder
  if [ -d "$folder" ]; then
    tar_name="$(basename "$folder")_$(date +'%Y-%m-%d').tar.gz"
    tar -czf "$tar_name" "$folder"
    echo "✅ Archív '$tar_name' bol vytvorený."
  else
    echo "❌ Chyba: Priečinok '$folder' neexistuje."
  fi
}

# Nekonečné menu
while true; do
  echo ""
  echo "🔹 Vyberte akciu:"
  echo "1️⃣ Zobraziť informácie o disku"
  echo "2️⃣ Generovať report CPU, RAM a TOP 10 procesov"
  echo "3️⃣ Vytvoriť .tar.gz archív z priečinka"
  echo "4️⃣ Ukončiť skript"
  read -p "👉 Zadajte číslo (1, 2, 3 alebo 4): " choice

  case $choice in
    1) disk_info ;;
    2) cpu_ram_report ;;
    3) create_backup ;;
    4) echo "👋 Ukončujem skript. Maj pekný deň!"; exit ;;
    *) echo "⚠️ Neplatná voľba. Prosím, zadajte 1, 2, 3 alebo 4." ;;
  esac
done
