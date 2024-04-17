#!/bin/bash

sudo systemctl stop kava
cosmprund prune ~/.kava/data
sudo systemctl start kava