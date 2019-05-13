#!/bin/bash

## Variabili
name=(giovanni francesco lucia aurora alberto vincenzo peppe giuseppe
   maria mariateresa anna gianluca silvestro paolo simona antonio raffaele)
length_salt_element="${#name[@]}"
length_pass=0
length_salt=0
count=0

## Funzioni

function unalias_all() {
   unalias grep &>/dev/null
   unalias sed &>/dev/null
   unalias command &>/dev/null
   unalias apt-get &>/dev/null
   unalias apt-rdepends &>/dev/null
}

function mixer_name() { # Passing argument $password_gen
   if [ "$#" != "1" ]; then
      return 1
   fi

   unalias_all
   bit_primary=$(tr </dev/urandom -cd 0-1 | head -c 1) ### Decide se le lettere dovranno essere maiuscole o minuscole
   salt="${name[$((RANDOM % length_salt_element))]}"
   password_gen="$1"
   key_casual=""
   translate=""
   seed=$(($((RANDOM % length_pass)) + 1)) ### Numero casuale preso dalla lunghezza dalla password generata
   length_salt=${#salt}

   for a in $(seq 1 "$length_salt"); do
      bit_upper_or_lower=$(tr </dev/urandom -cd 0-1 | head -c 1) ### Singolo carattere se maiuscolo o minuscolo

      if [[ $bit_upper_or_lower -eq 1 ]]; then
         translate="$translate$(echo "$salt" | cut -c "$a" | tr '[:lower:]' '[:upper]')"
      else
         translate="$translate$(echo "$salt" | cut -c "$a")"
      fi

   done

   salt="$translate"

   for a in $(seq $seed $((seed + length_salt - 1))); do
      key_casual="$key_casual$(echo "$password_gen" | cut -c "$a")"
   done
   translate="${password_gen//key_casual/salt}"
   password_gen="$translate"

   length_pass=${#password_gen} ### Ricalcolo della sua lunghezza

   if [[ $length_pass -gt $count ]]; then
      tmp=$((length_pass - count))
      tmp=$((length_pass - tmp))

      for a in $(seq 1 "$tmp"); do
         translate="$translate$(echo "$password_gen" | cut -c "$a")"

      done
      password_gen="$translate"
   fi

   export password_gen
}

function genumber() {
   if [ "$#" != "1" ]; then
      count=15
   else
      if [[ $1 -lt 8 ]]; then
         echo >&2 "La lunghezza deve essere minimo di 8 caratteri!"
         return 1
      fi
      count=$1
   fi

   password_gen="$(tr </dev/urandom -cd 0-9 | head -c "$count")"

   echo "$password_gen"
}

function genpass_alnum() {
   if [ "$#" != "1" ]; then
      count=15
   else
      if [[ $1 -lt 8 ]]; then
         echo >&2 "La lunghezza deve essere minimo di 8 caratteri!"
         return 1
      fi
      count="$1"
   fi

   password_gen="$(tr </dev/urandom -cd 'a-zA-Z0-9_:-' | head -c "$count")"

   length_pass=${#password_gen}
   mixer_name "$password_gen"

   echo "$password_gen"
}

function genpass() {
   if [ "$#" != "1" ]; then
      count=15
   else
      if [[ $1 -lt 8 ]]; then
         echo >&2 "La lunghezza deve essere minimo di 8 caratteri!"
         return 1
      fi
      count="$1"
   fi

   password_gen="$(tr </dev/urandom -cd '[:graph:]' | head -c "$count")"

   length_pass=${#password_gen}
   mixer_name "$password_gen"

   echo "$password_gen"
}

function batt() {
   if [ -f "/sys/class/power_supply/BAT1/capacity" ]; then
      BATT="$(cat /sys/class/power_supply/BAT1/capacity)"

      if [[ $BATT -ge 15 ]]; then
         echo -e "($(cat /sys/class/power_supply/BAT1/capacity)%)"
      else
         echo -e "($(cat /sys/class/power_supply/BAT1/capacity)%)"
      fi
   fi
}

function dpack() {
   unalias_all

   if [ $# -ne 1 ]; then
      return 1
   fi
   if ! command -v pdep &>/dev/null; then
      echo "La funzione 'dpack' dipende da 'pdep'"
      return 1
   fi

   package="$1"
   depends="$(pdep "$1" | paste -s -d' ')"
   if apt-get download "$package" 2>/dev/null; then
      apt-get download $depends
   fi
}

function pdep() {
   unalias_all

   if ! command -v apt-rdepends &>/dev/null; then
      echo "Il pacchetto 'apt-rdepends' non è installato. Installalo prima."
      return 1
   fi

   if [ $# -ne 1 ]; then
      return 1
   fi

   #LANG=en apt-cache depends "$1" | sed 's/^[[:space:]]*//' | awk '/^Depends:|\|Depends:/{print $2}'
   apt-rdepends -s "$1" "$1" 2>/dev/null | sort | uniq
}

function connection() {
   unalias_all

   devices=($(find /sys/class/net/ ! -type d | awk 'BEGIN { FS="/" } {print $5}' 2>&1 | grep -v lo | paste -s))

   for i in $(seq 0 $((${#devices[@]} - 1))); do
      printf " \033[0;34m%s\e[0m: %s " "${devices[$i]}" "$(ip addr show dev ${devices[$i]} | grep '\<inet\>' | sed's/\ *//' | cut -d" " -f 2)"
   done
   echo -e "\n"
}
