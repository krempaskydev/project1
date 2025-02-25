#!/bin/bash

# Funkcia na vytvorenie priečinkov a súborov
create_folders() {
  folder_name=$(date +'%Y-%m-%d')
  mkdir -p "$folder_name"
  cd "$folder_name" || exit 1  # Ak sa nepodarí prejsť, skript skončí s chybou

  days=("Pondelok" "Utorok" "Streda" "Štvrtok" "Piatok" "Sobota" "Nedela")

  for day in "${days[@]}"; do
    mkdir -p "$day"  # Použitie -p zabráni chybe, ak priečinok už existuje
    num_files=$(shuf -i 10-100 -n 1)  # Náhodný počet súborov (10 až 100)

    for i in $(seq 1 $num_files); do
      size=$(shuf -i 1-1000 -n 1)  # Náhodná veľkosť súboru (1 až 1000 KB)
      dd if=/dev/urandom of="$day/file_${i}.txt" bs=1K count=$size status=none
    done
  done

  cd ..  # Vrátime sa späť do hlavného adresára
  echo "✅ Priečinky a súbory boli úspešne vytvorené v priečinku $folder_name."
}

# Funkcia na zoradenie priečinkov podľa veľkosti v MB
sort_directories_by_size() {
  folder_name=$(date +'%Y-%m-%d')
  if [ ! -d "$folder_name" ]; then
    echo "⚠️ Chyba: Priečinok $folder_name neexistuje. Najskôr ho vytvorte."
    return
  fi

  echo "📂 Zoradené priečinky podľa veľkosti (MB):"
  du -sm "$folder_name"/* | sort -n | awk '{print $2, $1 " MB"}'
}

# Funkcia na vypísanie 10 najväčších súborov v MB + cesta k nim
list_largest_files() {
  folder_name=$(date +'%Y-%m-%d')
  if [ ! -d "$folder_name" ]; then
    echo "⚠️ Chyba: Priečinok $folder_name neexistuje. Najskôr ho vytvorte."
    return
  fi

  echo "📁 10 najväčších súborov v priečinku $folder_name:"
  find "$folder_name" -type f -exec du -m {} + 2>/dev/null | sort -rh | head -n 10 | awk '{print "📄 " $2 " - " $1 " MB"}'
}

# Nekonečná slučka na výber akcie
while true; do
  echo ""
  echo "🔹 Vyberte akciu:"
  echo "1️⃣ Vytvoriť priečinky a súbory"
  echo "2️⃣ Zoradiť priečinky podľa veľkosti"
  echo "3️⃣ Vypísať 10 najväčších súborov"
  echo "4️⃣ Ukončiť skript"
  read -p "👉 Zadajte číslo (1, 2, 3 alebo 4): " choice

  case $choice in
    1) create_folders ;;
    2) sort_directories_by_size ;;
    3) list_largest_files ;;
    4) echo "👋 Ukončujem skript. Maj pekný deň!"; exit ;;
    *) echo "⚠️ Neplatná voľba. Prosím, zadajte 1, 2, 3 alebo 4." ;;
  esac
done