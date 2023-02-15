#!/bin/bash

# Create 550MB swap memory space
sudo fallocate -l 550M /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

while true; do
  # Get available RAM
  R=$(free -m | awk '/^Mem:/{print $7}')

  # Get occupied swap memory
  S=$(free -m | awk '/^Swap:/{print $3}')

  # Check if occupied swap memory is less than 100MB
  if [ $S -lt 100 ]; then
    echo "Occupied swap memory is less than 100MB, swapping operation is put on hold."
  else
    # Check if RAM is sufficient for swapping
    if [ $R -gt $S ]; then
      echo "RAM is sufficient for swapping, performing the swapping process..."
      # Perform swapping process
      sudo swapoff /swapfile
      sudo swapon /swapfile
    else
      echo "RAM will not be able to accommodate the swap contents, putting swapping process on hold."
    fi
  fi

  # Display available RAM
  echo "Available RAM: $R MB"

  # Display total swap memory
  echo "Total swap memory: 550 MB"

  # Display used/free swap memory
  USED=$(free -m | awk '/^Swap:/{print $3}')
  FREE=$(free -m | awk '/^Swap:/{print $4}')
  echo "Used/Free swap memory: $USED/$FREE MB"

  # Repeat the process after 1 second
  sleep 15
done
