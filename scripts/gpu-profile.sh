#!/usr/bin/bash

CARD_ID=card1

# Fan curve - celsius, percentage
FAN_CURVE_0="25 25"
FAN_CURVE_1="30 25"
FAN_CURVE_2="85 35"
FAN_CURVE_3="90 40"
FAN_CURVE_4="95 50"

FAN_CTRL_SYSFS="/sys/class/drm/$CARD_ID/device/gpu_od/fan_ctrl"

echo "0 $FAN_CURVE_0" | sudo tee "$FAN_CTRL_SYSFS/fan_curve"
echo "1 $FAN_CURVE_1" | sudo tee "$FAN_CTRL_SYSFS/fan_curve"
echo "2 $FAN_CURVE_2" | sudo tee "$FAN_CTRL_SYSFS/fan_curve"
echo "3 $FAN_CURVE_3" | sudo tee "$FAN_CTRL_SYSFS/fan_curve"
echo "4 $FAN_CURVE_4" | sudo tee "$FAN_CTRL_SYSFS/fan_curve"
echo "c" | sudo tee "$FAN_CTRL_SYSFS/fan_curve" # Commit the fan curve

cat "$FAN_CTRL_SYSFS/fan_curve"

# Increase power limit to the maximum allowed
HWMON="/sys/class/drm/$CARD_ID/device/hwmon/hwmon2"

sudo cat "$HWMON/power1_cap_max" | sudo tee "$HWMON/power1_cap"

cat "$HWMON/power1_cap"
