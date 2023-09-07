#!/bin/bash
# This script will make your Wi-Fi card enter monitor mode, which will turn off any active Wi-Fi connections.
echo "### Please close anything that uses your internet, as monitor mode will disable Wi-Fi connections."

# Asking function
ask_to_continue() {
  read -p "Do you want to continue (Y/N)? " response
  case "$response" in
    [yY]) 
      echo "Continuing..."
      ;;
    [nN]) 
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid input. Please enter Y or N."
      ask_to_continue # Ask again if the input is not Y or N
      ;;
  esac
}

# Running the function
ask_to_continue

# Check for available Wi-Fi cards
handle_wifi_card() {
  local wifi_cards="$(airmon-ng)"

  if echo "$wifi_cards" | grep -q "wlan0"; then
    wifi_interface="wlan0"
  elif echo "$wifi_cards" | grep -q "wlan1"; then
    wifi_interface="wlan1"
  elif echo "$wifi_cards" | grep -q "wlp1s0"; then 
    wifi_interface="wlp1s0"
  else
    echo "### No compatible Wi-Fi card found."
    exit 1
  fi

  echo "### Found Wi-Fi card: $wifi_interface"

  # Ask the user if they want to enter monitor mode
  read -p "Enter monitor mode for $wifi_interface (Y/N)? " response
  case "$response" in
    [yY]) 
      echo "Entering monitor mode for $wifi_interface..."
      sudo ip link set "$wifi_interface" down
      sudo iwconfig "$wifi_interface" mode monitor
      sudo ip link set "$wifi_interface" up
      echo "Monitor mode for $wifi_interface has been enabled."
      ;;
    [nN]) 
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid input. Please enter Y or N."
      handle_wifi_card # Ask again if the input is not Y or N
      ;;
  esac
}

# Running the function to handle Wi-Fi card
handle_wifi_card
