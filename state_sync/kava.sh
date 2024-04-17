#!/bin/bash
echo "Stop kava"
sudo systemctl stop kava
echo "Start cosmprund"
$HOME/cosmprund/build/cosmprund prune ~/.kava/data
echo "Start kava"
sudo systemctl start kava