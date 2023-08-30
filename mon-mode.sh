#!/bin/bash
# This script will maake your wifi card enter monitor mode, which will turn off any wifi connections. 
echo "### Please close anything that uses your internet, when your wifi card enters monitor mode, it will not allow wifi to work, even if you are using an external card."
# asking function
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
# running the function
ask_to_continue

# check for the cards
handle_outputs() {
  local firstcheck="$(airmon-ng | grep wlan0)"
  local secondcheck="$(airmon-ng | grep wlan1)"

  # check for wlan0
  if echo "$firstcheck" | grep -q "wlan0"; then
    echo "### Found wifi card!"
    ask_to_enter() {
        read -p "Enter monitor mode now? (Y/N) " response
        case "$response" in
            [yY]) 
                echo "Continuing..."
                  sudo ip link set wlan0 down
                  sudo iwconfig wlan0 mode monitor
                  sudo ip link set wlan0 up
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
# running the function
ask_to_enter

  else
    echo "### Can't find wifi card"
  fi

  # check for wlan1
  if echo "$secondcheck" | grep -q "wlan1"; then
    echo "### Can't find wlan0, or it is not supported. Moving to wlan1..."
        ask_to_enter() {
        read -p "Enter monitor mode now? (Y/N) " response
        case "$response" in
            [yY]) 
                echo "Continuing..."
                  sudo ip link set wlan1 down
                  sudo iwconfig wlan1 mode monitor 
                  sudo ip link set wlan1 up
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
# running the function
ask_to_enter
  else
    echo "### No wifi card??"
  fi
}

EOF


