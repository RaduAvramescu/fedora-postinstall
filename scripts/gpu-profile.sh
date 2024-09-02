#!/usr/bin/bash

if ! [ $(id -u) = 0 ]; then
    echo "Script needs to run as root!"
    exit 1
fi

CARD_ID=card1
FAN_CTRL_SYSFS="/sys/class/drm/$CARD_ID/device/gpu_od/fan_ctrl"
HWMON="/sys/class/drm/$CARD_ID/device/hwmon/hwmon2"
MAX_POWER_CAP=`cat "$HWMON/power1_cap_max"`

# Increase power limit to the maximum allowed
cd "$HWMON"

echo "$MAX_POWER_CAP" | tee power1_cap

sleep 1

# Set fan curve - celsius, percentage
cd "$FAN_CTRL_SYSFS"

FAN_CURVE_0="25 25"
FAN_CURVE_1="30 25"
FAN_CURVE_2="85 35"
FAN_CURVE_3="90 40"
FAN_CURVE_4="95 50"

echo "0 $FAN_CURVE_0" | tee fan_curve
echo "1 $FAN_CURVE_1" | tee fan_curve
echo "2 $FAN_CURVE_2" | tee fan_curve
echo "3 $FAN_CURVE_3" | tee fan_curve
echo "4 $FAN_CURVE_4" | tee fan_curve
echo "c" | tee fan_curve # Commit the fan curve
